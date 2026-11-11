import 'package:get/get.dart';
import 'package:tasoclean/features/shop/screens/product_model.dart';

class CartItem {
  const CartItem({
    required this.productDocId,
    required this.productName,
    required this.variantName,
    required this.variantLabel,
    required this.price,
    required this.image,
    required this.quantity,
  });

  final String productDocId;
  final String productName;
  final String variantName;
  final String variantLabel; // "1 Liter"
  final num price;
  final String image;
  final int quantity;

  String get key => CartsController.keyOf(productDocId, variantName);

  num get lineTotal => price * quantity;

  CartItem copyWith({int? quantity}) => CartItem(
        productDocId: productDocId,
        productName: productName,
        variantName: variantName,
        variantLabel: variantLabel,
        price: price,
        image: image,
        quantity: quantity ?? this.quantity,
      );
}

/// In-memory cart (cleared when the app restarts).
class CartsController extends GetxController {
  /// Safe to call from any screen – registers the cart on first use.
  static CartsController get instance =>
      Get.isRegistered<CartsController>() ? Get.find<CartsController>() : Get.put(CartsController(), permanent: true);

  static const int maxPerItem = 99;

  static String keyOf(String productDocId, String variantName) => '$productDocId|$variantName';

  final RxMap<String, CartItem> _items = <String, CartItem>{}.obs;

  List<CartItem> get items => _items.values.toList();
  bool get isEmpty => _items.isEmpty;

  /// Total units – the number shown on the cart badge.
  int get count => _items.values.fold(0, (sum, i) => sum + i.quantity);

  num get total => _items.values.fold<num>(0, (sum, i) => sum + i.lineTotal);

  int quantityOf(ProductModel product, ProductVariantModel variant) =>
      _items[keyOf(product.docId, variant.name)]?.quantity ?? 0;

  void add(ProductModel product, ProductVariantModel variant, {int quantity = 1}) {
    final k = keyOf(product.docId, variant.name);
    final existing = _items[k];

    if (existing != null) {
      _items[k] = existing.copyWith(quantity: (existing.quantity + quantity).clamp(1, maxPerItem));
    } else {
      _items[k] = CartItem(
        productDocId: product.docId,
        productName: product.name,
        variantName: variant.name,
        variantLabel: variant.label,
        price: variant.price,
        image: variant.image.isNotEmpty ? variant.image : product.imageUrl,
        quantity: quantity.clamp(1, maxPerItem),
      );
    }
  }

  void increment(String key) {
    final item = _items[key];
    if (item == null) return;
    _items[key] = item.copyWith(quantity: (item.quantity + 1).clamp(1, maxPerItem));
  }

  void decrement(String key) {
    final item = _items[key];
    if (item == null) return;
    if (item.quantity <= 1) {
      _items.remove(key);
    } else {
      _items[key] = item.copyWith(quantity: item.quantity - 1);
    }
  }

  void remove(String key) => _items.remove(key);

  void clear() => _items.clear();
}
