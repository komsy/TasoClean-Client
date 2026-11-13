import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class Coupon {
  const Coupon({required this.code, this.percent = 0, this.amount = 0});

  final String code;
  final num percent; // e.g. 10 = 10% off
  final num amount; // flat KSh off (used when percent is 0)

  num discountFor(num subtotal) {
    final d = percent > 0 ? (subtotal * percent / 100).round() : amount;
    return d > subtotal ? subtotal : d;
  }
}

class ProductOrderRepository extends GetxController {
  static ProductOrderRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  static const String _orders = 'ProductOrders';
  static const String _coupons = 'Coupons';

  /// Saves the order and returns its document id.
  Future<String> createOrder(Map<String, dynamic> data) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw 'Please sign in to place an order.';

      final doc = await _db.collection(_orders).add({
        ...data,
        'userId': user.uid,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });
      return doc.id;
    } on FirebaseException catch (e) {
      throw 'Firebase error: ${e.message ?? e.code}';
    }
  }

  /// Looks a code up in `Coupons` (document id = the code, upper-case).
  /// Fields: discountPercent (num) or discountAmount (num), isActive (bool, optional),
  /// expiresAt (Timestamp, optional). Returns null if missing, inactive or expired.
  Future<Coupon?> getCoupon(String code) async {
    try {
      final snap = await _db.collection(_coupons).doc(code).get();
      if (!snap.exists) return null;

      final d = snap.data() ?? {};
      if (d['isActive'] == false) return null;

      final expires = d['expiresAt'];
      if (expires is Timestamp && expires.toDate().isBefore(DateTime.now())) return null;

      final percent = d['discountPercent'] is num ? d['discountPercent'] as num : 0;
      final amount = d['discountAmount'] is num ? d['discountAmount'] as num : 0;
      if (percent <= 0 && amount <= 0) return null;

      return Coupon(code: code, percent: percent, amount: amount);
    } on FirebaseException catch (e) {
      throw 'Firebase error: ${e.message ?? e.code}';
    }
  }
}