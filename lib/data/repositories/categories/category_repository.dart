import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:k_store/features/shop/models/category_model.dart';

import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../../services/cloud_storage/firebase_storage_service.dart';

class CategoryRepository extends GetxController {
  static CategoryRepository get instance => Get.find();

  //Variables
  final _db = FirebaseFirestore.instance;

  //Get all categories   
  Future<List<CategoryModel>> getAllCategories() async {
    try{
      final snapshot = await _db.collection('Categories').get();
      final list = snapshot.docs.map((document) => CategoryModel.fromSnapshot(document)).toList();
      return list;

    }on FirebaseException catch (e) {
      throw MFirebaseException(e.code).message;
    } on PlatformException catch (e){
      throw MPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  //Get Sub categories
  Future<List<CategoryModel>> getSubCategories(String categoryId) async {
    try{
      final snapshot = await _db.collection('Categories').where('ParentId', isEqualTo: categoryId).get();
      final result = snapshot.docs.map((e) => CategoryModel.fromSnapshot(e)).toList();
      return result;

    }on FirebaseException catch (e) {
      throw MFirebaseException(e.code).message;
    } on PlatformException catch (e){
      throw MPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
  //Upload Categories to the cloud Firebase
    Future<void> uploadDummydata(List<CategoryModel> categories) async {
    try{
      //Upload all the categories along with their Images
      final storage = Get.put(MFirebaseStorageService());

      //Loop through each category
      for (var category in categories ) {
        //Get ImageData link from the local assets
        final file = await storage.getImageDataFromAssets(category.image);

        //Upload Image and Get its URL
        final url = await storage.uploadImageData('Categories',file,category.name);

        //Assign url to category.image attribute
        category.image = url;

        //store category in firestore
        await _db.collection('Categories').doc(category.id).set(category.toJson());
      }
    }on FirebaseException catch (e) {
      throw MFirebaseException(e.code).message;
    } on PlatformException catch (e){
      throw MPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
    }

}