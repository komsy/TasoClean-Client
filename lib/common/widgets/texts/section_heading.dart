import 'package:flutter/material.dart';

class MSectionHeading extends StatelessWidget {
  const MSectionHeading({
    super.key,
    this.textColor,
    required this.title,
    this.rightSideWidget,
    this.buttonTitle = 'View all',
    this.onPressed,
    this.showActionButton=true,
  });

  final Color? textColor;
  final Widget? rightSideWidget;
  final String title, buttonTitle;

  final bool showActionButton;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: Theme.of(context).textTheme.headlineSmall!.apply(color: textColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
        // if (rightSideWidget!= null) rightSideWidget!
        if(showActionButton) TextButton(onPressed: onPressed, child: Text(buttonTitle))
      ],
    );
  }
}
