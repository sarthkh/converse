import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Shimmer shimmer({
  required BuildContext context,
  required double height,
  required double width,
}) {
  return Shimmer.fromColors(
    baseColor: Theme.of(context).cardColor,
    highlightColor: Theme.of(context).hintColor.withOpacity(0.35),
    period: const Duration(milliseconds: 1750),
    child: Container(
      height: height,
      width: width,
      color: Theme.of(context).scaffoldBackgroundColor,
    ),
  );
}
