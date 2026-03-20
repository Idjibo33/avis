import 'package:avis/Widget.dart/image_widget.dart';
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
    return Row(
      children: [
        Expanded(
          child: ImageWidget(url: optionAUrl, height: heights),
        ),
        const Gap(2),
        Expanded(
          child: ImageWidget(url: optionBUrl, height: heights),
        ),
      ],
    );
  }
}
