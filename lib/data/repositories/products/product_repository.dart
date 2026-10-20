import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:k_store/features/shop/models/product_model.dart';
import '../../../utils/constants/enums.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../../services/cloud_storage/firebase_storage_service.dart';

class ProductRepository extends GetxController {
  static ProductRepository get instance => Get.find();

  //Firestore instance for database interactions
  final _db = FirebaseFirestore.instance;

  //Get limited featured products
  Future<List<ProductModel>> getFeaturedProducts() async {
    try{
      final snapshot = await _db.collection('Products').where('IsFeatured',isEqualTo: true).limit(4).get();
      // print(snapshot);
      return snapshot.docs.map((e) => ProductModel.fromSnapshot(e)).toList();

    }on FirebaseException catch (e) {
      throw MFirebaseException(e.code).message;
    } on PlatformException catch (e){
      throw MPlatformException(e.code).message;
    } catch (e) {
      print(e);
      throw e.toString(); // 'Something went wrong fetching products. Please try again';
    }
  }
//Get all featured products
Future<List<ProductModel>> getAllFeaturedProducts() async {
    try{
      final snapshot = await _db.collection('Products').where('IsFeatured',isEqualTo: true).get();

      return snapshot.docs.map((e) => ProductModel.fromSnapshot(e)).toList();

    }on FirebaseException catch (e) {
      throw MFirebaseException(e.code).message;
    } on PlatformException catch (e){
      throw MPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong fetching products. Please try again';
    }
  }

  //Get products based on the query
  Future<List<ProductModel>> fetchProductsByQuery(Query query) async {
    try{
      final querySnapShot = await query.get();
      
      final List<ProductModel> productList =querySnapShot.docs.map((doc) => ProductModel.fromQuerySnapshot(doc)).toList();
      
      return productList;
    }on FirebaseException catch (e) {
      throw MFirebaseException(e.code).message;
    } on PlatformException catch (e){
      throw MPlatformException(e.code).message;
    } catch (e) {
      throw  'Something went wrong fetching products. Please try again';
    }
  }
  
    Future<List<ProductModel>> getFavouriteProducts(List<String> productIds) async {
    try{
      final snapshot = await _db.collection('Products').where(FieldPath.documentId, whereIn: productIds).get();
      print(snapshot);
      return snapshot.docs.map((querySnapshot) => ProductModel.fromSnapshot(querySnapshot)).toList();
    }on FirebaseException catch (e) {
      throw MFirebaseException(e.code).message;
    } on PlatformException catch (e){
      throw MPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong fetching products. Please try again';
    }
  }

  Future<List<ProductModel>> getProductsForBrand({required String brandId, int limit = -1}) async {
    try{
      final querySnapshot = limit == -1
        ? await _db.collection('Products').where('Brand.id', isEqualTo: brandId).get()
        : await _db.collection('Products').where('Brand.id', isEqualTo: brandId).limit(limit).get();
      
      final products = querySnapshot.docs.map((doc) => ProductModel.fromSnapshot(doc)).toList();
      return products;
    }on FirebaseException catch (e) {
      throw MFirebaseException(e.code).message;
    } on PlatformException catch (e){
      throw MPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong fetching products. Please try again';
    }
  }

  Future<List<ProductModel>> getProductsForCategory({required String categoryId, int limit = -1}) async {
    try{
      QuerySnapshot productCategoryQuery = limit == -1
        ? await _db.collection('ProductsCategory').where('categoryId', isEqualTo: categoryId).get()
        : await _db.collection('ProductsCategory').where('categoryId', isEqualTo: categoryId).limit(limit).get();
      
      //Extract productsids from the documents
      List<String> productIds = productCategoryQuery.docs.map((doc) => doc['productId'] as String).toList();

      //Query to get all documents where the productId is in the list of productIds, FieldPath.documentId to query documents in collection
      final productsQuery = await _db.collection('Products').where(FieldPath.documentId, whereIn: productIds).get();

      //Extract product names or other relevant data from the documents
      List<ProductModel> products = productsQuery.docs.map((doc) => ProductModel.fromSnapshot(doc)).toList();

      return products;
    }on FirebaseException catch (e) {
      throw MFirebaseException(e.code).message;
    } on PlatformException catch (e){
      throw MPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }


  //Upload dummy data to the Cloud Firebase
  Future<void> uploadDummyData(List<ProductModel> products) async {
  try{
      //Upload all the products along with their Images
      final storage = Get.put(MFirebaseStorageService());

      //Loop through each product
      for (var product in products ) {
        //Get ImageData link from the local assets
        final thumbnail = await storage.getImageDataFromAssets(product.thumbnail);

        //Upload Image and Get its URL
        final url = await storage.uploadImageData('Products/Images',thumbnail,product.thumbnail.toString());

        //Assign url to product.thumbnail attribute
        product.thumbnail = url;

        //Product list of images
        if(product.images != null && product.images!.isNotEmpty){
          List<String> imageUrl = [];
          for (var image in product.images!){
            //Get image data link from local assets
            final assetImage = await storage.getImageDataFromAssets(image);

            //Upload image and get its URL
            final url = await storage.uploadImageData('Products/Images', assetImage, image);

            //Assign URL to product.thumbnail attribute
            imageUrl.add(url);
          }
          product.images!.clear();
          product.images!.addAll(imageUrl);
        }
        
        //Upload Variation Images
        if(product.productType == ProductType.variable.toString()){
          for (var variation in product.productVariations!){
            //Get image data link from local assets
            final assetImage = await storage.getImageDataFromAssets(variation.image);

            //Upload image and get its URL
            final url = await storage.uploadImageData('Products/Images', assetImage, variation.image);

            //Assign URL to product.thumbnail attribute
           variation.image = url;
          }
        }

        //Store product in Firestore
        await _db.collection('Products').doc(product.id).set(product.toJson());
      }
    }on FirebaseException catch (e) {
      throw e.message!;
    }on SocketException catch (e) {
      throw e.message;
    } on PlatformException catch (e){
      throw e.message!;
    } catch (e) {
      throw e.toString();
    }
  }
  

}