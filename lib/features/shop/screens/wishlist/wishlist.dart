import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:k_store/common/widgets/appbar/appbar.dart';
import 'package:k_store/common/widgets/icons/m_circular_icon.dart';
import 'package:k_store/common/widgets/layouts/grid_layout.dart';
import 'package:k_store/common/widgets/loaders/animation_loader.dart';
import 'package:k_store/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:k_store/common/widgets/shimmers/vertical_product_shimmer.dart';
import 'package:k_store/features/shop/controllers/products/favourites_controller.dart';
import 'package:k_store/features/shop/screens/home/home.dart';
import 'package:k_store/navigation_menu.dart';
import 'package:k_store/utils/constants/image_strings.dart';
import 'package:k_store/utils/constants/sizes.dart';
import 'package:k_store/utils/helpers/cloud_helper_functions.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = FavouritesController.instance;
   //  final controller = Get.put(FavouritesController());

    return Scaffold(
      appBar: MAppBar(
        title:
            Text('Wishlist', style: Theme.of(context).textTheme.headlineMedium),
        actions: [
          MCircularIcon(
              icon: Iconsax.add, onPressed: () => Get.to(const HomeScreen()))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(MSizes.defaultSpace),
            child: Obx(() => FutureBuilder(
                future: controller.favouriteProducts(),
                builder: (context, snapshot) {
                  //Nothing Found widget
                  final emptyWidget = MAnimationLoaderWidget(
                    text: 'Whoops! Wishlist is Empty...',
                    animation: MImages.pencilAnimation,
                    showAction: true,
                    actionText: 'Let\'s add some',
                    onActionPressed: () =>
                        Get.off(() => const NavigationMenu()),
                  );

                  const loader = MVerticalProductShimmer(itemCount: 6);

                  final widget = MCloudHelperFunctions.checkMultiRecordState(
                      snapshot: snapshot,
                      loader: loader,
                      nothingFound: emptyWidget);

                  ///Return appropriate widget based on snapshot state
                  if (widget != null) return widget;

                  final products = snapshot.data!;
                  return MGridLayout(
                      itemCount: products.length,
                      itemBuilder: (_, index) =>
                          MProductCardVertical(product: products[index])
                    );
                }),
            ),
          ),
      ),
    );
  }
}
