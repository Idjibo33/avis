import 'package:flutter/material.dart';

class Responsiveness extends StatelessWidget {
  static const double maxWidth = 600;

  final Widget child;
  const Responsiveness({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth < maxWidth
            ? constraints.maxWidth
            : maxWidth;
        return Center(
          child: SizedBox(width: width, child: child),
        );
      },
    );
  }
}
