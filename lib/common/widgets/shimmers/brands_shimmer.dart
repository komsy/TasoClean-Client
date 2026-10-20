import 'package:flutter/material.dart';
import 'package:k_store/common/widgets/layouts/grid_layout.dart';
import 'package:k_store/common/widgets/shimmers/shimmer.dart';

class MBrandsShimmer extends StatelessWidget {
  const MBrandsShimmer({
    super.key,
    this.itemCount = 4,
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return MGridLayout(
      itemCount: itemCount, 
      itemBuilder: (_, __) => const MShimmerEffect(width: 300, height: 80),
      );
  }
}
