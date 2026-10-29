import 'package:flutter/material.dart';
import 'package:tasoclean/common/widgets/shimmers/shimmer.dart';
import 'package:tasoclean/utils/constants/sizes.dart';

class MCategoryShimmerEffect extends StatelessWidget {
  const MCategoryShimmerEffect({
    super.key,
    this.itemCount = 6,
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
          itemCount: itemCount,
          scrollDirection: Axis.horizontal,
          separatorBuilder: (_, __) =>
              const SizedBox(width: MSizes.spaceBtwItems),
          itemBuilder: (_, __) {
            return const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Image
                MShimmerEffect(width: 55, height: 55, radius: 55),
                SizedBox(width: MSizes.spaceBtwItems / 2),

                MShimmerEffect(width: 55, height: 8),
              ],
            );
          }),
    );
  }
}
