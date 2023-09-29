import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:converse/common/widgets/text_widgets.dart';

Widget welcomePage({
  required BuildContext context,
  required String imagePath,
  required String title,
  required String subTitle,
  required int index,
  required PageController controller,
}) {
  return SafeArea(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            width: 325,
            height: 325,
            margin: const EdgeInsets.symmetric(vertical: 65),
            child: SvgPicture.asset(
              imagePath,
              fit: BoxFit.contain,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: text25Bold(text: title, context: context),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20),
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: text18Regular(text: subTitle, context: context),
        ),
      ],
    ),
  );
}
