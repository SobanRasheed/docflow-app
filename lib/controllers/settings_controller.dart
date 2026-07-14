import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_controller.g.dart';

class SettingsState {
  const SettingsState({
    this.isDarkMode = false,
    this.autoDeleteFiles = false,
  });

  final bool isDarkMode;
  final bool autoDeleteFiles;

  SettingsState copyWith({
    bool? isDarkMode,
    bool? autoDeleteFiles,
  }) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      autoDeleteFiles: autoDeleteFiles ?? this.autoDeleteFiles,
    );
  }
}

@riverpod
class SettingsController extends AsyncNotifier<SettingsState> {
  @override
  Future<SettingsState> build() async => const SettingsState();

  void toggleDarkMode(bool value) {
    state = AsyncData(state.value!.copyWith(isDarkMode: value));
  }

  void toggleAutoDelete(bool value) {
    state = AsyncData(state.value!.copyWith(autoDeleteFiles: value));
  }
}