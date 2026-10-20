import 'package:get/get.dart';
import 'package:k_store/utils/constants/enums.dart';
import 'package:k_store/utils/popups/loaders.dart';

import '../../../../data/repositories/products/product_repository.dart';
import '../../models/product_model.dart';

class ProductController extends GetxController {
  static ProductController get instance => Get.find();

  //Variables
  final isLoading = false.obs;
  final productRepository = Get.put(ProductRepository());
  RxList<ProductModel> featuredProducts = <ProductModel>[].obs;
//  RxList<ProductModel> featuredProducts = <ProductModel>[
//   ProductModel(
//     id:'001',
//     categoryId: '1',
//     description: 'Green Nike Sports Shoes',
//     productAttributes: [
//       ProductAttributeModel(
//         name: 'Color',
//         values: ['Green', 'Blue'],
//       ),
//       ProductAttributeModel(
//         name: 'Size',
//         values: ['40', '41'],
//       ),
//     ],
//     images: [
//       'https://firebasestorage.googleapis.com/v0/b/ecommerceapp-e6287.appspot.com/o/Banners%2FImages%2Fscaled_user2.png?alt=media&token=4e0b37a6-a237-4e69-82ec-02f2c11dc7f6',
//       'https://firebasestorage.googleapis.com/v0/b/ecommerceapp-e6287.appspot.com/o/Banners%2FImages%2Fscaled_user3.png?alt=media&token=ae175fcb-078d-4e07-8d45-1f50f4b80728',
//     ],
//     productType: 'ProductType.variable',
//     title: 'Green Nike Sports Shoes',
//     thumbnail: 'https://firebasestorage.googleapis.com/v0/b/ecommerceapp-e6287.appspot.com/o/Banners%2FImages%2Fscaled_user3.png?alt=media&token=ae175fcb-078d-4e07-8d45-1f50f4b80728',
//     isFeatured: true,
//     brand: BrandModel(
//       id: '1',
//       image: 'assets/icons/brands/nike.png',
//       productCount: 12,
//       isFeatured: true,
//       name: 'Nike',
//     ),
//     productVariations: [
//       ProductVariationModel(
//         id:'01',
//         description: 'Testing',
//         price: 1500,
//         salePrice: 1200,
//         sku: 'A1',
//         attributeValues: {
//           'Size': '40',
//           'Color': 'Green',
//         },
//         image: 'https://firebasestorage.googleapis.com/v0/b/ecommerceapp-e6287.appspot.com/o/Banners%2FImages%2Fscaled_user3.png?alt=media&token=ae175fcb-078d-4e07-8d45-1f50f4b80728',
//         stock: 15,
//       ),
//       ProductVariationModel(
//         id:'02',
//         description: 'Test',
//         price: 1400,
//         salePrice: 1200,
//         sku: 'A2',
//         attributeValues: {
//           'Size': '41',
//           'Color': 'Blue',
//         },
//         image: 'https://firebasestorage.googleapis.com/v0/b/ecommerceapp-e6287.appspot.com/o/Banners%2FImages%2Fscaled_user2.png?alt=media&token=4e0b37a6-a237-4e69-82ec-02f2c11dc7f6',
//         stock: 5,
//       ),
//     ],
//     price: 1500,
//     salePrice: 1000,
//     sku: 'A001',
//     stock: 20,
//   ),
// ].obs;


  @override
  void onInit() {
    fetchFeaturedProducts();
    super.onInit();
  }

  //Fetch products
  Future<void> fetchFeaturedProducts() async {
    try{
      //Show loader while loading products
      isLoading.value = true;

      //Fetch products from data source(Firestore, API, etc)
      final products = await productRepository.getFeaturedProducts();
      // print(products);
      //Assign products
      featuredProducts.assignAll(products);

    }catch (e) {
      MLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }finally{
      //Remove Loader
      isLoading.value = false;
    }
  }

  //Fetch products
  Future<List<ProductModel>> fetchAllFeaturedProducts() async {
    try{
      //Fetch All products from data source(Firestore, API, etc)
      final products = await productRepository.getAllFeaturedProducts();
      return products;
    }catch (e) {
      MLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    }
  }


  // //Get the product price or price range for variations
  // String getProductPrice (ProductModel product) {
  //   double smallestPrice = double.infinity;
  //   double largestPrice= 0.0;
  //
  //   //If no variations exists, return the simple price or sale price
  //   if(product.productType == ProductType.single.toString()) {
  //     return (product.salePrice > 0 ? product.salePrice : product.price).toString();
  //   } else {
  //     if (product.productVariations != null) {
  //       //Calculate the smallest and largest among variations
  //       for (var variation in product.productVariations!) {
  //         //Determine the price to consider (Sale price if available, otherwise regular price)
  //         double priceToConsinder = variation.salePrice > 0.0 ? variation
  //             .salePrice : variation.price;
  //
  //         //Update smallest and largest prices
  //         if (priceToConsinder < smallestPrice) {
  //           smallestPrice = priceToConsinder;
  //         }
  //         if (priceToConsinder > largestPrice) {
  //           largestPrice = priceToConsinder;
  //         }
  //       }
  //     }
  //     //If smallest and largest prices a re the same, retun a single price
  //     if(smallestPrice.isEqual(largestPrice)){
  //       return largestPrice.toString();
  //     } else {
  //       //Otherwise, return a price range
  //       return '$smallestPrice - \$$largestPrice';
  //     }
  //   }
  // }
  
  // Get the product price or price range for variations
  String getProductPrice(ProductModel product) {
    double smallestPrice = double.infinity;
    double largestPrice = 0.0;

    // If no variations exist, return the simple price or sale price
    if (product.productType == ProductType.single.toString()) {
      return (product.salePrice > 0 ? product.salePrice : product.price).toString();
    } else {
      if (product.productVariations != null && product.productVariations!.isNotEmpty) {
        // Calculate the smallest and largest prices among variations
        for (var variation in product.productVariations!) {
          // Determine the price to consider (Sale price if available, otherwise regular price)
          double priceToConsider = variation.salePrice > 0.0 ? variation.salePrice : variation.price;

          // Update smallest and largest prices
          if (priceToConsider < smallestPrice) {
            smallestPrice = priceToConsider;
          }
          if (priceToConsider > largestPrice) {
            largestPrice = priceToConsider;
          }
        }
      } else {
        // Return the base price if no variations exist
        return (product.salePrice > 0 ? product.salePrice : product.price).toString();
      }

      // If smallest and largest prices are approximately the same, return a single price
      if ((smallestPrice - largestPrice).abs() < 0.01) {
        return '\$$largestPrice';  // Return single price
      } else {
        // Otherwise, return a price range
        return '\$$smallestPrice - \$$largestPrice';
      }
    }
  }


  //Calculate discount percentage
  String? calaculateSalePercentage(double originalPrice, double? salePrice) {
    if(salePrice == null || salePrice <= 0.0) return null;
    if(originalPrice <= 0) return null;

    double percentage = ((originalPrice - salePrice) / originalPrice) * 100;
    return percentage.toStringAsFixed(0);
  }

  //Check product stock status
  String getProductStockStatus(int stock) {
    return stock > 0 ? 'In Stock' : 'Out of Stock';
  }
}