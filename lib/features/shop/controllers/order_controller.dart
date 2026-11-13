import 'package:get/get.dart';
import 'package:tasoclean/data/repositories/order/order_repository.dart';
import 'package:tasoclean/features/shop/models/order_model.dart';

class OrdersController extends GetxController {
  static OrdersController get instance => Get.find();

  final _repository = Get.put(OrderRepository());

  // Services tab
  final RxList<BookingModel> bookings = <BookingModel>[].obs;
  final RxBool loadingBookings = false.obs;
  final RxnString bookingsError = RxnString();

  // Products tab
  final RxList<ProductOrderModel> productOrders = <ProductOrderModel>[].obs;
  final RxBool loadingProducts = false.obs;
  final RxnString productsError = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchBookings();
    fetchProductOrders();
  }

  Future<void> fetchBookings() async {
    try {
      loadingBookings.value = true;
      bookingsError.value = null;
      bookings.assignAll(await _repository.getServiceBookings());
    } catch (e) {
      bookingsError.value = e.toString();
    } finally {
      loadingBookings.value = false;
    }
  }

  Future<void> fetchProductOrders() async {
    try {
      loadingProducts.value = true;
      productsError.value = null;
      productOrders.assignAll(await _repository.getProductOrders());
    } catch (e) {
      productsError.value = e.toString();
    } finally {
      loadingProducts.value = false;
    }
  }
}