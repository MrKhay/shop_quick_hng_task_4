import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_quick/shop_quick.dart';

import '../../../features.dart';

class OrderHistoryDetailScreen extends ConsumerStatefulWidget {
  final List<Order?> orders;
  const OrderHistoryDetailScreen({super.key, required this.orders});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OrderHistoryDetailScreenState();
}

class _OrderHistoryDetailScreenState
    extends ConsumerState<OrderHistoryDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: appBar(context: context, title: kOrder),
      body: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: kGap_3, vertical: kGap_3),
          child: _body(widget.orders)),
    );
  }

  Widget _body(List<Order?> orders) {
    final double height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return ListView(
      children: <Widget>[
        // body
        SizedBox(
          child: orders.isEmpty
              ? _emptyCart()
              : Scrollbar(
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: orders.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Order? order = orders[index];
                      if (order != null) {
                        return _orderTile(context, order, ref);
                      }
                      return null;
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(height: kGap_1),
                  ),
                ),
        ),

        const SizedBox(height: kGap_4),

        // cart summary
        if (orders.isNotEmpty) _cartSummary(context, orders),

        const SizedBox(height: kGap_4),

        /// You might like
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              kYouMightLike,
              style: GoogleFonts.lora(
                textStyle: context.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        const Divider(),
        const SizedBox(height: kGap_0),

        ///
        SizedBox(
          width: width,
          child: _productYouMightLikeGrid(context),
        ),
      ],
    );
  }

  Widget _emptyCart() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SvgPicture.asset(
            Assets.cartSvgPath,
            semanticsLabel: 'My SVG Image',
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
            padding: const EdgeInsets.symmetric(
                horizontal: kGap_3, vertical: kGap_2),
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
}

Widget _productYouMightLikeGrid(BuildContext context) {
  return Consumer(builder: (context, ref, child) {
    var products =
        ref.read(productsDataNotifierProvider).value?.youMightLike ?? [];
    return GridView.builder(
      shrinkWrap: true,
      itemCount: products.length,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: kGap_3,
        mainAxisSpacing: 0,
        mainAxisExtent: context.screenSize.width * 0.65,
      ),
      itemBuilder: (_, int index) {
        final Product product = products[index];
        return productCard(product, context);
      },
    );
  });
}

Widget _cartSummary(BuildContext context, List<Order?> orders) {
  var navigator = Navigator.of(context);
  var deliveryCost = orders.length * 0.5;
  // sum up price of all products
  final double totalPrice = orders.totalPrice();
  final String price = r'$' + totalPrice.toStringAsFixed(2);
  return AnimatedContainer(
    duration: const Duration(milliseconds: 250),
    padding: const EdgeInsets.all(kGap_2),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(kGap_1),
      border: Border.all(color: context.colorScheme.primary),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// Cart sumary
        Text(
          kCartSummary,
          style: GoogleFonts.lora(
            textStyle: context.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: kGap_2),

        // prices
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kGap_4),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    kSubTotal,
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: context.colorScheme.outline,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    price,
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: context.colorScheme.outline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: kGap_2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    kDelivery,
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: context.colorScheme.outline,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    r'$' + deliveryCost.toString(),
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: context.colorScheme.outline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: kGap_2),
        const Divider(),
        const SizedBox(height: kGap_2),

        // check out
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Spacer(),
            // price
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Total amount
                Text(
                  kTotalSpent,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.outline,
                  ),
                ),
                const SizedBox(height: kGap_0),

                /// Price
                Text(
                  price,
                  style: context.textTheme.titleLarge?.copyWith(
                    color: context.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ],
    ),
  );
}

///
Widget _orderTile(BuildContext context, Order order, WidgetRef ref) {
  final double width = MediaQuery.of(context).size.width;
  final double totalPrice = order.product.currentPrice * order.quantity;

  return Container(
    height: double.infinity,
    margin: const EdgeInsets.only(bottom: kGap_2),
    width: width,
    constraints: BoxConstraints(
      minWidth: width,
      maxWidth: width,
      minHeight: width * 0.25,
      maxHeight: width * 0.32,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // img
        Flexible(
          flex: 2,
          child: Container(
            height: double.maxFinite,
            decoration: BoxDecoration(
              color: context.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(kGap_1),
              image: order.product.photos != null
                  ? DecorationImage(
                      image: NetworkImage(
                        order.product.photos!.first,
                      ),
                      fit: BoxFit.fill,
                    )
                  : null,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // id
                            Text(
                              order.id,
                              style: context.textTheme.bodySmall?.copyWith(
                                color: context.colorScheme.onSurface,
                                letterSpacing: kGap_01,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            const SizedBox(height: kGap_1),

                            /// name
                            Text(
                              order.product.name,
                              style: context.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: kGap_2),
                      Flexible(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // id
                              Text(
                                kUnitePrice,
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: context.colorScheme.outline,
                                  letterSpacing: kGap_01,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              const SizedBox(height: kGap_1),

                              /// Price
                              Text(
                                r'$' + totalPrice.toStringAsFixed(2),
                                style: context.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: kGap_1),
                  // Quantity
                  Flexible(
                    child: Row(
                      children: [
                        // qty
                        Text(
                          kQty,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.outline,
                            letterSpacing: kGap_01,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: kGap_0),
                        Text(
                          order.quantity.toString(),
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.outline,
                            letterSpacing: kGap_01,
                            fontWeight: FontWeight.w600,
                          ),
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
  );
}
