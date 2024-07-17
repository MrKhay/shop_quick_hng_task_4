// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

class ProductHistory {
  /// [Product] id
  final String id;

  /// quantity
  final int quantity;
  ProductHistory({
    required this.id,
    required this.quantity,
  });

  ProductHistory copyWith({
    String? id,
    int? quantity,
  }) {
    return ProductHistory(
      id: id ?? this.id,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'quantity': quantity,
    };
  }

  factory ProductHistory.fromMap(Map<String, dynamic> map) {
    return ProductHistory(
      id: map['id'] as String,
      quantity: map['quantity'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductHistory.fromJson(String source) =>
      ProductHistory.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ProductHistory(id: $id, quantity: $quantity)';

  @override
  bool operator ==(covariant ProductHistory other) {
    if (identical(this, other)) return true;

    return other.id == id && other.quantity == quantity;
  }

  @override
  int get hashCode => id.hashCode ^ quantity.hashCode;
}
