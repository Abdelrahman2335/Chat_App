import 'dart:ui';

class UIState {
  final bool isDarkMode;
  final Color color;
  final bool clearTextOnAction;
  final bool hidePassword;

  UIState({
    required this.isDarkMode,
    required this.color,
    required this.clearTextOnAction,
    required this.hidePassword,
  });

  UIState copyWith({
    bool? isDarkMode,
    Color? color,
    bool? clearTextOnAction,
    bool? hidePassword
  }) {
    return UIState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      color: color ?? this.color,
      clearTextOnAction: clearTextOnAction ?? this.clearTextOnAction,
        hidePassword:   hidePassword ?? this.hidePassword,
    );
  }

  static UIState initial() => UIState(
    isDarkMode: false,
    color: const Color(0xff4050B5), // or your default
    clearTextOnAction: false,
      hidePassword: true,
  );
}
