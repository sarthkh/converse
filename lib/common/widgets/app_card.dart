import 'package:flutter/material.dart';
import 'package:converse/common/widgets/app_decorations.dart';
import 'package:converse/common/widgets/text_widgets.dart';

Widget appCard({
  required BuildContext context,
  required double width,
  required double height,
  required Function()? onTap,
  required Widget child,
}) {
  return GestureDetector(
    onTap: onTap,
    child: SizedBox(
      width: width,
      height: height,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Theme.of(context).colorScheme.secondary,
        elevation: 10,
        child: Center(
          child: child,
        ),
      ),
    ),
  );
}
