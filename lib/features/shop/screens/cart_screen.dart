import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasoclean/features/shop/controllers/checkout_controller.dart' show formatAmount;
import 'package:tasoclean/features/shop/screens/cart_controller.dart';
import 'package:tasoclean/features/shop/screens/product_widgets.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = CartsController.instance;
    final t = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: kStoreBg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 12, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.maybePop(context),
                    icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
                  ),
                  Text('Your cart',
                      style: t.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  Obx(() => cart.isEmpty
                      ? const SizedBox.shrink()
                      : TextButton(onPressed: cart.clear, child: const Text('Clear'))),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                final items = cart.items;

                if (items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.white.withValues(alpha: 0.3)),
                        const SizedBox(height: 12),
                        Text('Your cart is empty', style: t.titleMedium?.copyWith(color: Colors.white70)),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => Navigator.maybePop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kStoreTan,
                            foregroundColor: Colors.black,
                            elevation: 0,
                            shape: const StadiumBorder(),
                          ),
                          child: const Text('Browse products', style: TextStyle(fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) {
                    final item = items[i];
                    return Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: kStoreCard,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: kStoreBorder),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 72, height: 72, child: ProductImage(url: item.image)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.productName,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: t.titleSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                                const SizedBox(height: 2),
                                Text(item.variantLabel, style: t.bodySmall?.copyWith(color: Colors.white60)),
                                const SizedBox(height: 4),
                                Text('KSh ${formatAmount(item.lineTotal)}',
                                    style: t.bodyMedium?.copyWith(color: kStoreTan, fontWeight: FontWeight.w800)),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () => cart.remove(item.key),
                                child: const Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Icon(Icons.delete_outline, color: Colors.white54, size: 20),
                                ),
                              ),
                              const SizedBox(height: 6),
                              QtyStepper(
                                quantity: item.quantity,
                                onAdd: () => cart.increment(item.key),
                                onRemove: () => cart.decrement(item.key),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),

            // Total + checkout
            Obx(() {
              if (cart.isEmpty) return const SizedBox.shrink();
              return Container(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
                decoration: const BoxDecoration(
                  color: kStoreCard,
                  border: Border(top: BorderSide(color: kStoreBorder)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('${cart.count} ${cart.count == 1 ? 'item' : 'items'}',
                              style: t.bodySmall?.copyWith(color: Colors.white60)),
                          Text('KSh ${formatAmount(cart.total)}',
                              style: t.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 160,
                      height: 50,
                      child: ElevatedButton(
                        // TODO: product checkout (delivery details + M-Pesa) isn't built yet.
                        onPressed: () => Get.snackbar('Checkout', 'Product checkout is not wired up yet.'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kStoreTan,
                          foregroundColor: Colors.black,
                          elevation: 0,
                          shape: const StadiumBorder(),
                        ),
                        child: const Text('Checkout', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
