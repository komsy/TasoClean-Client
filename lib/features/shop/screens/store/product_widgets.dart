import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasoclean/features/shop/controllers/checkout_controller.dart' show formatAmount;
import 'package:tasoclean/features/shop/controllers/cart_controller.dart';
import 'package:tasoclean/features/shop/models/product_model.dart';
import 'package:tasoclean/utils/constants/colors.dart';

// Store palette (from the Taso Store mockup)
const kStoreBg = Color(0xFF0F0F10);
const kStoreCard = Color(0xFF171719);
const kStoreBorder = Color(0xFF34343A);
const kStoreTan = Color(0xFFE2CBA7);
const kStoreBadge = Color(0xFFFF5A36);

// ─────────────────────────────────────────────────────────────
// Network image with loading + error fallback
// ─────────────────────────────────────────────────────────────
class ProductImage extends StatelessWidget {
  const ProductImage({super.key, required this.url, this.fit = BoxFit.contain});

  final String url;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    const fallback = Center(
      child: Icon(Icons.cleaning_services_outlined, color: Colors.white38, size: 36),
    );
    if (url.isEmpty) return fallback;

    return Image.network(
      url,
      fit: fit,
      loadingBuilder: (_, child, progress) => progress == null
          ? child
          : const Center(
              child: SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2)),
            ),
      errorBuilder: (_, __, ___) => fallback,
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Cart icon with live count badge
// ─────────────────────────────────────────────────────────────
class CartBadgeButton extends StatelessWidget {
  const CartBadgeButton({super.key, required this.onTap, this.dark = false});

  final VoidCallback onTap;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final cart = CartsController.instance;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 48,
        height: 48,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
             Icon(Icons.shopping_cart_outlined, color: dark ? Colors.white : Colors.black, size: 30),
            Positioned(
              top: 2,
              right: 0,
              child: Obx(() {
                final n = cart.count;
                if (n == 0) return const SizedBox.shrink();
                return Container(
                  constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: kStoreBadge, borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    n > 99 ? '99+' : '$n',
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
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

// ─────────────────────────────────────────────────────────────
// − n + stepper
// ─────────────────────────────────────────────────────────────
class QtyStepper extends StatelessWidget {
  const QtyStepper({super.key, required this.quantity, required this.onAdd, required this.onRemove, this.dark = false});

  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    Widget btn(IconData icon, VoidCallback onTap, {bool filled = false}) => Material(
          color: filled ? MColors.peach : dark ? MColors.darkCard : MColors.black.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 36,
              height: 36,
              child: Icon(icon, size: 20, color: filled ? Colors.black : dark ? Colors.white : Colors.black),
            ),
          ),
        );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        btn(Icons.remove, onRemove),
        SizedBox(
          width: 34,
          child: Text(
            '$quantity',
            textAlign: TextAlign.center,
            style: TextStyle(color: dark ? Colors.white : Colors.black, fontWeight: FontWeight.w700, fontSize: 16),
          ),
        ),
        btn(Icons.add, onAdd, filled: true),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// "Add to Cart" from a product card:
// single variant -> add straight away, several -> pick a size first
// ─────────────────────────────────────────────────────────────
void addToCartFromCard(BuildContext context, ProductModel product, {required bool dark}) {
  final variants = product.publishedVariants; 
  

  if (variants.length == 1) {
    CartsController.instance.add(product, variants.first);
    Get.snackbar(
      'Added to cart',
      product.name,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 1),
    );
  } else {
    showVariantSheet(context, product, dark: dark);
  }
}

void showVariantSheet(BuildContext context, ProductModel product, {required bool dark}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: dark ? MColors.black : MColors.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
    builder: (_) => _VariantSheet(product: product, dark: dark),
  );
}

class _VariantSheet extends StatelessWidget {
  const _VariantSheet({required this.product, required this.dark});
  final ProductModel product;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final cart = CartsController.instance;
    final t = Theme.of(context).textTheme;

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: dark ? Colors.white.withValues(alpha: 0.25) : Colors.black.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(product.name, style: t.titleMedium?.copyWith(color: dark ? Colors.white : Colors.black, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text('Choose a size', style: t.bodySmall?.copyWith(color: dark ? Colors.white60 : Colors.black54)),
              const SizedBox(height: 12),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final v in product.publishedVariants)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
                          decoration: BoxDecoration(
                            color: dark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: kStoreBorder),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(v.label,
                                        style: t.titleSmall?.copyWith(color: dark ? Colors.white : Colors.black, fontWeight: FontWeight.w600)),
                                    Text('KSh ${formatAmount(v.price)}',
                                        style: t.bodySmall?.copyWith(color: dark ? Colors.white : Colors.black, fontWeight: FontWeight.w700)),
                                  ],
                                ),
                              ),
                              Obx(() {
                                final q = cart.quantityOf(product, v);
                                if (q == 0) {
                                  return ElevatedButton(
                                    onPressed: () => cart.add(product, v),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: MColors.peach,
                                      foregroundColor:  Colors.black,
                                      elevation: 0,
                                      shape: const StadiumBorder(),
                                    ),
                                    child: const Text('Add', style: TextStyle(fontWeight: FontWeight.w700)),
                                  );
                                }
                                return QtyStepper(
                                  dark: dark,
                                  quantity: q,
                                  onAdd: () => cart.add(product, v),
                                  onRemove: () => cart.decrement(CartsController.keyOf(product.docId, v.name)),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kStoreTan,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: const StadiumBorder(),
                  ),
                  child: const Text('Done', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
