import 'package:flutter/material.dart';
import 'package:text_scroll/text_scroll.dart';

Widget text25Bold({
  required BuildContext context,
  required String text,
}) {
  return Text(
    text,
    style: TextStyle(
      fontFamily: 'custom_bold',
      fontSize: 25,
      color: Theme.of(context).textTheme.bodyLarge!.color,
    ),
  );
}

Widget text18Regular({
  required BuildContext context,
  required String text,
}) {
  return Text(
    text,
    style: TextStyle(
      fontFamily: 'custom_regular',
      fontSize: 18,
      color: Theme.of(context).textTheme.bodySmall!.color,
    ),
  );
}

Widget text20ExtraBold({
  required BuildContext context,
  required String text,
}) {
  return Text(
    text,
    style: TextStyle(
      fontFamily: 'custom_extra-bold',
      fontSize: 20,
      letterSpacing: 2,
      color: Theme.of(context).textTheme.bodySmall!.color,
    ),
  );
}

Widget text24Medium({
  required BuildContext context,
  required String text,
}) {
  return Text(
    text,
    style: TextStyle(
      fontFamily: 'custom_medium',
      fontSize: 24,
      color: Theme.of(context).textTheme.bodyLarge!.color,
    ),
  );
}

Widget text16Regular({
  required BuildContext context,
  required String text,
}) {
  return Text(
    text,
    style: TextStyle(
      fontFamily: 'custom_regular',
      fontSize: 16,
      color: Theme.of(context).textTheme.bodyLarge!.color,
    ),
  );
}

Widget text15Regular(
    {required BuildContext context,
    required String text,
    required Color color}) {
  return Text(
    text,
    style: TextStyle(
      fontFamily: 'custom_regular',
      fontSize: 15,
      color: color,
    ),
  );
}

Widget textUnderline({
  required String text,
  required Color color,
}) {
  return GestureDetector(
    onTap: () {},
    child: Text(
      text,
      style: TextStyle(
        fontFamily: 'custom_regular',
        fontSize: 16,
        color: color,
        decoration: TextDecoration.underline,
      ),
    ),
  );
}

Widget text22SemiBold({
  required BuildContext context,
  required String text,
}) {
  return Text(
    text,
    style: TextStyle(
      fontFamily: 'custom_semi-bold',
      fontSize: 22,
      color: Theme.of(context).textTheme.bodyLarge!.color,
    ),
  );
}

Widget text20Medium({
  required BuildContext context,
  required String text,
}) {
  return Text(
    text,
    style: TextStyle(
      fontFamily: 'custom_medium',
      fontSize: 20,
      color: Theme.of(context).textTheme.bodySmall!.color,
    ),
  );
}

Widget textScroll17Regular({
  required BuildContext context,
  required String text,
}) {
  return TextScroll(
    text,
    style: TextStyle(
      fontFamily: 'custom_regular',
      fontSize: 17,
      color: Theme.of(context).textTheme.bodySmall!.color,
    ),
    mode: TextScrollMode.bouncing,
    velocity: const Velocity(pixelsPerSecond: Offset(20, 0)),
    pauseBetween: const Duration(milliseconds: 2000),
  );
}
