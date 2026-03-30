import 'package:flutter/material.dart';

final messengerKey = GlobalKey<ScaffoldMessengerState>();
void showSuccess(String message) {
  messengerKey.currentState!.showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.green,
    ),
  );
}

void showError(String message) {
  messengerKey.currentState!.showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.red,
    ),
  );
}
