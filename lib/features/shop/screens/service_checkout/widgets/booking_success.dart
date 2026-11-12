import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasoclean/features/shop/controllers/checkout_controller.dart';
import 'package:tasoclean/features/shop/screens/service_checkout/widgets/booking_success_header.dart';
import 'package:tasoclean/features/shop/screens/service_checkout/widgets/booking_success_summary.dart';
import 'package:tasoclean/features/shop/screens/service_checkout/widgets/booking_suggestions.dart';
import 'package:tasoclean/features/shop/screens/service_checkout/widgets/checkout_colors.dart';
import 'package:tasoclean/utils/constants/colors.dart';
import 'package:tasoclean/utils/helpers/helper_functions.dart';

export 'package:tasoclean/features/shop/screens/service_checkout/widgets/booking_suggestions.dart'
    show SuggestedProduct, sampleSuggestedProducts;

void _goHome() => Get.until((route) => route.isFirst);

class BookingSuccessScreen extends StatelessWidget {
  const BookingSuccessScreen({
    super.key,
    required this.summary,
    this.products = sampleSuggestedProducts,
    this.onProductTap,
  });

  final BookingSummary summary;
  final List<SuggestedProduct> products;
  final ValueChanged<SuggestedProduct>? onProductTap;

  bool get _paidInFull => summary.payNow <= 0;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _goHome();
      },
      child: Scaffold(
        backgroundColor: dark ? MColors.black : MColors.white,
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
            children: [
              BookingSuccessHeader(paidInFull: _paidInFull,dark: dark),
              const SizedBox(height: 24),
              BookingSuccessSummaryCard(
                dark: dark,
                summary: summary,
                paidInFull: _paidInFull,
              ),
              if (products.isNotEmpty) ...[
                const SizedBox(height: 28),
                BookingSuggestions(
                  products: products,
                  onProductTap: onProductTap,
                ),
              ],
            ],
          ),
        ),
        bottomNavigationBar: Container(
          color: dark ? MColors.white.withValues(alpha: 0.27) : MColors.black.withValues(alpha: 0.27),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _goHome,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MColors.error,
                    foregroundColor: MColors.white,
                    elevation: 0,
                    shape: const StadiumBorder(),
                  ),
                  child: const Text(
                    'Back to home',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
