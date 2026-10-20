import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k_store/common/widgets/success_screen/success_screen.dart';
import 'package:k_store/data/repositories/authentication/authentication_repository.dart';
import 'package:k_store/data/repositories/order/order_repository.dart';
import 'package:k_store/features/personalization/controllers/address_controller.dart';
import 'package:k_store/features/shop/controllers/products/cart_controller.dart';
import 'package:k_store/features/shop/controllers/products/checkout_controller.dart';
import 'package:k_store/features/shop/models/order_model.dart';
import 'package:k_store/navigation_menu.dart';
import 'package:k_store/utils/constants/enums.dart';
import 'package:k_store/utils/constants/image_strings.dart';
import 'package:k_store/utils/popups/full_screen_loader.dart';
import 'package:k_store/utils/popups/loaders.dart';

class OrderController extends GetxController {
  static OrderController get instance => Get.find();

  //Variables
  final cartController = CartController.instance;
  final addressController = AddressController.instance;
  final checkoutController = Get.put(CheckoutController());
  final orderRepository = Get.put(OrderRepository());

  //Fetch user's order history
  Future<List<OrderModel>> fetchUserOrders() async {
    try{
      final userOrders = await orderRepository.fetchUserOrders();
      return userOrders;
    } catch (e) {
      MLoaders.warningSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    }
  }

  //Add methods for order processing
  void processOrder(double totalAmount) async{
    try{
      //Start Loader
      MFullScreenLoader.openLoadingDialog('Processing your order', MImages.pencilAnimation);

      //Get user Auth Id
      final userId = AuthenticationRepository.instance.authUser!.uid;
      if (userId.isEmpty) return;

      //Add Details
      final order = OrderModel (
        //Generate a unique ID for the order
        id: UniqueKey().toString(), 
        userId: userId,
        status: OrderStatus.pending,
        totalAmount: totalAmount,
        orderDate: DateTime.now(),
        paymentMethod: checkoutController.selectedPaymentMethod.value.name,
        address: addressController.selectedAddress.value,
        deliveryDate: DateTime.now(), //Set date as needed
        items: cartController.cartItems.toList(),
      );

      //Save the order to Firestore
      await orderRepository.saveOrder(order, userId);

      //Update the cart Status
      cartController.clearCart();

      //Show success screen
      Get.off(() => SuccessScreen(
          image: MImages.successfulPaymentIcon,
          title: 'Payment Success!',
          subtitle: 'Your item will be shipped soon!',
          onPressed: () => Get.offAll(() => const NavigationMenu()),
        )); 
    } catch (e) { 
      MLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}