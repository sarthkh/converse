import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'welcome_notifier.g.dart';

// welcome page auto dispose notifier provider
@riverpod
class IndexDot extends _$IndexDot {
  @override
  int build() {
    return 0;
  }

  void changeIndex(value) {
    state = value;
  }
}
