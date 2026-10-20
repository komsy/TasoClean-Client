import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:k_store/data/repositories/authentication/authentication_repository.dart';
import 'package:k_store/features/personalization/controllers/user_controllers.dart';
import 'package:k_store/utils/constants/image_strings.dart';
import 'package:k_store/utils/helpers/network_manager.dart';
import 'package:k_store/utils/popups/full_screen_loader.dart';
import 'package:k_store/utils/popups/loaders.dart';


class LoginController extends GetxController{
  static LoginController get instance =>Get.find();

  //Variables
  final localStorage = GetStorage();
  final hidePassword = true.obs; //Observable for hiding/showing password
  final rememberMe = false.obs; //Observable for privacy policy acceptance
  final email= TextEditingController();
  final password= TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();  //Form key for form validation
  final userController = Get.put(UserController()); //create instance of the user controller

  @override
  void onInit() {
    email.text = localStorage.read('REMEMBER_ME_EMAIL') ?? "";
    password.text = localStorage.read('REMEMBER_ME_PASSWORD') ?? "";
    super.onInit();
  }

  //Sigup
  Future <void> emailAndPasswordSignin() async {
    try {
      //Start loading
      MFullScreenLoader.openLoadingDialog('Logging you in...', MImages.docerAnimation);

      //Check Internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected){
        MFullScreenLoader.stopLoading();
        return;
      }

      //Form validation
      if(!loginFormKey.currentState!.validate()){
        MFullScreenLoader.stopLoading();
        return;
      }
      
      //Save data if remember me is selected
      if(rememberMe.value){
        localStorage.write('REMEMBER_ME_EMAIL',email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD',password.text.trim());
      }

      //Login User in the Firebase Authentication & save user data in the Firebase
      await AuthenticationRepository.instance.loginWithEmailAndPassword(email.text.trim(), password.text.trim());

      //Remove loader
      MFullScreenLoader.stopLoading();

      //Show success message
      //MLoaders.successSnackBar(title: 'Congratulations', message: 'Your account has been created! Verify email to continue.');

      //redirect
      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      //Remove loader
      MFullScreenLoader.stopLoading();

      //Show some generic error to the user
      MLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  Future <void> googleSignin() async{
    try{
      //Start loading
      MFullScreenLoader.openLoadingDialog('Logging you in...', MImages.docerAnimation);

      //Check Internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected){
        MFullScreenLoader.stopLoading();
        return;
      }

      //Google authentication
      final userCredentials = await AuthenticationRepository.instance.signInWithGoogle();

      //Save user record
      await userController.saveUserRecord(userCredentials);

      //Remove loader
      MFullScreenLoader.stopLoading();
      
      //redirect
      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      //Remove loader
      MFullScreenLoader.stopLoading();

      //Show some generic error to the user
      MLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }

  }
}