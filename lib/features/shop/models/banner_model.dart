import 'package:cloud_firestore/cloud_firestore.dart';

  class BannerModel {
    String imageUrl;
    final String targetScreen;
    final bool active;

  BannerModel({required this.targetScreen,required this.active,required this.imageUrl});

  //Convert model to Json structure so that you can store data in Firebase
  Map<String, dynamic> toJson() {
    return {
      'ImageUrl': imageUrl,
      'TargetScreen': targetScreen,
      'Active': active,
    };
  }

  //Map JSON oriented document snapshot from firebase to userModel
  factory BannerModel.fromSnapshot(DocumentSnapshot snapshot){
      final data = snapshot.data() as Map<String, dynamic>;
      //Map JSON record to the model
      return BannerModel(
        imageUrl: data['ImageUrl'] ?? '', 
        targetScreen: data['TargetScreen'] ?? '', 
        active: data['Active'] ?? false, 
      );
    }
  
}