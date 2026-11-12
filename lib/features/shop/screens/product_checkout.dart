import 'package:flutter/material.dart';
import 'package:tasoclean/features/shop/controllers/checkout_controller.dart' show formatAmount;
import 'package:tasoclean/features/shop/screens/product_widgets.dart';
import 'package:tasoclean/utils/constants/colors.dart';
import 'package:tasoclean/utils/helpers/helper_functions.dart';

// ─────────────────────────────────────────────────────────────
// DESIGN ONLY: sample data and local state, nothing is wired to
// the cart, Firestore or M-Pesa yet.
// ─────────────────────────────────────────────────────────────
class _SampleLine {
  const _SampleLine(this.name, this.variant, this.price, this.qty);
  final String name;
  final String variant;
  final num price;
  final int qty;
  num get total => price * qty;
}

const _sampleLines = <_SampleLine>[
  _SampleLine('Taso Air-freshener Tropical', '500 ml', 250, 1),
  _SampleLine('Taso Antiseptic Disinfectant', '5 Litres', 1200, 2),
];

const _kGreen = Color(0xFF4CAF6A);
const _kShipping = 200;
const _kTaxRate = 0.16;
const _kDemoDiscountRate = 0.10;

class ProductCheckoutScreen extends StatefulWidget {
  const ProductCheckoutScreen({super.key,});

  @override
  State<ProductCheckoutScreen> createState() => _ProductCheckoutScreenState();
}

class _ProductCheckoutScreenState extends State<ProductCheckoutScreen> {
  final _codeCtrl = TextEditingController();
  String? _appliedCode; // demo: any non-empty code "works"

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  void _applyCode() {
    final code = _codeCtrl.text.trim().toUpperCase();
    if (code.isEmpty) return;
    FocusScope.of(context).unfocus();
    setState(() => _appliedCode = code);
  }

  void _removeCode() {
    setState(() {
      _appliedCode = null;
      _codeCtrl.clear();
    });
  }

