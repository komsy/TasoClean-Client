import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k_store/common/widgets/texts/section_heading.dart';
import 'package:k_store/features/shop/models/payment_method_model.dart';
import 'package:k_store/features/shop/screens/checkout/widgets/payment_tile.dart';
import 'package:k_store/utils/constants/image_strings.dart';
import 'package:k_store/utils/constants/sizes.dart';

class CheckoutController extends GetxController {
  static CheckoutController get instance => Get.find();

  final Rx<PaymentMethodModel> selectedPaymentMethod = PaymentMethodModel.empty().obs;

  @override
  void onInit(){
    selectedPaymentMethod.value = PaymentMethodModel(name: 'Paypal', image: MImages.paypal);
    super.onInit();
  }

  Future<dynamic> selectPaymentMethod(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (_) => SingleChildScrollView(
        child: Container (
          padding: const EdgeInsets.all(MSizes.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MSectionHeading(title: 'Select Payment Method', showActionButton: false),
              const SizedBox(height: MSizes.spaceBtwSections),
              MPaymentTile(paymentMethod: PaymentMethodModel(image: MImages.paypal, name: 'Paypal')),
              const SizedBox(height: MSizes.spaceBtwItems / 2),
              MPaymentTile(paymentMethod: PaymentMethodModel(image: MImages.googlePay, name: 'Google Pay')),
              const SizedBox(height: MSizes.spaceBtwItems / 2),
              MPaymentTile(paymentMethod: PaymentMethodModel(image: MImages.creditCard, name: 'Credit Card')),
              const SizedBox(height: MSizes.spaceBtwItems / 2),
              const SizedBox(height: MSizes.spaceBtwSections),
            ],
          ),
          
        )
      )
    );
  }
}