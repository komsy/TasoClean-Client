import 'package:flutter/material.dart';
import 'package:tasoclean/features/shop/models/service_model.dart';
import 'package:tasoclean/utils/constants/colors.dart';

/// Firestore has no icon field, so pick one from the category name.
IconData serviceCategoryIcon(String name) {
  final n = name.toLowerCase();
  if (n.contains('laundry')) return Icons.local_laundry_service_outlined;
  if (n.contains('construction')) return Icons.construction;
  if (n.contains('pest')) return Icons.bug_report_outlined;
  if (n.contains('deep')) return Icons.weekend_outlined;
  return Icons.cleaning_services_outlined;
}

class MCategoryStrip extends StatefulWidget {
  const MCategoryStrip({
    required this.categories,
    required this.selected,
    required this.badgeFor,
    required this.onSelect,
  });
  final List<ServiceCategoryModel> categories;
  final int selected;
  final int Function(ServiceCategoryModel) badgeFor;
  final ValueChanged<int> onSelect;

  @override
  State<MCategoryStrip> createState() => _MCategoryStripState();
}

class _MCategoryStripState extends State<MCategoryStrip> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: widget.categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final c = widget.categories[i];
          final isSel = i == widget.selected;
          final badge = widget.badgeFor(c);
          return GestureDetector(
            onTap: () => widget.onSelect(i),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 90,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSel ? MColors.peach : MColors.darkCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSel
                          ? MColors.peachBorder
                          : Colors.white.withValues(alpha: 0.08),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(serviceCategoryIcon(c.categoryName),
                          size: 24,
                          color: isSel ? MColors.black : MColors.peach),
                      const SizedBox(height: 6),
                      Text(
                        c.categoryName,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: isSel ? MColors.black : MColors.peach,
                              fontWeight: FontWeight.w600,
                              height: 1.15,
                            ),
                      ),
                    ],
                  ),
                ),
                if (badge > 0)
                  Positioned(
                    top: -6,
                    right: -4,
                    child: Container(
                      width: 22,
                      height: 22,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          color: MColors.error, shape: BoxShape.circle),
                      child: Text('$badge',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700)),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
