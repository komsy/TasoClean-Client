import 'package:flutter/material.dart';
import 'package:k_store/common/widgets/images/m_circular_image.dart';
import 'package:k_store/common/widgets/texts/m_brand_title_text_with_verified_icon.dart';
import 'package:k_store/common/widgets/texts/product_title_text.dart';
import 'package:k_store/features/shop/controllers/products/product_controller.dart';
import 'package:k_store/features/shop/models/product_model.dart';
import 'package:k_store/utils/constants/enums.dart';
import 'package:k_store/utils/constants/image_strings.dart';
import 'package:k_store/utils/helpers/helper_functions.dart';

import '../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../common/widgets/texts/product_price_text.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';

class MProductMetaData extends StatelessWidget {
  const MProductMetaData({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = ProductController.instance;
    final salePercentage = controller.calaculateSalePercentage(product.price, product.salePrice);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Price & Sale Price
        Row(
          children: [
            MRoundedContainer(
              radius: MSizes.sm,
              backgroundColor: MColors.secondary.withOpacity(0.8),
              padding: const EdgeInsets.symmetric(horizontal: MSizes.sm, vertical: MSizes.xs),
              child: Text('$salePercentage%', style: Theme.of(context).textTheme.labelLarge!.apply(color: MColors.black)),
            ),
            const SizedBox(width: MSizes.spaceBtwItems),

            if(product.productType == ProductType.single.toString() && product.salePrice > 0)
              Text('${MTexts.currency} ${product.price}', style: Theme.of(context).textTheme.titleSmall!.apply(decoration: TextDecoration.lineThrough)),
            if(product.productType == ProductType.single.toString() && product.salePrice > 0)
              const SizedBox(width: MSizes.spaceBtwItems),
            MProductPriceText(price: controller.getProductPrice(product), isLarge: true),
            const SizedBox(width: MSizes.spaceBtwItems / 1.5),                      
          ],
        ),
        //Title
        MProductTitletext(title: product.title),
        const SizedBox(width: MSizes.spaceBtwItems / 1.5),

        //Stock Status
        Row(
          children: [
            const MProductTitletext(title: 'Stock: '),
            const SizedBox(width: MSizes.spaceBtwItems),
            Text(controller.getProductStockStatus(product.stock), style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
        const SizedBox(width: MSizes.spaceBtwItems / 1.5),

        //Brand
        Row(
          children: [
            MCircularImage(
              width: 32,
              height: 32,
              imageType: ImageType.asset,
              image: product.brand != null ? product.brand!.image : MImages.shoeIcon,
              overlayColor: dark ? MColors.white : MColors.dark,
            ),
            MBrandTitleTextWithVerifiedIcon(title: product.brand != null ? product.brand!.name : '', brandTextSize: TextSizes.medium),
          ],
        ) 
      ],
    );
  }
}