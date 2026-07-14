import 'tool_type.dart';

class ConversionTask {
  const ConversionTask({
    required this.id,
    required this.tool,
    required this.filePaths,
  });

  final String id;
  final ToolType tool;
  final List<String> filePaths;

  factory ConversionTask.fromJson(Map<String, dynamic> json) {
    return ConversionTask(
      id: json['id'] as String,
      tool: ToolType.fromJson(json['tool'] as Map<String, dynamic>),
      filePaths: List<String>.from(json['filePaths'] as List),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'tool': tool.toJson(),
        'filePaths': filePaths,
      };

  ConversionTask copyWith({
    String? id,
    ToolType? tool,
    List<String>? filePaths,
  }) {
    return ConversionTask(
      id: id ?? this.id,
      tool: tool ?? this.tool,
      filePaths: filePaths ?? this.filePaths,
    );
  }
}