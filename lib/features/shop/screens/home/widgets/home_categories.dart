import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasoclean/common/widgets/shimmers/category_shimmer.dart';
import 'package:tasoclean/features/shop/controllers/service_controller.dart';
import 'package:tasoclean/features/shop/screens/services/widgets/service_list.dart';
import '../../../../../common/widgets/image_text_widgets/vertical_image_text.dart';

class MHomeCategories extends StatelessWidget {
  const MHomeCategories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.put(ServiceController());

    return Obx(() {
      if (categoryController.isLoading.value) {
        return const MCategoryShimmerEffect();
      }

      if (categoryController.categories.isEmpty) {
        return Center(
            child: Text('No Data Found!',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .apply(color: Colors.white)));
      }
      return SizedBox(
        height: 80,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: categoryController.categories.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, index) {
            final category = categoryController.categories[index];

            return MVerticalImagetext(
              isNetworkImage: true,
              image: 'Null',
              title: category.categoryName,
              onTap: () =>
                Get.to(
                  () => BookServiceScreen(
                    categories: categoryController.categories.toList(),
                    initialCategory: index,
                  ),
                ),
            );
          },
        ),
      );
    });
  }
}
