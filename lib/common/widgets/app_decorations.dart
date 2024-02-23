import 'package:flutter/material.dart';

BoxDecoration appBoxShadow({
  required BuildContext context,
  required Color color,
  double radius = 15,
  double spreadR = 1.25,
  double blurR = 2.5,
  BoxBorder? border,
}) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(radius),
    border: border,
    boxShadow: [
      BoxShadow(
        color: Theme.of(context).primaryColor.withOpacity(0.35),
        spreadRadius: spreadR,
        blurRadius: blurR,
        offset: const Offset(0, 0), //x,y
      ),
    ],
  );
}

BoxDecoration appBoxDecorationTextField({
  required BuildContext context,
  required Color color,
  required Color borderColor,
  double radius = 15,
}) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: borderColor),
  );
}
