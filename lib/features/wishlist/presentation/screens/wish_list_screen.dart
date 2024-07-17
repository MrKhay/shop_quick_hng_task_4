import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shop_quick.dart';
import '../../../features.dart';

///
class WishListScreen extends ConsumerStatefulWidget {
  /// Shows all orders
  const WishListScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => WishListScreenState();
}

///
class WishListScreenState extends ConsumerState<WishListScreen> {
  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<Order>?> ordersState =
        ref.watch(ordersDataNotifierProvider);

    return Scaffold(
      //1
      body: CustomScrollView(
        slivers: <Widget>[
          //2
          SliverAppBar(
            pinned: true,
            snap: false,
            floating: true,
            backgroundColor: context.colorScheme.surface,
            expandedHeight: 150.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                kWishlist,
                textScaler: const TextScaler.linear(1),
                style: context.textTheme.titleMedium?.copyWith(
                    color: Colors.black, fontWeight: FontWeight.w600),
              ),
              background: Image.asset(
                Assets.cartImgPath,
                fit: BoxFit.fill,
              ),
            ),
          ),
          //3
          SliverToBoxAdapter(
            child: _body(),
          ),
        ],
      ),
    );
  }

  Widget _body() {
    final height = MediaQuery.of(context).size.height;
    //
    var wishList = ref.watch(wishListDataNotifierProvider).value ?? [];
    var products = ref.read(productsDataNotifierProvider).value?.products ?? [];
    List<Product?> wishListProducts = wishList.map((id) {
      var product = products.where(((p) => p.id == id)).firstOrNull;
      if (product == null) {
        return null;
      }
      return product;
    }).toList();

    if (wishListProducts.isEmpty) {
      return _emptyWishList(context);
    }

    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.all(kGap_2),
      child: ListView.builder(
        padding: const EdgeInsets.all(0),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (_, int index) {
          var product = wishListProducts[index]!;

          return wishListTile(context, product);
        },
        itemCount: wishListProducts.length,
      ),
    );
  }
}

Widget _emptyWishList(BuildContext context) {
  final height = MediaQuery.of(context).size.height;
  return Container(
    padding: const EdgeInsets.symmetric(vertical: kGap_1),
    height: height / 2,
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(
            Icons.heart_broken,
            size: kGap_4,
          ),
          const SizedBox(height: kGap_3),
          Text(
            kYourWishlistIsEmpty,
            style: context.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colorScheme.outline,
            ),
          ),
          const SizedBox(height: kGap_3),
        ],
      ),
    ),
  );
}

///
Widget wishListTile(BuildContext context, Product product) {
  final double width = MediaQuery.of(context).size.width;
  var navigator = Navigator.of(context);
  return Container(
    height: double.infinity,
    margin: const EdgeInsets.symmetric(vertical: kGap_2),
    width: width,
    constraints: BoxConstraints(
      minWidth: width,
      maxWidth: width,
      minHeight: width * 0.25,
      maxHeight: width * 0.27,
    ),
    child: GestureDetector(
      onTap: () async {
        await navigator.push(
          MaterialPageRoute<dynamic>(
            builder: (BuildContext _) => ProductDetailScreen(
              product: product,
            ),
          ),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // img
          Flexible(
            flex: 2,
            child: Container(
              height: double.maxFinite,
              decoration: BoxDecoration(
                color: context.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(kGap_1),
                image: product.photos != null
                    ? DecorationImage(
                        image: NetworkImage(
                          product.photos!.first,
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              product.name,
                              style: context.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: kGap_2),
                          Flexible(
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
                                const SizedBox(height: kGap_01),

                                /// Price
                                Text(
                                  r'$' +
                                      product.currentPrice.toStringAsFixed(2),
                                  style: context.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: kGap_1),

                    // remove btn
                    Flexible(child: Center(
                      child: Consumer(builder: (_, ref, child) {
                        return IconButton(
                            color: Colors.red,
                            onPressed: () async {
                              final bool? responce =
                                  await showConfirmationDialog(
                                context,
                                titleText: kRemoveProductFromWishlist,
                                actionTxtColor: context.colorScheme.onPrimary,
                                actionBtnColor: context.colorScheme.primary,
                              );
                              if (responce == null) return;

                              if (responce) {
                                ref
                                    .read(wishListDataNotifierProvider.notifier)
                                    .removeProductIdFromWishList(product.id);
                                context.showSnackBar(kRemovedFromWishlist);
                              }
                            },
                            icon: const Icon(Icons.remove));
                      }),
                    ))
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
