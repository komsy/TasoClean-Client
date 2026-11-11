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

String _kes(num v) {
  final fixed = v % 1 == 0 ? v.toInt().toString() : v.toStringAsFixed(2);
  final parts = fixed.split('.');
  final whole =
      parts[0].replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');
  return 'KES ${parts.length > 1 ? '$whole.${parts[1]}' : whole}';
}

class MServiceItemTile extends StatefulWidget {
  const MServiceItemTile({
    super.key,
    required this.service,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
  });

  final ServiceModel service;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  @override
  State<MServiceItemTile> createState() => _MServiceItemTileState();
}

class _MServiceItemTileState extends State<MServiceItemTile> {
  bool get _selected => widget.quantity > 0;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      constraints: const BoxConstraints(minHeight: 60),
      padding: const EdgeInsets.fromLTRB(16, 10, 10, 10),
      decoration: BoxDecoration(
        color: MColors.peach,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: _selected ? MColors.peachBorder : Colors.transparent,
            width: 2),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.service.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: t.titleSmall?.copyWith(
                        color: MColors.black, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text.rich(
                  TextSpan(
                    children: [
                      if (widget.service.description.isNotEmpty)
                        TextSpan(text: '${widget.service.description} · '),
                      TextSpan(
                          text: _kes(widget.service.amount),
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: t.bodySmall?.copyWith(
                      color: MColors.peachSubtitle,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (_selected) ...[
            _RoundButton(
                icon: Icons.remove,
                onTap: widget.onRemove,
                background: MColors.stepperIdle,
                foreground: MColors.black),
            SizedBox(
              width: 34,
              child: Text('${widget.quantity}',
                  textAlign: TextAlign.center,
                  style: t.titleSmall?.copyWith(
                      color: MColors.black, fontWeight: FontWeight.w600)),
            ),
          ],
          _RoundButton(
              icon: Icons.add,
              onTap: widget.onAdd,
              background: MColors.dark,
              foreground: MColors.white),
        ],
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({
    required this.icon,
    required this.onTap,
    required this.background,
    required this.foreground,
  });
  final IconData icon;
  final VoidCallback onTap;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
            width: 44,
            height: 40,
            child: Icon(icon, color: foreground, size: 22)),
      ),
    );
  }
}
