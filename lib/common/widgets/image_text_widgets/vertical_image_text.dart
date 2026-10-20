import 'package:flutter/material.dart';
import 'package:k_store/utils/constants/colors.dart';
import 'package:k_store/utils/helpers/helper_functions.dart';

import '../../../utils/constants/enums.dart';
import '../../../utils/constants/sizes.dart';
import '../images/m_circular_image.dart';


class MVerticalImagetext extends StatelessWidget {
  const MVerticalImagetext({
    super.key,
    required this.image,
    required this.title,
    this.textColor = MColors.white,
    this.backgroundColor,
    this.onTap,
    this.isNetworkImage=false,
  });

  final String image,title;
  final Color textColor;
  final Color? backgroundColor;
  final void Function()? onTap;
  final bool isNetworkImage;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: MSizes.spaceBtwItems),
        child: Column(
          children: [
            //Circular Icon
            Container(
              width: 56,
              height: 56,
              padding: const EdgeInsets.all(MSizes.sm),
              decoration: BoxDecoration(
                color: backgroundColor ?? (dark ? MColors.black : MColors.white),
                borderRadius: BorderRadius.circular(100)
              ),
              // return controller.imageUploading.value 
              //             ? const MShimmerEffect(width: 80, height: 80, radius: 80) 
              //             : MCircularImage(image: image , width: 80, height: 80, imageType: networkImage.isNotEmpty ? ImageType.network : ImageType.asset);
              //           }),
              child: Center(
                // child: Image(fit:BoxFit.cover,color: dark ? MColors.light : MColors.dark, image: isNetworkImage ? NetworkImage(image) : AssetImage(image) as ImageProvider) ,
                child: MCircularImage(image: image , width: 80, height: 80, imageType: isNetworkImage? ImageType.network : ImageType.asset),
                // child: Image(image: AssetImage(image), fit: BoxFit.cover,color: dark ? MColors.light : MColors.dark),
              ),
            ),
            const SizedBox(height: MSizes.spaceBtwItems / 2),
        
            //Text
            SizedBox(
              width: 55,
              child: Text(title, 
              style: Theme.of(context).textTheme.labelMedium!.apply(color:textColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              ),
            ),
        
          ],
        ),
      ),
    );
  }
}

