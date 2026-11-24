import 'package:avis/Helpers/platform_image.dart';
import 'package:avis/constants.dart';
import 'package:avis/widgets/corps_text_widget.dart';
import 'package:avis/widgets/titre_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

/// Sélecteur piloté par le parent : [image] est l'unique source de vérité.
///
/// Aucun état local ne peut donc rester désynchronisé après une publication
/// réussie ou un retrait. Un clic sur la vignette remplace l'image, le bouton
/// « Retirer l'image » permet de revenir au sélecteur vide.
class ImageFieldWidget extends StatelessWidget {
  final ValueChanged<XFile> imagePicked;
  final VoidCallback? imageRemoved;
  final XFile? image;
  final String? label;
  final String? erreur;

  const ImageFieldWidget({
    super.key,
    this.label,
    required this.imagePicked,
    this.imageRemoved,
    this.image,
    this.erreur,
  });

  Future<void> _choisirImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? nouvelleImage = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (nouvelleImage != null && context.mounted) {
      imagePicked(nouvelleImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final XFile? image = this.image;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: espaceSm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitreTextWidget(texte: label ?? "", fontSize: 14),
          const Gap(espaceSm),
          SizedBox(
            width: double.infinity,
            height: 270,
            child: image == null
                ? _selecteurVide(context)
                : _vignette(context, image),
          ),
          if (erreur != null) ...[
            const Gap(espaceXs),
            CorpsTextWidget(texte: erreur!, couleur: noir),
          ],
        ],
      ),
    );
  }

  Widget _selecteurVide(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Ajouter une image',
      child: InkWell(
        onTap: () => _choisirImage(context),
        borderRadius: BorderRadius.circular(rayonChamp),
        child: Container(
          decoration: BoxDecoration(
            color: surfaceNeutre,
            borderRadius: BorderRadius.circular(rayonInterne),
            border: Border.all(color: bordureNeutre),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: espaceSm,
            children: [
              FaIcon(FontAwesomeIcons.image, size: 32, color: teal),
              CorpsTextWidget(texte: 'Ajouter une image'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _vignette(BuildContext context, XFile image) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(rayonInterne),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _choisirImage(context),
                child: Semantics(
                  button: true,
                  label: "Remplacer l'image",
                  child: imageFromPath(image.path, fit: BoxFit.cover),
                ),
              ),
            ),
          ),
          Positioned(
            top: espaceXs,
            right: espaceXs,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: noir.withValues(alpha: 0.6),
                shape: BoxShape.circle,
              ),
              child: Semantics(
                button: true,
                label: "Retirer l'image",
                child: IconButton(
                  tooltip: "Retirer l'image",
                  icon: const Icon(Icons.close, size: 18, color: blanc),
                  onPressed: imageRemoved,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
