import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasoclean/features/shop/controllers/checkout_controller.dart';
import 'package:tasoclean/features/shop/screens/service_checkout/widgets/checkout_colors.dart';
import 'package:tasoclean/utils/constants/colors.dart';

class CheckoutSelectionCard extends StatelessWidget {
  const CheckoutSelectionCard({super.key, required this.controller , this.dark = false});

  final CheckoutController controller;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        color: dark ? MColors.white.withValues(alpha: 0.07) : MColors.black.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Obx(() {
        final lines = controller.lines;
        return Column(
          children: [
            if (lines.isEmpty)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'No services selected.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: dark ? MColors.white.withValues(alpha: 0.7) : MColors.black.withValues(alpha: 0.7),
                  ),
                ),
              ),
            for (final line in lines)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        '${line.service.name}${line.quantity > 1 ? ' x ${line.quantity}' : ''}',
                        style: textTheme.bodyMedium?.copyWith(
                          color: dark ? MColors.white : MColors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      formatAmount(line.lineTotal),
                      style: textTheme.bodyMedium?.copyWith(
                        color: dark ? MColors.white : MColors.black,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      }),
    );
  }
}
