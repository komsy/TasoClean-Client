import 'package:flutter/material.dart';
import 'package:tasoclean/features/shop/controllers/checkout_controller.dart';
import 'package:tasoclean/features/shop/screens/service_checkout/widgets/checkout_colors.dart';
import 'package:tasoclean/utils/constants/colors.dart';

class BookingSuccessSummaryCard extends StatelessWidget {
  const BookingSuccessSummaryCard({
    super.key,
    required this.summary,
    required this.paidInFull,
  });

  final BookingSummary summary;
  final bool paidInFull;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: checkoutDarkCard,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _InfoRow(label: 'Booking ref', value: summary.reference),
          _InfoRow(label: 'When', value: summary.whenLabel),
          _InfoRow(
            label: 'Services',
            value:
                '${summary.serviceCount} ${summary.serviceCount == 1 ? 'service' : 'services'} · ${summary.itemCount} ${summary.itemCount == 1 ? 'item' : 'items'}',
          ),
          _InfoRow(
            label: 'Total',
            value: formatKes(summary.servicesTotal),
          ),
          _InfoRow(
            label: paidInFull ? 'Due now' : 'Deposit due now',
            value: formatKes(summary.payNow),
            highlight: true,
            last: true,
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
  });

  final String label;
  final String value;
  final bool highlight;
  final bool last;

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
              color: MColors.white.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: textTheme.bodyMedium?.copyWith(
                color: highlight ? MColors.peach : MColors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
