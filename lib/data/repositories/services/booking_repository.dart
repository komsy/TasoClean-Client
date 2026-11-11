import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class BookingRepository extends GetxController {
  static BookingRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Change this if your collection is named differently.
  static const String _collection = 'Bookings';

  /// Creates the booking and returns its document id.
  ///
  /// Status starts as `pending_payment` when money is still due. Your backend
  /// (the M-Pesa callback) should be the thing that flips it to `confirmed`.
  Future<String> createBooking({
    required List<Map<String, dynamic>> lines,
    required DateTime scheduledDate,
    required String timeSlot,
    required String notes,
    required double servicesTotal,
    required double deposit,
    required double creditsApplied,
    required double walletApplied,
    required double payNow,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw 'Please sign in to book a service.';

      final doc = await _db.collection(_collection).add({
        'userId': user.uid,
        'services': lines,
        'scheduledDate': Timestamp.fromDate(scheduledDate),
        'timeSlot': timeSlot,
        'notes': notes,
        'servicesTotal': servicesTotal,
        'depositRequired': deposit,
        'creditsApplied': creditsApplied,
        'walletApplied': walletApplied,
        'amountDueNow': payNow,
        'paymentMethod': 'mpesa',
        'status': payNow > 0 ? 'pending_payment' : 'confirmed',
        'createdAt': FieldValue.serverTimestamp(),
      });

      return doc.id;
    } on FirebaseException catch (e) {
      throw 'Firebase error: ${e.message ?? e.code}';
    }
  }
}