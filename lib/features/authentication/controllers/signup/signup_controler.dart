import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k_store/data/repositories/authentication/authentication_repository.dart';
import 'package:k_store/data/repositories/user/user_repository.dart';
import 'package:k_store/features/authentication/screens/sigup/verify_email.dart';
import 'package:k_store/utils/constants/image_strings.dart';
import 'package:k_store/utils/helpers/network_manager.dart';
import 'package:k_store/utils/popups/full_screen_loader.dart';
import 'package:k_store/utils/popups/loaders.dart';

import '../../models/user/user_model.dart';

class SignupController extends GetxController{
  static SignupController get instance =>Get.find();

  //Variables
  final hidePassword = true.obs; //Observable for hiding/showing password
  final privacyPolicy = true.obs; //Observable for privacy policy acceptance
  final email= TextEditingController();
  final firstName= TextEditingController();
  final lastName= TextEditingController();
  final userName= TextEditingController();
  final password= TextEditingController();
  final phoneNumber= TextEditingController();
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();  //Form key for form validation


  //Sigup
  Future <void> signup() async {
    try {
      //Start loading
      MFullScreenLoader.openLoadingDialog('We are processing your information...', MImages.docerAnimation);

      //Check Internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected){
        MFullScreenLoader.stopLoading();
        return;
      }

      //Form validation
      if(!signupFormKey.currentState!.validate()){
        MFullScreenLoader.stopLoading();
        return;
      }
      
      //Privacy Policy Check
      if(!privacyPolicy.value){
        MLoaders.warningSnackBar(
          title: 'Accept Privacy Policy',
          message: 'In order to create account, you must have to read and accept the Privacy Policy & Terms of Use'
        );
        MFullScreenLoader.stopLoading();
        return;
      }

      //Register User in the Firebase Authentication & save user data in the Firebase
      final userCredential = await AuthenticationRepository.instance.registerWithEmailAndPassword(email.text.trim(), password.text.trim());

      //Save Authenticated user data in the firebase firestore
      final newUser = UserModel(
        id: userCredential.user!.uid,
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        userName: userName.text.trim(),
        email: email.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        profilePicture: '',
      );
      
      final userRepository = Get.put(UserRepository());
      await userRepository.saveUserRecord(newUser);

      //Remove loader
      MFullScreenLoader.stopLoading();

      //Show success message
      MLoaders.successSnackBar(title: 'Congratulations', message: 'Your account has been created! Verify email to continue.');

      //Move to verify Email screen
      Get.to(() => VerifyEmailScreen(email: email.text.trim(),));
    } catch (e) {
      //Remove loader
      MFullScreenLoader.stopLoading();

      //Show some generic error to the user
      MLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

}