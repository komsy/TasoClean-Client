import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasoclean/data/repositories/services/booking_repository.dart';
import 'package:tasoclean/features/shop/controllers/service_controller.dart';
import 'package:tasoclean/features/shop/models/service_model.dart';

/// 2800 -> "2,800"
String formatAmount(num v) {
  final fixed = v % 1 == 0 ? v.toInt().toString() : v.toStringAsFixed(2);
  final parts = fixed.split('.');
  final whole = parts[0].replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');
  return parts.length > 1 ? '$whole.${parts[1]}' : whole;
}

/// 2800 -> "KES 2,800"
String formatKes(num v) => 'KES ${formatAmount(v)}';

/// One selected service with its quantity.
class CartLine {
  const CartLine(this.category, this.service, this.quantity);

  final ServiceCategoryModel category;
  final ServiceModel service;
  final int quantity;

  double get lineTotal => service.amount.toDouble() * quantity;

  Map<String, dynamic> toMap() => {
        'categoryDocId': category.docId,
        'categoryName': category.categoryName,
        'serviceId': service.id,
        'serviceName': service.name,
        'unitAmount': service.amount,
        'quantity': quantity,
        'lineTotal': lineTotal,
      };
}

/// What the success screen needs to show.
class BookingSummary {
  const BookingSummary({
    required this.reference,
    required this.whenLabel,
    required this.itemCount,
    required this.serviceCount,
    required this.servicesTotal,
    required this.payNow,
  });

  final String reference;
  final String whenLabel;
  final int itemCount;
  final int serviceCount;
  final double servicesTotal;
  final double payNow;
}

class CheckoutController extends GetxController {
  static CheckoutController get instance => Get.find();

  static const double depositRate = 0.5;
  static const List<String> slots = ['Morning 8-12', 'Afternoon 12-4', 'Evening 4-7'];
  static const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  static String weekday(DateTime d) => _weekdays[d.weekday - 1];
  static String month(DateTime d) => _months[d.month - 1];

  final _services = ServiceController.instance;
  final _bookings = Get.put(BookingRepository());

  // ── Schedule + notes ───────────────────────────────────────
  final TextEditingController notes = TextEditingController();

  /// Next 14 days, starting tomorrow.
  late final List<DateTime> availableDays = () {
    final n = DateTime.now();
    return List.generate(14, (i) => DateTime(n.year, n.month, n.day + i));//+1 fo the following day
  }();

  late final Rx<DateTime> selectedDate = availableDays.first.obs;
  final RxInt slotIndex = 1.obs; // afternoon by default

  String get whenLabel {
    final d = selectedDate.value;
    return '${weekday(d)}, ${d.day} ${month(d)} - ${slots[slotIndex.value]}';
  }

  // ── Wallet / credits (TODO: load these from the user's Firestore doc) ──
  final RxDouble appCredits = 0.0.obs;
  final RxDouble walletBalance = 200.0.obs;
  final RxBool useCredits = false.obs;
  final RxBool useWallet = false.obs;

  final RxBool isSubmitting = false.obs;

  // ── Cart + totals ──────────────────────────────────────────
  List<CartLine> get lines {
    final out = <CartLine>[];
    for (final c in _services.categories) {
      for (final s in c.activeServices) {
        final q = _services.quantityOf(c, s);
        if (q > 0) out.add(CartLine(c, s, q));
      }
    }
    return out;
  }

  int get itemCount => lines.fold(0, (sum, l) => sum + l.quantity);

  double get servicesTotal => lines.fold(0.0, (sum, l) => sum + l.lineTotal);

  double get deposit => servicesTotal * depositRate;

  double get creditsApplied => useCredits.value ? math.min(appCredits.value, deposit) : 0.0;

  double get walletApplied =>
      useWallet.value ? math.min(walletBalance.value, deposit - creditsApplied) : 0.0;

  /// What the customer still has to pay now (via M-Pesa).
  double get payNow => deposit - creditsApplied - walletApplied;

  // ── Place booking ──────────────────────────────────────────
  Future<BookingSummary?> placeBooking() async {
    final current = lines;
    if (current.isEmpty) {
      Get.snackbar('Nothing selected', 'Pick at least one service first.');
      return null;
    }

    final total = servicesTotal;
    final dep = deposit;
    final credits = creditsApplied;
    final wallet = walletApplied;
    final pay = payNow;
    final label = whenLabel;

    try {
      isSubmitting.value = true;

      final id = await _bookings.createBooking(
        lines: current.map((l) => l.toMap()).toList(),
        scheduledDate: selectedDate.value,
        timeSlot: slots[slotIndex.value],
        notes: notes.text.trim(),
        servicesTotal: total,
        deposit: dep,
        creditsApplied: credits,
        walletApplied: wallet,
        payNow: pay,
      );

      // TODO: if pay > 0, trigger the M-Pesa STK push here (via your backend /
      // Cloud Function, never with Daraja secrets inside the app).

      final summary = BookingSummary(
        reference: 'TC-${id.substring(0, math.min(6, id.length)).toUpperCase()}',
        whenLabel: label,
        itemCount: current.fold(0, (sum, l) => sum + l.quantity),
        serviceCount: current.length,
        servicesTotal: total,
        payNow: pay,
      );

      _services.clearCart();
      return summary;
    } catch (e) {
      Get.snackbar('Booking failed', e.toString());
      return null;
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    notes.dispose();
    super.onClose();
  }
}