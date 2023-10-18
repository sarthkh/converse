import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class CustomDrawer extends ConsumerWidget {
  final Widget menuScreen;
  final Widget mainScreen;
  final ZoomDrawerController? controller;
  final bool isRtl;

  const CustomDrawer({
    super.key,
    required this.menuScreen,
    required this.mainScreen,
    required this.isRtl,
    required this.controller,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ZoomDrawer(
      controller: controller,
      menuScreen: menuScreen,
      mainScreen: mainScreen,
      borderRadius: 25,
      angle: 0,
      openCurve: Curves.ease,
      closeCurve: Curves.ease,
      duration: const Duration(milliseconds: 375),
      mainScreenScale: 0.325,
      reverseDuration: const Duration(milliseconds: 375),
      showShadow: true,
      mainScreenTapClose: true,
      drawerShadowsBackgroundColor: Theme.of(context).cardColor,
      slideWidth: MediaQuery.of(context).size.width * 0.75,
      menuBackgroundColor: Theme.of(context).colorScheme.surface,
      isRtl: isRtl,
    );
  }
}
