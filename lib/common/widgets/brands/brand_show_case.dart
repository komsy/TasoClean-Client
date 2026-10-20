import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k_store/common/widgets/containers/rounded_container.dart';
import 'package:k_store/common/widgets/shimmers/shimmer.dart';
import 'package:k_store/features/shop/models/brand_model.dart';
import 'package:k_store/features/shop/screens/brand/brand_products.dart';
import 'package:k_store/utils/constants/sizes.dart';
import 'package:k_store/utils/helpers/helper_functions.dart';

import '../../../../utils/constants/colors.dart';
import 'brand_card.dart';

class MBrandShowCase extends StatelessWidget {
  const MBrandShowCase({
    super.key, required this.images, required this.brand,
  });

  final BrandModel brand;
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => BrandProducts(brand: brand)),
      child: MRoundedContainer(
        showBorder: true,
        borderColor: MColors.darkGrey,
        backgroundColor: Colors.transparent,
        padding: const EdgeInsets.all(MSizes.md),
        margin: const EdgeInsets.only(bottom: MSizes.spaceBtwItems),
        child: Column(
          children: [
            //Brand with Products count
            MBrandCard(showBorder: false, brand:brand),
      
            //Brand top 3 product images
            Row(
              children: images.map((image) => brandTopProductImageWidget(image, context)).toList(),
            ),         
            
          ],
        ),
      ),
    );
  }

  Widget brandTopProductImageWidget(String image, context){
    return  Expanded(
      child: MRoundedContainer(
        height: 100,
        padding: const EdgeInsets.all(MSizes.md),
        margin: const EdgeInsets.only(right: MSizes.sm),
        backgroundColor: THelperFunctions.isDarkMode(context) ? MColors.darkGrey : MColors.light,
        child: CachedNetworkImage(
          fit: BoxFit.contain,
          imageUrl: image,
          progressIndicatorBuilder: (context, url, downloadProgress) => const MShimmerEffect(width: 100, height: 100),
          errorWidget:(context, url, error) => const Icon(Icons.error),
        ),
      )
    );
  }
}