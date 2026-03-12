import 'package:avis/Widget.dart/corps_text_widget.dart';
import 'package:avis/Widget.dart/titre_text_widget.dart';
import 'package:flutter/material.dart';

class UserStatisticsWidget extends StatelessWidget {
  const UserStatisticsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CorpsTextWidget(texte: 'posts'),
                  TitreTextWidget(fontSize: 25, texte: '100'),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CorpsTextWidget(texte: 'Votes'),
                  TitreTextWidget(fontSize: 25, texte: '100'),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CorpsTextWidget(texte: 'posts'),
                  TitreTextWidget(fontSize: 25, texte: '100'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
