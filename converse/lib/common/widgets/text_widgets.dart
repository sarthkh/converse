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

Widget text16Medium({
  required BuildContext context,
  required String text,
}) {
  return Text(
    text,
    style: TextStyle(
      fontFamily: 'custom_medium',
      fontSize: 16,
      color: Theme.of(context).textTheme.bodySmall!.color,
    ),
  );
}

Widget text17Medium({
  required BuildContext context,
  required String text,
}) {
  return Text(
    text,
    style: TextStyle(
      fontFamily: 'custom_medium',
      fontSize: 17,
      color: Theme.of(context).textTheme.bodyMedium!.color,
    ),
  );
}

Widget text16SemiBold({
  required BuildContext context,
  required String text,
}) {
  return Text(
    text,
    style: TextStyle(
      fontFamily: 'custom_semi-bold',
      fontSize: 16,
      color: Theme.of(context).textTheme.bodyLarge!.color,
    ),
  );
}

Widget text20SemiBold({
  required BuildContext context,
  required String text,
}) {
  return Text(
    text,
    style: TextStyle(
      fontFamily: 'custom_semi-bold',
      fontSize: 20,
      color: Theme.of(context).textTheme.bodyMedium!.color,
    ),
  );
}

Widget text17SemiBoldItalic({
  required BuildContext context,
  required String text,
}) {
  return Text(
    text,
    style: TextStyle(
      fontFamily: 'custom_semi-bold-italic',
      fontSize: 17,
      color: Theme.of(context).textTheme.bodyLarge!.color,
    ),
  );
}

Widget text17SemiBold({
  required BuildContext context,
  required String text,
  TextOverflow? overflow,
}) {
  return Text(
    text,
    style: TextStyle(
      fontFamily: 'custom_bold',
      fontSize: 17,
      letterSpacing: 1.25,
      color: Theme.of(context).textTheme.bodySmall!.color,
    ),
    overflow: overflow,
  );
}

Widget text16Bold({
  required BuildContext context,
  required String text,
}) {
  return Text(
    text,
    style: TextStyle(
      fontFamily: 'custom_bold',
      fontSize: 16,
      color: Theme.of(context).textTheme.bodyLarge!.color,
    ),
    overflow: TextOverflow.ellipsis,
    maxLines: 1,
  );
}

Widget text14Medium({
  required BuildContext context,
  required String text,
}) {
  return Text(
    text,
    style: TextStyle(
      fontFamily: 'custom_medium',
      fontSize: 14,
      color: Theme.of(context).textTheme.bodyLarge!.color,
    ),
  );
}

Widget text20Bold({
  required BuildContext context,
  required String text,
}) {
  return Text(
    text,
    style: TextStyle(
      fontFamily: 'custom_bold',
      fontSize: 20,
      color: Theme.of(context).textTheme.bodyLarge!.color,
    ),
  );
}

Widget text20Heavy({
  required BuildContext context,
  required String text,
}) {
  return Text(
    text,
    style: TextStyle(
      fontFamily: 'custom_heavy',
      fontSize: 20,
      letterSpacing: 1,
      color: Theme.of(context).primaryColor,
    ),
  );
}
