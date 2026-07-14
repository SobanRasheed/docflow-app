import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/tool_type.dart';

part 'done_controller.g.dart';

class DoneState {
  const DoneState({this.result, this.tool});

  final File? result;
  final ToolType? tool;
}

@riverpod
class DoneController extends AsyncNotifier<DoneState> {
  @override
  Future<DoneState> build() async => const DoneState();

  void setResult(File result, ToolType tool) {
    state = AsyncData(DoneState(result: result, tool: tool));
  }

  void reset() {
    state = const AsyncData(DoneState());
  }
}