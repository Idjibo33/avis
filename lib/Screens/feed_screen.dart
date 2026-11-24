import 'dart:async';

import 'package:avis/Helpers/navigators.dart';
import 'package:avis/Helpers/responsiveness.dart';
import 'package:avis/Models/interaction.dart';
import 'package:avis/Models/post.dart';
import 'package:avis/Providers/auth_services_providers.dart';
import 'package:avis/Providers/interactions_services_provider.dart';
import 'package:avis/Providers/post_table_proider.dart';
import 'package:avis/Screens/resultat_duel_screen.dart';
import 'package:avis/State/feed_view_state.dart';
import 'package:avis/constants.dart';
import 'package:avis/widgets/card_widget.dart';
import 'package:avis/widgets/corps_text_widget.dart';
import 'package:avis/widgets/empty_list_card_widget.dart';
import 'package:avis/widgets/logo.dart';
import 'package:avis/widgets/titre_text_widget.dart';
import 'package:avis/widgets/vote_description_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final List<int> interactedDuals = [];

  /// Extension de S10 (`docs/state-machines.md`) : identifiants des duels dont
  /// l'écriture est en vol. Set local au feed, jamais persisté : il rend le
  /// double-tap idempotent et désactive les cibles A/B via [VoteWriteScope].
  Set<int> _votesEnCours = <int>{};

  /// Identifiants ignorés pour le tour courant. Aucune écriture, aucune
  /// élévation : un invité peut passer. Dès que la file est vide, le mapper
  /// les réintègre silencieusement (`docs/state-machines.md`).
  Set<int> _skippedIds = <int>{};

  /// Incrémenté à chaque ignoré : la clé du swiper change même quand la liste
  /// visible reste identique (cas du dernier duel qui revient aussitôt).
  int _cycle = 0;

  final CardSwiperController _swipeController = CardSwiperController();
  int tentative = 0;

  @override
  void dispose() {
    unawaited(_swipeController.dispose());
    super.dispose();
  }

  /// Une seule porte d'entrée pour le vote, qu'il vienne du swipe ou du tap.
  ///
  /// Le duel n'est retiré du feed qu'après confirmation de l'écriture : un
  /// échec d'élévation annule le vote et laisse la carte en place. L'entrée
  /// dans [VoteWriteScope] désactive les deux cibles dès le début de l'écriture.
  /// L'auteur est refusé avant toute élévation ou écriture (le serveur applique
  /// la même règle) : un swipe sur son propre duel reste sans effet.
  Future<bool> _enregistrerVote(
    Post post,
    String choix,
    InteractionsServicesProvider interaction,
  ) async {
    final String? monIdentifiant = context
        .read<AuthServicesProviders>()
        .current
        .authUserId;
    if (monIdentifiant != null && post.user == monIdentifiant) {
      return false;
    }

    final int id = post.id ?? 0;
    if (interactedDuals.contains(id) || _votesEnCours.contains(id)) {
      return false;
    }

    setState(() => _votesEnCours = <int>{..._votesEnCours, id});

    bool reussi = false;
    bool voteEcrit = false;
    try {
      reussi = await demanderElevation(
        context,
        action: () async {
          // addInteraction renvoie false sur une erreur backend : puisque le
          // provider l'avalait, l'élévation seule ne prouvait pas l'écriture.
          voteEcrit = await interaction.addInteraction(
            interaction: Interaction(choix: choix, postId: post.id),
          );
        },
      );
    } finally {
      if (mounted) {
        setState(() {
          _votesEnCours = <int>{..._votesEnCours}..remove(id);
          if (reussi && voteEcrit && !interactedDuals.contains(id)) {
            interactedDuals.add(id);
          }
        });
      }
    }

    if (!reussi || !mounted) return reussi;
    if (!voteEcrit) {
      _afficherEchecVote();
      return false;
    }
    _afficherResultatVote(post);
    return true;
  }

  /// Passer est purement local : ni vote écrit, ni élévation, ni snackbar.
  void _passer(Post post) {
    final int id = post.id ?? 0;
    setState(() {
      _skippedIds = <int>{..._skippedIds, id};
      _cycle++;
    });
  }

  /// Échec d'écriture : la carte reste en place et aucun succès n'est annoncé.
  void _afficherEchecVote() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Vote impossible pour le moment.')),
    );
  }

  /// Le vote venant du feed, on propose la lecture du résultat sans obliger
  /// l'utilisateur à passer par son profil.
  void _afficherResultatVote(Post post) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        // Padding resserré : le libellé + l'action tiennent sur 320 px.
        padding: const EdgeInsets.symmetric(horizontal: espaceSm),
        content: const Text('Vote enregistré'),
        action: SnackBarAction(
          label: 'Voir le résultat',
          onPressed: () {
            if (!mounted) return;
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => ResultatDuelScreen(post: post),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // watch (et non read) : l'identité peut arriver après le premier build,
    // comme dans les tests qui publient la session après avoir monté l'écran.
    final String? monIdentifiant = context
        .watch<AuthServicesProviders>()
        .current
        .authUserId;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // Le disque mesure 36 dp dans une barre de 72 : il n'est plus serré
        // contre les bords et le point teal reste visible. Aligné à gauche,
        // il ouvre la lecture de la page avant la carte du duel.
        toolbarHeight: 72,
        centerTitle: false,
        titleSpacing: espaceLg,
        title: const Logo(size: 36, avecTexte: true),
      ),
      // La barre, le FAB et le changement d'onglet appartiennent au shell :
      // cet écran ne pousse aucune navigation principale.
      body: Responsiveness(
        child: Consumer<PostTableProider>(
          builder: (context, posts, child) => StreamBuilder<List<Post>>(
            key: ValueKey(tentative),
            stream: posts.streamPosts,
            builder: (context, snapshot) {
              final FeedViewState vue = FeedViewState.from(
                snapshot,
                interactedDuals.toSet(),
                skippedIds: _skippedIds,
              );
              return switch (vue.status) {
                FeedStatus.failed => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(espaceLg),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: espaceMd,
                      children: [
                        const CorpsTextWidget(
                          texte: "Impossible de charger le feed",
                        ),
                        TextButton(
                          onPressed: () => setState(() {
                            tentative++;
                          }),
                          child: const TitreTextWidget(
                            texte: "Réessayer",
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                FeedStatus.empty => const EmptyListCardWidget(),
                FeedStatus.allVoted => const EmptyListCardWidget(
                  texte: 'Vous avez voté sur tous les duels',
                  afficherCta: false,
                ),
                FeedStatus.ready => Consumer<InteractionsServicesProvider>(
                  builder: (context, interaction, child) => CardSwiper(
                    // La liste visible se réduit après chaque vote : sans clé,
                    // le swiper garde son index et affiche une carte vide (ou
                    // saute un duel). Une clé liée aux identifiants visibles
                    // le remet sur la première carte restante.
                    key: ValueKey(
                      '$_cycle:${vue.postsVisibles.map((post) => post.id).join(',')}',
                    ),
                    controller: _swipeController,
                    // Même gouttière que l'écran résultat : la carte est
                    // alignée sur les 24 dp du reste de l'application.
                    padding: const EdgeInsets.symmetric(
                      horizontal: espaceXl,
                      vertical: espaceXl,
                    ),
                    scale: 0.95,
                    duration: const Duration(milliseconds: 180),
                    isLoop: false,
                    allowedSwipeDirection: AllowedSwipeDirection.symmetric(
                      horizontal: true,
                      vertical: false,
                    ),
                    cardBuilder:
                        (
                          context,
                          cardIndex,
                          horizontalOffsetPercentage,
                          verticalOffsetPercentage,
                        ) {
                          final Post post = vue.postsVisibles[cardIndex];
                          return VoteWriteScope(
                            postId: post.id ?? 0,
                            votesEnCours: _votesEnCours,
                            child: CardWidget(
                              post: post,
                              onVoteA: () => _swipeController.swipe(
                                CardSwiperDirection.left,
                              ),
                              onVoteB: () => _swipeController.swipe(
                                CardSwiperDirection.right,
                              ),
                              onSkip: () => _passer(post),
                              estAuteur:
                                  monIdentifiant != null &&
                                  post.user == monIdentifiant,
                            ),
                          );
                        },
                    cardsCount: vue.postsVisibles.length,
                    numberOfCardsDisplayed: vue.postsVisibles.length > 2
                        ? 2
                        : vue.postsVisibles.length,
                    onSwipe: (previousIndex, currentIndex, direction) async {
                      if (previousIndex >= vue.postsVisibles.length) {
                        return false;
                      }
                      final Post swipedPost = vue.postsVisibles[previousIndex];
                      return switch (direction) {
                        CardSwiperDirection.right =>
                          await _enregistrerVoteEtContinuer(
                            swipedPost,
                            "B",
                            interaction,
                          ),
                        CardSwiperDirection.left =>
                          await _enregistrerVoteEtContinuer(
                            swipedPost,
                            "A",
                            interaction,
                          ),
                        _ => false,
                      };
                    },
                  ),
                ),
                FeedStatus.loading => const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: espaceSm,
                    children: [
                      CircularProgressIndicator.adaptive(),
                      CorpsTextWidget(texte: 'Chargement du feed…'),
                    ],
                  ),
                ),
              };
            },
          ),
        ),
      ),
    );
  }

  Future<bool> _enregistrerVoteEtContinuer(
    Post post,
    String choix,
    InteractionsServicesProvider interaction,
  ) => _enregistrerVote(post, choix, interaction);
}
