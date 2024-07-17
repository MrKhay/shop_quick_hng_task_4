// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_quick/features/_common/common.dart';

///
class OrderHistoryRepository {
  final SharedPreferences preferences;

  ///
  OrderHistoryRepository({
    required this.preferences,
  });

  /// add [OrderHistory]
  void addHistory(OrderHistory orderHistory) {
    var orderHistoryList = getHistory();

    // update list
    orderHistoryList = [orderHistory, ...orderHistoryList];
    // map
    var value = orderHistoryList.map((v) => v.toJson()).toList();

    // OrderHistory to its json representation
    preferences.setStringList(kOrderHistoryPreference, value);
  }

  /// remove [OrderHistory]
  void removeHistory(OrderHistory orderHistory) {
    var orderHistoryList = getHistory();

    // update list
    orderHistoryList.remove(orderHistory);

    // map
    var value = orderHistoryList.map((v) => v.toJson()).toList();

    // OrderHistory to its json representation
    preferences.setStringList(kOrderHistoryPreference, value);
  }

  /// Return's list of [OrderHistory]
  List<OrderHistory> getHistory() {
    var value = preferences.getStringList(kOrderHistoryPreference);

    // when null
    if (value == null) return [];

    //
    return value.map((v) => OrderHistory.fromJson(v)).toList();
  }
}
