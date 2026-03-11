import 'package:avis/widget.dart/connexion_widget.dart';
import 'package:avis/widget.dart/inscription_widget.dart';
import 'package:avis/widget.dart/logo.dart';
import 'package:avis/widget.dart/titre_text_widget.dart';
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
          child: ListView(
            children: [
              const Gap(20),
              const Logo(size: 50),
              const Gap(20),
              const TabBar(
                tabs: [
                  Tab(child: TitreTextWidget(texte: "Connexion")),
                  Tab(child: TitreTextWidget(texte: "Inscription")),
                ],
              ),
              const SizedBox(
                height: 550,
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
