import 'dart:io';

import 'package:flutter/material.dart';

Widget imageFromPath(String path, {BoxFit fit = BoxFit.cover}) {
  return Image.file(File(path), fit: fit);
}
