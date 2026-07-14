import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final publicKey = 'project_public_12caf94bff6a22a64d34bcf28f2450be_CasLM3395ec90549c1992fa7e78429f3665da';
  
  final client = HttpClient();
  
  // 1. Auth
  final authReq = await client.postUrl(Uri.parse('https://api.ilovepdf.com/v1/auth'));
  authReq.headers.contentType = ContentType.json;
  authReq.write(jsonEncode({'public_key': publicKey}));
  final authRes = await authReq.close();
  final authBody = await authRes.transform(utf8.decoder).join();
  
  final token = jsonDecode(authBody)['token'];
  
  for (final tool in ['pdfoffice', 'pdfword', 'officepdf', 'pdfexcel']) {
    final startReq = await client.getUrl(Uri.parse('https://api.ilovepdf.com/v1/start/' + tool));
    startReq.headers.add('Authorization', 'Bearer ' + token);
    final startRes = await startReq.close();
    final startBody = await startRes.transform(utf8.decoder).join();
    print(tool + ' -> ' + startRes.statusCode.toString() + ' ' + startBody);
  }
}
