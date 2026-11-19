import 'package:avis/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Logo extends StatelessWidget {
  final double size;
  const Logo({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    final double padding = size / 2;
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: const BoxDecoration(color: noir, shape: BoxShape.circle),
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: FaIcon(
              FontAwesomeIcons.layerGroup,
              size: size,
              color: blanc,
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            width: size * 0.36,
            height: size * 0.36,
            decoration: BoxDecoration(
              color: teal,
              shape: BoxShape.circle,
              border: Border.all(color: blanc, width: size * 0.07),
            ),
          ),
        ),
      ],
    );
  }
}
