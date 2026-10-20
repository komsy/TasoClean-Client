import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k_store/common/widgets/custom_shapes/containers/circular_container.dart';
import 'package:k_store/common/widgets/shimmers/shimmer.dart';
import 'package:k_store/features/shop/controllers/banner_controller.dart';
import 'package:k_store/utils/constants/enums.dart';

import '../../../../../common/widgets/images/m_rounded_image.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';


class MPromoSlider extends StatelessWidget {
  const MPromoSlider({
    super.key
  });
  

  @override
  Widget build(BuildContext context) {    
    final controller = Get.put(BannerController());
    return Obx(() { 
      if(controller.isLoading.value) return const MShimmerEffect(width: double.infinity, height: 190);

      if(controller.banners.isEmpty){
        return const Center(child: Text('No Data Found!'));
      } else {
        return Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                viewportFraction: 1,
                onPageChanged: (index, _) => controller.updatePageIndicator(index)
              ),
              items: controller.banners.map((banner)=> MRoundedImage( onPressed: () => Get.toNamed(banner.targetScreen),
                width: 400,height:400,image: banner.imageUrl, imageType: ImageType.network,)).toList(),
              ),
              const SizedBox(height: MSizes.spaceBtwItems),
        
              Center(
                child: Obx(
                  () =>Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (int i = 0; i < controller.banners.length; i++)
                      MCircularContainer(
                        width: 20,
                        height: 4,
                        margin: const EdgeInsets.only(right: 10),
                        backgroundColor: controller.carouselCurrentIndex.value == i ? MColors.primary: MColors.grey,
                      ),
                    ],
                  ),
                ),
              )
          ],
        );
      }
    });
  }
}
