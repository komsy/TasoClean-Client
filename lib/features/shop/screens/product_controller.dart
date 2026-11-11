import 'package:get/get.dart';
import 'package:tasoclean/features/shop/screens/product_model.dart';
import 'package:tasoclean/features/shop/screens/product_repository.dart';

class ProductsController extends GetxController {
  static ProductsController get instance => Get.find();

  final _repository = Get.put(ProductRepository());

  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();

  final RxString query = ''.obs;
  final RxString selectedCategory = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;
      products.assignAll(await _repository.getActiveProducts());

      // Reset the filter if the chosen category no longer exists.
      if (!categories.contains(selectedCategory.value)) selectedCategory.value = 'All';
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// "All" plus every category found on the products (empty if none have one).
  List<String> get categories {
    final seen = <String>{};
    for (final p in products) {
      final c = p.category;
      if (c != null && c.isNotEmpty) seen.add(c);
    }
    return ['All', ...seen];
  }

  /// Products after the search box and category chip are applied.
  List<ProductModel> get filtered {
    final q = query.value.trim().toLowerCase();
    final cat = selectedCategory.value;

    return products.where((p) {
      final matchesCategory = cat == 'All' || p.category == cat;
      final matchesQuery = q.isEmpty || p.name.toLowerCase().contains(q);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  void selectCategory(String c) => selectedCategory.value = c;

  /// Featured products first, then the rest. Handy for the booking-success
  /// "You might also like" row.
  List<ProductModel> suggestions({int limit = 4}) {
    final featured = products.where((p) => p.isFeatured).toList();
    final rest = products.where((p) => !p.isFeatured).toList();
    return [...featured, ...rest].take(limit).toList();
  }
}
