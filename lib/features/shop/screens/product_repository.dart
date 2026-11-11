import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tasoclean/features/shop/screens/product_model.dart';

class ProductRepository extends GetxController {
  static ProductRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String _collection = 'products';

  /// Active products that have at least one published variant.
  /// Note: productStatus is lowercase "active" here (services use "Active").
  Future<List<ProductModel>> getActiveProducts() async {
    try {
      final snapshot = await _db
          .collection(_collection)
          .where('productStatus', isEqualTo: 'active')
          .get();

      final list = snapshot.docs
          .map(ProductModel.fromSnapshot)
          .where((p) => p.isAvailable)
          .toList()
        ..sort((a, b) => a.productId.compareTo(b.productId));

      return list;
    } on FirebaseException catch (e) {
      throw 'Firebase error: ${e.message ?? e.code}';
    } catch (e) {
      throw 'Something went wrong while loading products. Please try again.';
    }
  }
}
