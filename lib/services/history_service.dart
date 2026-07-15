import 'package:hive_ce/hive_ce.dart';

import '../models/conversion_history_item.dart';

class HistoryService {
  HistoryService._();
  static final HistoryService _instance = HistoryService._();
  factory HistoryService() => _instance;

  Box<ConversionHistoryItem>? _box;

  Future<void> init() async {
    if (_box != null) return;
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ConversionHistoryItemAdapter());
    }
    _box = await Hive.openBox<ConversionHistoryItem>('conversion_history');
  }

  bool get isInitialized => _box != null;

  List<ConversionHistoryItem> getRecords() {
    final records = _box?.values.toList() ?? [];
    records.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return records;
  }

  Future<void> addRecord(ConversionHistoryItem record) async {
    await _box?.put(record.id, record);
  }

  Future<void> deleteRecord(String id) async {
    await _box?.delete(id);
  }

  Future<void> clearHistory() async {
    await _box?.clear();
  }
}