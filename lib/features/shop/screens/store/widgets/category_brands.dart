import 'package:flutter/material.dart';
import 'package:k_store/common/widgets/brands/brand_show_case.dart';
import 'package:k_store/common/widgets/shimmers/boxes_shimmer.dart';
import 'package:k_store/common/widgets/shimmers/list_tile_shimmer.dart';
import 'package:k_store/features/shop/controllers/products/brand_controller.dart';
import 'package:k_store/features/shop/models/category_model.dart';
import 'package:k_store/utils/constants/image_strings.dart';
import 'package:k_store/utils/constants/sizes.dart';
import 'package:k_store/utils/helpers/cloud_helper_functions.dart';

class CategoryBrands extends StatelessWidget {
  const CategoryBrands({super.key, required this.category});

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    final controller = BrandController.instance;

    return FutureBuilder(
      future: controller.getBrandsForCategory(category.id),
      builder: (context, snapshot) {
        //Handle Loader, No record, or Error message
        const loader = Column(
          children: [
            MListTileShimmer(),
            SizedBox(height: MSizes.spaceBtwItems),
            MBoxesShimmer(),
            SizedBox(height: MSizes.spaceBtwItems)
          ],
        );
        final widget = MCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot, loader: loader);
        if (widget != null) return widget;

        //Record found
        final brands = snapshot.data!;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: brands.length,
          itemBuilder: (_, index){
            final brand = brands[index];
            return FutureBuilder(
              future: controller.getBrandProducts(brandId:brand.id, limit: 3),
              builder: (context, snapshot) {
                //Handle Loadeer, No recod or Error message
                final widget = MCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot, loader: loader);
                if (widget != null) return widget;

                //Record found
                final products = snapshot.data!;
                return MBrandShowCase(brand: brand , images: products.map((e) => e.thumbnail).toList());
              }
            );
          },
        );
      }
    );
  }
}