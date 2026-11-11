import 'dart:developer';

import 'package:get/get.dart';
import 'package:tasoclean/data/repositories/services/service_repository.dart';
import 'package:tasoclean/features/shop/models/service_model.dart';
class ServiceController extends GetxController {
  static ServiceController get instance => Get.find();

  final _repository = Get.put(ServiceRepository());

  // Data + UI state
  final RxList<ServiceCategoryModel> categories = <ServiceCategoryModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();
  final RxInt selectedCategoryIndex = 0.obs;

  // Cart: service id -> quantity.
  // Service ids are only unique within a category, so the key is "<docId>_<id>".
  final RxMap<String, int> quantities = <String, int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchServices();
  }

  Future<void> fetchServices() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      final result = await _repository.getServiceCategories();
      log('Fetched ${result.length} service categories');
      categories.assignAll(result);
      log('fetched Categories ${categories.length}');
      if (selectedCategoryIndex.value >= categories.length) {
        selectedCategoryIndex.value = 0;
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // ── Selection ──────────────────────────────────────────────
  ServiceCategoryModel? get selectedCategory =>
      categories.isEmpty ? null : categories[selectedCategoryIndex.value];

  void selectCategory(int index) => selectedCategoryIndex.value = index;

  // ── Cart ───────────────────────────────────────────────────
  String _key(ServiceCategoryModel c, ServiceModel s) => '${c.docId}_${s.id}';

  int quantityOf(ServiceCategoryModel c, ServiceModel s) => quantities[_key(c, s)] ?? 0;

  void increment(ServiceCategoryModel c, ServiceModel s) {
    final k = _key(c, s);
    quantities[k] = (quantities[k] ?? 0) + 1;
  }

  void decrement(ServiceCategoryModel c, ServiceModel s) {
    final k = _key(c, s);
    final next = (quantities[k] ?? 0) - 1;
    if (next <= 0) {
      quantities.remove(k);
    } else {
      quantities[k] = next;
    }
  }

  /// Number of distinct services picked in a category (the red badge).
  int badgeFor(ServiceCategoryModel c) =>
      c.activeServices.where((s) => quantityOf(c, s) > 0).length;

  int get itemCount => quantities.values.fold(0, (a, b) => a + b);
  int get serviceCount => quantities.length;

  num get total {
    num sum = 0;
    for (final c in categories) {
      for (final s in c.activeServices) {
        sum += s.amount * quantityOf(c, s);
      }
    }
    return sum;
  }

  void clearCart() => quantities.clear();
}