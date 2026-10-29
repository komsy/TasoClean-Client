import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:tasoclean/common/styles/spacing_styles.dart';
import 'package:tasoclean/common/widgets/login_signup/form_divider.dart';
import 'package:tasoclean/common/widgets/login_signup/social_buttons.dart';
import 'package:tasoclean/features/authentication/screens/login/widgets/login_form.dart';
import 'package:tasoclean/features/authentication/screens/login/widgets/login_header.dart';
import 'package:tasoclean/utils/constants/sizes.dart';
import 'package:tasoclean/utils/constants/text_strings.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              //Logo, Title & Subtitle
              const MLoginHeader(),
              const MLoginForm(),

              //Divider
              MFormDivider(dividerText: MTexts.orSignInWith.capitalize!),
              const SizedBox(height: MSizes.spaceBtwSections/2),

              //Footer
              const MSocialButtons()
            ],
          ),
        ),
      ),
    );
  }
}
