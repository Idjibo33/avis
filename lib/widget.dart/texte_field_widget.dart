import 'package:avis/widget.dart/corps_text_widget.dart';
import 'package:avis/widget.dart/titre_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TexteFieldWidget extends StatelessWidget {
  final int? lines;
  final String? label;
  final String hint;
  const TexteFieldWidget({
    super.key,
    this.label,
    required this.hint,
    this.lines,
  });

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
            TextField(
              minLines: lines,
              maxLines: lines,
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
