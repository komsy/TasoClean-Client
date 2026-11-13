import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasoclean/data/repositories/order/product_order_repository.dart';
import 'package:tasoclean/features/shop/controllers/cart_controller.dart';

/// What the success screen needs after the order is saved.
class PlacedOrder {
  const PlacedOrder({
    required this.reference,
    required this.itemCount,
    required this.total,
    required this.address,
  });

  final String reference;
  final int itemCount;
  final num total;
  final String address;
}

class ProductCheckoutController extends GetxController {
  static ProductCheckoutController get instance => Get.find();

  // ── Store rules – change these to match your business ──────
  static const num shippingFee = 200; // flat rate
  static const double taxRate = 0.16; // Kenyan VAT
  /// true  -> shelf prices already include VAT; the tax row is informational
  ///          and the total is subtotal - discount + shipping.
  /// false -> VAT is added on top of (subtotal - discount).
  static const bool pricesIncludeTax = true;

  final _cart = CartsController.instance;
  final _repo = Get.put(ProductOrderRepository());

  // Coupon
  final TextEditingController couponCtrl = TextEditingController();
  final Rxn<Coupon> coupon = Rxn<Coupon>();
  final RxBool isApplying = false.obs;
  final RxnString couponError = RxnString();

  // TODO: load from the user's saved address / profile.
  final RxString address = 'Utawala, Nairobi'.obs;

  final RxBool isPlacing = false.obs;

  // ── Totals (all derived from the real cart) ────────────────
  List<CartItem> get items => _cart.items;

  num get subtotal => _cart.total;

  num get discount => coupon.value?.discountFor(subtotal) ?? 0;

  num get shipping => items.isEmpty ? 0 : shippingFee;

  num get _base => subtotal - discount;

  num get tax => pricesIncludeTax
      ? (_base * taxRate / (1 + taxRate)).round()
      : (_base * taxRate).round();

  num get total => _base + shipping + (pricesIncludeTax ? 0 : tax);

  // ── Coupon ─────────────────────────────────────────────────
  Future<void> applyCoupon() async {
    final code = couponCtrl.text.trim().toUpperCase();
    if (code.isEmpty) return;

    try {
      isApplying.value = true;
      couponError.value = null;

      final found = await _repo.getCoupon(code);
      if (found == null) {
        couponError.value = 'That code isn\'t valid or has expired.';
      } else {
        coupon.value = found;
      }
    } catch (e) {
      couponError.value = e.toString();
    } finally {
      isApplying.value = false;
    }
  }

  void removeCoupon() {
    coupon.value = null;
    couponError.value = null;
    couponCtrl.clear();
  }

  // ── Place order ────────────────────────────────────────────
  Future<PlacedOrder?> placeOrder() async {
    final lines = items;
    if (lines.isEmpty) {
      Get.snackbar('Cart is empty', 'Add something to your cart first.');
      return null;
    }

    // Snapshot everything before the cart is cleared.
    final sub = subtotal;
    final disc = discount;
    final ship = shipping;
    final taxAmount = tax;
    final tot = total;
    final count = _cart.count;
    final addr = address.value;
    final code = coupon.value?.code;

    try {
      isPlacing.value = true;

      final id = await _repo.createOrder({
        'items': lines
            .map((i) => {
                  'productDocId': i.productDocId,
                  'productName': i.productName,
                  'variantName': i.variantName,
                  'variantLabel': i.variantLabel,
                  'unitPrice': i.price,
                  'quantity': i.quantity,
                  'image': i.image,
                })
            .toList(),
        'subtotal': sub,
        'discount': disc,
        'couponCode': code,
        'shippingFee': ship,
        'tax': taxAmount,
        'taxIncluded': pricesIncludeTax,
        'total': tot,
        'deliveryAddress': addr,
      });

      _cart.clear();

      return PlacedOrder(
        reference: 'TO-${id.substring(0, math.min(6, id.length)).toUpperCase()}',
        itemCount: count,
        total: tot,
        address: addr,
      );
    } catch (e) {
      Get.snackbar('Order failed', e.toString());
      return null;
    } finally {
      isPlacing.value = false;
    }
  }

  @override
  void onClose() {
    couponCtrl.dispose();
    super.onClose();
  }
}