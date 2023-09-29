import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_svg/svg.dart';
import 'package:converse/common/widgets/text_styles.dart';
import 'package:converse/theme/palette.dart';

enum ToastType { pass, fail, info, alert }

Map<ToastType, String> toastIcons = {
  ToastType.pass: "assets/images/svgs/register/pass.svg",
  ToastType.fail: "assets/images/svgs/register/fail.svg",
  ToastType.info: "assets/images/svgs/register/info.svg",
  ToastType.alert: "assets/images/svgs/register/alert.svg",
};

ToastFuture toastInfo({
  required BuildContext context,
  required String msg,
  required ToastType type,
  Duration duration = const Duration(milliseconds: 2500),
  Duration animDuration = const Duration(milliseconds: 1000),
  ColorFilter colorFilter = const ColorFilter.mode(
    Palette.lightWhite,
    BlendMode.srcIn,
  ),
}) {
  return showToastWidget(
    IconToastWidget.toast(
      msg: msg,
      type: type,
      colorFilter: colorFilter,
    ),
    context: context,
    position: StyledToastPosition.center,
    animation: StyledToastAnimation.scale,
    reverseAnimation: StyledToastAnimation.fade,
    duration: duration,
    animDuration: animDuration,
    curve: Curves.elasticOut,
    reverseCurve: Curves.linear,
  );
}

class IconToastWidget extends StatelessWidget {
  final ToastType toastType;
  final String message;
  final ColorFilter colorFilter;
  final Color? backgroundColor;
  final Widget? textWidget;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final ShapeBorder? shape;
  final EdgeInsetsGeometry? margin;

  const IconToastWidget({
    super.key,
    required this.toastType,
    required this.message,
    required this.colorFilter,
    this.backgroundColor,
    this.textWidget,
    this.height,
    this.width,
    this.padding,
    this.shape,
    this.margin,
  });

  factory IconToastWidget.toast({
    required ToastType type,
    required String msg,
    required ColorFilter colorFilter,
  }) =>
      IconToastWidget(
        toastType: type,
        message: msg,
        colorFilter: colorFilter,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 35),
      padding:
          padding ?? const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      decoration: ShapeDecoration(
        color: backgroundColor ?? Theme.of(context).cardColor,
        shape: shape ??
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          _buildSvgPicture(),
          _buildContent(context),
        ],
      ),
    );
  }

  Widget _buildSvgPicture() {
    final svgAsset = toastIcons[toastType]!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: SvgPicture.asset(
        svgAsset,
        fit: BoxFit.fitWidth,
        width: 35,
        height: 35,
        colorFilter: colorFilter,
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return textWidget ??
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            message,
            style: toastStyle(context),
            softWrap: true,
            maxLines: 5,
          ),
        );
  }
}
