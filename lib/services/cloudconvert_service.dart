import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../core/api/dio_client.dart';
import '../core/config/api_config.dart';
import '../core/utils/exceptions.dart';
import '../models/tool_type.dart';

class CloudConvertService {
  CloudConvertService({Dio? dio, Connectivity? connectivity})
      : _dio = dio ?? DioClient.create(),
        _connectivity = connectivity ?? Connectivity();

  final Dio _dio;
  final Connectivity _connectivity;

  Future<File> convert(
    File input,
    ToolType tool, {
    List<File>? extras,
    Map<String, dynamic>? options,
    CancelToken? cancelToken,
    void Function(double progress)? onProgress,
  }) async {
    if (!ApiConfig.hasPublicKey) {
      throw const MissingConfigurationException();
    }
    final allFiles = [input, if (extras != null) ...extras];
    for (final f in allFiles) {
      _validateInput(f, tool);
    }
    await _ensureOnline(cancelToken: cancelToken);

    // 1. Create Job with tasks
    final tasks = <String, dynamic>{};
    final importTaskIds = <String>[];
    
    // Create import tasks
    for (var i = 0; i < allFiles.length; i++) {
      final taskId = 'import-${i + 1}';
      importTaskIds.add(taskId);
      tasks[taskId] = {
        'operation': 'import/upload',
      };
    }

    // Merge uses multiple inputs, others use a single input (or multiple if applicable)
    final inputTasks = importTaskIds.length == 1 ? importTaskIds.first : importTaskIds;

    // Create process task
    tasks['process-1'] = {
      'operation': tool.operation,
      'input': inputTasks,
      if (tool.inputFormat != null) 'input_format': tool.inputFormat,
      if (tool.outputFormat != null) 'output_format': tool.outputFormat,
      if (tool.defaultOptions.isNotEmpty || (options != null && options.isNotEmpty))
        'options': {
          ...tool.defaultOptions,
          ...?options,
        }
    };

    // Create export task
    tasks['export-1'] = {
      'operation': 'export/url',
      'input': ['process-1'],
    };

    final jobPayload = {'tasks': tasks};

    // Initialize Job
    onProgress?.call(0.05);
    final jobResponse = await _createJob(jobPayload, cancelToken: cancelToken);
    final jobId = jobResponse['id'] as String;
    final serverTasks = jobResponse['tasks'] as List<dynamic>;

    // 2. Upload Files
    final importTasksResponse = serverTasks.where((t) => t['operation'] == 'import/upload').toList();
    if (importTasksResponse.length != allFiles.length) {
      throw const ServerException('Mismatch in import tasks generated.');
    }

    for (var i = 0; i < allFiles.length; i++) {
      final file = allFiles[i];
      final taskData = importTasksResponse[i];
      final formInfo = taskData['result']['form'] as Map<String, dynamic>;
      final uploadUrl = formInfo['url'] as String;
      final parameters = formInfo['parameters'] as Map<String, dynamic>;

      final baseProgress = 0.1 + (i / allFiles.length) * 0.4;
      final span = 0.4 / allFiles.length;

      await _uploadFile(
        url: uploadUrl,
        parameters: parameters,
        file: file,
        cancelToken: cancelToken,
        onProgress: (p) => onProgress?.call((baseProgress + p * span).clamp(0.1, 0.5)),
      );
    }

    // 3. Poll for Completion
    onProgress?.call(0.6);
    String? downloadUrl;
    while (true) {
      if (cancelToken?.isCancelled ?? false) throw const CancelledException();
      
      final jobStatusResponse = await _getJobStatus(jobId, cancelToken: cancelToken);
      final status = jobStatusResponse['status'] as String;
      
      if (status == 'finished') {
        final jobTasks = jobStatusResponse['tasks'] as List<dynamic>;
        final exportTask = jobTasks.firstWhere((t) => t['operation'] == 'export/url');
        downloadUrl = exportTask['result']['files'][0]['url'] as String?;
        break;
      } else if (status == 'error') {
        final jobTasks = jobStatusResponse['tasks'] as List<dynamic>;
        final failedTask = jobTasks.firstWhere((t) => t['status'] == 'error', orElse: () => <String, dynamic>{});
        final msg = failedTask['message'] ?? 'Conversion task failed';
        throw ServerException(msg.toString());
      }

      await Future.delayed(const Duration(seconds: 3));
    }

    if (downloadUrl == null || downloadUrl.isEmpty) {
      throw const ServerException('Failed to get download URL from task.');
    }

    // 4. Download Result
    final bytes = await _download(
      url: downloadUrl,
      cancelToken: cancelToken,
      onProgress: (p) => onProgress?.call((0.6 + p * 0.4).clamp(0.6, 1.0)),
    );

    return _persist(input, tool, bytes);
  }

