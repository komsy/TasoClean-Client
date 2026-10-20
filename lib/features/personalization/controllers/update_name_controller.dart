import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k_store/data/repositories/user/user_repository.dart';
import 'package:k_store/features/personalization/controllers/user_controllers.dart';
import 'package:k_store/features/personalization/views/profile/profile.dart';
import 'package:k_store/utils/popups/loaders.dart';

import '../../../utils/constants/image_strings.dart';
import '../../../utils/helpers/network_manager.dart';
import '../../../utils/popups/full_screen_loader.dart';

class UpdateNameController extends GetxController{
  static UpdateNameController get instance => Get.find();

    //Variables
  final firstName= TextEditingController();
  final lastName= TextEditingController();
  final userController = UserController.instance; //create instance of the user controller
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> updateUserNameFormKey = GlobalKey<FormState>();  //Form key for form validation
  


  @override
  void onInit() {
    initializeNames();
    super.onInit();
  }

  //Fetch user record and show on the fields
  Future <void> initializeNames() async {
    firstName.text = userController.user.value.firstName;
    lastName.text = userController.user.value.lastName;
  }

  Future<void> updateUserName() async {
    try {
      //Start loading
      MFullScreenLoader.openLoadingDialog('We are updating your information...', MImages.docerAnimation);

      //Check Internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected){
        MFullScreenLoader.stopLoading();
        return;
      }

      //Form validation
      if(!updateUserNameFormKey.currentState!.validate()){
        MFullScreenLoader.stopLoading();
        return;
      }
      
      //Update user's first & last name in the firebase firestore
      Map<String, dynamic> name = {'Firstname': firstName.text.trim(),'Lastname': lastName.text.trim()};
      await userRepository.updateSingleField(name);

      //Update the Rx user value
      userController.user.value.firstName = firstName.text.trim();
      userController.user.value.lastName = lastName.text.trim();

      //Remove loader
      MFullScreenLoader.stopLoading();

      //Show success message
      MLoaders.successSnackBar(title: 'Congratulations', message: 'Your Name has been updated.');

      //Move to previous screen
      Get.off(() => const ProfileScreen());
    } catch (e) {
      //Remove loader
      MFullScreenLoader.stopLoading();

      //Show some generic error to the user
      MLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}