import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k_store/features/authentication/screens/password_configuration/reset_password.dart';

import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';

class ForgetPasswordController extends GetxController{
  static ForgetPasswordController get instance => Get.find();

  //Variables
  final email= TextEditingController();
  GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();  //Form key for form validation
  

  //Send reset password email
  sendPasswordResetEmail() async {
    try{
         //Start loading
      MFullScreenLoader.openLoadingDialog('Processing your request...', MImages.docerAnimation);

      //Check Internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected){
        MFullScreenLoader.stopLoading();
        return;
      }

      //Form validation
      if(!forgetPasswordFormKey.currentState!.validate()){
        MFullScreenLoader.stopLoading();
        return;
      }
      
      // //Send password reset email
      await AuthenticationRepository.instance.sendPasswordresetEmail(email.text.trim());

      // //Remove loader
      MFullScreenLoader.stopLoading();

      //Show success message
      MLoaders.successSnackBar(title: 'Congratulations', message: 'Email link sent to Reset your Password');

      //Move to verify Email screen
      Get.to(() => ResetPassword(email: email.text.trim(),));
    } catch (e) {
      //Remove loader
      MFullScreenLoader.stopLoading();

      //Show some generic error to the user
      MLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

    resendPasswordResetEmail(String eamil) async {
    try{
         //Start loading
      MFullScreenLoader.openLoadingDialog('Processing your request...', MImages.docerAnimation);

      //Check Internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected){
        MFullScreenLoader.stopLoading();
        return;
      }

      //Form validation
      if(!forgetPasswordFormKey.currentState!.validate()){
        MFullScreenLoader.stopLoading();
        return;
      }
      
      // //Send password reset email
      await AuthenticationRepository.instance.sendPasswordresetEmail(email.text.trim());

      // //Remove loader
      MFullScreenLoader.stopLoading();

      //Show success message
      MLoaders.successSnackBar(title: 'Congratulations', message: 'Email link sent to Reset your Password');

    } catch (e) {
      //Remove loader
      MFullScreenLoader.stopLoading();

      //Show some generic error to the user
      MLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}