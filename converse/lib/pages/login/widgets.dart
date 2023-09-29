import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget thirdPartyLogin(BuildContext context) {
  return Container(
    margin: const EdgeInsets.only(
      left: 75,
      right: 75,
      top: 65,
      bottom: 50,
    ),
    width: 345,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _loginButton(
          context: context,
          imagePath: "assets/images/svgs/register/google.svg",
        ),
        _loginButton(
          context: context,
          imagePath: "assets/images/svgs/register/facebook.svg",
        ),
        _loginButton(
          context: context,
          imagePath: "assets/images/svgs/register/x.svg",
        ),
      ],
    ),
  );
}

Widget _loginButton({
  required BuildContext context,
  required String imagePath,
}) {
  return GestureDetector(
    onTap: () {},
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
