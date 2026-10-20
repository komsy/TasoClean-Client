import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k_store/features/authentication/screens/login/login.dart';
import 'package:k_store/utils/constants/image_strings.dart';
import 'package:k_store/utils/constants/sizes.dart';
import 'package:k_store/utils/constants/text_strings.dart';
import 'package:k_store/utils/helpers/helper_functions.dart';

import '../../controllers/forget_password/forget_password_controller.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(CupertinoIcons.clear))
          ],
          ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(MSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               //Image
              Image(image: const  AssetImage(MImages.deliveredEmailIllustration), width: THelperFunctions.screenWidth()* 0.6,),
              const SizedBox(height: MSizes.spaceBtwSections),

              //Title & SUbtitle
              Text(MTexts.changeYourPasswordTitle, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
              const SizedBox(height: MSizes.spaceBtwItems),
              Text(MTexts.changeYourPasswordSubTitle, style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center),
              const SizedBox(height: MSizes.spaceBtwSections),
        
              //Buttons
               SizedBox(width: double.infinity,child: ElevatedButton(onPressed: () => Get.offAll( () => const LoginScreen()),child: const Text(MTexts.done))),
               SizedBox(width: double.infinity,child: TextButton(onPressed: () => ForgetPasswordController.instance.resendPasswordResetEmail(email),child: const Text(MTexts.resendEmail))),
            ],
          ),
        ),
      ),
    );
  }
}