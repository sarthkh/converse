import 'package:converse/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

bool isFromLogin = true;

void googleSignIn(BuildContext context, WidgetRef ref) {
  ref.read(authControllerProvider.notifier).googleSignIn(context, isFromLogin);
}

void facebookSignIn(BuildContext context, WidgetRef ref) {
  ref.read(authControllerProvider.notifier).facebookSignIn(context, isFromLogin);
}

Widget thirdPartyLogin(BuildContext context, WidgetRef ref) {
  return Container(
    margin: const EdgeInsets.only(
      left: 35,
      right: 35,
      top: 65,
      bottom: 50,
    ),
    width: 225,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _loginButton(
          context: context,
          imagePath: "assets/images/svgs/register/google.svg",
          onTap: () => googleSignIn(context, ref),
        ),
        _loginButton(
          context: context,
          imagePath: "assets/images/svgs/register/facebook.svg",
          onTap: () => facebookSignIn(context, ref),
        ),
        _loginButton(
          context: context,
          imagePath: "assets/images/svgs/register/phone.svg",
          onTap: () {},
        ),
      ],
    ),
  );
}

Widget _loginButton({
  required BuildContext context,
  required String imagePath,
  required Function() onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: SizedBox(
      width: 35,
      height: 35,
      child: SvgPicture.asset(
        imagePath,
        colorFilter: ColorFilter.mode(
          Theme.of(context).hintColor,
          BlendMode.srcIn,
        ),
      ),
    ),
  );
}
