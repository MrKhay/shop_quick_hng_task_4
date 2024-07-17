import 'package:shop_quick/features/features.dart';

extension OrderHistoryExtension on OrderHistory {
  List<Order?> toOrderList(List<Product> products) {
    var orders = productList.map((p) {
      var product = products.where((v) => v.id == p.id).firstOrNull;

      if (product != null) {
        return Order(
            id: product.id.split('').takeRange(5).join(),
            product: product,
            quantity: p.quantity,
            time: created);
      }
    }).toList();

    return orders;
  }
}
