import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:k_store/common/widgets/containers/rounded_container.dart';
import 'package:k_store/common/widgets/images/m_rounded_image.dart';
import 'package:k_store/common/widgets/products/favourite_icon/favourite_icon.dart';
import 'package:k_store/common/widgets/texts/m_brand_title_text_with_verified_icon.dart';
import 'package:k_store/common/widgets/texts/product_price_text.dart';
import 'package:k_store/common/widgets/texts/product_title_text.dart';
import 'package:k_store/features/shop/controllers/products/product_controller.dart';
import 'package:k_store/features/shop/models/product_model.dart';
import 'package:k_store/utils/constants/enums.dart';
import 'package:k_store/utils/helpers/helper_functions.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';

class MProductCardHorizontal extends StatelessWidget {
  const MProductCardHorizontal({super.key, required this.product});
  
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = ProductController.instance;
    final salePercentage = controller.calaculateSalePercentage(product.price, product.salePrice);



    //Container with side paddings, color, edges, radius and shadow.
    return Container(
        width: 310,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(MSizes.productImageRadius),
          color: dark ? MColors.darkerGrey : MColors.softGrey,
        ),
        child: Row(
          children: [
            //Thumbnail
            MRoundedContainer(
              height: 120,
              padding: const EdgeInsets.all(MSizes.sm),
              backgroundColor: dark ? MColors.dark : MColors.light,
              child: Stack(
                children: [
                  //Thumbnail Image
                  SizedBox(
                    height: 120,
                    width: 120,
                    child: MRoundedImage(imageType: ImageType.network, image: product.thumbnail,applyImageRadius: true)
                  ),

                  //Sale tag
                  if (salePercentage != null)
                  Positioned(
                    top: 12,
                    child: MRoundedContainer(
                      radius: MSizes.sm,
                      backgroundColor: MColors.secondary.withOpacity(0.8),
                      padding: const EdgeInsets.symmetric(horizontal: MSizes.sm, vertical: MSizes.xs),
                      child: Text('$salePercentage%', style: Theme.of(context).textTheme.labelLarge!.apply(color: MColors.black)),
                    ),
                  ),
      
                  //Favorite icon button
                  Positioned(
                    top: 0,
                    right: 0,
                    child: MFavouriteIcon(productId: product.id),
                  ),
                ],
              ),
            ),

            //Details
            SizedBox(
              width: 172,
              child: Padding(
                padding: const EdgeInsets.only(top: MSizes.sm, left: MSizes.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                       Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MProductTitletext(title: product.title, smallSize: true),
                          const SizedBox(height: MSizes.spaceBtwItems /2),
                          MBrandTitleTextWithVerifiedIcon(title: product.brand != null ? product.brand!.name : 'Unknown Brand'),
                        ],
                      ),

                      const Spacer(),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Price
                          Flexible(
                            child: Column(
                              children: [
                                if(product.productType ==ProductType.single.toString() && product.salePrice > 0)
                                Padding(
                                  padding: const EdgeInsets.only(left: MSizes.sm),
                                  child: Text(
                                    product.price.toString(),
                                    style: Theme.of(context).textTheme.labelMedium!.apply(decoration: TextDecoration.lineThrough),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(left: MSizes.sm),
                                  child: MProductPriceText(price:  controller.getProductPrice(product)),
                                ),
                              ],
                            ),
                          ),

                          //Add to cart button
                          Container(
                            decoration: const BoxDecoration(
                              color: MColors.dark,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(MSizes.cardRadiusMd),
                                bottomRight:  Radius.circular(MSizes.productImageRadius),
                              )
                            ),
                            child:const SizedBox(
                              width: MSizes.iconLg ,
                              height: MSizes.iconLg ,
                              child: Center(child: Icon(Iconsax.add, color: MColors.white)),
                            ),
                          )
                        ],
                      )
                  ],
                ),
              ),
            )
          ],
        ),
    );
  }
}