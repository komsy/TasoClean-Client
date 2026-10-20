import 'package:flutter/material.dart';
import 'package:k_store/utils/constants/image_strings.dart';
import 'package:k_store/utils/constants/sizes.dart';
import '../../../../utils/constants/colors.dart';

class TCircularImage extends StatelessWidget {
  const TCircularImage({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      padding: const EdgeInsets.all(MSizes.sm),
      decoration: BoxDecoration(
        color: dark ? MColors.black : MColors.white,
        borderRadius: BorderRadius.circular(100)
      ),
      child: Image(
        image: const AssetImage(MImages.clothIcon),
        color: dark ? MColors.white : MColors.dark,
      ),
    );
  }
}