import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasoclean/common/widgets/appbar/step_header.dart';
import 'package:tasoclean/features/shop/controllers/service_controller.dart';
import 'package:tasoclean/features/shop/models/service_model.dart';
import 'package:tasoclean/features/shop/screens/service_checkout/checkout.dart';
import 'package:tasoclean/features/shop/screens/services/widgets/category_strip.dart';
import 'package:tasoclean/features/shop/screens/services/widgets/service_bottom_bar.dart';
import 'package:tasoclean/features/shop/screens/services/widgets/service_header.dart';
import 'package:tasoclean/features/shop/screens/services/widgets/service_item_tile.dart';
import 'package:tasoclean/utils/constants/colors.dart';
import 'package:tasoclean/utils/constants/sizes.dart';
import 'package:tasoclean/utils/helpers/helper_functions.dart';

// ─────────────────────────────────────────────────────────────
// Local palette – swap these for MColors equivalents if you have them
// ─────────────────────────────────────────────────────────────
const primary = Color(0xFF4A78D0); // header
const dark = Color(0xFF1B1B1D); // body background
const darkCard = Color(0xFF2A2A2D); // unselected category chip
const darkBar = Color(0xFF232325); // bottom bar

/// Firestore has no icon field, so pick one from the category name.
IconData serviceCategoryIcon(String name) {
  final n = name.toLowerCase();
  if (n.contains('laundry')) return Icons.local_laundry_service_outlined;
  if (n.contains('construction')) return Icons.construction;
  if (n.contains('pest')) return Icons.bug_report_outlined;
  if (n.contains('deep')) return Icons.weekend_outlined;
  return Icons.cleaning_services_outlined;
}


// ─────────────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────────────
class BookServiceScreen extends StatefulWidget {
  const BookServiceScreen({
    super.key,
    required this.categories,
    this.initialCategory = 0,
    this.location = 'Utawala, Nairobi',
    this.step = 2,
  });

  /// All active categories (each holds its own `services` array).
  final List<ServiceCategoryModel> categories;

  /// Index of the category whose card was tapped.
  final int initialCategory;

  final String location;
  final int step; // 1..3 progress segments filled

  @override
  State<BookServiceScreen> createState() => _BookServiceScreenState();
}

class _BookServiceScreenState extends State<BookServiceScreen> {
  final controller = ServiceController.instance;
  late int _selected;

  @override
  void initState() {
    super.initState();
    final last = widget.categories.length - 1;
    _selected = widget.initialCategory < 0
        ? 0
        : (widget.initialCategory > last ? last : widget.initialCategory);
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      backgroundColor: primary,
      body: Column(
        children: [
          const MStepHeader(
            title: 'Book a service',
            subtitle: Text('utawala, Nairobi'),
            currentStep: 2,
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: dark ? MColors.black : MColors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(MSizes.spaceBtwSections)),
              ),
              child: widget.categories.isEmpty
                  ? Center(
                      child: Text('No services available',
                          style: TextStyle(color: dark ? MColors.white : MColors.black)))
                  : Obx(() {
                      final category = widget.categories[_selected];
                      final services = category.activeServices;

                      return Column(
                        children: [
                          const SizedBox(height: MSizes.spaceBtwItems),
                          MCategoryStrip(
                            dark: dark,
                            categories: widget.categories,
                            selected: _selected,
                            badgeFor: controller.badgeFor,
                            onSelect: (i) => setState(() => _selected = i),
                          ),
                          Expanded(
                            child: ListView(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 20, 20, 24),
                              children: [
                                Text(
                                  category.categoryName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: dark ? MColors.white : MColors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                const SizedBox(height: MSizes.defaultSpace / 2),
                                if (services.isEmpty)
                                  Text('No active services in this category.',
                                      style: TextStyle( color: dark ? MColors.white : MColors.black
                                              .withValues(alpha: 0.7))),
                                for (final service in services)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: MSizes.spaceBtwItems/2),
                                    child: MServiceItemTile(
                                      dark: dark,
                                      service: service,
                                      quantity: controller.quantityOf(
                                          category, service),
                                      onAdd: () => controller.increment(
                                          category, service),
                                      onRemove: () => controller.decrement(
                                          category, service),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          MServiceBottomBar(
                            dark: dark,
                            items: controller.itemCount,
                            services: controller.serviceCount,
                            total: controller.total,
                            onNext: controller.itemCount == 0 ? null : () => Get.to(() => const ScheduleAndPayScreen()),
                          ),
                        ],
                      );
                    }),
            ),
          ),
        ],
      ),
    );
  }
}
