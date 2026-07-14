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
    required this.operation,
    this.inputFormat,
    this.outputFormat,
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
  final String operation;
  final String? inputFormat;
  final String? outputFormat;
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
    operation: 'convert',
    inputFormat: 'pdf',
    outputFormat: 'docx',
    icon: Icons.description_outlined,
    color: Color(0xFF2563EB),
    category: ToolCategory.convert,
    acceptedInputs: ['pdf'],
    outputExtension: 'docx',
    supportsMultiple: false,
  );

  static const wordToPdf = ToolType(
    id: 'word_to_pdf',
    title: 'Word to PDF',
    subtitle: '.doc / .docx to .pdf',
    operation: 'convert',
    inputFormat: 'docx',
    outputFormat: 'pdf',
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
    operation: 'convert',
    inputFormat: 'pdf',
    outputFormat: 'xlsx',
    icon: Icons.table_chart_outlined,
    color: Color(0xFF16A34A),
    category: ToolCategory.convert,
    acceptedInputs: ['pdf'],
    outputExtension: 'xlsx',
    supportsMultiple: false,
  );

  static const excelToPdf = ToolType(
    id: 'excel_to_pdf',
    title: 'Excel to PDF',
    subtitle: '.xls / .xlsx to .pdf',
    operation: 'convert',
    inputFormat: 'xlsx',
    outputFormat: 'pdf',
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
    operation: 'merge',
    outputFormat: 'pdf',
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
    subtitle: 'Extract pages to ZIP',
    operation: 'convert',
    inputFormat: 'pdf',
    outputFormat: 'zip',
    icon: Icons.call_split_outlined,
    color: Color(0xFF0891B2),
    category: ToolCategory.organize,
    acceptedInputs: ['pdf'],
    outputExtension: 'zip',
    supportsMultiple: false,
  );

  static const compressPdf = ToolType(
    id: 'compress_pdf',
    title: 'Compress PDF',
    subtitle: 'Reduce file size',
    operation: 'compress',
    outputFormat: 'pdf',
    icon: Icons.compress_outlined,
    color: Color(0xFFDB2777),
    category: ToolCategory.optimize,
    acceptedInputs: ['pdf'],
    outputExtension: 'pdf',
    supportsMultiple: false,
  );

  static const imageToPdf = ToolType(
    id: 'image_to_pdf',
    title: 'Image to PDF',
    subtitle: 'JPG / PNG to PDF',
    operation: 'convert',
    outputFormat: 'pdf',
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
    operation: 'convert',
    inputFormat: 'pdf',
    outputFormat: 'jpg',
    icon: Icons.photo_library_outlined,
    color: Color(0xFF0D9488),
    category: ToolCategory.convert,
    acceptedInputs: ['pdf'],
    outputExtension: 'zip',
    supportsMultiple: false,
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
}

