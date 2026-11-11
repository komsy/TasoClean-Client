import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// One entry inside the `services` array of a category document.
class ServiceModel {
  const ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.amount,
    required this.duration,
    required this.status,
  });

  final int id;
  final String name;
  final String description;
  final num amount; // serviceAmount (KES)
  final num duration; // serviceDuration (hours, assumed)
  final String status; // "Active" / "Inactive"

  bool get isActive => status.toLowerCase() == 'active';

  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    return ServiceModel(
      id: (map['id'] as num?)?.toInt() ?? 0,
      name: map['serviceName'] as String? ?? '',
      description: map['description'] as String? ?? '',
      amount: map['serviceAmount'] as num? ?? 0,
      duration: map['serviceDuration'] as num? ?? 0,
      status: map['serviceStatus'] as String? ?? 'Inactive',
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'serviceName': name,
        'description': description,
        'serviceAmount': amount,
        'serviceDuration': duration,
        'serviceStatus': status,
      };
}

/// One Firestore document, e.g. "Home Cleaning" under category "Residential".
class ServiceCategoryModel {
  const ServiceCategoryModel({
    required this.docId,
    required this.category,
    required this.categoryName,
    required this.status,
    required this.colorHex,
    required this.serviceNumber,
    required this.services,
    this.updatedAt,
  });

  final String docId;
  final String category; // "Residential"
  final String categoryName; // "Home Cleaning"
  final String status; // serviceCategoryStatus
  final String colorHex; // serviceColor, e.g. "#000000"
  final String serviceNumber; // "SN0001"
  final List<ServiceModel> services;
  final DateTime? updatedAt;

  bool get isActive => status.toLowerCase() == 'active';

  /// Only the services that are currently active.
  List<ServiceModel> get activeServices => services.where((s) => s.isActive).toList();

  Color get color {
    var hex = colorHex.replaceFirst('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.tryParse(hex, radix: 16) ?? 0xFF000000);
  }

  factory ServiceCategoryModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    final rawServices = (data['services'] as List?) ?? const [];

    return ServiceCategoryModel(
      docId: doc.id,
      category: data['category'] as String? ?? '',
      categoryName: data['categoryName'] as String? ?? '',
      status: data['serviceCategoryStatus'] as String? ?? 'Inactive',
      colorHex: data['serviceColor'] as String? ?? '#000000',
      serviceNumber: data['serviceNumber'] as String? ?? '',
      services: rawServices
          .whereType<Map>()
          .map((m) => ServiceModel.fromMap(Map<String, dynamic>.from(m)))
          .toList(),
      updatedAt: _parseDate(data['updated_at']),
    );
  }

  Map<String, dynamic> toMap() => {
        'category': category,
        'categoryName': categoryName,
        'serviceCategoryStatus': status,
        'serviceColor': colorHex,
        'serviceNumber': serviceNumber,
        'services': services.map((s) => s.toMap()).toList(),
        'updated_at': updatedAt?.toUtc().toIso8601String(),
      };

  // updated_at is an ISO string in your data, but accept a Timestamp too.
  static DateTime? _parseDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}