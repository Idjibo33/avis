import 'package:avis/Screens/new_post_screen.dart';
import 'package:avis/Screens/user_profil_screen.dart';
import 'package:avis/auth_gate.dart';
import 'package:flutter/material.dart';

void naviguerAuthGate(BuildContext context) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => AuthGate()),
    (route) => false,
  );
}

void naviguerNewPostScreen(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => NewPostScreen()),
  );
}

void naviguerProfilScreen(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => UserProfilScreen()),
  );
}
