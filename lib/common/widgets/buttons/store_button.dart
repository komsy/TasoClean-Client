import 'package:flutter/material.dart';

class MStoreButton extends StatelessWidget {
  const MStoreButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.width = 200,
    this.backgroundColor = Colors.white,
    this.foregroundColor = Colors.black,
  });

  final String label;
  final VoidCallback? onPressed;
  final double? width;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: 0,
          shape: const StadiumBorder(),
        ),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
