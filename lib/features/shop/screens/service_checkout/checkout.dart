import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasoclean/common/widgets/texts/section_heading.dart';
import 'package:tasoclean/features/shop/controllers/checkout_controller.dart';
import 'package:tasoclean/features/shop/screens/service_checkout/widgets/checkout_header.dart';
import 'package:tasoclean/features/shop/screens/service_checkout/widgets/checkout_payment_fields.dart';
import 'package:tasoclean/features/shop/screens/service_checkout/widgets/checkout_schedule_picker.dart';
import 'package:tasoclean/features/shop/screens/service_checkout/widgets/checkout_selection_card.dart';
import 'package:tasoclean/features/shop/screens/service_checkout/widgets/checkout_summary_bar.dart';
import 'package:tasoclean/features/shop/screens/service_checkout/widgets/checkout_colors.dart';
import 'package:tasoclean/utils/constants/colors.dart';
import 'package:tasoclean/utils/constants/sizes.dart';

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
    return Scaffold(
      backgroundColor: checkoutBlue,
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          const CheckoutHeader(),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: checkoutDark,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
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
                          CheckoutSelectionCard(controller: c),
                          const SizedBox(height:MSizes.spaceBtwSections*0.75),
                          Text(
                            'When?',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: MColors.white),
                          ),
                          const SizedBox(height: MSizes.xm),
                          CheckoutSchedulePicker(controller: c),
                          const SizedBox(height: MSizes.spaceBtwSections*0.75),
                          Text(
                            'Anything we should know?',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: MColors.white),
                          ),
                          const SizedBox(height: MSizes.xm),
                          CheckoutNotesField(controller: c.notes),
                          const SizedBox(height: MSizes.defaultSpace),
                          CheckoutCreditsCard(controller: c),
                        ],
                      ),
                    ),
                  ),
                  CheckoutSummaryBar(controller: c),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
