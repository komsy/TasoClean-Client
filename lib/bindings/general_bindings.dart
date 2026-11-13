import 'package:get/get.dart';
import 'package:tasoclean/features/personalization/controllers/address_controller.dart';
import 'package:tasoclean/utils/helpers/network_manager.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(NetworkManager());
    Get.put(AddressController());
  }
}
