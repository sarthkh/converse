import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PassStrengthChecker extends ConsumerWidget {
  const PassStrengthChecker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strength = ref.watch(passwordStrengthProvider);

    return Container(
      width: 345,
      height: 5,
      margin: const EdgeInsets.symmetric(vertical: 25),
      child: LinearProgressIndicator(
        value: strength,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        color: strength <= 1 / 4
            ? Colors.red
            : strength == 2 / 4
                ? Colors.yellow
                : strength == 3 / 4
                    ? Colors.blue
                    : Colors.green,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

final passwordStrengthProvider =
    AutoDisposeStateNotifierProvider<PasswordStrengthNotifier, double>(
  (ref) {
    return PasswordStrengthNotifier();
  },
);

class PasswordStrengthNotifier extends StateNotifier<double> {
  PasswordStrengthNotifier() : super(0);

  RegExp numReg = RegExp(r".*[0-9].*");
  RegExp letterReg = RegExp(r".*[A-Za-z].*");

  void checkPassword(String value) {
    String password = value.trim();

    if (password.isEmpty) {
      state = 0;
    } else if (password.length < 5) {
      state = 1 / 4;
    } else if (password.length < 8) {
      state = 2 / 4;
    } else {
      if (!letterReg.hasMatch(password) || !numReg.hasMatch(password)) {
        // length >= 8 but does not contain both letter and digit characters
        state = 3 / 4;
      } else {
        // length >= 8 and contains both letter and digit characters
        state = 4 / 4;
      }
    }

    @override
    void dispose() {
      state = 0;
      super.dispose();
    }
  }
}
