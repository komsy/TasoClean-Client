import 'package:flutter/material.dart';
import 'package:tasoclean/common/widgets/shimmers/shimmer.dart';
import 'package:tasoclean/utils/constants/sizes.dart';

class MBoxesShimmer extends StatelessWidget {
  const MBoxesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [
            Expanded(child: MShimmerEffect(width: 150, height: 110)),
            SizedBox(height: MSizes.spaceBtwItems),
            Expanded(child: MShimmerEffect(width: 150, height: 110)),
            SizedBox(height: MSizes.spaceBtwItems),
            Expanded(child: MShimmerEffect(width: 150, height: 110)),
          ],
        )
      ],
    );
  }
}
