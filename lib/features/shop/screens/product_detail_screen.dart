import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasoclean/features/shop/controllers/checkout_controller.dart' show formatAmount;
import 'package:tasoclean/features/shop/screens/cart/cart.dart';
import 'package:tasoclean/features/shop/screens/cart_controller.dart';
import 'package:tasoclean/features/shop/screens/product_model.dart';
import 'package:tasoclean/features/shop/screens/product_widgets.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});

  final ProductModel product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final cart = CartsController.instance;
  int _variantIndex = 0;
  int _qty = 1;

  ProductModel get product => widget.product;
  List<ProductVariantModel> get variants => product.publishedVariants;
  ProductVariantModel get variant => variants[_variantIndex];

  String get _image => variant.image.isNotEmpty ? variant.image : product.imageUrl;

  void _addToCart() {
    cart.add(product, variant, quantity: _qty);
    Get.snackbar(
      'Added to cart',
      '${product.name} (${variant.label}) x $_qty',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
    setState(() => _qty = 1);
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final description = product.plainDescription;

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
                  const Spacer(),
                  CartBadgeButton(onTap: () => Get.to(() => const CartScreen())),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 260,
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: kStoreCard,
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(color: kStoreBorder),
                      ),
                      child: ProductImage(url: _image),
                    ),
                    const SizedBox(height: 20),
                    Text(product.name,
                        style: t.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Text('KSh ${formatAmount(variant.price)}',
                        style: t.titleMedium?.copyWith(color: kStoreTan, fontWeight: FontWeight.w800)),

                    if (variants.length > 1) ...[
                      const SizedBox(height: 22),
                      Text('Choose size',
                          style: t.titleSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          for (var i = 0; i < variants.length; i++)
                            GestureDetector(
                              onTap: () => setState(() => _variantIndex = i),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  color: i == _variantIndex ? kStoreTan : Colors.transparent,
                                  borderRadius: BorderRadius.circular(22),
                                  border: Border.all(
                                    color: i == _variantIndex ? kStoreTan : Colors.white.withValues(alpha: 0.25),
                                  ),
                                ),
                                child: Text(
                                  variants[i].label,
                                  style: TextStyle(
                                    color: i == _variantIndex ? Colors.black : Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Text('Quantity',
                            style: t.titleSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                        const Spacer(),
                        QtyStepper(
                          quantity: _qty,
                          onAdd: () => setState(() => _qty = (_qty + 1).clamp(1, CartsController.maxPerItem)),
                          onRemove: () => setState(() => _qty = (_qty - 1).clamp(1, CartsController.maxPerItem)),
                        ),
                      ],
                    ),

                    if (description.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Text('About this product',
                          style: t.titleSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      Text(description,
                          style: t.bodyMedium?.copyWith(color: Colors.white70, height: 1.5)),
                    ],
                  ],
                ),
              ),
            ),

            // Bottom bar
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              decoration: const BoxDecoration(
                color: kStoreCard,
                border: Border(top: BorderSide(color: kStoreBorder)),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _addToCart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kStoreTan,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: const StadiumBorder(),
                  ),
                  child: Text(
                    'Add to Cart · KSh ${formatAmount(variant.price * _qty)}',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
