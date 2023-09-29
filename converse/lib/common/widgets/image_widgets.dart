import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget authImage({
  required String imagePath,
  required Color color,
  double width = 25,
  double height = 25,
}) {
  return SvgPicture.asset(
    imagePath,
    width: width,
    height: height,
    colorFilter: ColorFilter.mode(
      color,
      BlendMode.srcIn,
    ),
  );
}
