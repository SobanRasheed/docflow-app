import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;

Future<void> main() async {
  final apiKey = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiYmFhOWI2Yzc3ZTFmMGY3YWQ2MTY0MWNjYjhlMzNhZGJjZTFlYTFmNzhkY2YyZjFiOWU1NzRjMGVhMTg5NjZiNWY3ZGFkMWVmY2NhNDc5ZjQiLCJpYXQiOjE3ODQwOTgzOTEuMzM3OTE3LCJuYmYiOjE3ODQwOTgzOTEuMzM3OTE4LCJleHAiOjQ5Mzk3NzE5OTEuMzMwNDgxLCJzdWIiOiI3NjMwODYzMyIsInNjb3BlcyI6WyJ1c2VyLnJlYWQiLCJ1c2VyLndyaXRlIiwidGFzay5yZWFkIiwidGFzay53cml0ZSIsIndlYmhvb2sucmVhZCIsIndlYmhvb2sud3JpdGUiLCJwcmVzZXQucmVhZCIsInByZXNldC53cml0ZSJdfQ.o859OyPfwR1Jj7Bcq5g1HJscr9yTDcQXSwjPhsQwUa0wtSscx3HOsLAeRc5Zs6Aw3GiJk2ueBpMi0VVaXcerrEmQIcxVnn3nfSLuRIVYO2UVNugSJwOB6Auyvm3EwidLu58lyRR0kTUqwsp0JpdYy-Wp4X-WYybT9Wr5kBUw9xPMZPkgeH8sPcYNsEeUJyBH9YOoh15eHyvqeWxO82-Ll4mQXqNmX6c1oDTMY2NnyrFB2rpGevatoqACWcs3ZXK2mABRQiVsUDDXaUVYcYdw-0KykqQtt17-efzm4JjdKCeedKcRQ-vCQE_z2Kt8ctRv5kn_bw_GDMv4w34qGBTol12CDpAVrwbS4PinTxbuI0M3MPYXpugr30DfqQaW4W1Gx_wQ2xKZcVJ1a_zdDiDMS6AnMhoBcOw6wif32NaGjpNDBbVXz66oGk7H7zfk5tWcEHWJdrUaCGFLYYj07USvRlkVq_cuTBaGIyfvNzlWziR8hEty7wtoE16d2MkJlenjH6YSu_hNjuL_6xgxsBpdxpjbYlUdwOe9cqmbk_k2vmTkePTWxchg2K3rHwy1hsA3l9v43bvxxvuU1uoqTuA-8HCYIsGRWRMlT7egV84kvSpaahHwnIdB9ixu5rFkWdx-aSXYjNn0dZDg3sujtSZH5mfPX-iYBG7FedkJ8TH5olU';
  final dio = Dio();
  
  // create dummy png
  final dummyFile = File('dummy.png');
  await dummyFile.writeAsBytes([137, 80, 78, 71, 13, 10, 26, 10]);
  
  try {
    print('1. Creating Job...');
    final payload = {
      "tasks": {
          "import-1": {"operation": "import/upload"},
          "convert-1": {
              "operation": "convert",
              "input": "import-1",
              "input_format": "png",
              "output_format": "jpg"
          },
          "export-1": {"operation": "export/url", "input": ["convert-1"]}
      }
    };
    final jobRes = await dio.post(
      'https://api.cloudconvert.com/v2/jobs',
      data: payload,
      options: Options(headers: {'Authorization': 'Bearer $apiKey'}),
    );
    final jobData = jobRes.data['data'];
    final jobId = jobData['id'];
    print('Job created: $jobId');
    
    final tasks = jobData['tasks'] as List;
    final importTask = tasks.firstWhere((t) => t['operation'] == 'import/upload');
    final uploadUrl = importTask['result']['form']['url'];
    final parameters = importTask['result']['form']['parameters'] as Map<String, dynamic>;
    
    print('2. Uploading to $uploadUrl');
    final formData = FormData.fromMap({
      ...parameters,
      'file': await MultipartFile.fromFile(dummyFile.path, filename: 'dummy.png'),
    });
    
    await dio.post(uploadUrl, data: formData);
    print('Upload successful.');
    
    print('3. Polling...');
    while (true) {
      final statusRes = await dio.get(
        'https://api.cloudconvert.com/v2/jobs/$jobId',
        options: Options(headers: {'Authorization': 'Bearer $apiKey'}),
      );
      final statusData = statusRes.data['data'];
      print('Status: ' + statusData['status']);
      if (statusData['status'] == 'finished') {
        final jobTasks = statusData['tasks'] as List;
        final exportTask = jobTasks.firstWhere((t) => t['operation'] == 'export/url');
        print('Download URL: ' + exportTask['result']['files'][0]['url']);
        break;
      } else if (statusData['status'] == 'error') {
        print('Job Failed: $statusData');
        break;
      }
      await Future.delayed(Duration(seconds: 3));
    }
  } catch (e) {
    if (e is DioException) {
      print('DioError: ${e.response?.statusCode} ${e.response?.data}');
      print('Error details: $e');
    } else {
      print('Error: $e');
    }
  }
}
