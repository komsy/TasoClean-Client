import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k_store/common/widgets/containers/rounded_container.dart';
import 'package:k_store/common/widgets/texts/product_price_text.dart';
import 'package:k_store/common/widgets/texts/product_title_text.dart';
import 'package:k_store/common/widgets/texts/section_heading.dart';
import 'package:k_store/features/shop/controllers/products/variation_controller.dart';
import 'package:k_store/features/shop/models/product_model.dart';
import 'package:k_store/utils/constants/colors.dart';
import 'package:k_store/utils/helpers/helper_functions.dart';

import '../../../../../common/widgets/chips/rounded_choice_chips.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';

class MProductAttributes extends StatelessWidget {
  const MProductAttributes({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = Get.put(VariationController());
  print("Variations id ${controller.variationStockStatus.value}");
    return Obx(() => Column(
          children: [
            //Selected atrribute pricing & description
            //Display variation price and stock when some variation is selected.
            if (controller.selectedVariation.value.id.isNotEmpty)
              MRoundedContainer(
                padding: const EdgeInsets.all(MSizes.md),
                backgroundColor: dark ? MColors.darkerGrey : MColors.grey,
                child: Column(
                  children: [
                    //Title, Price & Stock Status
                    Row(
                      children: [
                        const MSectionHeading(
                            title: 'Variation', showActionButton: false),
                        const SizedBox(width: MSizes.spaceBtwItems),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const MProductTitletext(
                                    title: 'Price: ', smallSize: true),
                                const SizedBox(width: MSizes.spaceBtwItems / 2),
                                //Actual Pri)ce
                            if(controller.selectedVariation.value.salePrice > 0)
                            Text('${MTexts.currency} ${controller.selectedVariation.value.price}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .apply(
                                        decoration:
                                            TextDecoration.lineThrough)),
                            const SizedBox(width: MSizes.spaceBtwItems),
                            //Sale Price
                            MProductPriceText(price: controller.getVariationPrice())
                          ],
                        ),

                        //Stock
                        Row(
                          children: [
                            const MProductTitletext(
                                title: 'Stock:  ', smallSize: true),
                            Text(controller.variationStockStatus.value,
                                style: Theme.of(context).textTheme.titleSmall),
                          ],
                        )
                      ],
                    ),
                  ],
                ),

                //Variation Description
                MProductTitletext(
                  title:
                   controller.selectedVariation.value.description ?? '',
                  smallSize: true,
                  maxLines: 4,
                ),
              ],
            ),
          ),
        const SizedBox(height: MSizes.spaceBtwItems),

        //Attributes
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: product.productAttributes!
              .map((attribute) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MSectionHeading(
                          title: attribute.name ?? '', showActionButton: false),
                      const SizedBox(height: MSizes.spaceBtwItems / 2),
                      Obx(() => Wrap(
                            spacing: 8,
                            children: attribute.values!.map((attributeValue) {
                              final isSelected = controller
                                      .selectedAttributes[attribute.name] ==
                                  attributeValue;
                              final available = controller
                                  .getAttributesAvailabilityInVariation(
                                      product.productVariations!,
                                      attribute.name!)
                                  .contains(attributeValue);

                              return MChoiceChip(
                                  text: attributeValue,
                                  selected: isSelected,
                                  onSelected: available
                                      ? (selected) {
                                          if (selected & available) {
                                            controller.onAttributeSelected(
                                                product,
                                                attribute.name ?? '',
                                                attributeValue);
                                          }
                                        }
                                      : null);
                            }).toList()),
                          )
                    ],
                  ))
              .toList(),
        ),

        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     const MSectionHeading(title: 'Sizes',showActionButton: false),
        //     const SizedBox(height: MSizes.spaceBtwItems / 2),
        //     Wrap(
        //       spacing: 8,
        //       children: [
        //         MChoiceChip(text: 'KE 34',selected: true, onSelected: (value) {}),
        //         MChoiceChip(text: 'KE 36',selected: false, onSelected: (value) {}),
        //         MChoiceChip(text: 'KE 36',selected: false, onSelected: (value) {}),
        //       ],
        //     )
        //   ],
        // ),
      ],
    )
    );
  }
}
