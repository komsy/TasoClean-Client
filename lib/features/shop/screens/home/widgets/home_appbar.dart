import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k_store/common/widgets/appbar/appbar.dart';
import 'package:k_store/common/widgets/products/cart/cart_menu_icon.dart';
import 'package:k_store/common/widgets/shimmers/shimmer.dart';
import 'package:k_store/features/personalization/controllers/user_controllers.dart';
import 'package:k_store/features/shop/screens/cart/cart.dart';
import 'package:k_store/utils/constants/colors.dart';
import 'package:k_store/utils/constants/text_strings.dart';

class MHomeAppBar extends StatelessWidget {
  const MHomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());

    return MAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(MTexts.homeAppbarTitle, style: Theme.of(context).textTheme.labelMedium!.apply(color: MColors.grey)),
          Obx(() {
            if(controller.profileLoading.value){
              //Display a shimmer loader while user profile is being loaded
              return const MShimmerEffect(width: 80, height: 15);
            } else{
              return Text(controller.user.value.fullName, style: Theme.of(context).textTheme.headlineSmall!.apply(color: MColors.white));
            }
          }),
        ],
      ),
      actions: const [
         MCartCounterIcon(iconColor: MColors.white)
      ],
    );
  }
}
