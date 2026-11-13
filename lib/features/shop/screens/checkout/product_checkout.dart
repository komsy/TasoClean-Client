import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasoclean/features/shop/controllers/cart_controller.dart';
import 'package:tasoclean/features/shop/controllers/checkout_controller.dart' show formatAmount;
import 'package:tasoclean/features/shop/controllers/product_checkout_controller.dart';
import 'package:tasoclean/features/shop/screens/checkout/widgets/product_success.dart';
import 'package:tasoclean/utils/constants/colors.dart';
import 'package:tasoclean/utils/helpers/helper_functions.dart';

const _kGreen = Color(0xFF4CAF6A);

class ProductCheckoutScreen extends StatefulWidget {
  const ProductCheckoutScreen({super.key});

  @override
  State<ProductCheckoutScreen> createState() => _ProductCheckoutScreenState();
}

class _ProductCheckoutScreenState extends State<ProductCheckoutScreen> {
  late final ProductCheckoutController c;

  @override
  void initState() {
    super.initState();
    c = Get.put(ProductCheckoutController());
  }

  @override
  void dispose() {
    Get.delete<ProductCheckoutController>();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    FocusScope.of(context).unfocus();
    final placed = await c.placeOrder();
    if (placed == null) return;

    Get.off(
      () => ProductSuccessScreen(
        summary: ProductOrderSummary(
          orderNumber: placed.reference,
          itemCount: placed.itemCount,
          total: placed.total,
          address: placed.address,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final text = dark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: dark ? MColors.black : MColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 20, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.maybePop(context),
                    icon: Icon(Icons.chevron_left, color: text, size: 30),
                  ),
                  Text('Checkout',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: text, fontWeight: FontWeight.w700)),
                ],
              ),
            ),

            // ── Content ─────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: Obx(() {
                  final items = c.items;
                  final applied = c.coupon.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _AddressCard(address: c.address.value, dark: dark),
                      const SizedBox(height: 24),

                      _SectionTitle('Order items', dark: dark),
                      const SizedBox(height: 10),
                      _ItemsCard(items: items, dark: dark),
                      const SizedBox(height: 24),

                      _SectionTitle('Promo code', dark: dark),
                      const SizedBox(height: 10),
                      applied == null
                          ? _CouponField(
                              controller: c.couponCtrl,
                              onApply: c.applyCoupon,
                              loading: c.isApplying.value,
                              error: c.couponError.value,
                              dark: dark,
                            )
                          : _CouponApplied(
                              code: applied.code,
                              saved: c.discount,
                              onRemove: c.removeCoupon,
                              dark: dark,
                            ),
                      const SizedBox(height: 24),

                      _SectionTitle('Order summary', dark: dark),
                      const SizedBox(height: 10),
                      _SummaryCard(
                        dark: dark,
                        subtotal: c.subtotal,
                        discount: c.discount,
                        couponCode: applied?.code,
                        shipping: c.shipping,
                        tax: c.tax,
                        taxRate: ProductCheckoutController.taxRate,
                        taxIncluded: ProductCheckoutController.pricesIncludeTax,
                        total: c.total,
                      ),
                    ],
                  );
                }),
              ),
            ),

            // ── Bottom bar ──────────────────────────────────
            Obx(() {
              final placing = c.isPlacing.value;
              final canPlace = !placing && c.items.isNotEmpty;

              return Container(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
                decoration: BoxDecoration(
                  color: dark ? MColors.darkCard : MColors.white,
                  border: const Border(top: BorderSide(color: MColors.peachLine)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Total',
                              style: TextStyle(color: text, fontSize: 13, fontWeight: FontWeight.w600)),
                          Text('KSh ${formatAmount(c.total)}',
                              style: TextStyle(color: text, fontSize: 24, fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 180,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: canPlace ? _placeOrder : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MColors.peach,
                          foregroundColor: Colors.black,
                          disabledBackgroundColor: MColors.peach.withValues(alpha: 0.4),
                          elevation: 0,
                          shape: const StadiumBorder(),
                        ),
                        child: placing
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.black),
                              )
                            : const Text('Place order',
                                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
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

// ─────────────────────────────────────────────────────────────
// Pieces
// ─────────────────────────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text, {required this.dark});
  final String text;
  final bool dark;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(color: dark ? Colors.white : Colors.black, fontWeight: FontWeight.w700),
      );
}

BoxDecoration _cardDecoration({required bool dark}) => BoxDecoration(
      color: dark ? MColors.darkCard : MColors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: MColors.peachLine),
    );

class _AddressCard extends StatelessWidget {
  const _AddressCard({required this.address, required this.dark});
  final String address;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final text = dark ? Colors.white : Colors.black;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(dark: dark),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: dark ? MColors.peach.withValues(alpha: 0.15) : MColors.black.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.location_on_outlined, color: dark ? MColors.peach : MColors.black),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(address, style: t.titleSmall?.copyWith(color: text, fontWeight: FontWeight.w700)),
          ),
          // TODO: open an address picker
          Text('Change',
              style: t.titleSmall?.copyWith(
                  color: dark ? MColors.peach : MColors.black, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _ItemsCard extends StatelessWidget {
  const _ItemsCard({required this.items, required this.dark});
  final List<CartItem> items;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final text = dark ? Colors.white : Colors.black;

    if (items.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: _cardDecoration(dark: dark),
        child: Text('Your cart is empty.', style: t.bodyMedium?.copyWith(color: text)),
      );
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(dark: dark),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0)
              Divider(
                height: 22,
                color: dark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.08),
              ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(items[i].productName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: t.titleSmall?.copyWith(color: text, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 2),
                      Text('${items[i].variantLabel}  ·  Qty ${items[i].quantity}',
                          style: t.bodySmall?.copyWith(color: dark ? Colors.white60 : Colors.black54)),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Text('KSh ${formatAmount(items[i].lineTotal)}',
                    style: t.titleSmall?.copyWith(color: text, fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _CouponField extends StatelessWidget {
  const _CouponField({
    required this.controller,
    required this.onApply,
    required this.loading,
    required this.error,
    required this.dark,
  });

  final TextEditingController controller;
  final VoidCallback onApply;
  final bool loading;
  final String? error;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final text = dark ? Colors.white : Colors.black;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 6, 6, 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: error != null ? const Color(0xFFE5484D) : MColors.peachLine,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  textCapitalization: TextCapitalization.characters,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => onApply(),
                  style: TextStyle(color: text, letterSpacing: 1, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    hintText: 'Enter coupon or promo code',
                    hintStyle: TextStyle(
                      color: dark ? Colors.white38 : Colors.black38,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: controller,
                builder: (_, value, __) {
                  final enabled = value.text.trim().isNotEmpty && !loading;
                  return SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: enabled ? onApply : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MColors.peach,
                        foregroundColor: dark ? Colors.black : Colors.white,
                        disabledBackgroundColor:
                            dark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.1),
                        disabledForegroundColor: dark ? Colors.white38 : Colors.black38,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        shape: const StadiumBorder(),
                      ),
                      child: loading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Apply', style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 0, 0),
            child: Text(error!, style: const TextStyle(color: Color(0xFFE5484D), fontSize: 12)),
          ),
      ],
    );
  }
}

class _CouponApplied extends StatelessWidget {
  const _CouponApplied({
    required this.code,
    required this.saved,
    required this.onRemove,
    required this.dark,
  });

  final String code;
  final num saved;
  final VoidCallback onRemove;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
      decoration: BoxDecoration(
        color: _kGreen.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _kGreen.withValues(alpha: 0.6)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(color: _kGreen, shape: BoxShape.circle),
            child: const Icon(Icons.check, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$code applied',
                    style: t.titleSmall?.copyWith(
                        color: dark ? Colors.white : Colors.black, fontWeight: FontWeight.w700)),
                Text('You saved KSh ${formatAmount(saved)}',
                    style: t.bodySmall?.copyWith(color: _kGreen, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          TextButton(
            onPressed: onRemove,
            child: Text('Remove', style: TextStyle(color: dark ? Colors.white70 : Colors.black54)),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.subtotal,
    required this.discount,
    required this.couponCode,
    required this.shipping,
    required this.tax,
    required this.taxRate,
    required this.taxIncluded,
    required this.total,
    required this.dark,
  });

  final num subtotal;
  final num discount;
  final String? couponCode;
  final num shipping;
  final num tax;
  final double taxRate;
  final bool taxIncluded;
  final num total;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final pct = (taxRate * 100).round();
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: _cardDecoration(dark: dark),
      child: Column(
        children: [
          _Row(label: 'Subtotal', value: 'KSh ${formatAmount(subtotal)}', dark: dark),
          if (couponCode != null)
            _Row(
              dark: dark,
              label: 'Discount ($couponCode)',
              value: '- KSh ${formatAmount(discount)}',
              valueColor: _kGreen,
            ),
          _Row(label: 'Shipping fee', value: 'KSh ${formatAmount(shipping)}', dark: dark),
          _Row(
            label: taxIncluded ? 'VAT ($pct%) included' : 'Tax ($pct% VAT)',
            value: 'KSh ${formatAmount(tax)}',
            dark: dark,
          ),
          Divider(
            height: 26,
            color: dark ? Colors.white.withValues(alpha: 0.22) : Colors.black.withValues(alpha: 0.22),
          ),
          _Row(label: 'Total', value: 'KSh ${formatAmount(total)}', bold: true, dark: dark),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.label,
    required this.value,
    required this.dark,
    this.valueColor,
    this.bold = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool bold;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final text = dark ? Colors.white : Colors.black;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: (bold ? t.titleMedium : t.bodyLarge)?.copyWith(
                color: text,
                fontWeight: bold ? FontWeight.w800 : FontWeight.w400,
              ),
            ),
          ),
          Text(
            value,
            style: (bold ? t.titleMedium : t.bodyLarge)?.copyWith(
              color: valueColor ?? text,
              fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}