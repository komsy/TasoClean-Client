import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k_store/data/repositories/authentication/authentication_repository.dart';
import 'package:k_store/features/authentication/controllers/signup/verify_email_controller.dart';
import 'package:k_store/utils/constants/image_strings.dart';
import 'package:k_store/utils/constants/sizes.dart';
import 'package:k_store/utils/constants/text_strings.dart';
import 'package:k_store/utils/helpers/helper_functions.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key, this.email});

  final String? email;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put( VerifyEmailController());

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () => AuthenticationRepository.instance.logout(),
                icon: const Icon(CupertinoIcons.clear))
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(MSizes.defaultSpace),
            child: Column(
              children: [
                //Image
                Image(
                  image: const AssetImage(MImages.deliveredEmailIllustration),
                  width: THelperFunctions.screenWidth() * 0.6,
                ),
                const SizedBox(height: MSizes.spaceBtwSections),

                //Title & SUbtitle
                Text(MTexts.confirmEmail,
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center),
                const SizedBox(height: MSizes.spaceBtwItems),
                Text(email ?? '',
                    style: Theme.of(context).textTheme.labelLarge,
                    textAlign: TextAlign.center),
                const SizedBox(height: MSizes.spaceBtwItems),
                Text(MTexts.confirmEmailSubTitle,
                    style: Theme.of(context).textTheme.labelMedium,
                    textAlign: TextAlign.center),
                const SizedBox(height: MSizes.spaceBtwItems),

                //Buttons to manually check email verification status and redirect
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () =>controller.checkEmailVerificationStatus(),
                        child: const Text(MTexts.mContinue)
                      )
                  ),
                const SizedBox(height: MSizes.spaceBtwItems),
                SizedBox(
                    width: double.infinity,
                    child: TextButton(
                        onPressed: () => controller.sendEmailVerification(),
                        child: const Text(MTexts.resendEmail)
                    )
                  ),
              ],
            ),
          ),
        ));
  }
}
