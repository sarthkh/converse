import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

Widget circleAvatar({
  required ImageProvider backgroundImage,
  double? radius,
}) {
  return CircleAvatar(
    backgroundImage: backgroundImage,
    radius: radius,
  );
}
