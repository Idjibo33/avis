import 'package:avis/Widget.dart/connexion_widget.dart';
import 'package:avis/Widget.dart/inscription_widget.dart';
import 'package:avis/Widget.dart/logo.dart';
import 'package:avis/Widget.dart/titre_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const Logo(size: 50),
              const Gap(16),
              const TabBar(
                tabs: [
                  Tab(child: TitreTextWidget(texte: "Connexion")),
                  Tab(child: TitreTextWidget(texte: "Inscription")),
                ],
              ),
              const Expanded(
                child: TabBarView(
                  children: [ConnexionWidget(), InscriptionWidget()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
