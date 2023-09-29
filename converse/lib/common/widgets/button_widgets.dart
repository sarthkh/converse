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
