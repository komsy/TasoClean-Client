import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:k_store/common/widgets/appbar/appbar.dart';
import 'package:k_store/features/personalization/controllers/update_name_controller.dart';
import 'package:k_store/utils/constants/sizes.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/validators/validation.dart';

class ChangeName extends StatelessWidget {
  const ChangeName({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateNameController());

    return Scaffold(
      appBar: MAppBar(
        title: Text(MTexts.changeNameTitle,style: Theme.of(context).textTheme.headlineSmall!.apply(color: MColors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(MSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Headings
          Text(MTexts.changeNameSubTitle,style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: MSizes.spaceBtwSections),

          Form(
            key: controller.updateUserNameFormKey,
            child: Column(
              children: [
                TextFormField(
                    controller: controller.firstName,
                    validator: (value) =>
                        MValidator.validateEmptyText('First name', value),
                    expands: false,
                    decoration: const InputDecoration(
                        labelText: MTexts.firstName,
                        prefixIcon: Icon(Iconsax.user)),
                  ),
                  const SizedBox(height: MSizes.spaceBtwInputFields),
                  TextFormField(
                    controller: controller.lastName,
                    validator: (value) =>
                        MValidator.validateEmptyText('Last name', value),
                    expands: false,
                    decoration: const InputDecoration(
                        labelText: MTexts.lastName,
                        prefixIcon: Icon(Iconsax.user)),
                  ),
              ],
            ),
          ),
          const SizedBox(height: MSizes.spaceBtwSections),
          //Sigup Button
          SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: ()=> controller.updateUserName(),
                  child: const Text(MTexts.changeName))),
          ],
        ),
      ),
    );
  }
}