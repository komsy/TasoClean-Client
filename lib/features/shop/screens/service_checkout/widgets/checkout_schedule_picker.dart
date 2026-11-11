import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasoclean/features/shop/controllers/checkout_controller.dart';
import 'package:tasoclean/features/shop/screens/service_checkout/widgets/checkout_colors.dart';
import 'package:tasoclean/utils/constants/colors.dart';

class CheckoutSchedulePicker extends StatelessWidget {
  const CheckoutSchedulePicker({super.key, required this.controller});

  final CheckoutController controller;

  void _open(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: checkoutBar,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => _ScheduleSheet(controller: controller),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _open(context),
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: checkoutPeachLine, width: 1.6),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_month_outlined,
                color: MColors.white, size: 22),
            const SizedBox(width: 6),
            // const Icon(Icons.schedule, color: MColors.white, size: 22),
            // const SizedBox(width: 12),
            Expanded(
              child: Obx(
                () => Text(
                  controller.whenLabel,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: MColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: MColors.white),
          ],
        ),
      ),
    );
  }
}

class _ScheduleSheet extends StatelessWidget {
  const _ScheduleSheet({required this.controller});

  final CheckoutController controller;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
        child: Obx(() {
          final selected = controller.selectedDate.value;
          final selectedSlot = controller.slotIndex.value;

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: MColors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Pick a day',
                style: textTheme.titleSmall?.copyWith(
                  color: MColors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 78,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.availableDays.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, index) {
                    final date = controller.availableDays[index];
                    final isSelected = date == selected;
                    return GestureDetector(
                      onTap: () => controller.selectedDate.value = date,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: 58,
                        decoration: BoxDecoration(
                          color: isSelected ? MColors.peach : checkoutDarkCard,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              CheckoutController.weekday(date),
                              style: textTheme.labelSmall?.copyWith(
                                color: isSelected
                                    ? MColors.black
                                    : MColors.white.withValues(alpha: 0.7),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${date.day}',
                              style: textTheme.titleMedium?.copyWith(
                                color:
                                    isSelected ? MColors.black : MColors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              CheckoutController.month(date),
                              style: textTheme.labelSmall?.copyWith(
                                color: isSelected
                                    ? MColors.black
                                    : MColors.white.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Pick a time',
                style: textTheme.titleSmall?.copyWith(
                  color: MColors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (var index = 0;
                      index < CheckoutController.slots.length;
                      index++)
                    GestureDetector(
                      onTap: () => controller.slotIndex.value = index,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: index == selectedSlot
                              ? MColors.peach
                              : checkoutDarkCard,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          CheckoutController.slots[index],
                          style: textTheme.bodyMedium?.copyWith(
                            color: index == selectedSlot
                                ? MColors.black
                                : MColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MColors.error,
                    foregroundColor: MColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
