import 'package:flutter/material.dart';
import 'package:converse/common/widgets/app_decorations.dart';
import 'package:converse/common/widgets/text_widgets.dart';

Widget appButton({
  required BuildContext context,
  required String buttonName,
  double width = 345,
  double height = 50,
  bool isLogin = true,
  void Function()? func,
}) {
  return GestureDetector(
    onTap: func,
    child: Container(
      width: width,
      height: height,
      // if isLogin true then put primary color else background color
      decoration: appBoxShadow(
        context: context,
        color: isLogin
            ? Theme.of(context).primaryColor
            : Theme.of(context).scaffoldBackgroundColor,
        border: Border.all(color: Theme.of(context).primaryColor),
      ),
      child: Center(
        child: text20ExtraBold(
          context: context,
          text: buttonName,
        ),
      ),
    ),
  );
}

Widget iconButton({
  required Function() onPressed,
  required Widget icon,
  EdgeInsets? margin,
  EdgeInsets? padding,
}) {
  return Container(
    margin: margin,
    padding: padding,
    child: IconButton(
      onPressed: onPressed,
      icon: icon,
    ),
  );
}

Widget outlinedButton({
  required BuildContext context,
  required Function() onPressed,
  required Widget child,
}) {
  return OutlinedButton(
    onPressed: onPressed,
    style: OutlinedButton.styleFrom(
      side: BorderSide(
        color: Theme.of(context).primaryColor,
      ),
    ),
    child: child,
  );
}

Widget textButton({
  required Function() onPressed,
  required Widget child,
  EdgeInsetsGeometry? padding,
}) {
  return Container(
    padding: padding,
    child: TextButton(
      onPressed: onPressed,
      child: child,
    ),
  );
}
