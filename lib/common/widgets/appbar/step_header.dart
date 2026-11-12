import 'package:flutter/material.dart';
import 'package:tasoclean/utils/constants/colors.dart';

class MStepHeader extends StatelessWidget {
  const MStepHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.currentStep,
    this.totalSteps = 3,
    this.onBack,
  });

  final String title;
  final Widget subtitle;
  final int currentStep;
  final int totalSteps;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: onBack ?? () => Navigator.maybePop(context),
                  icon: const Icon(
                    Icons.chevron_left,
                    color: MColors.white,
                    size: 30,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: textTheme.titleLarge?.copyWith(
                          color: MColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      DefaultTextStyle(
                        style: textTheme.bodySmall?.copyWith(
                              color: MColors.white.withValues(alpha: 0.85),
                            ) ??
                            const TextStyle(),
                        child: subtitle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                children: List.generate(totalSteps, (index) {
                  return Expanded(
                    child: Container(
                      height: 4,
                      margin: EdgeInsets.only(
                        right: index == totalSteps - 1 ? 0 : 8,
                      ),
                      decoration: BoxDecoration(
                        color: index < currentStep
                            ? MColors.white
                            : MColors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
