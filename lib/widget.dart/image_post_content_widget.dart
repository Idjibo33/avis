import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ImagePostContentWidget extends StatelessWidget {
  const ImagePostContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Image.asset('assets/image.jpg', height: 270)),
        const Gap(2),
        Expanded(child: Image.asset('assets/image.jpg', height: 270)),
      ],
    );
  }
}
