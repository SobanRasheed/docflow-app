import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/conversion_history_item.dart';
import '../services/history_service.dart';

part 'files_controller.g.dart';

@riverpod
class FilesController extends AsyncNotifier<List<ConversionHistoryItem>> {
  late HistoryService _service;

  @override
  Future<List<ConversionHistoryItem>> build() async {
    _service = HistoryService();
    if (!_service.isInitialized) {
      await _service.init();
    }
    return _service.getRecords();
  }

  Future<void> addRecord(ConversionHistoryItem record) async {
    await _service.addRecord(record);
    state = AsyncData(_service.getRecords());
  }

  Future<void> deleteRecord(String id) async {
    await _service.deleteRecord(id);
    state = AsyncData(_service.getRecords());
  }

  Future<void> clearHistory() async {
    await _service.clearHistory();
    state = const AsyncData([]);
  }
}