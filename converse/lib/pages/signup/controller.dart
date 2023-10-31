import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:converse/common/widgets/popup_message.dart';
import '../../auth/controller/auth_controller.dart';
import 'notifier/signup_notifier.dart';

class SignUpController {
  late WidgetRef ref;

  SignUpController({required this.ref});

  void handleSignUp(BuildContext context) {
    var state = ref.read(signUpNotifierProvider);

    String name = state.userName;
    String email = state.email;
    String password = state.password;
    String rePassword = state.rePassword;

    if (!RegExp(r'^[a-zA-Z0-9_]{5,25}$').hasMatch(name)) {
      toastInfo(
        context: context,
        type: ToastType.alert,
        msg:
            "Hold on, your username should be 5-25 characters long and can include letters, numbers, and underscores.",
      );
      return;
    }

    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(email)) {
      toastInfo(
        context: context,
        type: ToastType.alert,
        msg: "Oops, that email doesn't look right. Try again?",
      );
      return;
    }

    if (password.isEmpty) {
      toastInfo(
        context: context,
        msg: "Hey, your password can't be left blank.",
        type: ToastType.alert,
      );
      return;
    } else if (password.length < 5) {
      toastInfo(
        context: context,
        msg:
            "Just a heads up, your password should be at least 5 characters long.",
        type: ToastType.alert,
      );
      return;
    }

    if (rePassword.isEmpty) {
      toastInfo(
        context: context,
        type: ToastType.alert,
        msg: "Oops, you forgot to confirm your password.",
      );
      return;
    }

    if (password != rePassword) {
      toastInfo(
        context: context,
        type: ToastType.alert,
        msg: "Hmm, passwords don't match. Try again?",
      );
      return;
    }

    ref
        .read(authControllerProvider.notifier)
        .signUpWithEmail(context, email, password, name);
  }
}
