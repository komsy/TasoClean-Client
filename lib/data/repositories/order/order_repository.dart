import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tasoclean/features/shop/models/order_model.dart';

class OrderRepository extends GetxController {
  static OrderRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  static const String _bookings = 'Bookings';
  static const String _productOrders = 'ProductOrders';

  String _uid() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw 'Please sign in to see your orders.';
    return user.uid;
  }

  // Sorted on the device (newest first) so no composite index is needed.
  int _newestFirst(DateTime? a, DateTime? b) =>
      (b ?? DateTime.fromMillisecondsSinceEpoch(0)).compareTo(a ?? DateTime.fromMillisecondsSinceEpoch(0));

  Future<List<BookingModel>> getServiceBookings() async {
    try {
      final snap = await _db.collection(_bookings).where('userId', isEqualTo: _uid()).get();
      return snap.docs.map(BookingModel.fromSnapshot).toList()
        ..sort((a, b) => _newestFirst(a.createdAt, b.createdAt));
    } on FirebaseException catch (e) {
      throw 'Firebase error: ${e.message ?? e.code}';
    }
  }

  Future<List<ProductOrderModel>> getProductOrders() async {
    try {
      final snap = await _db.collection(_productOrders).where('userId', isEqualTo: _uid()).get();
      return snap.docs.map(ProductOrderModel.fromSnapshot).toList()
        ..sort((a, b) => _newestFirst(a.createdAt, b.createdAt));
    } on FirebaseException catch (e) {
      throw 'Firebase error: ${e.message ?? e.code}';
    }
  }
}