// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../../../features.dart';

@immutable

/// [Product] order details
class OrderHistory {
  /// unique id
  final String id;

  /// time order was placed
  final DateTime created;

  /// [ProductHistory] list
  final List<ProductHistory> productList;

  ///
  const OrderHistory({
    required this.id,
    required this.created,
    required this.productList,
  });

  OrderHistory copyWith({
    String? id,
    DateTime? time,
    List<ProductHistory>? productList,
  }) {
    return OrderHistory(
      id: id ?? this.id,
      created: time ?? created,
      productList: productList ?? this.productList,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'created': created.millisecondsSinceEpoch,
      'productList': productList.map((x) => x.toMap()).toList(),
    };
  }

  factory OrderHistory.fromMap(Map<String, dynamic> map) {
    return OrderHistory(
      id: map['id'] as String,
      created: DateTime.fromMillisecondsSinceEpoch(map['created'] as int),
      productList: List<ProductHistory>.from(
        (map['productList'] as dynamic).map<ProductHistory>(
          (x) => ProductHistory.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderHistory.fromJson(String source) =>
      OrderHistory.fromMap(json.decode(source) as Map<String, dynamic>);

  factory OrderHistory.fromOrderList(List<Order> orders) {
    final int randInt = Random().nextInt(1000);
    final String id = 'RS34$randInt';
    return OrderHistory(
      id: id,
      productList: orders
          .map((o) => ProductHistory(id: o.product.id, quantity: o.quantity))
          .toList(),
      created: DateTime.now(),
    );
  }

  @override
  String toString() =>
      'OrderHistory(id: $id, created: $created, productList: $productList)';

  @override
  bool operator ==(covariant OrderHistory other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.created == created &&
        listEquals(other.productList, productList);
  }

  @override
  int get hashCode => id.hashCode ^ created.hashCode ^ productList.hashCode;
}
