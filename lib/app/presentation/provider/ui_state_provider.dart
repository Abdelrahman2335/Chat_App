import 'package:flutter_riverpod/flutter_riverpod.dart';

final hidePassProvider = NotifierProvider<HidePassNotifier, bool>(() => HidePassNotifier());

class HidePassNotifier extends Notifier<bool> {
  @override
  bool build() => true;

  void toggle() => state = !state;

  void set(bool value) => state = value;
}
