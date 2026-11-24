import 'package:avis/constants.dart';
import 'package:avis/widgets/corps_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Portée des votes en cours, lue par [VoteDescriptionWidget].
///
/// Extension de S10 (`docs/state-machines.md`) : le feed possède un `Set<int>`
/// d'identifiants de duels en cours d'écriture. Tant que le duel affiché y est,
/// les deux cibles A/B sont désactivées : un double tap ne peut pas produire
/// deux écritures et l'état local n'avance jamais avant la confirmation.
class VoteWriteScope extends InheritedWidget {
  const VoteWriteScope({
    super.key,
    required this.postId,
    required this.votesEnCours,
    required super.child,
  });

  final int postId;
  final Set<int> votesEnCours;

  bool get enEcriture => votesEnCours.contains(postId);

  static VoteWriteScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<VoteWriteScope>();

  @override
  bool updateShouldNotify(VoteWriteScope oldWidget) =>
      oldWidget.enEcriture != enEcriture;
}

/// Deux cibles tactiles explicites, en plus du swipe de la carte.
/// Le tap et le swipe déclenchent exactement la même action côté feed.
class VoteDescriptionWidget extends StatelessWidget {
  final VoidCallback? onVoteA;
  final VoidCallback? onVoteB;
  final VoidCallback? onSkip;

  /// Vrai quand le duel affiché appartient à l'utilisateur courant : les
  /// cibles A/B sont désactivées et « Passer » reste le seul geste local.
  final bool estAuteur;
  const VoteDescriptionWidget({
    super.key,
    this.onVoteA,
    this.onVoteB,
    this.onSkip,
    this.estAuteur = false,
  });

  @override
  Widget build(BuildContext context) {
    // Hors du feed (aperçu, test isolé), aucune portée : cibles actives.
    final bool enEcriture =
        VoteWriteScope.maybeOf(context)?.enEcriture ?? false;
    final bool voteBloque = enEcriture || estAuteur;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        estAuteur
            ? const CorpsTextWidget(
                texte: "C'est votre duel : vous ne pouvez pas voter.",
              )
            : const CorpsTextWidget(
                texte: 'Touchez une option ou glissez la carte',
              ),
        const Gap(espaceSm),
        Row(
          children: [
            Expanded(
              child: _BoutonVote(
                libelle: 'A',
                tooltip: 'Voter pour A',
                couleur: noir,
                direction: Icons.arrow_back,
                action: voteBloque ? null : onVoteA,
                enabled: !voteBloque,
              ),
            ),
            const Gap(espaceSm),
            Expanded(
              child: _BoutonVote(
                libelle: 'B',
                tooltip: 'Voter pour B',
                couleur: teal,
                direction: Icons.arrow_forward,
                action: voteBloque ? null : onVoteB,
                enabled: !voteBloque,
              ),
            ),
          ],
        ),
        if (onSkip != null) ...[
          const Gap(espaceXs),
          Tooltip(
            message: 'Passer ce duel',
            child: TextButton.icon(
              onPressed: onSkip,
              icon: const Icon(Icons.arrow_forward, size: 15),
              label: const Text('Passer ce duel'),
              style: TextButton.styleFrom(
                foregroundColor: texteSecondaire,
                textStyle: textCorpsStyle,
                padding: const EdgeInsets.symmetric(
                  horizontal: espaceSm,
                  vertical: espaceXs,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
        ],
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
  final bool enabled;

  const _BoutonVote({
    required this.libelle,
    required this.tooltip,
    required this.couleur,
    required this.direction,
    required this.action,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Voter pour $libelle',
      button: true,
      enabled: enabled,
      child: Tooltip(
        message: tooltip,
        child: FilledButton(
          onPressed: action,
          style:
              FilledButton.styleFrom(
                minimumSize: const Size(48, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(rayonChamp),
                ),
              ).copyWith(
                backgroundColor: WidgetStateProperty.resolveWith<Color?>((
                  Set<WidgetState> states,
                ) {
                  if (states.contains(WidgetState.disabled))
                    return surfaceNeutre;
                  // Retour de press stable : seule la teinte change, sans
                  // translation ni mise à l'échelle, donc sans déplacement.
                  if (states.contains(WidgetState.pressed)) {
                    return couleur.withValues(alpha: 0.78);
                  }
                  return couleur;
                }),
                foregroundColor: WidgetStateProperty.resolveWith<Color?>((
                  Set<WidgetState> states,
                ) {
                  if (states.contains(WidgetState.disabled))
                    return texteSecondaire;
                  return blanc;
                }),
              ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: espaceSm,
            children: [Icon(direction, size: 18), Text(libelle)],
          ),
        ),
      ),
    );
  }
}
