import 'package:flutter/material.dart';
import 'package:tasoclean/common/widgets/appbar/appbar.dart';
import 'package:tasoclean/common/widgets/brands/brand_card.dart';
import 'package:tasoclean/common/widgets/shimmers/vertical_product_shimmer.dart';
import 'package:tasoclean/features/shop/controllers/products/brand_controller.dart';
import 'package:tasoclean/features/shop/models/brand_model.dart';
import 'package:tasoclean/utils/constants/sizes.dart';
import 'package:tasoclean/utils/helpers/cloud_helper_functions.dart';

import '../../../../common/widgets/products/sortable/sortable_products.dart';

class BrandProducts extends StatelessWidget {
  const BrandProducts({super.key, required this.brand});

  final BrandModel brand;

  @override
  Widget build(BuildContext context) {
    final brandController = BrandController.instance;

    return Scaffold(
      appBar: MAppBar(title: Text(brand.name), showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(MSizes.defaultSpace),
          child: Column(
            children: [
              //Brand detail
              MBrandCard(showBorder: true, brand: brand),
              const SizedBox(height: MSizes.spaceBtwItems),

              FutureBuilder(
                  future: brandController.getBrandProducts(brandId: brand.id),
                  builder: (context, snapshot) {
                    //Handle loader, no record or Error message
                    const loader = MVerticalProductShimmer();
                    final widget = MCloudHelperFunctions.checkMultiRecordState(
                        snapshot: snapshot, loader: loader);
                    if (widget != null) return widget;

                    //Records found
                    final brandProducts = snapshot.data!;
                    return MSortableProducts(products: brandProducts);
                  })
            ],
          ),
        ),
      ),
    );
  }
}
