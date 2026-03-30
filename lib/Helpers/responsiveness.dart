import 'package:flutter/material.dart';

class Responsiveness extends StatelessWidget {
  final Widget child;
  const Responsiveness({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Center(
        child: FractionallySizedBox(
          widthFactor: constraints.maxWidth < 500 ? 1 : 0.5,
          child: child,
        ),
      ),
    );
  }
}
