import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../features.dart';

///
class HomeScreen extends ConsumerStatefulWidget {
  /// [Product] screen displays all products
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ProductsScreenState();
}

///
class ProductsScreenState extends ConsumerState<HomeScreen> {
  String _selectedCategory = 'all';

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
    var navigator = Navigator.of(context);
    final AsyncValue<ProductsDataType?> productsState =
        ref.watch(productsDataNotifierProvider);

    final ProductsDataNotifier productsNotifier =
        ref.read(productsDataNotifierProvider.notifier);
    return Scaffold(
      appBar: appBar(
          context: context,
          title: kAppName,
          elevation: 0,
          backgroundColor: context.colorScheme.surface,
          style: GoogleFonts.redressed(
            textStyle: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: context.colorScheme.primary,
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  navigator.push(MaterialPageRoute(
                    builder: (context) => const OrderHistoryScreen(),
                  ));
                },
                icon: const Icon(
                  Icons.shopping_bag,
                ))
          ]),
      backgroundColor: context.colorScheme.surface,
      body: Padding(
        padding:
            const EdgeInsets.only(left: kGap_3, right: kGap_3, top: kGap_2),
        child: productsState.maybeWhen(
          orElse: () => NetworkStateWrapper(child: _loading()),
          loading: () => NetworkStateWrapper(child: _loading()),
          error: (Object error, StackTrace stackTrace) => NetworkStateWrapper(
            child: errorWidget(
              context: context,
              errorMsg: error.toString(),
              retry: productsNotifier.getProducts,
            ),
          ),
          data: (ProductsDataType? data) {
            if (data == null) {
              return errorWidget(
                context: context,
                retry: productsNotifier.getProducts,
              );
            }

            return _body(data);
          },
        ),
      ),
    );
  }

  Widget _loading() {
    return Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          width: context.textTheme.titleLarge?.fontSize,
          height: context.textTheme.titleLarge?.fontSize,
          child: const CircularProgressIndicator.adaptive(),
        ),
        const SizedBox(height: kGap_2),
        Text(
          kFetchingProducts,
          style: context.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colorScheme.outline,
          ),
        ),
      ],
    ));
  }

  Widget _body(ProductsDataType data) {
    final double width = MediaQuery.of(context).size.width;
    return ListView(
      children: <Widget>[
        ///
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              kWelcome,
              style: context.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w400),
            ),
          ],
        ),
        const SizedBox(height: kGap_2),

        // search container
        _searchContainer(),
        const SizedBox(height: kGap_2),

        _catergoriesContainer(data.products.getCategories(), _selectedCategory),

        const SizedBox(height: kGap_2),

        /// Products
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              kProducts,
              style: GoogleFonts.lora(
                textStyle: context.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        const Divider(),

        /// Deals grid
        SizedBox(
          width: width,
          child: _productDealGrid(
              data.products.filterByCategory(_selectedCategory)),
        ),
        const SizedBox(height: kGap_4),
      ],
    );
  }

  Widget _catergoriesContainer(
      List<String> categories, String selectedCategory) {
    return Container(
      width: context.screenSize.width,
      height: context.screenSize.height * 0.13,
      constraints: BoxConstraints(
        maxWidth: context.screenSize.width,
        minWidth: context.screenSize.width,
        maxHeight: context.screenSize.width * 0.13,
        minHeight: context.screenSize.width * 0.01,
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: categories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          final String category = categories[index];
          final bool isSelected = category == selectedCategory;
          return GestureDetector(
            onTap: () {
              // update selected category
              setState(() {
                _selectedCategory = category;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              alignment: Alignment.center,
              height: double.infinity,
              margin: const EdgeInsets.all(kGap_1),
              padding: const EdgeInsets.symmetric(
                  horizontal: kGap_2, vertical: kGap_1),
              decoration: BoxDecoration(
                color: isSelected
                    ? context.colorScheme.inverseSurface
                    : context.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(kGap_0),
              ),
              child: Text(
                category,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : null,
                  color: isSelected
                      ? context.colorScheme.onInverseSurface
                      : context.colorScheme.onSurface,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _searchContainer() {
    return GestureDetector(
      onTap: () {
        showSearch(
          context: context,
          delegate: ProductListSearchDelegate(),
        );
      },
      child: Container(
        width: context.screenSize.width,
        padding:
            const EdgeInsets.symmetric(horizontal: kGap_1, vertical: kGap_1),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kGap_1),
            border: Border.all(
              color: context.colorScheme.outlineVariant,
            )),
        child: Row(
          children: [
            Icon(Icons.search, color: context.colorScheme.outline),
            const SizedBox(width: kGap_0),
            Text(
              kSearch,
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _productDealGrid(List<Product> products) {
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
  }
}

///
Widget productCard(Product product, BuildContext context) {
  final NavigatorState navigator = Navigator.of(context);
  final double width = MediaQuery.of(context).size.width;
  return AnimatedContainer(
    duration: const Duration(milliseconds: 300),
    clipBehavior: Clip.hardEdge,
    margin: const EdgeInsets.symmetric(vertical: kGap_2),
    height: width * 0.7,
    width: width * 0.4,
    decoration: const BoxDecoration(),
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
      child: Column(
        children: <Widget>[
          Flexible(
              child: Hero(
            tag: product.heroTag,
            child: Container(
              decoration: product.photos != null
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(kGap_1),
                      image: DecorationImage(
                        image: NetworkImage(product.photos!.first),
                        fit: BoxFit.fill,
                      ),
                    )
                  : null,
            ),
          )),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: kGap_1),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      /// Name
                      Text(
                        product.name,
                        maxLines: 2,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.colorScheme.outline,
                        ),
                      ),
                      const SizedBox(height: kGap_0),

                      /// Pricet
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            r'$' + product.currentPrice.toStringAsFixed(2),
                            style: context.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: context.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: kGap_2),
                Flexible(
                    flex: 2,
                    child: FittedBox(child: _addToCartBtn(context, product)))
              ],
            ),
          )
        ],
      ),
    ),
  );
}

Widget _addToCartBtn(BuildContext context, Product product) {
  final int randInt = Random().nextInt(1000);
  return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding:
            const EdgeInsets.symmetric(horizontal: kGap_1, vertical: kGap_1),
        shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(kGap_1)),
      ),
      onPressed: () {
        final String id = '$randInt Order';

        final Order order = Order(
          id: id,
          product: product,
          quantity: 1,
          time: DateTime.now(),
        );

        ref.read(ordersDataNotifierProvider.notifier).addNewOrder(order);

        // show snackbar
        context.showSnackBar(
          kOrderAdded,
          type: SnackBarType.success,
        );
      },
      child: Text(
        kAddToCart,
        style: context.textTheme.bodyMedium?.copyWith(
          color: context.colorScheme.primary,
        ),
      ),
    );
  });
}
