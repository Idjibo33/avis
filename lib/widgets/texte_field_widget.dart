import 'package:avis/widgets/corps_text_widget.dart';
import 'package:avis/widgets/titre_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TexteFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final int? lines;
  final String? label;
  final String hint;
  final bool obscureText;
  const TexteFieldWidget({
    super.key,
    this.label,
    required this.hint,
    this.lines,
    required this.controller,
    this.obscureText = false,
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
              controller: controller,
              obscuringCharacter: '•',
              obscureText: obscureText,
              minLines: obscureText ? 1 : lines,
              maxLines: obscureText ? 1 : lines,
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
