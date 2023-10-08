import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'dart:ui' as ui;

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        fit: StackFit.expand,
        children: [
          BackdropFilter(
            filter: ui.ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: Container(
              color: Theme.of(context).cardColor.withOpacity(0.125),
            ),
          ),
          Center(
            child: LoadingAnimationWidget.flickr(
              leftDotColor: Theme.of(context).hintColor,
              rightDotColor: Theme.of(context).colorScheme.secondary,
              size: 75,
            ),
          ),
        ],
      ),
    );
  }
}
