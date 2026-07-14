import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/utils/exceptions.dart';
import '../core/utils/validators.dart';
import '../models/tool_type.dart';
import '../services/permission_service.dart';

part 'upload_controller.g.dart';

class UploadState {
  const UploadState({
    this.tool,
    this.files = const [],
    this.error,
  });

  final ToolType? tool;
  final List<File> files;
  final String? error;

  bool get isValid => tool != null && files.isNotEmpty && error == null;

  UploadState copyWith({
    ToolType? tool,
    List<File>? files,
    String? error,
    bool clearError = false,
  }) {
    return UploadState(
      tool: tool ?? this.tool,
      files: files ?? this.files,
      error: clearError ? null : error ?? this.error,
    );
  }
}

@riverpod
class UploadController extends AsyncNotifier<UploadState> {
  @override
  Future<UploadState> build() async => const UploadState();

  void setTool(ToolType tool) {
    state = AsyncData(UploadState(tool: tool, files: const [], error: null));
  }

  Future<void> pickFiles() async {
    final current = state.value;
    if (current?.tool == null) return;
    final tool = current!.tool!;

    final hasPermission = await PermissionService.requestStorage();
    if (!hasPermission) {
      state = AsyncData(current.copyWith(error: 'Storage permission denied.'));
      return;
    }

    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        allowMultiple: tool.supportsMultiple,
        type: FileType.custom,
        allowedExtensions: tool.acceptedInputs,
      );

      if (result == null || result.files.isEmpty) {
        state = AsyncData(current.copyWith(error: 'No files selected.'));
        return;
      }

      final files = result.files.map((f) => File(f.path!)).toList();
      
      // Validate all files
      for (final file in files) {
        Validators.validateFile(file, tool);
      }

      state = AsyncData(current.copyWith(files: files, clearError: true));
    } on DocFlowException catch (e) {
      state = AsyncData(current.copyWith(error: e.message));
    } catch (e) {
      state = AsyncData(current.copyWith(error: 'Failed to pick files.'));
    }
  }

  void clearFiles() {
    final current = state.value;
    if (current != null) {
      state = AsyncData(current.copyWith(files: const [], clearError: true));
    }
  }
}