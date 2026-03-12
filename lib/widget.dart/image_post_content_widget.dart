import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ImagePostContentWidget extends StatelessWidget {
  final double heights;
  const ImagePostContentWidget({super.key, required this.heights});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Image.asset('assets/image.jpg', height: heights)),
        const Gap(2),
        Expanded(child: Image.asset('assets/image.jpg', height: heights)),
      ],
    );
  }
}
