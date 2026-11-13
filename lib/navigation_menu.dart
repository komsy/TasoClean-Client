import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tasoclean/features/personalization/views/settings/settings.dart';
import 'package:tasoclean/features/shop/screens/home/home.dart';
import 'package:tasoclean/features/shop/screens/order/widgets/order.dart';
import 'package:tasoclean/features/shop/screens/services/services.dart';
import 'package:tasoclean/features/shop/screens/store/store_screen.dart';
import 'package:tasoclean/utils/constants/colors.dart';
import 'package:tasoclean/utils/helpers/helper_functions.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final darkmode =THelperFunctions.isDarkMode(context);
    
    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
            height: 80,
            elevation: 0,
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: (index) => controller.selectedIndex.value =index,
            backgroundColor: darkmode ? MColors.black: Colors.white,
            indicatorColor: darkmode ? MColors.white.withValues(alpha: 0.1): MColors.black.withValues(alpha: 0.1),

            destinations: const  [
              NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
              NavigationDestination(icon: Icon(Iconsax.gallery), label: 'Services'),
              NavigationDestination(icon: Icon(Iconsax.shop), label: 'Store'),
              NavigationDestination(icon: Icon(Iconsax.document), label: 'Orders'),
              NavigationDestination(icon: Icon(Iconsax.user), label: 'Profile'),
            ],
          ),
      ),
      body: Obx(() =>controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex =0.obs;

  final screens= [
    const HomeScreen() ,
    const ServicesScreen(),
    const StoreScreen(),
    const OrdersScreen(),
    const SettingsScreen()];
}