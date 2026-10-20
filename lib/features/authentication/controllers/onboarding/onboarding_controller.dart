import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:k_store/features/authentication/screens/login/login.dart';

class OnBoardingController extends GetxController {
  static OnBoardingController get instance => Get.find();
  //variables
  final pageController = PageController();
  Rx<int> currentPageIndex = 0.obs;

  //Update current index when page scroll
  void updatepageIndiator(index) => currentPageIndex.value = index;

  //jump to the specific dot slected page
  void dotNavigationClick(index) {
    currentPageIndex.value = index;
    pageController.jumpTo(index);
  }

  //update current index & jump to next page
  void nextPage() {
    if(currentPageIndex.value == 2){

      //Update user opening the app first time to false
      final storage =GetStorage();
      storage.write('isFirstTime', false);
      
      Get.offAll(const LoginScreen());
    } else {
      int page = currentPageIndex.value + 1;
      pageController.jumpToPage(page);
    }
  }

  //update current index & jump to next page
  void skipPage() {
    currentPageIndex.value = 2;
    pageController.jumpToPage(2);
  }


}