import 'package:flutter/material.dart';
import 'package:converse/theme/palette.dart';

TextStyle text18MediumStyle(BuildContext context) {
  return TextStyle(
    fontFamily: 'custom_medium',
    fontSize: 18,
    color: Theme.of(context).textTheme.bodyMedium!.color,
  );
}

TextStyle toastStyle(BuildContext context) {
  return const TextStyle(
    fontFamily: 'custom_semi-bold',
    fontSize: 20,
    color: Palette.lightWhite,
  );
}