  // ── Demo maths so the rows add up ──────────────────────────
  num get _subtotal => _sampleLines.fold<num>(0, (s, l) => s + l.total);
  num get _discount => _appliedCode == null ? 0 : (_subtotal * _kDemoDiscountRate).round();
  num get _tax => ((_subtotal - _discount) * _kTaxRate).round();
  num get _total => _subtotal - _discount + _kShipping;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
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
                    icon: Icon(Icons.chevron_left, color: dark ? Colors.white : Colors.black, size: 30),
                  ),
                  Text('Checkout',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: dark ? Colors.white : Colors.black, fontWeight: FontWeight.w700)),
                ],
              ),
            ),

            // ── Content ─────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const _SectionTitle('Deliver to'),
                    // const SizedBox(height: 10),
                    _AddressCard(dark: dark),
                    const SizedBox(height: 24),

                    _SectionTitle('Order items', dark: dark),
                    const SizedBox(height: 10),
                    _ItemsCard(lines: _sampleLines, dark: dark),
                    const SizedBox(height: 24),

                    _SectionTitle('Promo code', dark: dark),
                    const SizedBox(height: 10),
                    _appliedCode == null
                        ? _CouponField(controller: _codeCtrl, onApply: _applyCode, dark: dark)
                        : _CouponApplied(code: _appliedCode!, saved: _discount, onRemove: _removeCode),
                    const SizedBox(height: 24),

                    // const _SectionTitle('Payment method'),
                    // const SizedBox(height: 10),
                    // const _MpesaTile(),
                    // const SizedBox(height: 24),

                    _SectionTitle('Order summary', dark: dark),
                    const SizedBox(height: 10),
                    _SummaryCard(
                      dark: dark,
                      subtotal: _subtotal,
                      discount: _discount,
                      couponCode: _appliedCode,
                      shipping: _kShipping,
                      tax: _tax,
                      taxRate: _kTaxRate,
                      total: _total,
                    ),
                  ],
                ),
              ),
            ),

            // ── Bottom bar ──────────────────────────────────
            Container(
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
                        Text('Total', style: TextStyle(color: dark ? Colors.white : Colors.black, fontSize: 13, fontWeight: FontWeight.w600)),
                        Text('KSh ${formatAmount(_total)}',
                            style: TextStyle(
                                color: dark ? Colors.white : Colors.black, fontSize: 24, fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 180,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MColors.peach,
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shape: const StadiumBorder(),
                      ),
                      child: const Text('Place order',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
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
  const _SectionTitle(this.text, {this.dark = false});
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

BoxDecoration _cardDecoration({Color? border, bool? dark}) => BoxDecoration(
      color: dark == true ? MColors.darkCard : MColors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: border ?? MColors.peachLine),
    );

class _AddressCard extends StatelessWidget {
  const _AddressCard({this.dark = false});
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(dark : dark),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Utawala, Nairobi',
                    style: t.titleSmall?.copyWith(color: dark ? Colors.white : Colors.black, fontWeight: FontWeight.w700)),
                // const SizedBox(height: 2),
                // Text('Delivery in 1-2 days',
                //     style: t.bodySmall?.copyWith(color: dark ? Colors.white60 : Colors.black54)),
              ],
            ),
          ),
          Text('Change',
              style: t.titleSmall?.copyWith(color: dark ? MColors.peach : MColors.black, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _ItemsCard extends StatelessWidget {
  const _ItemsCard({required this.lines, this.dark = false});
  final List<_SampleLine> lines;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(dark : dark),
      child: Column(
        children: [
          for (var i = 0; i < lines.length; i++) ...[
            if (i > 0) Divider(height: 22, color: dark ? MColors.white.withValues(alpha: 0.08) : MColors.black.withValues(alpha: 0.08)),
            Row(
              children: [
                // Thumbnail placeholder – use ProductImage(url: ...) with real data
                // Container(
                //   width: 56,
                //   height: 56,
                //   decoration: BoxDecoration(
                //     color: Colors.white.withValues(alpha: 0.05),
                //     borderRadius: BorderRadius.circular(14),
                //     border: Border.all(color: kStoreBorder),
                //   ),
                //   child: const ProductImage(url: ''),
                // ),
                // const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(lines[i].name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: t.titleSmall?.copyWith(color: dark ? Colors.white : Colors.black, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 2),
                      Text('${lines[i].variant}  ·  Qty ${lines[i].qty}',
                          style: t.bodySmall?.copyWith(color: dark ? Colors.white60 : Colors.black54)),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Text('KSh ${formatAmount(lines[i].total)}',
                    style: t.titleSmall?.copyWith(color: dark ? Colors.white : Colors.black, fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _CouponField extends StatelessWidget {
  const _CouponField({required this.controller, required this.onApply, required this.dark});
  final TextEditingController controller;
  final VoidCallback onApply;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 6, 6, 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        // border: Border.all(color: kStoreTan.withValues(alpha: 0.6), width: 1.4),
      ),
      child: Row(
        children: [
          // const Icon(Icons.local_offer_outlined, color: kStoreTan, size: 22),
          // const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              textCapitalization: TextCapitalization.characters,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => onApply(),
              style: TextStyle(color: dark ? Colors.white : Colors.black, letterSpacing: 1, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: 'Enter coupon or promo code',
                hintStyle: TextStyle(color: dark ? Colors.white38 : Colors.black38, letterSpacing: 0, fontWeight: FontWeight.w400),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (_, value, __) {
              final enabled = value.text.trim().isNotEmpty;
              return SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: enabled ? onApply : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MColors.peach,
                    foregroundColor: dark ? Colors.black : Colors.white,
                    disabledBackgroundColor: dark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.1),
                    disabledForegroundColor: dark ? Colors.white38 : Colors.black38,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    shape: const StadiumBorder(),
                  ),
                  child: const Text('Apply', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CouponApplied extends StatelessWidget {
  const _CouponApplied({required this.code, required this.saved, required this.onRemove});
  final String code;
  final num saved;
  final VoidCallback onRemove;

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
                    style: t.titleSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                Text('You saved KSh ${formatAmount(saved)}',
                    style: t.bodySmall?.copyWith(color: _kGreen, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          TextButton(
            onPressed: onRemove,
            child: const Text('Remove', style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }
}

class _MpesaTile extends StatelessWidget {
  const _MpesaTile();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: kStoreTan.withValues(alpha: 0.6), width: 1.4),
      ),
      child: Row(
        children: [
          // Placeholder badge – swap for your M-Pesa logo asset.
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: const Text('M-PESA',
                style: TextStyle(color: Color(0xFF3AA63F), fontSize: 9, fontWeight: FontWeight.w800)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('M-Pesa', style: t.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                Text('Pay securely via M-Pesa',
                    style: t.bodySmall?.copyWith(color: Colors.white60)),
              ],
            ),
          ),
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(color: kStoreTan, shape: BoxShape.circle),
            child: const Icon(Icons.check, color: Colors.black, size: 19),
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
    required this.total,
    required this.dark,
  });

  final num subtotal;
  final num discount;
  final String? couponCode;
  final num shipping;
  final num tax;
  final double taxRate;
  final num total;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: _cardDecoration(dark : dark),
      child: Column(
        children: [
          _Row(label: 'Subtotal', value: 'KSh ${formatAmount(subtotal)}', dark: dark),
          if (couponCode != null)
            _Row(dark: dark,
              label: 'Discount ($couponCode)',
              value: '- KSh ${formatAmount(discount)}',
              valueColor: _kGreen,              
            ),
          _Row(label: 'Shipping fee', value: 'KSh ${formatAmount(shipping)}', hint: 'Nairobi, 1-2 days', dark: dark),
          _Row(label: 'Tax (${(taxRate * 100).round()}% VAT)', value: 'KSh ${formatAmount(tax)}', dark: dark),
          Divider(height: 26, color: dark ? Colors.white.withValues(alpha: 0.22) : Colors.black.withValues(alpha: 0.22)),
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
    this.hint,
    this.valueColor,
    this.bold = false,
    required this.dark,
  });

  final String label;
  final String value;
  final String? hint;
  final Color? valueColor;
  final bool bold;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: (bold ? t.titleMedium : t.bodyLarge)?.copyWith(
                    color: bold ? (dark ? Colors.white : Colors.black) : (dark ? Colors.white : Colors.black),
                    fontWeight: bold ? FontWeight.w800 : FontWeight.w400,
                  ),
                ),
                if (hint != null)
                  Text(hint!, style: t.bodySmall?.copyWith(color: dark ? Colors.white38 : Colors.black38)),
              ],
            ),
          ),
          Text(
            value,
            style: (bold ? t.titleMedium : t.bodyLarge)?.copyWith(
              color: valueColor ?? (dark ? Colors.white : Colors.black),
              fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}