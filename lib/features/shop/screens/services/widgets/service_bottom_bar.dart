import 'package:flutter/material.dart';
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

String _kes(num v) {
  final fixed = v % 1 == 0 ? v.toInt().toString() : v.toStringAsFixed(2);
  final parts = fixed.split('.');
  final whole =
      parts[0].replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');
  return 'KES ${parts.length > 1 ? '$whole.${parts[1]}' : whole}';
}

class MServiceBottomBar extends StatefulWidget {
  const MServiceBottomBar({
    required this.items,
    required this.services,
    required this.total,
    required this.onNext,
  });
  final int items;
  final int services;
  final num total;
  final VoidCallback? onNext;

  @override
  State<MServiceBottomBar> createState() => MServiceBottomBarState();
}

class MServiceBottomBarState extends State<MServiceBottomBar> {
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: MColors.darkBar,
        border: Border(
            top: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${widget.items} ${widget.items == 1 ? 'item' : 'items'} · ${widget.services} ${widget.services == 1 ? 'service' : 'services'}',
                      style: t.bodySmall?.copyWith(
                          color: MColors.white.withValues(alpha: 0.7)),
                    ),
                    const SizedBox(height: 2),
                    Text(_kes(widget.total),
                        style: t.titleLarge?.copyWith(
                            color: MColors.white, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              SizedBox(
                width: 110,
                height: 52,
                child: ElevatedButton(
                  onPressed: widget.onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MColors.error,
                    foregroundColor: MColors.white,
                    disabledBackgroundColor:
                        MColors.error.withValues(alpha: 0.35),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Next',
                        style: t.bodyMedium?.copyWith(
                          color: MColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.arrow_forward, color: MColors.white),
                    ],
                  )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
