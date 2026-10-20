import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k_store/common/widgets/appbar/appbar.dart';
import 'package:k_store/common/widgets/appbar/tabbar.dart';
import 'package:k_store/common/widgets/containers/search_container.dart';
import 'package:k_store/common/widgets/layouts/grid_layout.dart';
import 'package:k_store/common/widgets/products/cart/cart_menu_icon.dart';
import 'package:k_store/common/widgets/shimmers/brands_shimmer.dart';
import 'package:k_store/common/widgets/texts/section_heading.dart';
import 'package:k_store/features/shop/controllers/category_controller.dart';
import 'package:k_store/features/shop/controllers/products/brand_controller.dart';
import 'package:k_store/features/shop/screens/brand/all_brands.dart';
import 'package:k_store/features/shop/screens/brand/brand_products.dart';
import 'package:k_store/features/shop/screens/store/widgets/category.dart';
import 'package:k_store/utils/constants/sizes.dart';
import 'package:k_store/utils/helpers/helper_functions.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../common/widgets/brands/brand_card.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final categories = CategoryController.instance.featuredCategories;
    final brandController = Get.put(BrandController());

    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: MAppBar(
          title: Text(
            'Store',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          actions: const [
            MCartCounterIcon(iconColor: null),
          ],
        ),
        body: NestedScrollView(
            headerSliverBuilder: (_, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  pinned: true,
                  floating: true,
                  backgroundColor: dark ? MColors.dark : MColors.white,
                  expandedHeight: 440,

                  flexibleSpace: Padding(
                      padding: const EdgeInsets.all(MSizes.defaultSpace),
                      child: ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          //Search bar
                          const SizedBox(height: MSizes.spaceBtwItems),
                          const MSearchContainer(
                            text: 'Search in Store',
                            showBorder: true,
                            showBackground: false,
                            padding: EdgeInsets.zero,
                          ),
                          const SizedBox(height: MSizes.spaceBtwSections),

                          //Featured brands
                          MSectionHeading(
                              title: "Featured Brands",
                              onPressed: () =>
                                  Get.to(() => const AllBrandsScreen())),
                          const SizedBox(height: MSizes.spaceBtwItems / 1.5),

                          Obx(() {
                            if(brandController.isLoading.value) return const MBrandsShimmer();

                            if(brandController.featuredBrands.isEmpty){
                              return Center(child: Text('No Data Found!', style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.white)));
                            }
                            return MGridLayout(
                              itemCount: brandController.featuredBrands.length,
                              mainAxisExtent: 80,
                              itemBuilder: (_, index) {
                                //Pass each brand and onPress event
                                final brand = brandController.featuredBrands[index];
                                return MBrandCard(showBorder: false,brand: brand,onTap: () => Get.to(() => BrandProducts(brand: brand)));
                            });
                          }),
                        ],
                      )),

                  //Tabs
                  bottom: MTabBar(
                    tabs: categories
                        .map((category) => Tab(child: Text(category.name)))
                        .toList(),
                  ),
                )
              ];
            },
            body: TabBarView(
                children: categories
                    .map((category) => MCategoryTab(category: category))
                    .toList())),
      ),
    );
  }
}
