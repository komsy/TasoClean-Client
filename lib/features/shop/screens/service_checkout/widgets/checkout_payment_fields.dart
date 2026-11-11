import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasoclean/features/shop/controllers/checkout_controller.dart';
import 'package:tasoclean/features/shop/screens/service_checkout/widgets/checkout_colors.dart';
import 'package:tasoclean/utils/constants/colors.dart';
import 'package:tasoclean/utils/constants/sizes.dart';

class CheckoutNotesField extends StatelessWidget {
  const CheckoutNotesField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(28),
      borderSide: BorderSide(color: MColors.white.withValues(alpha: 0.15)),
    );
    return TextField(
      controller: controller,
      minLines: 1,
      maxLines: 3,
      textCapitalization: TextCapitalization.sentences,
      style: const TextStyle(color: MColors.white),
      decoration: InputDecoration(
        hintText: 'Job description, gate code, areas to focus on...',
        hintStyle: TextStyle(color: MColors.white.withValues(alpha: 0.45)),
        filled: true,
        fillColor: checkoutDarkCard,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: const BorderSide(color: checkoutPeachLine, width: 1.6),
        ),
      ),
    );
  }
}

class CheckoutCreditsCard extends StatelessWidget {
  const CheckoutCreditsCard({super.key, required this.controller});

  final CheckoutController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
      decoration: BoxDecoration(
        color: checkoutDarkCard,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Obx(
        () => Column(
          children: [
            _ToggleRow(
              title: 'Use App Credits?',
              amount: controller.appCredits.value,
              value: controller.useCredits.value,
              onChanged: controller.appCredits.value > 0
                  ? (value) => controller.useCredits.value = value
                  : null,
            ),
            _ToggleRow(
              title: 'Use Wallet Balance?',
              amount: controller.walletBalance.value,
              value: controller.useWallet.value,
              onChanged: controller.walletBalance.value > 0
                  ? (value) => controller.useWallet.value = value
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.title,
    required this.amount,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final double amount;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: MSizes.sm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.bodySmall?.copyWith(
                    color: MColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: MSizes.sm),
                Text( formatKes(amount),
                  style: textTheme.bodyMedium?.copyWith(
                    color: MColors.grey.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeTrackColor: MColors.success,
          inactiveTrackColor: MColors.white.withValues(alpha: 0.18),
          trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
          thumbColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? MColors.white
                : MColors.white.withValues(alpha: 0.55),
          ),
        ),
      ],
    );
  }
}
