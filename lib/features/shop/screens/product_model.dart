import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasoclean/features/shop/controllers/checkout_controller.dart' show formatAmount;

bool _asBool(dynamic v) {
  if (v is bool) return v;
  if (v is num) return v != 0;
  if (v is String) return v == '1' || v.toLowerCase() == 'true';
  return false;
}

num _asNum(dynamic v) => v is num ? v : (num.tryParse('$v') ?? 0);

/// One entry in a product's `variants` array.
class ProductVariantModel {
  const ProductVariantModel({
    required this.name,
    required this.attribute,
    required this.attributeValue,
    required this.price,
    required this.image,
    required this.isFeatured,
    required this.isPublished,
  });

  final String name; // variantName, e.g. "Taso Methylated Spirit - Food Warming - 1 Liter"
  final String attribute; // variantAttribute, e.g. "color"
  final String attributeValue; // variantAttributeValue, e.g. "1 Liter"
  final num price; // variantPrice
  final String image; // productImage (url)
  final bool isFeatured;
  final bool isPublished;

  /// Short text for chips/rows: "1 Liter", falling back to the full name.
  String get label => attributeValue.isNotEmpty ? attributeValue : name;

  factory ProductVariantModel.fromMap(Map<String, dynamic> m) {
    return ProductVariantModel(
      name: m['variantName'] as String? ?? '',
      attribute: m['variantAttribute'] as String? ?? '',
      attributeValue: m['variantAttributeValue'] as String? ?? '',
      price: _asNum(m['variantPrice']),
      image: m['productImage'] as String? ?? '',
      isFeatured: _asBool(m['isFeatured']),
      isPublished: _asBool(m['isPublished']),
    );
  }

  Map<String, dynamic> toMap() => {
        'variantName': name,
        'variantAttribute': attribute,
        'variantAttributeValue': attributeValue,
        'variantPrice': price,
        'productImage': image,
        'isFeatured': isFeatured ? 1 : 0,
        'isPublished': isPublished ? 1 : 0,
      };
}

class ProductModel {
  const ProductModel({
    required this.docId,
    required this.productId,
    required this.name,
    required this.description,
    required this.status,
    required this.variants,
    this.category,
  });

  final String docId;
  final int productId;
  final String name; // productName
  final String description; // HTML string
  final String status; // productStatus: "active"
  final List<ProductVariantModel> variants;

  /// Not visible in your screenshot – read from `category` / `categoryName`
  /// if the field exists, otherwise null.
  final String? category;

  bool get isActive => status.toLowerCase() == 'active';

  List<ProductVariantModel> get publishedVariants => variants.where((v) => v.isPublished).toList();

  /// Shown in the shop only when active and at least one variant is published.
  bool get isAvailable => isActive && publishedVariants.isNotEmpty;

  bool get isFeatured => publishedVariants.any((v) => v.isFeatured);

  num get minPrice => publishedVariants.isEmpty
      ? 0
      : publishedVariants.map((v) => v.price).reduce(math.min);

  num get maxPrice => publishedVariants.isEmpty
      ? 0
      : publishedVariants.map((v) => v.price).reduce(math.max);

  /// "KSh 600" or "KSh 250 – 1,200"
  String get priceLabel => minPrice == maxPrice
      ? 'KSh ${formatAmount(minPrice)}'
      : 'KSh ${formatAmount(minPrice)} – ${formatAmount(maxPrice)}';

  /// First available variant image.
  String get imageUrl {
    for (final v in publishedVariants) {
      if (v.image.isNotEmpty) return v.image;
    }
    return '';
  }

  /// The description is stored as HTML (`<p data-start=...>...</p>`).
  /// This strips it to readable text; use flutter_html if you want rich rendering.
  String get plainDescription {
    final s = description
        .replaceAll(RegExp(r'<\s*br\s*/?>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'</\s*(p|div|h[1-6])\s*>', caseSensitive: false), '\n\n')
        .replaceAll(RegExp(r'<\s*li[^>]*>', caseSensitive: false), '• ')
        .replaceAll(RegExp(r'</\s*li\s*>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'<[^>]+>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&amp;', '&');
    return s.replaceAll(RegExp(r'\n{3,}'), '\n\n').trim();
  }

  factory ProductModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    final rawVariants = (data['variants'] as List?) ?? const [];
    final cat = (data['category'] ?? data['categoryName']) as String?;

    return ProductModel(
      docId: doc.id,
      productId: _asNum(data['productId']).toInt(),
      name: data['productName'] as String? ?? '',
      description: data['description'] as String? ?? '',
      status: data['productStatus'] as String? ?? 'inactive',
      category: (cat == null || cat.trim().isEmpty) ? null : cat.trim(),
      variants: rawVariants
          .whereType<Map>()
          .map((m) => ProductVariantModel.fromMap(Map<String, dynamic>.from(m)))
          .toList(),
    );
  }
}
