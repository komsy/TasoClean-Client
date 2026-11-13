import 'package:flutter/material.dart';
import 'package:tasoclean/common/widgets/custom_shapes/containers/primary_header_containers.dart';
import 'package:tasoclean/common/widgets/texts/section_heading.dart';
import 'package:tasoclean/features/shop/screens/home/widgets/home_appbar.dart';
import 'package:tasoclean/features/shop/screens/home/widgets/home_promotional_sections.dart';
import 'package:tasoclean/utils/constants/image_strings.dart';

import '../../../../utils/constants/sizes.dart';
import 'widgets/home_categories.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            MPrimaryHeaderContainer(
              child: Column(
                children: [
                  const MHomeAppBar(),
                  const SizedBox(height: MSizes.spaceBtwItems),

                  //SearchBar
                  // const MSearchContainer(text: "Search for Services..."),
                  // const SizedBox(height: MSizes.spaceBtwItems),

                  //Services
                  Padding(
                    padding: const EdgeInsets.only(left: MSizes.defaultSpace),
                    child: Column(
                      children: [
                        //Heading
                        MSectionHeading(
                          title: 'Popular Services',
                          textColor: Colors.white,
                          showActionButton: false,
                          onPressed: () {},
                        ),
                        const SizedBox(height: MSizes.spaceBtwItems),

                        //Services
                        const MHomeCategories(),
                      ],
                    ),
                  ),
                  const SizedBox(height: MSizes.spaceBtwSections),
                ],
              ),
            ),

            //Body
            Transform.translate(
              offset: const Offset(
                0,
                -25,
              ), // Shift content 10 pixels upward
              child: Padding(
                padding: const EdgeInsets.all(MSizes.defaultSpace),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const MBookNowCard(
                      title: 'Book a Service',
                      description:
                          'Get trusted professionals at your doorstep.',
                      buttonText: 'Book Now',
                      image: MImages.productImage34,
                    ),
                    const SizedBox(height: MSizes.defaultSpace / 1.5),
                    MHomeSpecialOffers(
                      offers: const [
                        MSpecialOffer(
                          title: 'Deep Home Cleaning',
                          subtitle: 'From KES 4,500',
                          buttonText: 'Book Now',
                          image: MImages.productImage34,
                        ),
                        MSpecialOffer(
                          title: 'Kitchen Cleaning',
                          subtitle: 'From KES 2,500',
                          buttonText: 'Book Now',
                          image: MImages.productImage36,
                        ),
                        MSpecialOffer(
                          title: 'Bedroom Cleaning',
                          subtitle: 'From KES 3,000',
                          buttonText: 'Book Now',
                          image: MImages.productImage32,
                        ),
                      ],
                    ),
                    const SizedBox(height: MSizes.defaultSpace / 2),
                    const MWhyChooseUs(),
                    const SizedBox(height: MSizes.spaceBtwSections / 2),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
