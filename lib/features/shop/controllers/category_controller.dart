import 'package:get/get.dart';
import 'package:k_store/data/repositories/categories/category_repository.dart';
import 'package:k_store/data/repositories/products/product_repository.dart';
import 'package:k_store/features/shop/models/category_model.dart';
import 'package:k_store/features/shop/models/product_model.dart';
import 'package:k_store/utils/popups/loaders.dart';

class CategoryController extends GetxController {
  static CategoryController get instance => Get.find();

  final isLoading = false.obs;
  final _categoryRepository = Get.put(CategoryRepository());
  RxList<CategoryModel> allCategories = <CategoryModel>[].obs;
  RxList<CategoryModel> featuredCategories = <CategoryModel>[].obs;

  @override
  void onInit() {
    fetchCategories();
    super.onInit();
  }

//Load category data
Future<void> fetchCategories() async {
  try{
    //Show loader while loading categories
    isLoading.value = true;

    //Fetch Categories from data source(Firestore, API, etc)
    final categories = await _categoryRepository.getAllCategories();

    //Update the categories list
    allCategories.assignAll(categories);
      // print(allCategories);

    //filter featured categories
    featuredCategories.assignAll(allCategories.where((category) => category.isFeatured && category.parentId.isEmpty).take(8).toList());
      // print(featuredCategories);

  }catch (e) {
    MLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
  }finally{
    //Remove Loader
    isLoading.value = false;
  }
}

//Load selected category data
Future<List<CategoryModel>> getSubCategories(String categoryId) async {
  try{
    final subCategories = await _categoryRepository.getSubCategories(categoryId);
    return subCategories;
  }catch (e) {
    MLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    return [];
  }
}

//Get category or sub-category products.
  Future<List<ProductModel>> getCategoryroducts({required String categoryId, int limit=4}) async {
    try {
      // Fetch limited (4) products against each subcategory
      final products = await ProductRepository.instance.getProductsForCategory(categoryId:categoryId,limit:limit);
      return products;
    } catch (e) {
      MLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    } 
  }

}