import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../features.dart';

part 'wishlist_data_notifier.g.dart';

@Riverpod(keepAlive: true)

/// Manages [Product]
class WishListDataNotifier extends _$WishListDataNotifier {
  @override
  Future<List<String>?> build() async {
    return [];
  }

  /// Add [Product] id to wishlist
  Future<void> addProductIdToWishList(String productID) async {
    // old wishlist
    var oldWishlist = state.value ?? [];

    // update state
    state = AsyncValue<List<String>?>.data([productID, ...oldWishlist]);
  }

  /// Add [Product] id to wishlist
  Future<void> removeProductIdFromWishList(String productID) async {
    // old wishlist
    var oldWishlist = state.value ?? [];
    oldWishlist.remove(productID);

    // update state
    state = AsyncValue<List<String>?>.data([...oldWishlist]);
  }
}
