import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shop_quick/features/_common/extensions/order_history_extension.dart';
import 'package:shop_quick/features/_common/notifiers/order_history_data_notifier/order_history_data_notifier.dart';
import '../../../../shop_quick.dart';
import '../../../features.dart';

///
class OrderHistoryScreen extends ConsumerStatefulWidget {
  /// [Product] screen displays all products
  const OrderHistoryScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      OrderHistoryScreenState();
}

///
class OrderHistoryScreenState extends ConsumerState<OrderHistoryScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        context: context,
        title: kkOrderHistory,
        elevation: 0,
        backgroundColor: context.colorScheme.surface,
      ),
      backgroundColor: context.colorScheme.surface,
      body: Padding(
        padding:
            const EdgeInsets.only(left: kGap_3, right: kGap_3, top: kGap_2),
        child: _body(),
      ),
    );
  }

  Widget _body() {
    final orderHistory =
        ref.watch(orderHistoryDataNotifierProvider).value ?? [];

    // when empty
    if (orderHistory.isEmpty) {
      return _emptyOrderHistory(context);
    }

    return ListView.builder(
      itemBuilder: (context, index) {
        return orderHistoryTile(context, orderHistory[index], ref);
      },
      itemCount: orderHistory.length,
    );
  }
}

Widget _emptyOrderHistory(BuildContext context) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SvgPicture.asset(
          Assets.cartSvgPath,
          semanticsLabel: 'SVG Image',
        ),
        const SizedBox(height: kGap_3),
        Text(
          kYourOrderHistoryIsEmpty,
          style: context.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: kGap_1),
        Text(
          kYourCartIsEmptyInfo,
          textAlign: TextAlign.center,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.outline,
          ),
        ),
        const SizedBox(height: kGap_3),
        MaterialButton(
          elevation: 0,
          padding:
              const EdgeInsets.symmetric(horizontal: kGap_3, vertical: kGap_2),
          color: context.colorScheme.primary,
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(kGap_2)),
          onPressed: () => {
            /// navigate back home
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const ShopFast()),
              (Route<dynamic> route) => false,
            )
          },
          child: Text(
            kStartShopping,
            style: context.textTheme.bodyLarge?.copyWith(
              color: context.colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        )
      ],
    ),
  );
}

///
Widget orderHistoryTile(
    BuildContext context, OrderHistory orderHistory, WidgetRef ref) {
  final double width = MediaQuery.of(context).size.width;
  final products = ref.read(productsDataNotifierProvider).value?.products ?? [];
  final orders = orderHistory.toOrderList(products);
  var navigator = Navigator.of(context);
  // sum up price of all products
  final double totalPrice = orders.totalPrice();
  final String price = r'$' + totalPrice.toStringAsFixed(2);
  return GestureDetector(
    onTap: () {
      navigator.push(MaterialPageRoute(
        builder: (context) => OrderHistoryDetailScreen(orders: orders),
      ));
    },
    child: Container(
      height: double.infinity,
      margin: const EdgeInsets.only(bottom: kGap_2),
      width: width,
      constraints: BoxConstraints(
        minWidth: width,
        maxWidth: width,
        minHeight: width * 0.25,
        maxHeight: width * 0.28,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // img
          Flexible(
            flex: 2,
            child: Container(
              height: double.maxFinite,
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: context.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(kGap_1),
              ),
              child: Icon(
                Icons.shopping_basket,
                size: kGap_4,
                color: context.colorScheme.outline,
              ),
            ),
          ),
          const SizedBox(width: kGap_2),
          // details
          Flexible(
            flex: 4,
            child: SizedBox(
              width: double.maxFinite,
              child: Padding(
                padding: const EdgeInsets.all(kGap_1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // id
                              Text(
                                orderHistory.id,
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: context.colorScheme.onSurface,
                                  letterSpacing: kGap_01,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),

                              const SizedBox(height: kGap_1),

                              /// Price
                              Text(
                                orders.length < 2
                                    ? '${orders.length} Item'
                                    : '${orders.length} Items',
                                style: context.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: kGap_2),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // unit
                              Text(
                                kTotalPrice,
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: context.colorScheme.outline,
                                  letterSpacing: kGap_01,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              const SizedBox(height: kGap_1),

                              /// Price
                              Text(
                                price,
                                style: context.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: kGap_1),
                    // Quantity
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// date
                          Text(
                            orderHistory.created.formatCurrentDateTime(),
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.colorScheme.onSurface,
                              letterSpacing: kGap_01,
                              fontWeight: FontWeight.w300,
                            ),
                          ),

                          /// remove btn
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(kGap_2),
                            ),
                            child: IconButton(
                                onPressed: () async {
                                  final bool? responce =
                                      await showConfirmationDialog(
                                    context,
                                    titleText: kDeleteOrderHistoryInfo,
                                    actionTxtColor:
                                        context.colorScheme.onPrimary,
                                    actionBtnColor: context.colorScheme.primary,
                                  );
                                  if (responce == null) return;

                                  if (responce) {
                                    ref
                                        .read(orderHistoryDataNotifierProvider
                                            .notifier)
                                        .removeNewOrder(orderHistory);
                                  }
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: context.colorScheme.error,
                                )),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
