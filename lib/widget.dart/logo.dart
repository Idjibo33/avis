import 'package:avis/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Logo extends StatelessWidget {
  final double size;
  const Logo({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    double padding = size / 2;
    return Stack(
      alignment: AlignmentGeometry.center,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [backgroundCouleureBleue, backgroundCouleureRose],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: FaIcon(FontAwesomeIcons.layerGroup, size: size),
          ),
        ),
      ],
    );
  }
}