  void _validateInput(File file, ToolType tool) {
    if (!file.existsSync()) {
      throw FileTooLargeException(0.0, ApiConfig.maxFileSizeMb);
    }
    final stat = file.statSync();
    final sizeMb = stat.size / (1024 * 1024);
    if (sizeMb > ApiConfig.maxFileSizeMb) {
      throw FileTooLargeException(sizeMb, ApiConfig.maxFileSizeMb);
    }
    final ext = p.extension(file.path).toLowerCase().replaceAll('.', '');
    if (!tool.accepts(ext)) {
      throw UnsupportedFormatException(ext, tool.title);
    }
  }

  Future<void> _ensureOnline({CancelToken? cancelToken}) async {
    if (cancelToken?.isCancelled ?? false) throw const CancelledException();
    final result = await _connectivity.checkConnectivity();
    if (result.any((c) => c == ConnectivityResult.none)) {
      throw const NetworkException();
    }
  }

  Future<Map<String, dynamic>> _createJob(Map<String, dynamic> payload, {CancelToken? cancelToken}) async {
    return _withRetry(
      cancelToken: cancelToken,
      action: () async {
        final r = await _dio.post<Map<String, dynamic>>(
          ApiConfig.baseUrl,
          data: payload,
          options: _authHeaders(),
          cancelToken: cancelToken,
        );
        _ensureOk(r, fallback: 'Could not create job');
        return r.data!['data'] as Map<String, dynamic>;
      },
    );
  }

  Future<void> _uploadFile({
    required String url,
    required Map<String, dynamic> parameters,
    required File file,
    CancelToken? cancelToken,
    void Function(double)? onProgress,
  }) async {
    return _withRetry(
      cancelToken: cancelToken,
      action: () async {
        final formMap = <String, dynamic>{...parameters};
        formMap['file'] = await MultipartFile.fromFile(file.path, filename: p.basename(file.path));
        final form = FormData.fromMap(formMap);

        final r = await _dio.post<dynamic>(
          url,
          data: form,
          cancelToken: cancelToken,
          onSendProgress: (s, t) {
            if (t > 0) onProgress?.call(s / t);
          },
        );
        final status = r.statusCode ?? 0;
        if (status < 200 || status >= 300) {
          throw ServerException('Upload failed with status $status');
        }
      },
    );
  }

  Future<Map<String, dynamic>> _getJobStatus(String jobId, {CancelToken? cancelToken}) async {
    return _withRetry(
      cancelToken: cancelToken,
      action: () async {
        final r = await _dio.get<Map<String, dynamic>>(
          '${ApiConfig.baseUrl}/$jobId',
          options: _authHeaders(),
          cancelToken: cancelToken,
        );
        _ensureOk(r, fallback: 'Could not fetch job status');
        return r.data!['data'] as Map<String, dynamic>;
      },
    );
  }

  Future<Uint8List> _download({
    required String url,
    CancelToken? cancelToken,
    void Function(double)? onProgress,
  }) async {
    return _withRetry(
      cancelToken: cancelToken,
      action: () async {
        final r = await _dio.get<List<int>>(
          url,
          options: Options(responseType: ResponseType.bytes),
          cancelToken: cancelToken,
          onReceiveProgress: (s, t) {
            if (t > 0) onProgress?.call(s / t);
          },
        );
        final status = r.statusCode ?? 0;
        if (status < 200 || status >= 300) {
          throw ServerException('Download failed with status $status');
        }
        final data = r.data;
        if (data == null || data.isEmpty) {
          throw const ServerException('Empty download payload.');
        }
        return Uint8List.fromList(data);
      },
    );
  }

