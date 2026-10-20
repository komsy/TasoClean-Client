import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:k_store/common/widgets/login_signup/terms_conditions_checkbox.dart';
import 'package:k_store/features/authentication/controllers/signup/signup_controler.dart';
import 'package:k_store/utils/constants/sizes.dart';
import 'package:k_store/utils/constants/text_strings.dart';
import 'package:k_store/utils/validators/validation.dart';

class MSignUpForm extends StatelessWidget {
  const MSignUpForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());

    return Form(
        key: controller.signupFormKey,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.firstName,
                    validator: (value) =>
                        MValidator.validateEmptyText('First name', value),
                    expands: false,
                    decoration: const InputDecoration(
                        labelText: MTexts.firstName,
                        prefixIcon: Icon(Iconsax.user)),
                  ),
                ),
                const SizedBox(height: MSizes.spaceBtwInputFields),
                Expanded(
                  child: TextFormField(
                    controller: controller.lastName,
                    validator: (value) =>
                        MValidator.validateEmptyText('Last name', value),
                    expands: false,
                    decoration: const InputDecoration(
                        labelText: MTexts.lastName,
                        prefixIcon: Icon(Iconsax.user)),
                  ),
                )
              ],
            ),
            const SizedBox(height: MSizes.spaceBtwInputFields),

            //Username
            TextFormField(
              controller: controller.userName,
              validator: (value) =>
                  MValidator.validateEmptyText('Username', value),
              expands: false,
              decoration: const InputDecoration(
                  labelText: MTexts.username,
                  prefixIcon: Icon(Iconsax.user_edit)),
            ),
            const SizedBox(height: MSizes.spaceBtwInputFields),

            //Email
            TextFormField(
              controller: controller.email,
              validator: (value) => MValidator.validateEmail(value),
              expands: false,
              decoration: const InputDecoration(
                  labelText: MTexts.email, prefixIcon: Icon(Iconsax.direct)),
            ),
            const SizedBox(height: MSizes.spaceBtwInputFields),

            //Phone Number
            TextFormField(
              controller: controller.phoneNumber,
              validator: (value) => MValidator.validatePhoneNumber(value),
              expands: false,
              decoration: const InputDecoration(
                  labelText: MTexts.phoneNo, prefixIcon: Icon(Iconsax.call)),
            ),
            const SizedBox(height: MSizes.spaceBtwInputFields),

            //Password
            Obx(() => TextFormField(
                  controller: controller.password,
                  validator: (value) => MValidator.validatePassword(value),
                  obscureText: controller.hidePassword.value,
                  decoration: InputDecoration(
                    labelText: MTexts.password,
                    prefixIcon: const Icon(Iconsax.password_check),
                    suffixIcon: IconButton(
                        onPressed: () => controller.hidePassword.value =
                            !controller.hidePassword.value,
                        icon: Icon(controller.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye)),
                  ),
                )
              ),
            const SizedBox(height: MSizes.spaceBtwSections),

            //Terms & Conditions CheckboxRow(
            const MTermsAndConditionsCheckbox(),
            const SizedBox(height: MSizes.spaceBtwSections),

            //Sigup Button
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () => controller.signup(),
                    child: const Text(MTexts.createAccount))),
          ],
        ));
  }
}
