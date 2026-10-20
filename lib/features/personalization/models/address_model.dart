import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:k_store/utils/formatters/formatter.dart';

  class AddressModel {
    String id;
    final String name;
    final String phoneNumber;
    final String street;
    final String city;
    final String state;
    final String postalCode;
    final String country;
    final DateTime? dateTime;
    bool selectedAddress;

  AddressModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    this.dateTime,
    this.selectedAddress = true,
  });

String get formattedPhoneNo => MFormatter.formatPhoneNumber(phoneNumber);

  //Empty Helper function
  static AddressModel empty() =>AddressModel(id: '', name: '', phoneNumber: '',street: '', city: '', state: '', postalCode: '', country: '');
  
  //JSON Format
  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Name': name,
      'PhoneNumber': phoneNumber,
      'Street': street,
      'City': city,
      'State': state,
      'PostalCode': postalCode,
      'Country': country,
      'DateTime': DateTime.now(),
      'SelectedAddress': selectedAddress,
    };
  }

  //Map Json oriented document snapshot from Firebase to Model
  factory AddressModel.fromMap(Map<String, dynamic> data){

      //Map JSON record to the model
      return AddressModel(
        id: data['Id'] as String, 
        name: data['Name'] as String, 
        phoneNumber: data['PhoneNumber'] as String, 
        street: data['Street'] as String, 
        city: data['City'] as String, 
        state: data['State'] as String, 
        postalCode: data['PostalCode'] as String, 
        country: data['Country'] as String, 
        selectedAddress: data['SelectedAddress'] as bool, 
        dateTime: (data['DateTime'] as Timestamp).toDate(), 
      );
  }

  //Factory constructor to create an addressmodel from a documentsnapshot
  factory AddressModel.fromDocumentSnapshot(DocumentSnapshot  snapshot){
      final data = snapshot.data() as Map<String, dynamic>;

        //Map JSON record to the model
        return AddressModel(
        id: snapshot.id, 
        // id: data['Id'], 
        name: data['Name'] ?? '', 
        phoneNumber: data['PhoneNumber'] ?? '', 
        street: data['Street'] ?? '', 
        city: data['City'] ?? '', 
        state: data['State'] ?? '', 
        postalCode: data['PostalCode'] ?? '', 
        country: data['Country'] ?? '', 
        dateTime: (data['DateTime'] as Timestamp).toDate(), 
        selectedAddress: data['SelectedAddress'] as bool, 
     );
  }

  @override
  String toString() {
    return '$street,$city,$state,$postalCode,$country';
  }

}