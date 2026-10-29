import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tasoclean/common/widgets/appbar/appbar.dart';
import 'package:tasoclean/common/widgets/icons/m_circular_icon.dart';
import 'package:tasoclean/common/widgets/layouts/grid_layout.dart';
import 'package:tasoclean/common/widgets/loaders/animation_loader.dart';
import 'package:tasoclean/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:tasoclean/common/widgets/shimmers/vertical_product_shimmer.dart';
import 'package:tasoclean/features/shop/controllers/products/favourites_controller.dart';
import 'package:tasoclean/features/shop/screens/home/home.dart';
import 'package:tasoclean/navigation_menu.dart';
import 'package:tasoclean/utils/constants/image_strings.dart';
import 'package:tasoclean/utils/constants/sizes.dart';
import 'package:tasoclean/utils/helpers/cloud_helper_functions.dart';

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
          child: Obx(
            () => FutureBuilder(
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
                          MProductCardVertical(product: products[index]));
                }),
          ),
        ),
      ),
    );
  }
}
