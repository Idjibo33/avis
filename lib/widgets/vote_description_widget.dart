import 'package:avis/constants.dart';
import 'package:avis/widgets/corps_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Deux cibles tactiles explicites, en plus du swipe de la carte.
/// Le tap et le swipe déclenchent exactement la même action côté feed.
class VoteDescriptionWidget extends StatelessWidget {
  final VoidCallback? onVoteA;
  final VoidCallback? onVoteB;
  const VoteDescriptionWidget({super.key, this.onVoteA, this.onVoteB});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CorpsTextWidget(texte: 'Touchez une option ou glissez la carte'),
        const Gap(espaceSm),
        Row(
          children: [
            Expanded(
              child: _BoutonVote(
                libelle: 'A',
                tooltip: 'Voter pour A',
                couleur: noir,
                direction: Icons.arrow_back,
                action: onVoteA,
              ),
            ),
            const Gap(espaceSm),
            Expanded(
              child: _BoutonVote(
                libelle: 'B',
                tooltip: 'Voter pour B',
                couleur: teal,
                direction: Icons.arrow_forward,
                action: onVoteB,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BoutonVote extends StatelessWidget {
  final String libelle;
  final String tooltip;
  final Color couleur;
  final IconData direction;
  final VoidCallback? action;

  const _BoutonVote({
    required this.libelle,
    required this.tooltip,
    required this.couleur,
    required this.direction,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: FilledButton(
        onPressed: action,
        style: FilledButton.styleFrom(
          backgroundColor: couleur,
          disabledBackgroundColor: surfaceNeutre,
          foregroundColor: blanc,
          disabledForegroundColor: texteSecondaire,
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(rayonChamp),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: espaceSm,
          children: [Icon(direction, size: 18), Text(libelle)],
        ),
      ),
    );
  }
}
