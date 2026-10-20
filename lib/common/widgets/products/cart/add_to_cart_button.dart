import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:k_store/features/shop/controllers/products/cart_controller.dart';
import 'package:k_store/features/shop/models/product_model.dart';
import 'package:k_store/features/shop/screens/product_details/product_detail.dart';
import 'package:k_store/utils/constants/colors.dart';
import 'package:k_store/utils/constants/enums.dart';
import 'package:k_store/utils/constants/sizes.dart';

class ProductCardAddToCartButton extends StatelessWidget {
  const ProductCardAddToCartButton({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;

    return InkWell(
      onTap: () {
        //If the product have variations then show the product details for variation selection
        //Else add product to the cart.
        if (product.productType == ProductType.single.toString()) {
          final cartitem = cartController.convertToCartItem(product, 1);
          cartController.addOneToCart(cartitem);
        } else {
          Get.to(() => ProductDetailScreen(product: product));
        }
      },
      child: Obx(() {
        final productQuantityInCart = cartController.getProductQuantityInCart(product.id);
        return Container(
          decoration: BoxDecoration(
              color: productQuantityInCart > 0 ? MColors.primary:  MColors.dark,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(MSizes.cardRadiusMd),
                bottomRight: Radius.circular(MSizes.productImageRadius),
              )),
          child:  SizedBox(
            width: MSizes.iconLg,
            height: MSizes.iconLg,
            child: Center(
              child: productQuantityInCart > 0 
              ? Text(productQuantityInCart.toString(), style: Theme.of(context).textTheme.bodyLarge!.apply(color: MColors.white))
              : const Icon(Iconsax.add, color: MColors.white),
            ),
          ),
        );
      }),
    );
  }
}
