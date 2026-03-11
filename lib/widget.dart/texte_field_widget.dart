import 'package:avis/widget.dart/corps_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TexteFieldWidget extends StatelessWidget {
  final String? label;
  final String hint;
  const TexteFieldWidget({super.key, this.label, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CorpsTextWidget(texte: label ?? ""),
            const Gap(8),
            TextField(
              decoration: InputDecoration(
                hint: CorpsTextWidget(texte: hint),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
