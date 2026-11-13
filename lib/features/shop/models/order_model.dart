import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';

DateTime? _date(dynamic v) {
  if (v is Timestamp) return v.toDate();
  if (v is String) return DateTime.tryParse(v);
  return null;
}

num _num(dynamic v) => v is num ? v : (num.tryParse('$v') ?? 0);

String _ref(String prefix, String id) => '$prefix-${id.substring(0, math.min(6, id.length)).toUpperCase()}';

// ─────────────────────────────────────────────────────────────
// Service bookings  (collection: Bookings – written by BookingRepository)
// ─────────────────────────────────────────────────────────────
class BookingLine {
  const BookingLine({required this.name, required this.quantity, required this.lineTotal});

  final String name;
  final int quantity;
  final num lineTotal;

  factory BookingLine.fromMap(Map<String, dynamic> m) => BookingLine(
        name: m['serviceName'] as String? ?? '',
        quantity: _num(m['quantity']).toInt(),
        lineTotal: _num(m['lineTotal']),
      );
}

class BookingModel {
  const BookingModel({
    required this.id,
    required this.status,
    required this.timeSlot,
    required this.lines,
    required this.servicesTotal,
    required this.amountDueNow,
    this.scheduledDate,
    this.createdAt,
  });

  final String id;
  final String status; // pending_payment | confirmed | completed | cancelled
  final DateTime? scheduledDate;
  final String timeSlot;
  final List<BookingLine> lines;
  final num servicesTotal;
  final num amountDueNow;
  final DateTime? createdAt;

  String get reference => _ref('TC', id);
  int get itemCount => lines.fold(0, (s, l) => s + l.quantity);

  factory BookingModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return BookingModel(
      id: doc.id,
      status: d['status'] as String? ?? 'pending_payment',
      scheduledDate: _date(d['scheduledDate']),
      timeSlot: d['timeSlot'] as String? ?? '',
      servicesTotal: _num(d['servicesTotal']),
      amountDueNow: _num(d['amountDueNow']),
      createdAt: _date(d['createdAt']),
      lines: ((d['services'] as List?) ?? const [])
          .whereType<Map>()
          .map((m) => BookingLine.fromMap(Map<String, dynamic>.from(m)))
          .toList(),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Product orders  (collection: ProductOrders)
//
// PROPOSED schema – product checkout isn't saving orders yet, so write
// documents in this shape when you wire it up:
//   userId, status, couponCode?, subtotal, discount, shippingFee, tax, total,
//   createdAt, items: [{productName, variantLabel, unitPrice, quantity, image}]
// ─────────────────────────────────────────────────────────────
class ProductOrderLine {
  const ProductOrderLine({
    required this.name,
    required this.variantLabel,
    required this.unitPrice,
    required this.quantity,
    required this.image,
  });

  final String name;
  final String variantLabel;
  final num unitPrice;
  final int quantity;
  final String image;

  factory ProductOrderLine.fromMap(Map<String, dynamic> m) => ProductOrderLine(
        name: m['productName'] as String? ?? '',
        variantLabel: m['variantLabel'] as String? ?? '',
        unitPrice: _num(m['unitPrice']),
        quantity: _num(m['quantity']).toInt(),
        image: m['image'] as String? ?? '',
      );
}

class ProductOrderModel {
  const ProductOrderModel({
    required this.id,
    required this.status,
    required this.items,
    required this.total,
    this.createdAt,
  });

  final String id;
  final String status; // pending | processing | shipped | delivered | cancelled
  final List<ProductOrderLine> items;
  final num total;
  final DateTime? createdAt;

  String get reference => _ref('TO', id);
  int get itemCount => items.fold(0, (s, i) => s + i.quantity);

  factory ProductOrderModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return ProductOrderModel(
      id: doc.id,
      status: d['status'] as String? ?? 'pending',
      total: _num(d['total']),
      createdAt: _date(d['createdAt']),
      items: ((d['items'] as List?) ?? const [])
          .whereType<Map>()
          .map((m) => ProductOrderLine.fromMap(Map<String, dynamic>.from(m)))
          .toList(),
    );
  }
}