import 'package:flutter/material.dart';
import 'package:tasoclean/utils/constants/colors.dart';

class BookingSuccessHeader extends StatelessWidget {
  const BookingSuccessHeader({super.key, required this.paidInFull, required this.dark});

  final bool paidInFull;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    const successGreen = Color(0xFF3AA63F);

    return Column(
      children: [
        Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 650),
            curve: Curves.easeOutBack,
            builder: (_, value, child) =>
                Transform.scale(scale: value, child: child),
            child: Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                color: successGreen.withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: successGreen,
                    shape: BoxShape.circle,
                  ),
                  child:
                      const Icon(Icons.check, color: MColors.white, size: 38),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 22),
        Text(
          paidInFull ? 'Booking confirmed!' : 'Booking placed!',
          textAlign: TextAlign.center,
          style: textTheme.headlineSmall?.copyWith(
            color: dark ? MColors.white : MColors.black,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          paidInFull
              ? 'Your pro is booked. We\'ll send a reminder before the visit.'
              : 'Complete the M-Pesa prompt on your phone to lock in your slot.',
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(
            color: dark ? MColors.white.withValues(alpha: 0.7) : MColors.black.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
