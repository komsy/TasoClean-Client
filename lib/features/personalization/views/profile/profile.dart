import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:k_store/common/widgets/appbar/appbar.dart';
import 'package:k_store/common/widgets/images/m_circular_image.dart';
import 'package:k_store/common/widgets/shimmers/shimmer.dart';
import 'package:k_store/common/widgets/texts/section_heading.dart';
import 'package:k_store/features/personalization/views/profile/widgets/change_name.dart';
import 'package:k_store/features/personalization/views/profile/widgets/profile_menu.dart';
import 'package:k_store/utils/constants/image_strings.dart';
import 'package:k_store/utils/constants/sizes.dart';
import 'package:k_store/utils/constants/text_strings.dart';

import '../../../../utils/constants/enums.dart';
import '../../controllers/user_controllers.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;

    return Scaffold(
      appBar:
          const MAppBar(title: Text(MTexts.profileTitle), showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(MSizes.defaultSpace),
          child: Column(
            children: [
              SizedBox(
                child: Column(
                  children: [
                     Obx(() { 
                      final networkImage = controller.user.value.profilePicture;
                      final image = networkImage.isNotEmpty ? networkImage :MImages.user;
                      print(image);
                      return controller.imageUploading.value 
                          ? const MShimmerEffect(width: 80, height: 80, radius: 80) 
                          : MCircularImage(image: image , width: 80, height: 80, imageType: networkImage.isNotEmpty ? ImageType.network : ImageType.asset);
                        }),
                    TextButton(
                        onPressed: () => controller.uploadUserProfilePicture(),
                        child: const Text(MTexts.profileSubTitle)),
                  ],
                ),
              ),

              //Profile Information Details
              const SizedBox(height: MSizes.spaceBtwItems / 2),
              const Divider(),
              const SizedBox(height: MSizes.spaceBtwItems),
              const MSectionHeading(title: MTexts.profileSectionHeading1),
              const SizedBox(height: MSizes.spaceBtwItems),

              MProfileMenu(
                  onPressed: () => Get.to(() => const ChangeName()),
                  title: 'Name',
                  value: controller.user.value.fullName),
              MProfileMenu(
                  onPressed: () {},
                  title: 'UserName',
                  value: controller.user.value.userName),

              //Heading Personal Info
              const SizedBox(height: MSizes.spaceBtwItems),
              const Divider(),
              const SizedBox(height: MSizes.spaceBtwItems),
              const MSectionHeading(title: MTexts.profileSectionHeading2),
              const SizedBox(height: MSizes.spaceBtwItems),

              MProfileMenu(
                  onPressed: () {},
                  title: 'User ID',
                  value: controller.user.value.id,
                  icon: Iconsax.copy),
              MProfileMenu(
                  onPressed: () {},
                  title: 'Email',
                  value: controller.user.value.email),
              MProfileMenu(
                  onPressed: () {},
                  title: 'Phone Number',
                  value: controller.user.value.phoneNumber),
              const Divider(),
              const SizedBox(height: MSizes.spaceBtwItems),

              Center(
                child: TextButton(
                  onPressed: () => controller.deleteAccountWarningPopup(),
                  child: const Text(MTexts.profileCloseAccount,
                      style: TextStyle(color: Colors.red)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
