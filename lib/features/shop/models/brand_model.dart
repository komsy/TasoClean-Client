import 'package:cloud_firestore/cloud_firestore.dart';

  class BrandModel {
    String id;
    String name;
    String image;
    bool? isFeatured;
    int? productCount;

  BrandModel({
    required this.id,
    required this.name,
    required this.image,
    this.isFeatured,
    this.productCount ,
  });


  //Empty Helper function
  static BrandModel empty() =>BrandModel(id: '', name: '', image: '');
  
  //JSON Format
  toJson() {
    return {
      'Id': id,
      'Name': name,
      'Image': image,
      'ProductCount': productCount,
      'IsFeatured': isFeatured,
    };
  }

  //Map Json oriented document snapshot from Firebase to Model
  factory BrandModel.fromJson(Map<String, dynamic> document){
    final data = document;
    if(data.isEmpty) return BrandModel.empty();

      //Map JSON record to the model
      return BrandModel(
        id: data['Id'] ?? '', 
        name: data['Name'] ?? '', 
        image: data['Image'] ?? '', 
        isFeatured: data['IsFeatured'] ?? false,
        productCount: int.parse((data['ProductCount'] ?? 0).toString()), 
      );
  }

  //To correct
  //Map Json oriented document snapshot from Firebase to Model
  factory BrandModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    if(document.data() != null){
      final data = document.data()!;

        //Map JSON record to the model
        return BrandModel(
          id: document.id, 
          name: data['Name'] ?? '', 
          image: data['Image'] ?? '', 
          isFeatured: data['IsFeatured'] ?? false,
          productCount: data['ProductCount'] ?? '', 
        );
    } else {
      return BrandModel.empty();
    }
  }

}