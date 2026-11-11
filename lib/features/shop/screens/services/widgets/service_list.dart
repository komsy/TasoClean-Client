import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasoclean/features/shop/controllers/service_controller.dart';
import 'package:tasoclean/features/shop/models/service_model.dart';
import 'package:tasoclean/features/shop/screens/service_checkout/checkout.dart';
import 'package:tasoclean/features/shop/screens/services/widgets/category_strip.dart';
import 'package:tasoclean/features/shop/screens/services/widgets/service_bottom_bar.dart';
import 'package:tasoclean/features/shop/screens/services/widgets/service_header.dart';
import 'package:tasoclean/features/shop/screens/services/widgets/service_item_tile.dart';
import 'package:tasoclean/utils/constants/colors.dart';

// ─────────────────────────────────────────────────────────────
// Local palette – swap these for MColors equivalents if you have them
// ─────────────────────────────────────────────────────────────
const primary = Color(0xFF4A78D0); // header
const dark = Color(0xFF1B1B1D); // body background
const darkCard = Color(0xFF2A2A2D); // unselected category chip
const darkBar = Color(0xFF232325); // bottom bar
const _kStepperIdle = Color(0xFFE9C98F); // minus button (peach, darker)
const _kPeachBorder = Color(0xFFE5484D); // selected outline

/// Firestore has no icon field, so pick one from the category name.
IconData serviceCategoryIcon(String name) {
  final n = name.toLowerCase();
  if (n.contains('laundry')) return Icons.local_laundry_service_outlined;
  if (n.contains('construction')) return Icons.construction;
  if (n.contains('pest')) return Icons.bug_report_outlined;
  if (n.contains('deep')) return Icons.weekend_outlined;
  return Icons.cleaning_services_outlined;
}

String _kes(num v) {
  final fixed = v % 1 == 0 ? v.toInt().toString() : v.toStringAsFixed(2);
  final parts = fixed.split('.');
  final whole =
      parts[0].replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');
  return 'KES ${parts.length > 1 ? '$whole.${parts[1]}' : whole}';
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
    this.step = 1,
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
    return Scaffold(
      backgroundColor: primary,
      body: Column(
        children: [
          MServiceHeader(location: widget.location, step: widget.step),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: dark,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: widget.categories.isEmpty
                  ? const Center(
                      child: Text('No services available',
                          style: TextStyle(color: MColors.white)))
                  : Obx(() {
                      final category = widget.categories[_selected];
                      final services = category.activeServices;

                      return Column(
                        children: [
                          const SizedBox(height: 20),
                          MCategoryStrip(
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
                                        color: MColors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                const SizedBox(height: 12),
                                if (services.isEmpty)
                                  Text('No active services in this category.',
                                      style: TextStyle(
                                          color: MColors.white
                                              .withValues(alpha: 0.7))),
                                for (final service in services)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: MServiceItemTile(
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
