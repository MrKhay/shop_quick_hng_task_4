import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../features.dart';

part 'order_history_data.g.dart';

/// Manages [OrderHistory]
@Riverpod(keepAlive: true)
class OrderHistoryDataNotifier extends _$OrderHistoryDataNotifier {
  late OrderHistoryRepository orderHistoryRepository;
  late SharedPreferences preferences;
  @override
  Future<List<OrderHistory>?> build() async {
    preferences = await SharedPreferences.getInstance();
    orderHistoryRepository = OrderHistoryRepository(preferences: preferences);

    var orderHistory = orderHistoryRepository.getHistory();
    return orderHistory;
  }

  /// add new order history
  void addNewOrder(List<Order> orders) {
    List<OrderHistory> oldRrderHistroy = state.value ?? <OrderHistory>[];

    // update state
    state = AsyncValue<List<OrderHistory>>.data(
        <OrderHistory>[OrderHistory.fromOrderList(orders), ...oldRrderHistroy]);

    // update local storage
    orderHistoryRepository.addHistory(OrderHistory.fromOrderList(orders));
  }

  /// remove  order history
  void removeNewOrder(OrderHistory order) {
    List<OrderHistory> oldOrderHistory = state.value ?? <OrderHistory>[];
    oldOrderHistory.remove(order);

    // update state
    state =
        AsyncValue<List<OrderHistory>>.data(<OrderHistory>[...oldOrderHistory]);

    // update local storage
    orderHistoryRepository.removeHistory(order);
  }

  /// clear orders
  void clearOrders() {
    // update state
    // state = const AsyncValue<List<Order>>.data(<Order>[]);
  }
}
