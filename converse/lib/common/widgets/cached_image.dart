import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

CachedNetworkImage cachedNetworkImage({
  required String imageUrl,
  required BoxFit fit,
  required Widget Function(BuildContext, String) placeholder,
  required Widget Function(BuildContext, String, Object) errorWidget,
}) {
  return CachedNetworkImage(
    imageUrl: imageUrl,
    fit: fit,
    placeholder: placeholder,
    fadeInCurve: Curves.ease,
    fadeOutCurve: Curves.ease,
    errorWidget: errorWidget,
  );
}

CachedNetworkImageProvider cachedNetworkImageProvider({
  required String url,
}) {
  return CachedNetworkImageProvider(url);
}
