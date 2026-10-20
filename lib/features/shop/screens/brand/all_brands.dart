import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k_store/common/widgets/brands/brand_card.dart';
import 'package:k_store/common/widgets/layouts/grid_layout.dart';
import 'package:k_store/common/widgets/shimmers/brands_shimmer.dart';
import 'package:k_store/common/widgets/texts/section_heading.dart';
import 'package:k_store/features/shop/controllers/products/brand_controller.dart';
import 'package:k_store/features/shop/models/brand_model.dart';
import 'package:k_store/features/shop/screens/brand/brand_products.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/constants/sizes.dart';

class AllBrandsScreen extends StatelessWidget {
  const AllBrandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final brandController = Get.put(BrandController());
    return Scaffold(
      appBar:  const MAppBar(title: Text('Brand'), showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding:  const EdgeInsets.all(MSizes.defaultSpace),
          child: Column(
            children: [
              //Heading
              const MSectionHeading(title: 'Brands', showActionButton: false),
              const SizedBox(height: MSizes.spaceBtwItems),

              //Brands
               Obx(() {
                  if(brandController.isLoading.value) return const MBrandsShimmer();

                  if(brandController.allBrands.isEmpty){
                    return Center(child: Text('No Data Found!', style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.white)));
                  }
                  return MGridLayout(
                    itemCount: brandController.allBrands.length,
                    mainAxisExtent: 80,
                    itemBuilder: (_, index) {
                      //Pass each brand and onPress event
                      final brand = brandController.allBrands[index];
                      return MBrandCard(showBorder: false,brand: brand,onTap: () => Get.to(() => BrandProducts(brand: brand)));
                  });
                }),
              // MGridLayout(
              //   itemCount: 8, 
              //   mainAxisExtent: 80,
              //   itemBuilder: (context, index) => MBrandCard(
              //         showBorder: true
              //         , brand:BrandModel.empty(),
              //         onTap: () => Get.to(() => const BrandProducts()),
              //     )
              // ),
            ]
          ),
        ),
      ),
    );
  }
}