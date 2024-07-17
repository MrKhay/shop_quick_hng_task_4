import '../../features.dart';

extension ListExtension on List {
  /// Returns only [range] items from list
  ///
  /// If list is less than that returns list
  List<T> takeRange<T>(int range) {
    if (length < range) {
      return this as List<T>;
    }

    return getRange(0, range).toList() as List<T>;
  }

  /// Returns only [range] items from list
  ///
  /// If list is less than that returns list
  double totalPrice<T extends Order>() {
    if (isEmpty) {
      return 0;
    }

    var totalPrice = (this as List<Order?>)
        .map((order) =>
            (order?.product.currentPrice ?? 0) * (order?.quantity ?? 0))
        .reduce((total, price) => total + price);

    return totalPrice;
  }
}
