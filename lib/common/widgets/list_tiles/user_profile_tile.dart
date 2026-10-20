import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:k_store/common/widgets/images/m_circular_image.dart';
import 'package:k_store/features/personalization/views/profile/profile.dart';
import 'package:k_store/utils/constants/colors.dart';
import 'package:k_store/utils/constants/image_strings.dart';

import '../../../features/personalization/controllers/user_controllers.dart';


class MUserProfileTile extends StatelessWidget {
  const MUserProfileTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;

    return ListTile(
      leading: const MCircularImage(image: MImages.user,width: 50,height: 50,padding: 0),
      title: Text(controller.user.value.fullName,style: Theme.of(context).textTheme.headlineSmall!.apply(color: MColors.white),),
      subtitle: Text(controller.user.value.email,style: Theme.of(context).textTheme.bodyMedium!.apply(color: MColors.white),),
      trailing: IconButton(onPressed: () =>Get.to(() => const ProfileScreen()), icon: const Icon(Iconsax.edit, color: MColors.white)),
    );
  }
}