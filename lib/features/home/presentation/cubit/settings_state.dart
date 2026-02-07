import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SettingsState extends Equatable {
  final ThemeMode themeMode;
  final bool isSoundEnabled;

  const SettingsState({required this.themeMode, required this.isSoundEnabled});

  factory SettingsState.initial() =>
      const SettingsState(themeMode: ThemeMode.dark, isSoundEnabled: true);

  SettingsState copyWith({ThemeMode? themeMode, bool? isSoundEnabled}) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      isSoundEnabled: isSoundEnabled ?? this.isSoundEnabled,
    );
  }

  @override
  List<Object?> get props => [themeMode, isSoundEnabled];
}
