import 'package:avis/Providers/auth_services_providers.dart';
import 'package:avis/Providers/interactions_services_provider.dart';
import 'package:avis/Services/auth_repository.dart';
import 'package:avis/Providers/post_table_proider.dart';
import 'package:avis/constants.dart';
import 'package:avis/widgets/corps_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class UserStatisticsWidget extends StatelessWidget {
  const UserStatisticsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthSessionState session = context.read<AuthServicesProviders>().current;
    final String? userId = session.authUserId;
    final bool invite = session.status == AuthSessionStatus.guest;
    final TextStyle styleChiffres = textChiffresStyle.copyWith(fontSize: 25);
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(espaceXl),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Deux colonnes à largeur égale : un compteur très long ne peut
              // plus pousser la rangée hors de l'écran.
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // FittedBox : sur 360 px, chaque colonne ne mesure que
                    // ~128 px. Sans bornage, le Row donne une largeur infinie
                    // au texte et déborde de 63 px (pollué par la police de
                    // repli des tests). Le libellé reste intact, il est
                    // seulement réduit si nécessaire.
                    const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.article_outlined, size: 16, color: teal),
                          Gap(espaceXs),
                          CorpsTextWidget(texte: 'Publications'),
                        ],
                      ),
                    ),
                    const Gap(espaceXs),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Consumer<PostTableProider>(
                        builder: (context, posts, child) => StreamBuilder(
                          stream: invite || userId == null
                              ? null
                              : posts.readUserPost(userId: userId),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                snapshot.data!.count.toString(),
                                style: styleChiffres,
                              );
                            }
                            return Text('0', style: styleChiffres);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const VerticalDivider(width: espaceXl),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.how_to_vote_outlined, size: 16, color: teal),
                          Gap(espaceXs),
                          CorpsTextWidget(texte: 'Votes'),
                        ],
                      ),
                    ),
                    const Gap(espaceXs),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Consumer<InteractionsServicesProvider>(
                        builder: (context, interactions, child) =>
                            FutureBuilder(
                              future: invite || userId == null
                                  ? null
                                  : interactions.readUserInteractions(
                                      userId: userId,
                                    ),
                              builder: (context, snapshot) {
                                final String valeur = snapshot.hasData
                                    ? snapshot.data!.count.toString()
                                    : '0';
                                return Text(valeur, style: styleChiffres);
                              },
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
