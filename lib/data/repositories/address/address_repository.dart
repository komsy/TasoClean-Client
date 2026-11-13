import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tasoclean/data/repositories/authentication/authentication_repository.dart';
import 'package:tasoclean/features/personalization/models/address_model.dart';

class AddressRepository extends GetxController {
  static AddressRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  //Get addresses
  Future<List<AddressModel>> fetchUserAddresses() async {
    try {
      final userId = AuthenticationRepository.instance.authUser!.uid;
      if (userId.isEmpty) {
        throw 'Unable to find user information. Try again in a few minutes';
      }

      final result = await _db
          .collection('Users')
          .doc(userId)
          .collection('Addresses')
          .get();
      return result.docs
          .map(AddressModel.fromSnapshot)
          .toList();
    } catch (e) {
      throw Exception(
        'Something went wrong while fetching address information. Please try again later. $e',
      );
    }
  }

  Future<void> setDefaultAddress(String addressId) async {
    try {
      final userId = AuthenticationRepository.instance.authUser!.uid;
      final addresses = _db
          .collection('Users')
          .doc(userId)
          .collection('Addresses');
      final snapshot = await addresses.get();
      final batch = _db.batch();

      for (final document in snapshot.docs) {
        batch.update(document.reference, {'isDefault': document.id == addressId});
      }

      await batch.commit();
    } catch (e) {
      throw Exception(
        'Unable to update your default address. Please try again later. $e',
      );
    }
  }

  Future<String> addAddress(AddressModel address) async {
    try {
      final userId = AuthenticationRepository.instance.authUser!.uid;

      final currentAddress = await _db
          .collection('Users')
          .doc(userId)
          .collection('Addresses')
          .add(address.toMap());
      return currentAddress.id;
    } catch (e) {
      throw Exception(
        'Something went wrong while saving address information. Please try again later. $e',
      );
    }
  }
}
