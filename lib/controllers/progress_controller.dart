import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:path/path.dart' as p;

import '../core/utils/exceptions.dart';
import '../models/conversion_history_item.dart';
import '../models/tool_type.dart';
import '../services/ilovepdf_service.dart';
import 'done_controller.dart';
import 'files_controller.dart';
import 'upload_controller.dart';

part 'progress_controller.g.dart';

class ConversionState {
  const ConversionState({
    this.progress = 0.0,
    this.result,
    this.tool,
    this.error,
    this.isCompleted = false,
  });

  final double progress;
  final File? result;
  final ToolType? tool;
  final String? error;
  final bool isCompleted;
}

@riverpod
class ProgressController extends AsyncNotifier<ConversionState> {
  CancelToken? _cancelToken;

  @override
  Future<ConversionState> build() async {
    final uploadState = ref.read(uploadControllerProvider).value;
    if (uploadState == null || uploadState.tool == null || uploadState.files.isEmpty) {
      return const ConversionState(error: 'No files selected.');
    }

    // Auto-start conversion on screen load
    Future.microtask(() => _startConversion(uploadState.tool!, uploadState.files));
    return ConversionState(progress: 0.0, tool: uploadState.tool);
  }

  Future<void> _startConversion(ToolType tool, List<File> files) async {
    _cancelToken = CancelToken();
    state = AsyncData(ConversionState(progress: 0.0, tool: tool));

    try {
      final service = ILovePdfService();
      final result = await service.convert(
        files.first,
        tool,
        extras: files.length > 1 ? files.sublist(1) : null,
        cancelToken: _cancelToken,
        onProgress: (p) {
          state = AsyncData(ConversionState(progress: p, tool: tool));
        },
      );

      // Save to history
      final historyItem = ConversionHistoryItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        toolId: tool.id,
        toolTitle: tool.title,
        inputName: p.basename(files.first.path),
        outputPath: result.path,
        createdAt: DateTime.now(),
        sizeBytes: result.lengthSync(),
      );
      await ref.read(filesControllerProvider.notifier).addRecord(historyItem);

      // Pass to DoneController
      ref.read(doneControllerProvider.notifier).setResult(result, tool);

      state = AsyncData(ConversionState(
        progress: 1.0,
        result: result,
        tool: tool,
        isCompleted: true,
      ));
    } on DocFlowException catch (e) {
      state = AsyncData(ConversionState(error: e.message, tool: tool));
    } catch (e) {
      // Updated to show the actual error message for better debugging
      state = AsyncData(ConversionState(error: e.toString(), tool: tool));
    }
  }

  void cancel() {
    _cancelToken?.cancel();
    _cancelToken = null;
  }

  void reset() {
    _cancelToken?.cancel();
    state = const AsyncData(ConversionState());
  }
}
