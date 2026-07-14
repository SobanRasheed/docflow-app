import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors.dart';
import '../../../routes/route_names.dart';

class GlassNavBar extends StatelessWidget {
  const GlassNavBar({super.key, required this.child});
  final Widget child;

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith(RouteNames.files)) return 1;
    if (location.startsWith(RouteNames.settings)) return 2;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final index = _currentIndex(context);

    return Scaffold(
      body: child,
      extendBody: true,
      bottomNavigationBar: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Theme(
            data: Theme.of(context).copyWith(
              navigationBarTheme: NavigationBarThemeData(
                backgroundColor: isDark ? AppColors.darkGlass : AppColors.lightGlass,
                elevation: 0,
                surfaceTintColor: Colors.transparent,
              ),
            ),
            child: NavigationBar(
              selectedIndex: index,
              onDestinationSelected: (i) {
                switch (i) {
                  case 0:
                    context.go(RouteNames.home);
                  case 1:
                    context.go(RouteNames.files);
                  case 2:
                    context.go(RouteNames.settings);
                }
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.folder_outlined),
                  selectedIcon: Icon(Icons.folder),
                  label: 'Files',
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}