import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:converse/theme/palette.dart';
import 'package:converse/common/widgets/button_widgets.dart';
import 'package:converse/common/widgets/text_widgets.dart';
import 'package:converse/common/widgets/app_bar.dart';
import 'package:converse/common/widgets/app_textfield.dart';
import 'package:converse/pages/signup/notifier/signup_notifier.dart';
import 'package:converse/pages/signup/controller.dart';
import 'package:converse/pages/signup/pass_strength_checker.dart';

final passwordVisibleStateProvider = StateProvider<bool>((ref) {
  return true;
});
final confirmPasswordVisibleStateProvider = StateProvider<bool>((ref) {
  return true;
});

class SignUp extends ConsumerWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signUpProvider = ref.watch(signUpNotifierProvider);

    final bool isLightTheme =
        Theme.of(context).colorScheme.brightness == Brightness.light;

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          child: Scaffold(
            appBar: buildAppbar(
              context: context,
              bottom: true,
              actions: const [],
              title: text24Medium(context: context, text: "Create Account"),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 35),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 35),
                  // signup message to enter details
                  Center(
                    child: text16Regular(
                      context: context,
                      text: "Enter your details below to signup",
                    ),
                  ),
                  // spacing
                  const SizedBox(height: 30),
                  // username text box
                  AppTextField(
                    text: "Username",
                    iconName: "assets/images/svgs/register/user.svg",
                    hintText: "Enter your username",
                    isPasswordField: false,
                    func: (value) => ref
                        .read(signUpNotifierProvider.notifier)
                        .onUserNameChange(value),
                  ),
                  // spacing
                  const SizedBox(height: 25),
                  // email text box
                  AppTextField(
                    text: "Email Address",
                    iconName: "assets/images/svgs/register/mail.svg",
                    hintText: "Enter your email address",
                    isPasswordField: false,
                    func: (value) => ref
                        .read(signUpNotifierProvider.notifier)
                        .onUserEmailChange(value),
                  ),
                  // spacing
                  const SizedBox(height: 25),
                  // password text box
                  AppTextField(
                    text: "Password",
                    iconName: "assets/images/svgs/register/lock.svg",
                    hintText: "Enter your password",
                    isPasswordField: true,
                    func: (value) {
                      ref
                          .read(passwordStrengthProvider.notifier)
                          .checkPassword(value);
                      ref
                          .read(signUpNotifierProvider.notifier)
                          .onUserPasswordChange(value);
                    },
                    obscureTextProvider: passwordVisibleStateProvider,
                  ),
                  // password strength checker
                  const PassStrengthChecker(),
                  // confirm password text box
                  AppTextField(
                    text: "Confirm Password",
                    iconName: "assets/images/svgs/register/lock.svg",
                    hintText: "Enter your confirm password",
                    isPasswordField: true,
                    func: (value) => ref
                        .read(signUpNotifierProvider.notifier)
                        .onUserRePasswordChange(value),
                    obscureTextProvider: confirmPasswordVisibleStateProvider,
                  ),
                  // spacing
                  const SizedBox(height: 40),
                  // terms and conditions text
                  SizedBox(
                    width: 345,
                    child: text15Regular(
                      context: context,
                      text:
                          "By creating an account, you agree to our Terms of Use and Privacy Policy",
                      color:
                          isLightTheme ? Palette.darkBlue : Palette.lightBlue,
                    ),
                  ),
                  // spacing
                  const SizedBox(height: 30),
                  // app signup button
                  Center(
                    child: appButton(
                      context: context,
                      buttonName: "SIGN UP",
                      func: () {
                        SignUpController(ref: ref).handleSignUp(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
