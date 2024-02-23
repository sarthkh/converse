import 'dart:async';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<Map<String, dynamic>> compressFile(
  File file, {
  required int quality,
}) async {
  // to generate temp path
  final dir = await Directory.systemTemp.create();
  final targetPath =
      '${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

  var result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    targetPath,
    quality: quality,
  );

  return {
    'file': File(result!.path),
    'dir': dir,
  };
}
