import 'dart:io';

import 'package:avis/auth_gate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void naviguerAuthGate(BuildContext context) {
  if (Platform.isIOS) {
    Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(builder: (context) => AuthGate()),
      (route) => false,
    );
  }
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => AuthGate()),
    (route) => false,
  );
}
