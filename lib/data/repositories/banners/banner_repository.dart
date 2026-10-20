import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:k_store/features/shop/models/banner_model.dart';
 
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class BannerRepository extends GetxController {
  static BannerRepository get instance => Get.find();

  //Variables
  final _db = FirebaseFirestore.instance;

  //Get all banners   
  Future<List<BannerModel>> fetchBanners() async {
    try{
      final result = await _db.collection('Banners').where('Active', isEqualTo: true).get();
      final data = result.docs.map((documentSnapshot) => BannerModel.fromSnapshot(documentSnapshot)).toList();
      return data;
    }on FirebaseException catch (e) {
      throw MFirebaseException(e.code).message;
    } on FormatException catch(_){
      throw const MFormatException();
    } on PlatformException catch (e){
      throw MPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong while fetching Banners. Please try again';
    }
  }

  //Upload Banner to the cloud Firebase


   //Function to save Banner data to Firestore
    Future<void> updateSingleField(Map<String, dynamic> json) async {
      try {
        await _db.collection("Banners").doc('1').update(json);
      }on FirebaseException catch (e) {
          throw MFirebaseException(e.code).message;
        }on FormatException catch (_) {
          throw const MFormatException();
        } on PlatformException catch (e){
          throw MPlatformException(e.code).message;
        } catch (e) {
          throw 'Something went wrong. Please try again';
        }
      }
}