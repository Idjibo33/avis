import 'package:avis/Widget.dart/titre_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

class ImageFieldWidget extends StatelessWidget {
  final String? label;
  const ImageFieldWidget({super.key, this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitreTextWidget(texte: label ?? ""),
            const Gap(8),
            SizedBox(
              width: double.infinity,
              height: 270,
              child: Card(
                child: Center(child: const FaIcon(FontAwesomeIcons.image)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
