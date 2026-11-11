import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasoclean/features/shop/screens/cart_controller.dart';
import 'package:tasoclean/features/shop/screens/cart_screen.dart';
import 'package:tasoclean/features/shop/screens/product_controller.dart';
import 'package:tasoclean/features/shop/screens/product_detail_screen.dart';
import 'package:tasoclean/features/shop/screens/product_model.dart';
import 'package:tasoclean/features/shop/screens/product_widgets.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductsController());
    CartsController.instance; // make sure the cart is registered

    return Scaffold(
      backgroundColor: kStoreBg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header: title, search, cart ──────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 12, 0),
              child: Row(
                children: [
                  Text(
                    'Taso\nStore',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          height: 1.1,
                        ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: _SearchField(onChanged: (v) => controller.query.value = v)),
                  const SizedBox(width: 4),
                  CartBadgeButton(onTap: () => Get.to(() => const CartScreen())),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Category chips ───────────────────────────────
            Obx(() {
              final cats = controller.categories;
              final selected = controller.selectedCategory.value;
              if (cats.length <= 1) return const SizedBox.shrink();

              return SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: cats.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (_, i) {
                    final isSel = cats[i] == selected;
                    return GestureDetector(
                      onTap: () => controller.selectCategory(cats[i]),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSel ? kStoreTan : Colors.transparent,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: isSel ? kStoreTan : Colors.white.withValues(alpha: 0.25)),
                        ),
                        child: Text(
                          cats[i],
                          style: TextStyle(
                            color: isSel ? Colors.black : Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
            const SizedBox(height: 14),

            // ── Grid ─────────────────────────────────────────
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.errorMessage.value != null) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(controller.errorMessage.value!,
                              textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70)),
                          const SizedBox(height: 12),
                          TextButton(onPressed: controller.fetchProducts, child: const Text('Retry')),
                        ],
                      ),
                    ),
                  );
                }

                final items = controller.filtered;
                if (items.isEmpty) {
                  return const Center(
                    child: Text('No products found', style: TextStyle(color: Colors.white70)),
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.fetchProducts,
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    itemCount: items.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      mainAxisExtent: 262,
                    ),
                    itemBuilder: (context, i) => _ProductCard(product: items[i]),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.onChanged});
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: const BorderSide(color: kStoreBorder),
    );
    return TextField(
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white),
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Search cleaning products...',
        hintStyle: const TextStyle(color: Colors.white54),
        prefixIcon: const Icon(Icons.search, color: Colors.white54),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(borderSide: const BorderSide(color: kStoreTan)),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => Get.to(() => ProductDetailScreen(product: product)),
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        decoration: BoxDecoration(
          color: kStoreCard,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: kStoreBorder),
        ),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: ProductImage(url: product.imageUrl),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: t.titleSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w700, height: 1.15),
            ),
            const SizedBox(height: 4),
            Text(product.priceLabel, style: t.bodySmall?.copyWith(color: Colors.white)),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                onPressed: () => addToCartFromCard(context, product),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kStoreTan,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  padding: EdgeInsets.zero,
                  shape: const StadiumBorder(),
                ),
                child: const Text('Add to Cart', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
