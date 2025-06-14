import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/ui_state_model.dart';

class UIStateNotifier extends StateNotifier<UIState> {
  UIStateNotifier() : super(UIState.initial());

  void toggleTheme() {
    state = state.copyWith(isDarkMode: !state.isDarkMode);
  }

  void toggleColor(Color selectedColor) {
    state = state.copyWith(color: selectedColor);
  }

  void setClearText() {}

  void togglePassword() {
    state = state.copyWith(hidePassword: !state.hidePassword);
  }

}

final uiStateNotifier = StateNotifierProvider<UIStateNotifier, UIState>((ref) {
  return UIStateNotifier();
});
