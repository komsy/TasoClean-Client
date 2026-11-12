import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasoclean/common/widgets/appbar/appbar.dart';
import 'package:tasoclean/common/widgets/custom_shapes/containers/primary_header_containers.dart';
import 'package:tasoclean/features/shop/controllers/service_controller.dart';
import 'package:tasoclean/features/shop/screens/services/widgets/service_list.dart';
import 'package:tasoclean/features/shop/screens/services/widgets/services_card.dart';
import 'package:tasoclean/utils/constants/colors.dart';
import 'package:tasoclean/utils/constants/sizes.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ServiceController.instance;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            MPrimaryHeaderContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MAppBar(
                    title: Text('Our Services', style: Theme.of(context).textTheme.headlineSmall!.apply(color: MColors.white)),
                    showBackArrow: false,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: MSizes.defaultSpace),
                    child: Text(
                      'Pick a service and book a trusted pro.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: MColors.white),
                    ),
                  ),
                  const SizedBox(height: MSizes.spaceBtwSections),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: MSizes.defaultSpace / 1.5),
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Padding(
                    padding: EdgeInsets.all(MSizes.spaceBtwSections),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (controller.errorMessage.value != null) {
                  return Padding(
                    padding: const EdgeInsets.all(MSizes.defaultSpace),
                    child: Column(
                      children: [
                        Text(controller.errorMessage.value!, textAlign: TextAlign.center),
                        const SizedBox(height: 12),
                        TextButton(onPressed: controller.fetchServices, child: const Text('Retry')),
                      ],
                    ),
                  );
                }

                if (controller.categories.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(MSizes.spaceBtwSections),
                    child: Center(child: Text('No services available yet.')),
                  );
                }

                return Column(
                  children: [
                    for (var i = 0; i < controller.categories.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: MSizes.defaultSpace/2),
                        child: MServiceCard(
                          category: controller.categories[i],
                          onTap: () => Get.to(
                            () => BookServiceScreen(
                              categories: controller.categories.toList(),
                              initialCategory: i,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: MSizes.spaceBtwSections),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}