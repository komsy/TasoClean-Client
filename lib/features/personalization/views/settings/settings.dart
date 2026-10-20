import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:k_store/common/widgets/appbar/appbar.dart';
import 'package:k_store/common/widgets/custom_shapes/containers/primary_header_containers.dart';
import 'package:k_store/common/widgets/list_tiles/settings_menu_tile.dart';
import 'package:k_store/common/widgets/texts/section_heading.dart';
import 'package:k_store/features/personalization/views/address/address.dart';
import 'package:k_store/features/shop/screens/order/Order.dart';
import 'package:k_store/utils/constants/colors.dart';
import 'package:k_store/utils/constants/sizes.dart';

import '../../../../common/widgets/list_tiles/user_profile_tile.dart';
import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../profile/widgets/load_data.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
          //Header
          MPrimaryHeaderContainer(
            child: Column(
              children: [
                MAppBar(title: Text('Account', style: Theme.of(context).textTheme.headlineMedium!.apply(color: MColors.white),),),

                //User profile card
                const MUserProfileTile(),
                const SizedBox(height: MSizes.spaceBtwSections),
              ],
            )
            ),

          //Body
          Padding(
            padding: const EdgeInsets.all(MSizes.defaultSpace),
            child: Column(
              children: [
                //Account Setting
                const MSectionHeading(title: 'Account Setting'),
                const SizedBox(height: MSizes.spaceBtwItems),

                MSettingsMenuTile(icon: Iconsax.safe_home, title: "My Addresses", subTitle: "Set shopping delivery address", onTap: () => Get.to(() => const UserAddressScreen())),
                MSettingsMenuTile(icon: Iconsax.shopping_cart, title: "My Cart", subTitle: "Add, remove products", onTap: () {}),
                MSettingsMenuTile(icon: Iconsax.bag_tick, title: "My Orders", subTitle: "In-progress and Completed Orders", onTap: () => Get.to(() => const OrderScreen())),

                //App Setting
                const SizedBox(height: MSizes.spaceBtwSections),
                const MSectionHeading(title: 'App Settings'),
                const SizedBox(height: MSizes.spaceBtwItems),
                MSettingsMenuTile(icon: Iconsax.document_upload, title: "Load Data", subTitle: "Add, remove products", onTap: () => Get.to(() => const LoadDataScreen())),
                MSettingsMenuTile(icon: Iconsax.location, title: "Geolocation", subTitle: "Set recommendatio based on location", trailing: Switch(value: false, onChanged: (value) {})),

                //Logout Button
                const SizedBox(height: MSizes.spaceBtwSections),
                SizedBox(
                  width: double.infinity,
                  child:  OutlinedButton(onPressed: () =>AuthenticationRepository.instance.logout(), child: const Text('Logout')),
                ),
                const SizedBox(height: MSizes.spaceBtwSections * 2.5 ),
              ],
            ),
            ),
          ],
        ),
      ),
    );
  }
}

