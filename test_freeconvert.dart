import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final apiKey = 'api_production_d1d547b882c79479b595a0f66435ac61a5bfc4c753e2934c6cd9997ef5ac2259.6a5632029c8b7ba61e343ea2.6a5632249c8b7ba61e343eaa';
  
  final client = HttpClient();
  
  // 1. Create Job
  final jobReq = await client.postUrl(Uri.parse('https://api.freeconvert.com/v1/process/jobs'));
  jobReq.headers.add('Authorization', 'Bearer ' + apiKey);
  jobReq.headers.contentType = ContentType.json;
  
  final payload = {
    "tasks": {
        "import-1": {
            "operation": "import/upload"
        },
        "convert-1": {
            "operation": "convert",
            "input": "import-1",
            "input_format": "pdf",
            "output_format": "docx"
        },
        "export-1": {
            "operation": "export/url",
            "input": ["convert-1"]
        }
    }
  };
  
  jobReq.write(jsonEncode(payload));
  final jobRes = await jobReq.close();
  final jobBody = await jobRes.transform(utf8.decoder).join();
  print('Job Response: ' + jobRes.statusCode.toString() + ' ' + jobBody);
  
}
