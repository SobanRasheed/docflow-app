import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../controllers/auth_controller.dart';

import '../views/screens/auth/login_screen.dart';
import '../views/screens/auth/register_screen.dart';
import '../views/screens/auth/splash_screen.dart';
import '../views/screens/done/done_screen.dart';
import '../views/screens/files/files_screen.dart';
import '../views/screens/home/home_screen.dart';
import '../views/screens/progress/progress_screen.dart';
import '../views/screens/settings/settings_screen.dart';
import '../views/screens/upload/upload_screen.dart';
import '../views/widgets/common/glass_nav_bar.dart';
import 'route_names.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: RouteNames.splash,
    redirect: (context, state) {
      // Don't redirect during splash screen or while auth is still loading
      if (state.matchedLocation == RouteNames.splash || authState.isLoading) {
        return null;
      }

      final isAuth = authState.value != null;
      final isGoingToLogin = state.matchedLocation == RouteNames.login || state.matchedLocation == RouteNames.register;

      if (!isAuth && !isGoingToLogin) {
        return RouteNames.login;
      }

      if (isAuth && isGoingToLogin) {
        return RouteNames.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.register,
        builder: (context, state) => const RegisterScreen(),
      ),
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