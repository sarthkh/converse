import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:converse/common/widgets/popup_message.dart';
import 'package:converse/pages/signup/notifier/signup_notifier.dart';

class SignUpController {
  late WidgetRef ref;

  SignUpController({required this.ref});

  void handleSignUp(BuildContext context) {
    var state = ref.read(signUpNotifierProvider);

    String name = state.userName;
    String email = state.email;
    String password = state.password;
    String rePassword = state.rePassword;

    if (!RegExp(r'^[a-zA-Z0-9_]{5,}$').hasMatch(name)) {
      toastInfo(
        context: context,
        type: ToastType.alert,
        msg:
            "Username is invalid. It should be at least 5 characters long and consist of alphanumeric characters and underscores.",
      );
      return;
    }

    if (!RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(email)) {
      toastInfo(
        context: context,
        type: ToastType.alert,
        msg: "Please enter a valid email!",
      );
      return;
    }

    if (password != rePassword) {
      toastInfo(
        context: context,
        type: ToastType.alert,
        msg: "Passwords do not match!",
      );
      return;
    }
  }
}
