import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'core/theme/theme.dart';
import 'routes/app_router.dart';
import 'services/history_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // .env is optional when ILOVEPDF_PUBLIC_KEY is supplied via --dart-define.
  }
  await Hive.initFlutter();
  await HistoryService().init();
  runApp(const ProviderScope(child: DocFlowApp()));
}

class DocFlowApp extends ConsumerWidget {
  const DocFlowApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: 'DocFlow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: router,
    );
  }
}