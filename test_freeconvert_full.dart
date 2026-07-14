import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;

Future<void> main() async {
  final apiKey = 'api_production_d1d547b882c79479b595a0f66435ac61a5bfc4c753e2934c6cd9997ef5ac2259.6a5632029c8b7ba61e343ea2.6a5632249c8b7ba61e343eaa';
  final dio = Dio();
  
  // create dummy pdf
  final dummyFile = File('dummy.pdf');
  await dummyFile.writeAsBytes([0x25, 0x50, 0x44, 0x46, 0x2D, 0x31, 0x2E, 0x34, 0x0A, 0x25, 0xE2, 0xE3, 0xCF, 0xD3, 0x0A]);
  
  try {
    print('1. Creating Job...');
    final payload = {
      "tasks": {
          "import-1": {"operation": "import/upload"},
          "convert-1": {
              "operation": "convert",
              "input": "import-1",
              "input_format": "pdf",
              "output_format": "docx"
          },
          "export-1": {"operation": "export/url", "input": ["convert-1"]}
      }
    };
    final jobRes = await dio.post(
      'https://api.freeconvert.com/v1/process/jobs',
      data: payload,
      options: Options(headers: {'Authorization': 'Bearer \$apiKey'}),
    );
    final jobData = jobRes.data;
    final jobId = jobData['id'];
    print('Job created: \$jobId');
    
    final tasks = jobData['tasks'] as List;
    final importTask = tasks.firstWhere((t) => t['operation'] == 'import/upload');
    final uploadUrl = importTask['result']['form']['url'];
    final parameters = importTask['result']['form']['parameters'] as Map<String, dynamic>;
    
    print('2. Uploading to \$uploadUrl');
    final formData = FormData.fromMap({
      ...parameters,
      'file': await MultipartFile.fromFile(dummyFile.path, filename: 'dummy.pdf'),
    });
    
    await dio.post(uploadUrl, data: formData);
    print('Upload successful.');
    
    print('3. Polling...');
    while (true) {
      final statusRes = await dio.get(
        'https://api.freeconvert.com/v1/process/jobs/$jobId',
        options: Options(headers: {'Authorization': 'Bearer \$apiKey'}),
      );
      final statusData = statusRes.data;
      print('Status: ' + statusData['status']);
      if (statusData['status'] == 'completed') {
        final jobTasks = statusData['tasks'] as List;
        final exportTask = jobTasks.firstWhere((t) => t['operation'] == 'export/url');
        print('Download URL: ' + exportTask['result']['url']);
        break;
      } else if (statusData['status'] == 'failed') {
        print('Job Failed: \$statusData');
        break;
      }
      await Future.delayed(Duration(seconds: 3));
    }
  } catch (e) {
    if (e is DioException) {
      print('DioError: \${e.response?.statusCode} \${e.response?.data}');
      print('Error details: \$e');
    } else {
      print('Error: \$e');
    }
  }
}
