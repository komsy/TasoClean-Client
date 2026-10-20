import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k_store/common/widgets/appbar/appbar.dart';
import 'package:k_store/common/widgets/custom_shapes/curved_edges/curved_edges_widget.dart';
import 'package:k_store/common/widgets/products/favourite_icon/favourite_icon.dart';
import 'package:k_store/features/shop/controllers/products/images_controller.dart';
import 'package:k_store/features/shop/models/product_model.dart';
import 'package:k_store/utils/constants/colors.dart';
import 'package:k_store/utils/constants/sizes.dart';

import '../../../../../common/widgets/images/m_rounded_image.dart';
import '../../../../../utils/constants/enums.dart';
import '../../../../../utils/helpers/helper_functions.dart';


class MProductImageSlider extends StatelessWidget {
  const MProductImageSlider({
    super.key, required this.product,
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    final controller = Get.put(ImagesController());
    final images = controller.getAllProductImages(product);
    
    return MCurvedEdgeWidget(
      child: Container(
        color: dark ? MColors.darkGrey: MColors.light,
        child: Stack(
          children: [
            //Main Large Image
            SizedBox(
              height: 400,
              child: Padding(
                padding:  const EdgeInsets.all(MSizes.productImageRadius * 2),
                child:  Center(child: Obx(() {
                  final image = controller.selectedProductImage.value;
                  return GestureDetector(
                    onTap: () => controller.showEnlargedImage(image),
                    child: CachedNetworkImage(imageUrl:image,
                    progressIndicatorBuilder: (_, __, downloadProgress) => 
                      CircularProgressIndicator(value: downloadProgress.progress,color: MColors.primary),
                    ),
                  );
                 })),
              )
            ),
    
            //Image slider
            Positioned(
              right: 0,
              bottom: 30,
              left: MSizes.defaultSpace,
              child: SizedBox(
                height: 80,
                child: ListView.separated(
                  itemCount: images.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics: const AlwaysScrollableScrollPhysics(),
                  separatorBuilder: (_, __)=> const SizedBox(width: MSizes.spaceBtwItems),
                  itemBuilder: (_, index) => Obx(
                    () {
                      final imageSelected = controller.selectedProductImage.value == images[index]; 
                      return MRoundedImage(
                        width: 80,
                        height:80,
                        image: images[index],
                        imageType: ImageType.network,
                        applyImageRadius: true,
                        backgroundColor: dark ? MColors.dark: MColors.white,
                        onPressed: () => controller.selectedProductImage.value = images[index],
                        border: Border.all(color: imageSelected ? MColors.primary : Colors.transparent),
                        // padding: const EdgeInsets.all(MSizes.sm),
                      );
                    }
                  )
                ),
              ),
            ),
    
            //AppBar Icons
            MAppBar(
              showBackArrow: true,
              actions: [MFavouriteIcon(productId: product.id)],
            )
          ],
        ),
      ),
    );
  }
}