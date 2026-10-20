import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k_store/common/widgets/custom_shapes/containers/primary_header_containers.dart';
import 'package:k_store/common/widgets/shimmers/vertical_product_shimmer.dart';
import 'package:k_store/common/widgets/texts/section_heading.dart';
import 'package:k_store/features/shop/controllers/products/product_controller.dart';
import 'package:k_store/features/shop/screens/home/widgets/home_appbar.dart';

import '../../../../common/widgets/containers/search_container.dart';
import '../../../../common/widgets/layouts/grid_layout.dart';
import '../../../../common/widgets/products/product_cards/product_card_vertical.dart';
import '../../../../utils/constants/sizes.dart';
import '../all_products/all_products.dart';
import 'widgets/home_categories.dart';
import 'widgets/promo_slider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {  
    final controller = Get.put(ProductController());
    return  Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
           MPrimaryHeaderContainer(
              child: Column(
                children: [
                   const MHomeAppBar(),                  
                   const SizedBox(height: MSizes.spaceBtwSections),

                  //SearchBar
                   const MSearchContainer(text: "Search in Store"),
                   const SizedBox(height: MSizes.spaceBtwSections),

                  //Categories
                  Padding(
                    padding:  const EdgeInsets.only(left: MSizes.defaultSpace),
                    child: Column(
                      children: [
                        //Heading
                         MSectionHeading(title: 'Popular Categories', textColor: Colors.white,showActionButton: false, onPressed: () {},),
                         const SizedBox(height: MSizes.spaceBtwItems),

                        //Categories
                        const MHomeCategories()
                      ],
                    ),
                  ),

                  const SizedBox(height: MSizes.spaceBtwSections),
                ],
              ),
            ),

            //Body
             Padding(
              padding: const EdgeInsets.all(MSizes.defaultSpace),
              child:  Column(
                children: [
                  const MPromoSlider(),
                  const SizedBox(height: MSizes.spaceBtwSections),

                  //Heading
                  MSectionHeading(title: 'Popular Products', 
                  onPressed: () => Get.to(() =>  AllProducts(
                    title: 'Popular Products',
                    // query: FirebaseFirestore.instance.collection('Products').where('IsFeatured',isEqualTo: true).limit(6),
                    futureMethod: controller.fetchAllFeaturedProducts(),
                    )),
                  ),
                  const SizedBox(height: MSizes.spaceBtwItems),
                  
                  //Popular Products 
                  Obx((){
                    if(controller.isLoading.value) return const MVerticalProductShimmer();

                    if(controller.featuredProducts.isEmpty){
                      return Center(child: Text('No Data Found!', style: Theme.of(context).textTheme.bodyMedium));
                    }
                    return MGridLayout(
                      itemCount: controller.featuredProducts.length,
                      itemBuilder: (_,index) =>  MProductCardVertical(product: controller.featuredProducts[index]),
                    );
                   })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
