import 'package:get/get.dart';
import 'package:k_store/data/repositories/banners/banner_repository.dart';
import 'package:k_store/utils/popups/loaders.dart';

import '../../../data/repositories/user/user_repository.dart';
import '../models/banner_model.dart';
import 'package:image_picker/image_picker.dart';

class BannerController extends GetxController {
  static BannerController get instance => Get.find();

  //Variables
  final carouselCurrentIndex = 0.obs;
  final imageUploading = false.obs;
  final isLoading = false.obs;
  RxList<BannerModel> banners = <BannerModel>[].obs;
  final userRepository = UserRepository.instance;
  final bannerRepository = Get.put(BannerRepository());


  @override
  void onInit() {
    fetchBanners();
    super.onInit();
  }
  //Update Page Navigation Dots
  void updatePageIndicator(index) => carouselCurrentIndex.value = index;

  //Fetch Banners
  Future<void> fetchBanners() async {
    try{
      //Show loader while loading banners
      isLoading.value = true;

      //Fetch Banners from data source(Firestore, API, etc)
      final bannerRepo = Get.put(BannerRepository());
      final banners = await bannerRepo.fetchBanners();
      
      //Assign banners
      this.banners.assignAll(banners);

    }catch (e) {
      MLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }finally{
      //Remove Loader
      isLoading.value = false;
    }
  }

  uploadUserBannerPicture() async{
    try{
      final image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 70,maxHeight: 512,maxWidth: 512);
      if(image != null){
        imageUploading.value = true;
        //Upload image
        final imageUrl = await userRepository.uploadImage('Banners/Images/',image);

        //update user image record
        Map<String, dynamic> json = {'ImageUrl': imageUrl};
        await bannerRepository.updateSingleField(json);

        //update the local data with new imageUrl
        // this.banners.value.imageUrl = imageUrl;
        // this.banners.refresh();

        //Show success message
        MLoaders.successSnackBar(title: 'Congratulations', message: 'Your Banner Image has been updated.');
      }
    } catch (e) {
      //Show some generic error to the user
      MLoaders.errorSnackBar(title: 'Oh Snap!', message: 'Something went wrong: $e');
    } finally {
      imageUploading.value = false;
    }
  }

}