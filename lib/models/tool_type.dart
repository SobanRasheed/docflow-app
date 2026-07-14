import 'package:flutter/material.dart';

enum ToolCategory {
  convert,
  organize,
  optimize,
}

class ToolType {
  const ToolType({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.toolCode,
    required this.icon,
    required this.color,
    required this.category,
    required this.acceptedInputs,
    required this.outputExtension,
    required this.supportsMultiple,
    this.defaultOptions = const <String, dynamic>{},
  });

  final String id;
  final String title;
  final String subtitle;
  final String toolCode;
  final IconData icon;
  final Color color;
  final ToolCategory category;
  final List<String> acceptedInputs;
  final String outputExtension;
  final bool supportsMultiple;
  final Map<String, dynamic> defaultOptions;

  static const pdfToWord = ToolType(
    id: 'pdf_to_word',
    title: 'PDF to Word',
    subtitle: 'Editable .docx output',
    toolCode: 'pdfoffice',
    icon: Icons.description_outlined,
    color: Color(0xFF2563EB),
    category: ToolCategory.convert,
    acceptedInputs: ['pdf'],
    outputExtension: 'docx',
    supportsMultiple: false,
    defaultOptions: {'output': 'word'},
  );

  static const wordToPdf = ToolType(
    id: 'word_to_pdf',
    title: 'Word to PDF',
    subtitle: '.doc / .docx to .pdf',
    toolCode: 'officepdf',
    icon: Icons.picture_as_pdf_outlined,
    color: Color(0xFFDC2626),
    category: ToolCategory.convert,
    acceptedInputs: ['doc', 'docx'],
    outputExtension: 'pdf',
    supportsMultiple: false,
  );

  static const pdfToExcel = ToolType(
    id: 'pdf_to_excel',
    title: 'PDF to Excel',
    subtitle: 'Editable .xlsx output',
    toolCode: 'pdfoffice',
    icon: Icons.table_chart_outlined,
    color: Color(0xFF16A34A),
    category: ToolCategory.convert,
    acceptedInputs: ['pdf'],
    outputExtension: 'xlsx',
    supportsMultiple: false,
    defaultOptions: {'output': 'excel'},
  );

  static const excelToPdf = ToolType(
    id: 'excel_to_pdf',
    title: 'Excel to PDF',
    subtitle: '.xls / .xlsx to .pdf',
    toolCode: 'officepdf',
    icon: Icons.grid_on_outlined,
    color: Color(0xFFEA580C),
    category: ToolCategory.convert,
    acceptedInputs: ['xls', 'xlsx'],
    outputExtension: 'pdf',
    supportsMultiple: false,
  );

  static const mergePdf = ToolType(
    id: 'merge_pdf',
    title: 'Merge PDF',
    subtitle: 'Combine multiple PDFs',
    toolCode: 'merge',
    icon: Icons.call_merge_outlined,
    color: Color(0xFF7C3AED),
    category: ToolCategory.organize,
    acceptedInputs: ['pdf'],
    outputExtension: 'pdf',
    supportsMultiple: true,
  );

  static const splitPdf = ToolType(
    id: 'split_pdf',
    title: 'Split PDF',
    subtitle: 'Extract ranges into a zip',
    toolCode: 'split',
    icon: Icons.call_split_outlined,
    color: Color(0xFF0891B2),
    category: ToolCategory.organize,
    acceptedInputs: ['pdf'],
    outputExtension: 'zip',
    supportsMultiple: false,
    defaultOptions: {'split_mode': 'ranges', 'ranges': '1'},
  );

  static const compressPdf = ToolType(
    id: 'compress_pdf',
    title: 'Compress PDF',
    subtitle: 'Reduce file size',
    toolCode: 'compress',
    icon: Icons.compress_outlined,
    color: Color(0xFFDB2777),
    category: ToolCategory.optimize,
    acceptedInputs: ['pdf'],
    outputExtension: 'pdf',
    supportsMultiple: false,
    defaultOptions: {'compression_level': 'recommended'},
  );

  static const imageToPdf = ToolType(
    id: 'image_to_pdf',
    title: 'Image to PDF',
    subtitle: 'JPG / PNG to PDF',
    toolCode: 'imagepdf',
    icon: Icons.image_outlined,
    color: Color(0xFFCA8A04),
    category: ToolCategory.convert,
    acceptedInputs: ['jpg', 'jpeg', 'png'],
    outputExtension: 'pdf',
    supportsMultiple: true,
  );

  static const pdfToImage = ToolType(
    id: 'pdf_to_image',
    title: 'PDF to Image',
    subtitle: 'Each page as JPG',
    toolCode: 'pdfjpg',
    icon: Icons.photo_library_outlined,
    color: Color(0xFF0D9488),
    category: ToolCategory.convert,
    acceptedInputs: ['pdf'],
    outputExtension: 'zip',
    supportsMultiple: false,
    defaultOptions: {'pdfjpg_mode': 'pages'},
  );

  static const List<ToolType> all = [
    pdfToWord,
    wordToPdf,
    pdfToExcel,
    excelToPdf,
    mergePdf,
    splitPdf,
    compressPdf,
    imageToPdf,
    pdfToImage,
  ];

  static ToolType? byId(String id) {
    for (final t in all) {
      if (t.id == id) return t;
    }
    return null;
  }

  bool accepts(String extension) {
    final lower = extension.toLowerCase().replaceAll('.', '');
    return acceptedInputs.any((e) => e.toLowerCase() == lower);
  }

  factory ToolType.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String;
    final tool = ToolType.byId(id);
    if (tool == null) {
      throw ArgumentError('Unknown ToolType id: $id');
    }
    return tool;
  }

  Map<String, dynamic> toJson() => {'id': id};

  ToolType copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? toolCode,
    IconData? icon,
    Color? color,
    ToolCategory? category,
    List<String>? acceptedInputs,
    String? outputExtension,
    bool? supportsMultiple,
    Map<String, dynamic>? defaultOptions,
  }) {
    return ToolType(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      toolCode: toolCode ?? this.toolCode,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      category: category ?? this.category,
      acceptedInputs: acceptedInputs ?? this.acceptedInputs,
      outputExtension: outputExtension ?? this.outputExtension,
      supportsMultiple: supportsMultiple ?? this.supportsMultiple,
      defaultOptions: defaultOptions ?? this.defaultOptions,
    );
  }
}