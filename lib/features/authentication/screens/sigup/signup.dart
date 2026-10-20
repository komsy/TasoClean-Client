import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k_store/common/widgets/login_signup/form_divider.dart';
import 'package:k_store/common/widgets/login_signup/social_buttons.dart';
import 'package:k_store/features/authentication/screens/sigup/widgets/signup_form.dart';
import 'package:k_store/utils/constants/sizes.dart';
import 'package:k_store/utils/constants/text_strings.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(MSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Tittle
              Text(MTexts.signupTitle, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: MSizes.spaceBtwSections),

              //Form
              const MSignUpForm(),
              const SizedBox(height: MSizes.spaceBtwItems),
    
              //Divider
              MFormDivider(dividerText: MTexts.orSignUpWith.capitalize!),
              const SizedBox(height: MSizes.spaceBtwSections),
        
              //Footer
              const  MSocialButtons()
            ],
          ),
        ),
      ),
    );
  }
}
