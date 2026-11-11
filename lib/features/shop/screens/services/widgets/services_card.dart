import 'package:flutter/material.dart';
import 'package:tasoclean/features/shop/models/service_model.dart';
import 'package:tasoclean/features/shop/screens/services/widgets/service_list.dart'
    show serviceCategoryIcon;
import 'package:tasoclean/utils/constants/colors.dart';
import 'package:tasoclean/utils/constants/sizes.dart';

class MServiceCard extends StatelessWidget {
  const MServiceCard({super.key, required this.category, this.onTap});

  final ServiceCategoryModel category;
  final VoidCallback? onTap;

  /// "Laundry, Ironing, ..." – falls back to the parent group ("Residential").
  String get _subtitle {
    final names = category.activeServices
        .map((s) => s.name)
        .where((n) => n.isNotEmpty)
        .toList();
    return names.isEmpty ? category.category : names.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: MColors.peach,
      borderRadius: BorderRadius.circular(MSizes.cardRadiusLg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(MSizes.cardRadiusLg),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 72),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                // Icon tile
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: MColors.peachTile,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(serviceCategoryIcon(category.categoryName),
                      color: MColors.peachIcon, size: 26),
                ),
                const SizedBox(width: 14),

                // Title + subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        category.categoryName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleSmall?.copyWith(
                          color: MColors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodySmall?.copyWith(
                          color: MColors.peachSubtitle,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),

                // Red action circle
                ExcludeSemantics(
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: const BoxDecoration(
                      color: MColors.error,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.chevron_right,
                      color: MColors.white,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
