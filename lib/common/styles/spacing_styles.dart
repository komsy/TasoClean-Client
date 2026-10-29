import 'package:flutter/material.dart';
import 'package:tasoclean/utils/constants/sizes.dart';

class TSpacingStyle {
  static const EdgeInsetsGeometry paddingWithAppBarHeight = EdgeInsets.only(
    top: MSizes.appBarHeight / 2,
    left: MSizes.defaultSpace,
    bottom: MSizes.defaultSpace,
    right: MSizes.defaultSpace,
  );
}
