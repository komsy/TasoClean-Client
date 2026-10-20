import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:k_store/utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';

class MRoundedImage1 extends StatelessWidget {
  const MRoundedImage1({
    super.key,
    this.width,
    this.height,
    required this.imageUrl,
    this.applyImageradius=true,
    this.border,
    this.backgroundColor=MColors.light,
    this.fit=BoxFit.contain,
    this.padding,
    this.onPressed,
    this.isNetworkImage=false,
    this.borderRadius=MSizes.md,
  });

  final double? width,height;
  final String imageUrl;
  final bool applyImageradius;
  final BoxBorder? border;
  final Color backgroundColor;
  final BoxFit? fit;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onPressed;
  final bool isNetworkImage;
  final double borderRadius;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(border:border, color: backgroundColor,borderRadius: BorderRadius.circular(borderRadius)),
        child: ClipRRect(
          borderRadius:applyImageradius ?  BorderRadius.circular(borderRadius) : BorderRadius.zero,
          child: Image(fit: fit,image: isNetworkImage ? NetworkImage(imageUrl) : AssetImage(imageUrl) as ImageProvider) ,
          ),
      ),
    );
  }
}

