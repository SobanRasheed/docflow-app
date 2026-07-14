import 'package:hive_ce/hive_ce.dart';

part 'conversion_history_item.g.dart';

@HiveType(typeId: 0)
class ConversionHistoryItem extends HiveObject {
  ConversionHistoryItem({
    required this.id,
    required this.toolId,
    required this.toolTitle,
    required this.inputName,
    required this.outputPath,
    required this.createdAt,
    required this.sizeBytes,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String toolId;

  @HiveField(2)
  final String toolTitle;

  @HiveField(3)
  final String inputName;

  @HiveField(4)
  final String outputPath;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final int sizeBytes;

  Map<String, dynamic> toJson() => {
        'id': id,
        'toolId': toolId,
        'toolTitle': toolTitle,
        'inputName': inputName,
        'outputPath': outputPath,
        'createdAt': createdAt.toIso8601String(),
        'sizeBytes': sizeBytes,
      };

  factory ConversionHistoryItem.fromJson(Map<String, dynamic> json) {
    return ConversionHistoryItem(
      id: json['id'] as String,
      toolId: json['toolId'] as String,
      toolTitle: json['toolTitle'] as String,
      inputName: json['inputName'] as String,
      outputPath: json['outputPath'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      sizeBytes: json['sizeBytes'] as int,
    );
  }

  ConversionHistoryItem copyWith({
    String? id,
    String? toolId,
    String? toolTitle,
    String? inputName,
    String? outputPath,
    DateTime? createdAt,
    int? sizeBytes,
  }) {
    return ConversionHistoryItem(
      id: id ?? this.id,
      toolId: toolId ?? this.toolId,
      toolTitle: toolTitle ?? this.toolTitle,
      inputName: inputName ?? this.inputName,
      outputPath: outputPath ?? this.outputPath,
      createdAt: createdAt ?? this.createdAt,
      sizeBytes: sizeBytes ?? this.sizeBytes,
    );
  }
}