import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../views/screens/done/done_screen.dart';
import '../views/screens/files/files_screen.dart';
import '../views/screens/home/home_screen.dart';
import '../views/screens/progress/progress_screen.dart';
import '../views/screens/settings/settings_screen.dart';
import '../views/screens/upload/upload_screen.dart';
import '../views/widgets/common/glass_nav_bar.dart';
import 'route_names.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RouteNames.home,
    routes: [
      ShellRoute(
        builder: (context, state, child) => GlassNavBar(child: child),
        routes: [
          GoRoute(
            path: RouteNames.home,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: RouteNames.files,
            builder: (context, state) => const FilesScreen(),
          ),
          GoRoute(
            path: RouteNames.settings,
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.upload,
        builder: (context, state) => const UploadScreen(),
      ),
      GoRoute(
        path: RouteNames.progress,
        builder: (context, state) => const ProgressScreen(),
      ),
      GoRoute(
        path: RouteNames.done,
        builder: (context, state) => const DoneScreen(),
      ),
    ],
  );
});