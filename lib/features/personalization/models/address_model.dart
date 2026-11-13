import 'package:cloud_firestore/cloud_firestore.dart';

/// Stored at Users/{uid}/Addresses/{id}
class AddressModel {
  const AddressModel({
    this.id = '',
    required this.label,
    required this.addressLine,
    required this.latitude,
    required this.longitude,
    this.details = '',
    this.city = '',
    this.isDefault = false,
  });

  final String id;
  final String label; // Home | Work | Other
  final String addressLine; // street / area, editable by the user
  final String details; // apartment, gate code, landmark...
  final String city;
  final double latitude;
  final double longitude;
  final bool isDefault;

  /// "Utawala Road, Nairobi" – skips the city if the line already contains it.
  String get fullAddress {
    final line = addressLine.trim();
    final c = city.trim();
    if (c.isEmpty || line.toLowerCase().contains(c.toLowerCase())) return line;
    return line.isEmpty ? c : '$line, $c';
  }

  AddressModel copyWith({String? id, bool? isDefault}) => AddressModel(
        id: id ?? this.id,
        label: label,
        addressLine: addressLine,
        details: details,
        city: city,
        latitude: latitude,
        longitude: longitude,
        isDefault: isDefault ?? this.isDefault,
      );

  factory AddressModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    final point = d['location'];

    return AddressModel(
      id: doc.id,
      label: d['label'] as String? ?? 'Other',
      addressLine: d['addressLine'] as String? ?? '',
      details: d['details'] as String? ?? '',
      city: d['city'] as String? ?? '',
      latitude: point is GeoPoint ? point.latitude : 0,
      longitude: point is GeoPoint ? point.longitude : 0,
      isDefault: d['isDefault'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
        'label': label,
        'addressLine': addressLine,
        'details': details,
        'city': city,
        'location': GeoPoint(latitude, longitude),
        'isDefault': isDefault,
        'updatedAt': FieldValue.serverTimestamp(),
      };
}