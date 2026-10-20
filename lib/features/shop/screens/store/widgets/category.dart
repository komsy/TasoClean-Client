import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k_store/common/widgets/layouts/grid_layout.dart';
import 'package:k_store/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:k_store/common/widgets/shimmers/vertical_product_shimmer.dart';
import 'package:k_store/common/widgets/texts/section_heading.dart';
import 'package:k_store/features/shop/controllers/category_controller.dart';
import 'package:k_store/features/shop/models/category_model.dart';
import 'package:k_store/features/shop/models/product_model.dart';
import 'package:k_store/features/shop/screens/all_products/all_products.dart';
import 'package:k_store/features/shop/screens/store/widgets/category_brands.dart';
import 'package:k_store/utils/helpers/cloud_helper_functions.dart';

import '../../../../../common/widgets/brands/brand_show_case.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';

class MCategoryTab extends StatelessWidget {
  const MCategoryTab({super.key, required this.category});
  
  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    final controller = CategoryController.instance;

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children:[ 
        Padding(
          padding: const EdgeInsets.all(MSizes.defaultSpace),
          child: Column(
            children: [

              //Brands
              CategoryBrands(category: category),
              const SizedBox(height: MSizes.spaceBtwItems),

              //Products
              FutureBuilder(
                future: controller.getCategoryroducts(categoryId: category.id),
                builder: (context, snapshot) {
                  //Handle Loadeer, No recod or Error message
                  final response = MCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot, loader: const MVerticalProductShimmer());
                  if (response != null) return response;

                  //Record found
                  final products = snapshot.data!;
                
                  return Column(
                    children: [
                      MSectionHeading(
                        title: 'You might like', 
                        onPressed: () => Get.to(AllProducts(
                          title: category.name,
                          futureMethod: controller.getCategoryroducts(categoryId: category.id, limit: -1),
                        )),
                      ),
                      const SizedBox(height: MSizes.spaceBtwItems),
                      MGridLayout(itemCount: products.length, itemBuilder: (_, index) => MProductCardVertical(product: products[index])),
                    ],
                  );
                }
              ),
              // const SizedBox(height: MSizes.spaceBtwSections),
            ],
          ),
        ),
      ]
    );
  }
}