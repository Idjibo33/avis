import 'package:avis/constants.dart';
import 'package:avis/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ImagePostContentWidget extends StatelessWidget {
  final String optionAUrl;
  final String optionBUrl;
  final double heights;
  const ImagePostContentWidget({
    super.key,
    required this.heights,
    required this.optionAUrl,
    required this.optionBUrl,
  });

  @override
  Widget build(BuildContext context) {
    final BorderRadius rayon = BorderRadius.circular(rayonInterne);
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: rayon,
            child: SizedBox(
              width: double.infinity,
              height: heights,
              child: ImageWidget(url: optionAUrl, height: heights),
            ),
          ),
        ),
        const Gap(espaceXs),
        Expanded(
          child: ClipRRect(
            borderRadius: rayon,
            child: SizedBox(
              width: double.infinity,
              height: heights,
              child: ImageWidget(url: optionBUrl, height: heights),
            ),
          ),
        ),
      ],
    );
  }
}
