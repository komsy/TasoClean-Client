import 'package:get/get.dart';
import 'package:k_store/features/personalization/controllers/address_controller.dart';
import 'package:k_store/features/shop/controllers/products/variation_controller.dart';
import 'package:k_store/utils/helpers/network_manager.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(NetworkManager());
    Get.put(VariationController());
    Get.put(AddressController());
  }
}