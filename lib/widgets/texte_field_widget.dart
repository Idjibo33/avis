import 'package:avis/constants.dart';
import 'package:avis/widgets/corps_text_widget.dart';
import 'package:avis/widgets/titre_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TexteFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final int? lines;
  final String? label;
  final String hint;
  final bool obscureText;
  final String? erreur;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final TextCapitalization textCapitalization;

  const TexteFieldWidget({
    super.key,
    this.label,
    required this.hint,
    this.lines,
    required this.controller,
    this.obscureText = false,
    this.erreur,
    this.textInputAction,
    this.onSubmitted,
    this.onChanged,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  State<TexteFieldWidget> createState() => _TexteFieldWidgetState();
}

class _TexteFieldWidgetState extends State<TexteFieldWidget> {
  bool _motDePasseVisible = false;

  @override
  Widget build(BuildContext context) {
    final bool masque = widget.obscureText && !_motDePasseVisible;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: espaceSm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitreTextWidget(texte: widget.label ?? "", fontSize: 14),
          const Gap(espaceSm),
          TextField(
            controller: widget.controller,
            obscuringCharacter: '•',
            obscureText: masque,
            minLines: masque ? 1 : widget.lines,
            maxLines: masque ? 1 : widget.lines,
            textInputAction: widget.textInputAction,
            textCapitalization: widget.textCapitalization,
            onSubmitted: widget.onSubmitted,
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              hint: CorpsTextWidget(texte: widget.hint),
              suffixIcon: widget.obscureText
                  ? Semantics(
                      button: true,
                      label: masque
                          ? 'Afficher le mot de passe'
                          : 'Masquer le mot de passe',
                      child: IconButton(
                        tooltip: masque
                            ? 'Afficher le mot de passe'
                            : 'Masquer le mot de passe',
                        icon: Icon(
                          masque
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () => setState(
                          () => _motDePasseVisible = !_motDePasseVisible,
                        ),
                      ),
                    )
                  : null,
            ),
          ),
          if (widget.erreur != null) ...[
            const Gap(espaceXs),
            CorpsTextWidget(texte: widget.erreur!, couleur: noir),
          ],
        ],
      ),
    );
  }
}
