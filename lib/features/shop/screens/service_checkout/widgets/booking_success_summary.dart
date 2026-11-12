import 'package:flutter/material.dart';
import 'package:tasoclean/features/shop/controllers/checkout_controller.dart';
import 'package:tasoclean/features/shop/screens/service_checkout/widgets/checkout_colors.dart';
import 'package:tasoclean/utils/constants/colors.dart';

class BookingSuccessSummaryCard extends StatelessWidget {
  const BookingSuccessSummaryCard({
    super.key,
    required this.summary,
    required this.paidInFull,
    this.dark = false,
  });

  final BookingSummary summary;
  final bool paidInFull;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: dark ? MColors.white.withValues(alpha: 0.07) : MColors.black.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _InfoRow(label: 'Booking ref', value: summary.reference, dark: dark),
          _InfoRow(label: 'When', value: summary.whenLabel, dark: dark),
          _InfoRow(
            label: 'Services',
            value:
                '${summary.serviceCount} ${summary.serviceCount == 1 ? 'service' : 'services'} · ${summary.itemCount} ${summary.itemCount == 1 ? 'item' : 'items'}',
            dark: dark,
          ),
          _InfoRow(
            label: 'Total',
            value: formatKes(summary.servicesTotal),
            dark: dark,
          ),
          _InfoRow(
            label: paidInFull ? 'Due now' : 'Deposit due now',
            value: formatKes(summary.payNow),
            highlight: true,
            last: true,
            dark: dark,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.highlight = false,
    this.last = false,
    this.dark = false,
  });

  final String label;
  final String value;
  final bool highlight;
  final bool last;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: dark ? MColors.white.withValues(alpha: 0.6) : MColors.black.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: textTheme.bodyMedium?.copyWith(
                color: highlight ? dark ? MColors.peach : MColors.peachIcon : dark ? MColors.white : MColors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
