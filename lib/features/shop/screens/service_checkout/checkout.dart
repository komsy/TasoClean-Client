import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasoclean/common/widgets/appbar/step_header.dart';
import 'package:tasoclean/features/shop/controllers/checkout_controller.dart';
import 'package:tasoclean/features/shop/screens/service_checkout/widgets/checkout_payment_fields.dart';
import 'package:tasoclean/features/shop/screens/service_checkout/widgets/checkout_schedule_picker.dart';
import 'package:tasoclean/features/shop/screens/service_checkout/widgets/checkout_selection_card.dart';
import 'package:tasoclean/features/shop/screens/service_checkout/widgets/checkout_summary_bar.dart';
import 'package:tasoclean/features/shop/screens/service_checkout/widgets/checkout_colors.dart';
import 'package:tasoclean/utils/constants/colors.dart';
import 'package:tasoclean/utils/constants/sizes.dart';
import 'package:tasoclean/utils/helpers/helper_functions.dart';

class ScheduleAndPayScreen extends StatefulWidget {
  const ScheduleAndPayScreen({super.key});

  @override
  State<ScheduleAndPayScreen> createState() => _ScheduleAndPayScreenState();
}

class _ScheduleAndPayScreenState extends State<ScheduleAndPayScreen> {
  late final CheckoutController c;

  @override
  void initState() {
    super.initState();
    c = Get.put(CheckoutController());
  }

  @override
  void dispose() {
    Get.delete<CheckoutController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    
    return Scaffold(
      backgroundColor: checkoutBlue,
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          const MStepHeader(
            title: 'Schedule & Pay',
            subtitle: Text('Complete your booking details'),
            currentStep: 3,
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: dark ? MColors.black : MColors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CheckoutSelectionCard(controller: c, dark: dark),
                          const SizedBox(height:MSizes.spaceBtwSections*0.75),
                          Text(
                            'When?',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: dark ? MColors.white : MColors.black),
                          ),
                          const SizedBox(height: MSizes.xm),
                          CheckoutSchedulePicker(controller: c, dark: dark),
                          const SizedBox(height: MSizes.spaceBtwSections*0.75),
                          Text(
                            'Anything we should know?',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: dark ? MColors.white : MColors.black),
                          ),
                          const SizedBox(height: MSizes.xm),
                          CheckoutNotesField(controller: c.notes, dark: dark),
                          const SizedBox(height: MSizes.defaultSpace),
                          CheckoutCreditsCard(controller: c, dark: dark),
                        ],
                      ),
                    ),
                  ),
                  CheckoutSummaryBar(controller: c, dark: dark),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
