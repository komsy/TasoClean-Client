import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tasoclean/features/shop/models/service_model.dart';

class ServiceRepository extends GetxController {
  static ServiceRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Change this if your collection is named differently.
  static const String _collection = 'services';

  /// All active categories, each with its services array.
  Future<List<ServiceCategoryModel>> getServiceCategories() async {
    try {
      final snapshot = await _db
          .collection(_collection)
          .where('serviceCategoryStatus', isEqualTo: 'Active')
          .get();
      log('Fetched ${snapshot.docs.length} service categories from Firestore');
      log('Documents: ${snapshot.docs.map((doc) => doc.data()).toList()}');
      return snapshot.docs.map(ServiceCategoryModel.fromSnapshot).toList();
    } on FirebaseException catch (e) {
      throw 'Firebase error: ${e.message ?? e.code}';
    } catch (e) {
      throw 'Something went wrong while loading services. Please try again.';
    }
  }

  /// Categories filtered by their parent group, e.g. "Residential".
  Future<List<ServiceCategoryModel>> getByCategory(String category) async {
    try {
      final snapshot = await _db
          .collection(_collection)
          .where('serviceCategoryStatus', isEqualTo: 'Active')
          .where('category', isEqualTo: category)
          .get();

      return snapshot.docs.map(ServiceCategoryModel.fromSnapshot).toList();
    } on FirebaseException catch (e) {
      throw 'Firebase error: ${e.message ?? e.code}';
    } catch (e) {
      throw 'Something went wrong while loading services. Please try again.';
    }
  }
}