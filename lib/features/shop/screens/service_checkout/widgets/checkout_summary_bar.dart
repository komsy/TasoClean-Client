import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasoclean/features/shop/controllers/checkout_controller.dart';
import 'package:tasoclean/features/shop/screens/service_checkout/widgets/booking_success.dart';
import 'package:tasoclean/utils/constants/colors.dart';

class CheckoutSummaryBar extends StatelessWidget {
  const CheckoutSummaryBar({super.key, required this.controller, this.dark = false});

  final CheckoutController controller;
  final bool dark;

  Future<void> _pay() async {
    final summary = await controller.placeBooking();
    if (summary != null) {
      Get.off(() => BookingSuccessScreen(summary: summary));
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      color: dark ? MColors.white.withValues(alpha: 0.07) : MColors.black.withValues(alpha: 0.07),
      child: SafeArea(
        top: false,
        child: Obx(() {
          final total = controller.servicesTotal;
          final applied = controller.creditsApplied + controller.walletApplied;
          final submitting = controller.isSubmitting.value;
          final canPay = !submitting && controller.lines.isNotEmpty;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SummaryRow(
                dark: dark,
                label:
                    'Deposit required (${(CheckoutController.depositRate * 100).round()}%):',
                value: formatKes(controller.deposit),
                bold: true,
              ),
              if (applied < 0) ...[
                _SummaryRow(
                dark: dark,
                  label: 'Credits & wallet',
                  value: '- ${formatKes(applied)}',
                ),
                _SummaryRow(
                dark: dark,
                  label: 'Pay now:',
                  value: formatKes(controller.payNow),
                  bold: true,
                ),
              ],
              Container(
                height: 1.2,
                color: MColors.peachLine.withValues(alpha: 0.7),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Total',
                            style: textTheme.bodySmall?.copyWith(
                              color: dark ? MColors.white.withValues(alpha: 0.6) : MColors.black.withValues(alpha: 0.6),
                            ),
                          ),
                          Text(
                            formatKes(total),
                            style: textTheme.headlineSmall?.copyWith(
                              color: dark ? MColors.white : MColors.black,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 190,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: canPay ? _pay : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MColors.error,
                          foregroundColor: MColors.white,
                          disabledBackgroundColor:
                              MColors.error.withValues(alpha: 0.35),
                          elevation: 0,
                          shape: const StadiumBorder(),
                        ),
                        child: submitting
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.4,
                                  color: MColors.white,
                                ),
                              )
                            : Text(
                                controller.payNow > 0
                                    ? 'Pay with M-Pesa'
                                    : 'Confirm booking',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.bold = false,
    this.dark = false,  
  });

  final String label;
  final String value;
  final bool bold;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final style = (bold ? textTheme.titleMedium : textTheme.bodyLarge)?.copyWith(
      color: dark ? MColors.white : MColors.black,
      fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
    );
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: MColors.peachLine.withValues(alpha: 0.7),
            width: 1.2,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(value, style: style?.copyWith(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
