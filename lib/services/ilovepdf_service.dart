// ============================================================================
// SECURITY NOTICE
// ----------------------------------------------------------------------------
// This file is the ONLY layer that talks to iLovePDF directly. When migrating
// to a Node.js backend, replace the body of `convert()` (and the private
// helpers below) to call your backend instead — controllers, views, models and
// routes do not need to change.
//
// IMPORTANT: The direct-API approach used here is NOT safe for production
// distribution. The iLovePDF public key is bundled in the compiled app and is
// trivially extractable. Use this build only for local testing.
// ============================================================================

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

class ILovePdfService {
  ILovePdfService({Dio? dio, Connectivity? connectivity})
      : _dio = dio ?? DioClient.create(),
        _connectivity = connectivity ?? Connectivity();

  final Dio _dio;
  final Connectivity _connectivity;
  String? _jwt;

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
    _validateInput(input, tool);
    if (extras != null) {
      for (final f in extras) {
        _validateInput(f, tool);
      }
    }
    await _ensureOnline(cancelToken: cancelToken);

    final jwt = await _authenticate(cancelToken: cancelToken);
    _jwt = jwt;

    final task = await _startTask(tool.toolCode, cancelToken: cancelToken);

    final files = <File>[input, if (extras != null) ...extras];
    final serverFiles = <_ServerFile>[];
    for (var i = 0; i < files.length; i++) {
      final f = files[i];
      final baseProgress = i / files.length;
      final span = 1 / files.length;
      final serverName = await _uploadFile(
        task: task,
        file: f,
        cancelToken: cancelToken,
        onProgress: (p) => onProgress?.call(
          (baseProgress + p * span * 0.6).clamp(0.0, 0.6),
        ),
      );
      serverFiles.add(_ServerFile(serverName, p.basename(f.path)));
    }

    await _process(
      task: task,
      tool: tool,
      files: serverFiles,
      options: {...tool.defaultOptions, ...?options},
      cancelToken: cancelToken,
    );

    final bytes = await _download(
      task: task,
      cancelToken: cancelToken,
      onProgress: (p) => onProgress?.call((0.6 + p * 0.4).clamp(0.6, 1.0)),
    );

