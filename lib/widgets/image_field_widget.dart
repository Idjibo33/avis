import 'package:avis/Helpers/platform_image.dart';
import 'package:avis/widgets/titre_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

class ImageFieldWidget extends StatefulWidget {
  final Function(XFile i) imagePicked;
  final String? label;
  const ImageFieldWidget({super.key, this.label, required this.imagePicked});

  @override
  State<ImageFieldWidget> createState() => _ImageFieldWidgetState();
}

class _ImageFieldWidgetState extends State<ImageFieldWidget> {
  XFile? pickedImage;

  Future<void> imagepicking() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        pickedImage = image;
      });
      widget.imagePicked(image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitreTextWidget(texte: widget.label ?? ""),
            const Gap(8),
            SizedBox(
              width: double.infinity,
              height: 270,
              child: pickedImage == null
                  ? GestureDetector(
                      onTap: () => imagepicking(),
                      child: const Card(
                        child: Center(
                          child: FaIcon(FontAwesomeIcons.image),
                        ),
                      ),
                    )
                  : imageFromPath(pickedImage!.path, fit: BoxFit.cover),
            ),
          ],
        ),
      ),
    );
  }
}
