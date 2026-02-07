import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/settings_entity.dart';
import '../../../../core/storage/objectbox_manager.dart';
import '../../../../core/network/audio_service.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final ObjectBoxManager _storage;

  SettingsCubit(this._storage) : super(SettingsState.initial()) {
    _loadSettings();
  }

  void _loadSettings() {
    final settings = _storage.settingsBox.getAll();
    if (settings.isNotEmpty) {
      final s = settings.first;
      AudioService.soundEnabled = s.isSoundEnabled;
      emit(
        state.copyWith(
          themeMode: s.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          isSoundEnabled: s.isSoundEnabled,
        ),
      );
    }
  }

  void toggleTheme() {
    final newMode = state.themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    emit(state.copyWith(themeMode: newMode));
    _saveSettings();
  }

  void toggleSound() {
    emit(state.copyWith(isSoundEnabled: !state.isSoundEnabled));
    _saveSettings();
  }

  void _saveSettings() {
    AudioService.soundEnabled = state.isSoundEnabled;
    final settings = _storage.settingsBox.getAll();
    if (settings.isNotEmpty) {
      final s = settings.first;
      _storage.settingsBox.put(
        AppSettings(
          id: s.id,
          isDarkMode: state.themeMode == ThemeMode.dark,
          isSoundEnabled: state.isSoundEnabled,
        ),
      );
    } else {
      _storage.settingsBox.put(
        AppSettings(
          isDarkMode: state.themeMode == ThemeMode.dark,
          isSoundEnabled: state.isSoundEnabled,
        ),
      );
    }
  }
}
