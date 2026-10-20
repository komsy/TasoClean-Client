import 'package:flutter/material.dart';
import 'package:k_store/common/widgets/appbar/appbar.dart';
import 'package:k_store/common/widgets/images/m_rounded_image.dart';
import 'package:k_store/common/widgets/products/product_cards/product_card_horizontal.dart';
import 'package:k_store/common/widgets/shimmers/vertical_product_shimmer.dart';
import 'package:k_store/common/widgets/texts/section_heading.dart';
import 'package:k_store/features/shop/controllers/category_controller.dart';
import 'package:k_store/features/shop/models/category_model.dart';
import 'package:k_store/features/shop/screens/all_products/all_products.dart';
import 'package:k_store/utils/constants/enums.dart';
import 'package:k_store/utils/constants/image_strings.dart';
import 'package:k_store/utils/constants/sizes.dart';
import 'package:k_store/utils/helpers/cloud_helper_functions.dart';

class SubCategoriesScreen extends StatelessWidget {
  const SubCategoriesScreen({super.key, required this.category});

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    final controller = CategoryController.instance;

    return Scaffold(
      appBar: MAppBar(title: Text(category.name), showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left:  MSizes.defaultSpace, right: MSizes.defaultSpace),
          child: Column(
            children: [
              //Banner
              const MRoundedImage(width: double.infinity,height: 300, imageType: ImageType.asset, image: MImages.promoBanner3, applyImageRadius: true),
              const SizedBox(height: MSizes.spaceBtwSections),

              //Sub-Categories
              FutureBuilder(
                future: controller.getSubCategories(category.id),
                builder: (context, snapshot) {
                  const loader = MVerticalProductShimmer();
                  final widget = MCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot,loader: loader);

                  ///Return appropriate widget based on snapshot state
                  if (widget != null) return widget;

                  final subCategories = snapshot.data!;

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: subCategories.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (_, index){
                      final subCategory = subCategories[index]; 

                      return FutureBuilder(
                        future: controller.getCategoryroducts(categoryId: subCategory.id),
                        builder: (context, snapshot) {
                          
                          final widget = MCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot,loader: loader);

                          ///Return appropriate widget based on snapshot state
                          if (widget != null) return widget;
                          final products = snapshot.data!;

                          return Column(
                            children: [
                              //Heading
                              MSectionHeading(
                                title: subCategory.name, 
                                onPressed: () => AllProducts(
                                  title: subCategory.name,
                                  futureMethod: controller.getCategoryroducts(categoryId: subCategory.id, limit: -1),
                                ),
                              ),
                              const SizedBox(height: MSizes.spaceBtwItems / 2),
                          
                              SizedBox(
                                height: 120,
                                child: ListView.separated(
                                  itemCount: products.length,
                                  scrollDirection: Axis.horizontal,
                                  separatorBuilder: (context, index) => const SizedBox(width: MSizes.spaceBtwItems),
                                  itemBuilder: (context, index) => MProductCardHorizontal(product: products[index])
                                ),
                              ),

                              const SizedBox(height: MSizes.spaceBtwSections),
                            ],
                          );
                        }
                      );
                    },
                  );
                }
              )
            ],
          ),
        ),
      ),
    );
  }
}