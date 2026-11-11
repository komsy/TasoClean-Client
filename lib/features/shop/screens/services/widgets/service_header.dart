import 'package:flutter/material.dart';
import 'package:tasoclean/utils/constants/colors.dart';

class MServiceHeader extends StatefulWidget {
  const MServiceHeader({required this.location, required this.step});
  final String location;
  final int step;

  @override
  State<MServiceHeader> createState() => MServiceHeaderState();
}

class MServiceHeaderState extends State<MServiceHeader> {
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
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
                  onPressed: () => Navigator.maybePop(context),
                  icon: const Icon(Icons.chevron_left, color: MColors.white, size: 30),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Book a service',
                          style: t.titleLarge?.copyWith(color: MColors.white, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 2),
                      Text.rich(
                        TextSpan(
                          text: '${widget.location} · ',
                          children: const [
                            TextSpan(text: 'change', style: TextStyle(decoration: TextDecoration.underline)),
                          ],
                        ),
                        style: t.bodySmall?.copyWith(color: MColors.white.withValues(alpha: 0.85)),
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
                children: List.generate(3, (i) {
                  return Expanded(
                    child: Container(
                      height: 4,
                      margin: EdgeInsets.only(right: i == 2 ? 0 : 8),
                      decoration: BoxDecoration(
                        color: i < widget.step ? MColors.white : MColors.white.withValues(alpha: 0.3),
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
