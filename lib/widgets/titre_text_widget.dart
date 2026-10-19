import 'package:avis/constants.dart';
import 'package:flutter/material.dart';

class TitreTextWidget extends StatelessWidget {
  final double? fontSize;
  final TextAlign? align;
  final Color? couleur;
  final String texte;
  final int? maxLines;
  final TextOverflow? overflow;
  const TitreTextWidget({
    super.key,
    required this.texte,
    this.couleur,
    this.align,
    this.fontSize,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      texte,
      style: textTitreStyle.copyWith(color: couleur, fontSize: fontSize),
      textAlign: align,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
