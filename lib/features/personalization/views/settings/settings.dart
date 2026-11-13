import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tasoclean/common/widgets/appbar/appbar.dart';
import 'package:tasoclean/common/widgets/custom_shapes/containers/primary_header_containers.dart';
import 'package:tasoclean/common/widgets/list_tiles/settings_menu_tile.dart';
import 'package:tasoclean/common/widgets/texts/section_heading.dart';
import 'package:tasoclean/features/personalization/views/address/address.dart';
import 'package:tasoclean/features/shop/screens/cart/cart_screen.dart';
import 'package:tasoclean/features/shop/screens/order/widgets/order.dart';
import 'package:tasoclean/utils/constants/colors.dart';
import 'package:tasoclean/utils/constants/sizes.dart';
import 'package:tasoclean/utils/popups/loaders.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/widgets/list_tiles/user_profile_tile.dart';
import '../../../../data/repositories/authentication/authentication_repository.dart';

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
                MAppBar(
                  title: Text(
                    'Account',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .apply(color: MColors.white),
                  ),
                ),

                //User profile card
                const MUserProfileTile(),
                const SizedBox(height: MSizes.spaceBtwSections),
              ],
            )),

            //Body
            Padding(
              padding: const EdgeInsets.all(MSizes.defaultSpace),
              child: Column(
                children: [
                  //Account Setting
                  const MSectionHeading(title: 'Account Setting'),
                  const SizedBox(height: MSizes.spaceBtwItems),

                  MSettingsMenuTile(
                      icon: Iconsax.safe_home,
                      title: "My Addresses",
                      subTitle: "Set shopping delivery address",
                      onTap: () => Get.to(() => const UserAddressScreen())),
                  MSettingsMenuTile(
                      icon: Iconsax.shopping_cart,
                      title: "My Cart",
                      subTitle: "Add, remove products",
                      onTap: () => Get.to(() => const MCartScreen())),
                  
                  MSettingsMenuTile(
                    icon: Iconsax.support, 
                    title: "Contact Support",
                    subTitle: "Tap to Call or Email for Support", 
                    trailing: IconButton(
                          onPressed: () async {
                            String? encodeQueryParameters(
                              Map<String, String> params) {
                                return params.entries
                                    .map((MapEntry<String, String> e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                                    .join('&');
                              }
                            
                            final Uri emailLaunchUri = Uri(
                              scheme: 'mailto', 
                              path: 'gkmbaabu@gmail.com',
                              query: encodeQueryParameters(<String, String>{
                                'subject': 'Support Request',
                                'body': 'Hello, I need help with...',
                              }),
                            );
                            
                            try {
                              // Attempt to launch the email app
                              await launchUrl(emailLaunchUri);
                            } catch (e) {
                              // Handle any errors that occur during the launch
                              MLoaders.errorSnackBar(title: 'Could not launch email app', message: e.toString());
                            } 
                          },
                          icon:  const Icon(Icons.email,color: Colors.orange),
                        ),
                    onTap: () {
                      final Uri phoneLaunchUri = Uri(
                        scheme: 'tel',
                        path: '0762907970',
                      );
                      try {
                        // Attempt to launch the phone dialer
                        launchUrl(phoneLaunchUri);
                      } catch (e) {
                        // Handle any errors that occur during the launch
                        MLoaders.errorSnackBar(title: 'Could not launch phone dialer', message: e.toString());
                      } 
                    }
                    ),
            
                  //Logout Button
                  // const SizedBox(height: MSizes.spaceBtwSections),
                  // //App Setting
                  // const SizedBox(height: MSizes.spaceBtwSections),
                  // const MSectionHeading(title: 'App Settings'),
                  const SizedBox(height: MSizes.spaceBtwItems),
                  //Logout Button
                  const SizedBox(height: MSizes.spaceBtwSections * 1.5),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                        onPressed: () =>
                            AuthenticationRepository.instance.logout(),
                        child: const Text('Logout')),
                  ),
                  const SizedBox(height: MSizes.spaceBtwSections * 2.5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
