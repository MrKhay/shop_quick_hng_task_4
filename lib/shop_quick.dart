import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_quick/features/_common/notifiers/order_history_data_notifier/order_history_data_notifier.dart';
import 'features/features.dart';

///
class ShopFast extends ConsumerStatefulWidget {
  ///
  const ShopFast({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShopFastState();
}

class _ShopFastState extends ConsumerState<ShopFast> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // load products
    ref.read(productsDataNotifierProvider);

    // load orders
    ref.read(ordersDataNotifierProvider);

    // load network state
    ref.read(networkStateNotifierProvider);

    // load wishlist
    ref.read(wishListDataNotifierProvider);

    // load order history
    ref.read(orderHistoryDataNotifierProvider);
  }

  @override
  Widget build(BuildContext context) {
    List screens = [
      const HomeScreen(),
      const WishListScreen(),
      const CartScreen(),
    ];
    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: BorderDirectional(
            top: BorderSide(
              color: context.colorScheme.outline,
              width: 0.11,
            ),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(
            width: 0.05,
            color: context.colorScheme.outline,
          ))),
          child: NavigationBar(
            backgroundColor: context.colorScheme.surface,
            indicatorColor: context.colorScheme.surface,

            selectedIndex: _selectedIndex,

            onDestinationSelected: (int index) {
              setState(() {
                /// updated index
                _selectedIndex = index;
              });
            },

            // enableFloatingNavBar: false(
            destinations: <Widget>[
              NavigationDestination(
                icon: Icon(
                  Icons.home_outlined,
                  color: context.colorScheme.outline,
                ),
                selectedIcon: const Icon(Icons.home),
                label: kHome,
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.favorite_border,
                  color: context.colorScheme.outline,
                ),
                selectedIcon: const Icon(Icons.favorite),
                label: kWishlist,
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.shopping_basket_outlined,
                  color: context.colorScheme.outline,
                ),
                selectedIcon: const Icon(Icons.shopping_basket_rounded),
                label: kCart,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget underConstruction(BuildContext context) {
  return Container(
    color: context.colorScheme.surface,
    width: context.screenSize.width,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.construction,
          color: context.colorScheme.primary,
        ),
        const SizedBox(height: kGap_1),
        Text(
          kUnderConstruction,
          style: context.textTheme.titleLarge?.copyWith(
            color: context.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: kGap_3),
        OutlinedButton(
            onPressed: () async {
              /// navigate back home
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const ShopFast()),
                (Route<dynamic> route) => false,
              );
            },
            child: const Text(kGoHome))
      ],
    ),
  );
}
