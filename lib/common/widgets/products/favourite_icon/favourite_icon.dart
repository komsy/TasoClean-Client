import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tasoclean/features/shop/controllers/products/favourites_controller.dart';
import 'package:tasoclean/utils/constants/colors.dart';
import '../../icons/m_circular_icon.dart';

class MFavouriteIcon extends StatelessWidget {
  const MFavouriteIcon({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FavouritesController());

    // final controller = FavouritesController.instance;

    return Obx(
      () => MCircularIcon(
        icon:
            controller.isFavourite(productId) ? Iconsax.heart5 : Iconsax.heart,
        color: controller.isFavourite(productId) ? MColors.error : null,
        onPressed: () => controller.toggleFavouriteProduct(productId),
      ),
    );
  }
}
