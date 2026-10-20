import 'package:get/get.dart';
import 'package:k_store/features/shop/controllers/products/cart_controller.dart';
import 'package:k_store/features/shop/controllers/products/images_controller.dart';
import 'package:k_store/features/shop/models/product_model.dart';
import 'package:k_store/features/shop/models/product_variation_model.dart';

class VariationController extends GetxController {
  static VariationController get instance=> Get.find();

  //Variables
  RxMap selectedAttributes = {}.obs;
  RxString variationStockStatus = ''.obs;
  Rx<ProductVariationModel> selectedVariation = ProductVariationModel.empty().obs;


  //Select attribute and variation
  void onAttributeSelected(ProductModel product, attributeName, attributeValue) {
    //When attribute is selected we will firstadd that attribute to the slectedAttributes
    final selectedAttributes = Map<String, dynamic>.from(this.selectedAttributes);
    selectedAttributes[attributeName] = attributeValue;
    this.selectedAttributes[attributeName] = attributeValue;

    final selectedVariation = product.productVariations!.firstWhere((variation) => 
    _isSameAttributeValues(variation.attributeValues, selectedAttributes),
    orElse: () => ProductVariationModel.empty(),
    );

    //Show the selected variation image as main Image
    if(selectedVariation.image.isNotEmpty) {
      ImagesController.instance.selectedProductImage.value = selectedVariation.image;
    }

    //Show selecte variation quantity already in the cart
    if (selectedVariation.id.isNotEmpty) { 
      final cartController = CartController.instance;
      cartController.productQuantityInCart.value = cartController.getVariationQuantityInCart(product.id, selectedVariation.id);
    }
    
    getProductVariationStockStatus();

    //Assign selected variation
    this.selectedVariation.value = selectedVariation;
  }

  //Check if slected attributes matches any variation attributes
  bool _isSameAttributeValues(Map<String, dynamic> variationAttributes, Map<String, dynamic> selectedAttributes) {
    //If selectedAttribute contains 3 attributes and current variation contains 2 then return.
    if(variationAttributes.length != selectedAttributes.length) return false;

    //If any of the attributes is different then return e.g [Green,Large] x [Green, Small]
    for (final key in variationAttributes.keys) {
      //Attributes[key] = valuewhich could be [Green, Small, Cotton] etc.
      if(variationAttributes[key] != selectedAttributes[key]) return false;
    }

    return true;
  }

  //Check Attribute availability / stock in variation
  // Set<String?> getAttributesAvailabilityInVariation(List<ProductVariationModel> variations, String attributeName) {
  //   //Pass the variations to check which attributes are available and stock is not 0
  //   final availableVariationAttributeValues = variations.where((variation) =>
  //     //Check empty / Out of stock attributes
  //     variation.attributeValues[attributeName] != null && variation.attributeValues[attributeName]!.isNotEmpty && variation.stock > 0)
  //   //Fetch all non-empty attributes of variations
  //   .map((variation) => variation.attributeValues[attributeName]).toSet();
  // }
  Set<String?> getAttributesAvailabilityInVariation(List<ProductVariationModel> variations, String attributeName) {
  // Pass the variations to check which attributes are available and stock is not 0
  final availableVariationAttributeValues = variations
    .where((variation) =>
      // Check for non-null, non-empty attributes and stock greater than 0
      variation.attributeValues[attributeName] != null && 
      variation.attributeValues[attributeName]!.isNotEmpty && 
      variation.stock > 0)
    // Fetch all non-empty attributes of variations
    .map((variation) => variation.attributeValues[attributeName])
    .toSet();

  return availableVariationAttributeValues;
}

  
  String getVariationPrice () {
    return (selectedVariation.value.salePrice > 0 ? selectedVariation.value.salePrice : selectedVariation.value.price).toString();
  }
  //Check product variation stock status
  void getProductVariationStockStatus() {
    variationStockStatus.value = selectedVariation.value.stock > 0 ? 'In Stock' : 'Out of Stock';
  }

   String getProductStockStatus(int stock) {
    return stock > 0 ? 'In Stock' : 'Out of Stock';
  }

  //Reset selected attributes when switching products
  void resetSelectedAttributes() {
    selectedAttributes.clear();
    variationStockStatus.value = '';
    selectedVariation.value = ProductVariationModel.empty();
  }
}