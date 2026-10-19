import 'package:flutter/material.dart';

// Sur le web, XFile.path est une URL blob utilisable par Image.network.
Widget imageFromPath(String path, {BoxFit fit = BoxFit.cover}) {
  return Image.network(path, fit: fit);
}
