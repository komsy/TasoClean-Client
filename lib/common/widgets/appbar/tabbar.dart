import 'package:flutter/material.dart';
import 'package:k_store/utils/device/device_utility.dart';
import 'package:k_store/utils/helpers/helper_functions.dart';

import '../../../utils/constants/colors.dart';

class MTabBar extends StatelessWidget implements PreferredSizeWidget {
  const MTabBar({super.key, required this.tabs});

  final List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Material(
      color: dark ?  MColors.black : MColors.white,
      child: TabBar(
        tabs: tabs,
        isScrollable: true,
        indicatorColor: MColors.primary,
        unselectedLabelColor: MColors.darkGrey,
        labelColor: dark ? MColors.white : MColors.primary,
      ),
    );
  }
  
  @override
  
  Size get preferredSize => Size.fromHeight(MDeviceUtils.getAppBarHeight());
}