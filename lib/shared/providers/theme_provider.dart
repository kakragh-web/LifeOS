import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos_ai/core/constants/app_constants.dart';
import 'package:lifeos_ai/core/services/storage_service.dart';

/// Persists and exposes the current [ThemeMode].
/// Reads the stored value on startup; writes on every change.
final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final stored =
        ref.read(storageServiceProvider).getString(StorageKeys.themeMode);
    return switch (stored) {
      'dark' => ThemeMode.dark,
      'light' => ThemeMode.light,
      _ => ThemeMode.system,
    };
  }

  Future<void> setMode(ThemeMode mode) async {
    state = mode;
    await ref
        .read(storageServiceProvider)
        .setString(StorageKeys.themeMode, mode.name);
  }

  void toggle() =>
      setMode(state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
}
