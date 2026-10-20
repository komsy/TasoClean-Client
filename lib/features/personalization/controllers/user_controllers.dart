import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:k_store/data/repositories/authentication/authentication_repository.dart';
import 'package:k_store/data/repositories/user/user_repository.dart';
import 'package:k_store/features/authentication/screens/login/login.dart';
import 'package:k_store/features/personalization/views/profile/widgets/re_authenticate_user_login_form.dart';
import 'package:k_store/utils/constants/image_strings.dart';
import 'package:k_store/utils/constants/sizes.dart';
import 'package:k_store/utils/constants/text_strings.dart';
import 'package:k_store/utils/popups/full_screen_loader.dart';
import 'package:k_store/utils/popups/loaders.dart';

import '../../../utils/helpers/network_manager.dart';
import '../../authentication/models/user/user_model.dart';

class UserController extends GetxController{
  static UserController get instance => Get.find();

  final hidePassword = true.obs; //Observable for hiding/showing password
  final profileLoading = false.obs;
  final imageUploading = false.obs;
  final verifyEmail= TextEditingController();
  final verifyPassword= TextEditingController();
  Rx<UserModel> user =UserModel.empty().obs; //Observable user
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> reAuthFormKey = GlobalKey<FormState>();  //Form key for form validation
  
  @override
  void onInit() {
    super.onInit();
    fetchUserRecord();
  }

  //Fetch user record
  Future <void> fetchUserRecord() async {
    try{
      profileLoading.value = true;
      final user = await userRepository.fetchUserDetails();
      // print(user);
      this.user(user);
    } catch (e){
      user(UserModel.empty());
    } finally {
      profileLoading.value = false;
    }
  }

  //Save user record from any registration provider
  Future<void> saveUserRecord(UserCredential? userCredentials) async {
    try{
      //First update Rx User and then check if user data is already stored. If not store new data
      await fetchUserRecord();
      
      //If no record already stored
      if (user.value.id.isEmpty){
        if(userCredentials !=null){
          //Convert name to first and last names
          final nameParts = UserModel.nameParts(userCredentials.user!.displayName ?? '');
          final username = UserModel.generateUsername(userCredentials.user!.displayName ?? '');

          //Map data
          final user = UserModel(
            id: userCredentials.user!.uid, 
            firstName: nameParts[0], 
            lastName: nameParts.length > 1 ? nameParts.sublist(1).join('') : '', 
            userName: username, 
            email: userCredentials.user!.email ?? '', 
            phoneNumber: userCredentials.user!.phoneNumber ?? '', 
            profilePicture: userCredentials.user!.photoURL ?? '', 
            );
          //Save user data
          await userRepository.saveUserRecord(user);
        }
      }
    }catch(e){
      MLoaders.warningSnackBar(
        title: 'Data not saved',
        message: 'Something went wrong while saving your information. You can re-save your data in your Profile'
        );
    }
  }

  void deleteAccountWarningPopup() async {
   Get.defaultDialog(
    contentPadding: const EdgeInsets.all(MSizes.md),
    title: MTexts.deleteAccTitle,
    middleText: MTexts.deleteAccMiddletext,
    confirm: ElevatedButton(
      onPressed: () async => deleteUserAccount(), 
      style: ElevatedButton.styleFrom(backgroundColor: Colors.red, side: const BorderSide(color: Colors.red)),
      child:const Padding(padding: EdgeInsets.symmetric(horizontal: MSizes.lg), child: Text(MTexts.deleteButton))
    ),
    cancel: OutlinedButton(
      child: const Text(MTexts.deleteButtonCancel),
      onPressed: () => Navigator.of(Get.overlayContext!).pop(),
    )
   );
  }

  //Delete user Account
  void deleteUserAccount() async {
    try{
      MFullScreenLoader.openLoadingDialog('Processing...', MImages.docerAnimation);

      //First re-authenticate user
      final auth = AuthenticationRepository.instance;
      final provider = auth.authUser!.providerData.map((e) =>e.providerId).first;
      if(provider.isNotEmpty){
        //Re verify auth email
        if (provider == 'google.com'){
          await auth.signInWithGoogle();
          await auth.deleteAccount();
          MFullScreenLoader.stopLoading();
          Get.offAll(() => const LoginScreen());
        } else if (provider == 'password'){
          MFullScreenLoader.stopLoading();
          Get.to(() => const ReAuthenticateUserLoginForm());
        }
      }
    } catch (e) {
      //Remove loader
      MFullScreenLoader.stopLoading();

      //Show some generic error to the user
      MLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  //Re-Authenticate before deleting
  Future<void> reAuthenticateEmailAndPasswordUser() async {
    try{
      MFullScreenLoader.openLoadingDialog('Processing...', MImages.docerAnimation);

      //Check Internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected){
        MFullScreenLoader.stopLoading();
        return;
      }
      
      //Form validation
      if(!reAuthFormKey.currentState!.validate()){
        MFullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance.reAuthenticateEmailAndPassword(verifyEmail.text.trim(),verifyPassword.text.trim());
      await AuthenticationRepository.instance.deleteAccount();
      MFullScreenLoader.stopLoading();
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      //Remove loader
      MFullScreenLoader.stopLoading();

      //Show some generic error to the user
      MLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }


  uploadUserProfilePicture() async{
    try{
      final image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 70,maxHeight: 512,maxWidth: 512);
      if(image != null){
        imageUploading.value = true;
        //Upload image
        final imageUrl = await userRepository.uploadImage('Users/Images/Profile/',image);

        //update user image record
        Map<String, dynamic> json = {'ProfilePicture': imageUrl};
        await userRepository.updateSingleField(json);

        //update the local data with new imageUrl
        user.value.profilePicture = imageUrl;
        user.refresh();

        //Show success message
        MLoaders.successSnackBar(title: 'Congratulations', message: 'Your Profile Image has been updated.');
      }
    } catch (e) {
      //Show some generic error to the user
      MLoaders.errorSnackBar(title: 'Oh Snap!', message: 'Something went wrong: $e');
    } finally {
      imageUploading.value = false;
    }
  }
}