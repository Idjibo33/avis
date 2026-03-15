import 'dart:io';

import 'package:avis/Screens/new_post_screen.dart';
import 'package:avis/Screens/user_profil_screen.dart';
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

void naviguerNewPostScreen(BuildContext context) {
  if (Platform.isIOS) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => NewPostScreen()),
    );
  }
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => NewPostScreen()),
  );
}

void naviguerProfilScreen(BuildContext context) {
  if (Platform.isIOS) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => UserProfilScreen()),
    );
  }
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => UserProfilScreen()),
  );
}
