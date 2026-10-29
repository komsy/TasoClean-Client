import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tasoclean/common/widgets/appbar/appbar.dart';
import 'package:tasoclean/common/widgets/texts/section_heading.dart';
import 'package:tasoclean/features/shop/controllers/banner_controller.dart';
import 'package:tasoclean/utils/constants/sizes.dart';

import '../../../../../common/widgets/list_tiles/settings_menu_tile.dart';

class LoadDataScreen extends StatelessWidget {
  const LoadDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = BannerController.instance;

    return Scaffold(
      appBar: const MAppBar(title: Text('Load Data'), showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(MSizes.defaultSpace),
          child: Column(
            children: [
              // SizedBox(
              //   child: Column(
              //     children: [
              //       TextButton(
              //           onPressed: () => controller.uploadUserProfilePicture(),
              //           child: const Text(MTexts.profileSubTitle)),
              //     ],
              //   ),
              // ),

              const MSectionHeading(title: 'Main Record'),
              const SizedBox(height: MSizes.spaceBtwItems),
              MSettingsMenuTile(
                  icon: Iconsax.bag_tick,
                  title: "Upload Categories",
                  subTitle: "Upload Data here.",
                  onTap: () => controller.uploadUserBannerPicture()),
              MSettingsMenuTile(
                  icon: Iconsax.bag_tick,
                  title: "Upload Banners",
                  subTitle: "Upload Data here.",
                  onTap: () => controller.uploadUserBannerPicture()),
            ],
          ),
        ),
      ),
    );
  }
}
