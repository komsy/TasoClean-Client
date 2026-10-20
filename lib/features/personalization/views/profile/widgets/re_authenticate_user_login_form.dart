import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:k_store/features/personalization/controllers/user_controllers.dart';
import 'package:k_store/utils/constants/sizes.dart';

import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/validators/validation.dart';

class ReAuthenticateUserLoginForm extends StatelessWidget {
  const ReAuthenticateUserLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;

    return Scaffold(
      appBar: AppBar(title: const Text(MTexts.reAuthenticate)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(MSizes.defaultSpace),
          child: Form(
            key: controller.reAuthFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Email
                TextFormField(
                  controller: controller.verifyEmail,
                  validator: (value) => MValidator.validateEmail(value),
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.direct_right),
                      labelText: MTexts.email),
                ),
                const SizedBox(height: MSizes.spaceBtwInputFields),
                //Password
                Obx(() => TextFormField(
                      controller: controller.verifyPassword,
                      validator: (value) =>
                          MValidator.validateEmptyText('Password', value),
                      obscureText: controller.hidePassword.value,
                      decoration: InputDecoration(
                        labelText: MTexts.password,
                        prefixIcon: const Icon(Iconsax.password_check),
                        suffixIcon: IconButton(
                            onPressed: () => controller.hidePassword.value =
                                !controller.hidePassword.value,
                            icon: Icon(controller.hidePassword.value
                                ? Iconsax.eye_slash
                                : Iconsax.eye)),
                      ),
                    )),

                const SizedBox(height: MSizes.spaceBtwSections),
                //Verify Button
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () =>controller.reAuthenticateEmailAndPasswordUser(), child: const Text(MTexts.verify))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