  Future<File> _persist(File input, ToolType tool, Uint8List bytes) async {
    final dir = await getApplicationDocumentsDirectory();
    final outDir = Directory(p.join(dir.path, 'docflow', 'outputs'));
    if (!outDir.existsSync()) await outDir.create(recursive: true);
    final stem = p.basenameWithoutExtension(input.path);
    final ts = DateTime.now().toIso8601String().replaceAll(RegExp(r'[:.]'), '-');
    final outPath = p.join(outDir.path, '${stem}_${ts}.${tool.outputFormat ?? tool.outputExtension}');
    final outFile = File(outPath);
    await outFile.writeAsBytes(bytes, flush: true);
    return outFile;
  }

  Options _authHeaders() {
    return Options(
      headers: {'Authorization': 'Bearer ${ApiConfig.currentPublicKey}'},
    );
  }

  void _ensureOk(Response<dynamic> r, {required String fallback}) {
    final status = r.statusCode ?? 0;
    if (status >= 200 && status < 300) return;
    
    final serverMsg = _extractMessage(r.data);
    
    if (status == 401 || status == 403 || status == 402) {
      throw AuthException(serverMsg ?? 'Invalid or expired API credentials');
    }
    if (status == 413) {
      throw FileTooLargeException(0.0, ApiConfig.maxFileSizeMb);
    }
    
    final finalMsg = serverMsg ?? '$fallback ($status)';
    throw ServerException(finalMsg);
  }

  String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final error = data['error'];
      if (error is Map<String, dynamic>) {
        return error['message']?.toString();
      }
      final v = data['message'] ?? data['error'] ?? data['name'];
      if (v != null && v.toString().trim().isNotEmpty) return v.toString();
    }
    return null;
  }

  bool _isRetryable(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.connectionError) {
      return true;
    }
    if (e.type == DioExceptionType.badResponse) {
      final code = e.response?.statusCode ?? 0;
      return code >= 500 || code == 429;
    }
    return false;
  }

  Future<T> _withRetry<T>({
    required Future<T> Function() action,
    CancelToken? cancelToken,
  }) async {
    var attempt = 0;
    while (true) {
      if (cancelToken?.isCancelled ?? false) throw const CancelledException();
      try {
        return await action();
      } on AuthException {
        if (ApiConfig.currentKeyIndex < ApiConfig.publicKeys.length - 1) {
          ApiConfig.currentKeyIndex++;
          continue;
        }
        rethrow;
      } on DocFlowException {
        rethrow;
      } on DioException catch (e) {
        if (cancelToken?.isCancelled ?? false || e.type == DioExceptionType.cancel) {
          throw const CancelledException();
        }
        
        final code = e.response?.statusCode ?? 0;
        if (code == 402 || code == 401 || code == 403) {
          if (ApiConfig.currentKeyIndex < ApiConfig.publicKeys.length - 1) {
            ApiConfig.currentKeyIndex++;
            continue;
          }
        }
        if (_isRetryable(e) && attempt < ApiConfig.maxRetries) {
          attempt++;
          final delay = Duration(seconds: 1 << attempt);
          await Future.delayed(delay);
          continue;
        }
        throw _mapDio(e);
      }
    }
  }

  DocFlowException _mapDio(DioException e) {
    final serverMsg = _extractMessage(e.response?.data);
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return const TimeoutException();
      case DioExceptionType.connectionError:
        return const NetworkException();
      case DioExceptionType.cancel:
        return const CancelledException();
      case DioExceptionType.badResponse:
        final code = e.response?.statusCode ?? 0;
        if (code == 401 || code == 403 || code == 402) {
          return AuthException(serverMsg ?? 'Invalid or expired API credentials');
        }
        if (code == 413) return FileTooLargeException(0.0, ApiConfig.maxFileSizeMb);
        return ServerException(serverMsg ?? 'Server Error ($code)');
      default:
        return ServerException(serverMsg ?? 'Unexpected connection error');
    }
  }
}
