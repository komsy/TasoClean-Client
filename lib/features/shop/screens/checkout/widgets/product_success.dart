import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasoclean/features/shop/controllers/checkout_controller.dart' show formatKes;
import 'package:tasoclean/features/shop/controllers/service_controller.dart';
import 'package:tasoclean/features/shop/screens/order/widgets/order.dart';
import 'package:tasoclean/features/shop/screens/services/widgets/service_list.dart';
import 'package:tasoclean/features/shop/screens/services/widgets/services_card.dart';
import 'package:tasoclean/features/shop/screens/store/product_widgets.dart'
    show kStoreBg, kStoreBorder, kStoreCard, kStoreTan;

const _kGreen = Color(0xFF3AA63F);

/// What this screen needs to show. Build it in your product checkout after the
/// order is saved.
class ProductOrderSummary {
  const ProductOrderSummary({
    required this.orderNumber,
    required this.itemCount,
    required this.total,
    required this.address,
    this.estimatedDelivery = 'Within 1-2 days',
  });

  final String orderNumber;
  final int itemCount;
  final num total;
  final String address;
  final String estimatedDelivery;
}

void _goHome() => Get.until((route) => route.isFirst);

class ProductSuccessScreen extends StatelessWidget {
  const ProductSuccessScreen({super.key, required this.summary, this.maxServices = 3});

  final ProductOrderSummary summary;
  final int maxServices;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    // Reuse the services controller if it's already loaded, otherwise start it.
    final services = Get.isRegistered<ServiceController>()
        ? Get.find<ServiceController>()
        : Get.put(ServiceController());

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _goHome();
      },
      child: Scaffold(
        backgroundColor: kStoreBg,
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
            children: [
              // Animated check
              Center(
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 650),
                  curve: Curves.easeOutBack,
                  builder: (_, v, child) => Transform.scale(scale: v, child: child),
                  child: Container(
                    width: 92,
                    height: 92,
                    decoration: BoxDecoration(color: _kGreen.withValues(alpha: 0.18), shape: BoxShape.circle),
                    child: Center(
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: const BoxDecoration(color: _kGreen, shape: BoxShape.circle),
                        child: const Icon(Icons.check, color: Colors.white, size: 38),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Text('Order placed!',
                  textAlign: TextAlign.center,
                  style: t.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text('Thanks for shopping with Taso. We\'ll let you know when your order is on its way.',
                  textAlign: TextAlign.center,
                  style: t.bodyMedium?.copyWith(color: Colors.white70)),
              const SizedBox(height: 24),

              // Summary
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: kStoreCard,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: kStoreBorder),
                ),
                child: Column(
                  children: [
                    _InfoRow(label: 'Order no.', value: summary.orderNumber),
                    _InfoRow(
                      label: 'Items',
                      value: '${summary.itemCount} ${summary.itemCount == 1 ? 'item' : 'items'}',
                    ),
                    _InfoRow(label: 'Delivering to', value: summary.address),
                    _InfoRow(label: 'Estimated delivery', value: summary.estimatedDelivery),
                    _InfoRow(label: 'Total', value: formatKes(summary.total), highlight: true, last: true),
                  ],
                ),
              ),

              // Suggested services
              Obx(() {
                final loading = services.isLoading.value;
                final list = services.categories.toList();
                if (loading || list.isEmpty) return const SizedBox.shrink();

                final shown = list.take(maxServices).toList();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    Text('Need a hand at home?',
                        style: t.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text('Book a trusted pro in a few taps.',
                        style: t.bodySmall?.copyWith(color: Colors.white60)),
                    const SizedBox(height: 14),
                    for (var i = 0; i < shown.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: MServiceCard(
                          category: shown[i],
                          onTap: () => Get.to(
                            () => BookServiceScreen(categories: list, initialCategory: i),
                          ),
                        ),
                      ),
                  ],
                );
              }),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: kStoreCard,
            border: Border(top: BorderSide(color: kStoreBorder)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: OutlinedButton(
                        onPressed: _goHome,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                          shape: const StadiumBorder(),
                        ),
                        child: const Text('Continue shopping', style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        // Replace this route so Back from Orders goes home, not to this screen.
                        onPressed: () => Get.off(() => const OrdersScreen(initialTab: 1)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kStoreTan,
                          foregroundColor: Colors.black,
                          elevation: 0,
                          shape: const StadiumBorder(),
                        ),
                        child: const Text('View my orders', style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.highlight = false,
    this.last = false,
  });

  final String label;
  final String value;
  final bool highlight;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: t.bodyMedium?.copyWith(color: Colors.white60)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: t.bodyMedium?.copyWith(
                color: highlight ? kStoreTan : Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}