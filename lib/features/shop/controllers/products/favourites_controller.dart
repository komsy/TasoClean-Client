import 'dart:convert';
import 'package:get/get.dart';
import 'package:k_store/data/repositories/products/product_repository.dart';
import 'package:k_store/features/shop/models/product_model.dart';
import 'package:k_store/utils/local_storage/storage_utility.dart';
import 'package:k_store/utils/popups/loaders.dart';

class FavouritesController extends GetxController{
  static FavouritesController get instance => Get.find();
  //Variables
  final favourites = <String, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    initFavourites();
  }

  //Method to initialize favourites by reading from storage
  void initFavourites() {
    final json = MLocalStorage.instance().readData('favourites');
    if (json != null) {
      final storedFavourites = jsonDecode(json) as Map<String, dynamic>;
      favourites.assignAll(storedFavourites.map((key, value) => MapEntry(key, value as bool)));
    }
  }

  bool isFavourite(String productId) {
    return favourites[productId] ?? false;
  }

  void toggleFavouriteProduct(String productId){
    if(!favourites.containsKey(productId)){
      favourites[productId] = true;
      saveFavouritesToStorage();
      MLoaders.customToast(message: 'Product has been added to the Wishlist.');
    } else {
      MLocalStorage.instance().removeData(productId);
      favourites.remove(productId);
      saveFavouritesToStorage();
      favourites.refresh();
      MLoaders.customToast(message: 'Product has been removed from the Wishlist.');
    }
  }
  
  void saveFavouritesToStorage() {
    final encodedFavourites = json.encode(favourites);
    MLocalStorage.instance().saveData('favourites', encodedFavourites);
  }

  Future<List<ProductModel>> favouriteProducts() async {
    return await ProductRepository.instance.getFavouriteProducts(favourites.keys.toList());
  }
}