    return _persist(input, tool, bytes);
  }

  void _validateInput(File file, ToolType tool) {
    if (!file.existsSync()) {
      throw const FileTooLargeException(0, 0);
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
    if (cancelToken?.isCancelled ?? false) {
      throw const CancelledException();
    }
    final result = await _connectivity.checkConnectivity();
    if (result.any((c) => c == ConnectivityResult.none)) {
      throw const NetworkException();
    }
  }

  Future<String> _authenticate({CancelToken? cancelToken}) async {
    return _withRetry(
      cancelToken: cancelToken,
      action: () async {
        final r = await _dio.post<Map<String, dynamic>>(
          '/auth',
          data: {'public_key': ApiConfig.publicKey},
          cancelToken: cancelToken,
        );
        _ensureOk(r, fallback: 'Authentication failed.');
        final token = r.data?['token'] as String?;
        if (token == null || token.isEmpty) {
          throw const AuthException();
        }
        return token;
      },
    );
  }

  Future<String> _startTask(String tool, {CancelToken? cancelToken}) async {
    return _withRetry(
      cancelToken: cancelToken,
      action: () async {
        final r = await _dio.get<Map<String, dynamic>>(
          '/start/$tool',
          options: _authHeaders(),
          cancelToken: cancelToken,
        );
        _ensureOk(r, fallback: 'Could not start task.');
        final task = r.data?['task'] as String?;
        if (task == null || task.isEmpty) {
          throw const ServerException('No task id returned.');
        }
        return task;
      },
    );
  }

  Future<String> _uploadFile({
    required String task,
    required File file,
    CancelToken? cancelToken,
    void Function(double)? onProgress,
  }) async {
    return _withRetry(
      cancelToken: cancelToken,
      action: () async {
        final form = FormData.fromMap({
          'task': task,
          'file': await MultipartFile.fromFile(file.path),
        });
        final r = await _dio.post<Map<String, dynamic>>(
          '/upload',
          data: form,
          options: _authHeaders(),
          cancelToken: cancelToken,
          onSendProgress: (s, t) {
            if (t > 0) onProgress?.call(s / t);
          },
        );
        _ensureOk(r, fallback: 'Upload failed.');
        final name = r.data?['server_filename'] as String?;
        if (name == null) {
          throw const ServerException('Upload did not return a filename.');
        }
        return name;
      },
    );
  }

  Future<void> _process({
    required String task,
    required ToolType tool,
    required List<_ServerFile> files,
    required Map<String, dynamic> options,
    CancelToken? cancelToken,
  }) async {
    return _withRetry(
      cancelToken: cancelToken,
      action: () async {
        final payload = <String, dynamic>{
          'task': task,
          'tool': tool.toolCode,
          'files': files
              .map((f) => {'server_filename': f.name, 'filename': f.original})
              .toList(),
          ...options,
        };
        final r = await _dio.post<Map<String, dynamic>>(
          '/process',
          data: payload,
          options: _authHeaders(),
          cancelToken: cancelToken,
        );
        _ensureOk(r, fallback: 'Processing failed.');
      },
    );
  }

  Future<Uint8List> _download({
    required String task,
    CancelToken? cancelToken,
    void Function(double)? onProgress,
  }) async {
    return _withRetry(
      cancelToken: cancelToken,
      action: () async {
        final r = await _dio.get<List<int>>(
          '/download/$task',
          options: _authHeaders(responseType: ResponseType.bytes),
          cancelToken: cancelToken,
          onReceiveProgress: (s, t) {
            if (t > 0) onProgress?.call(s / t);
          },
        );
        _ensureOk(r, fallback: 'Download failed.');
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
    final outPath = p.join(outDir.path, '${stem}_${ts}.${tool.outputExtension}');
    final outFile = File(outPath);
    await outFile.writeAsBytes(bytes, flush: true);
    return outFile;
  }

  Options _authHeaders({ResponseType? responseType}) {
    return Options(
      headers: {'Authorization': 'Bearer ${_jwt ?? ''}'},
      responseType: responseType,
    );
  }

  void _ensureOk(Response<dynamic> r, {required String fallback}) {
    final status = r.statusCode ?? 0;
    if (status >= 200 && status < 300) return;
    if (status == 401 || status == 403) {
      throw const AuthException();
    }
    if (status == 413) {
      throw const FileTooLargeException(0, 0);
    }
    if (status == 415 || status == 422) {
      final msg = _extractMessage(r.data) ?? fallback;
      throw ServerException(msg);
    }
    if (status >= 500) {
      throw ServerException(_extractMessage(r.data));
    }
    throw ServerException(_extractMessage(r.data) ?? fallback);
  }

  String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final v = data['message'] ?? data['error'] ?? data['name'];
      if (v is String && v.trim().isNotEmpty) return v;
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
      return code >= 500;
    }
    return false;
  }

  Future<T> _withRetry<T>({
    required Future<T> Function() action,
    CancelToken? cancelToken,
  }) async {
    var attempt = 0;
    while (true) {
      if (cancelToken?.isCancelled ?? false) {
        throw const CancelledException();
      }
      try {
        return await action();
      } on DocFlowException {
        rethrow;
      } on DioException catch (e) {
        if (cancelToken?.isCancelled ?? false || e.type == DioExceptionType.cancel) {
          throw const CancelledException();
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
        if (code == 401 || code == 403) return const AuthException();
        if (code == 413) return const FileTooLargeException(0, 0);
        if (code == 415 || code == 422) {
          return ServerException(_extractMessage(e.response?.data));
        }
        return ServerException(_extractMessage(e.response?.data));
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return ServerException(_extractMessage(e.response?.data));
    }
  }
}

class _ServerFile {
  const _ServerFile(this.name, this.original);
  final String name;
  final String original;
}