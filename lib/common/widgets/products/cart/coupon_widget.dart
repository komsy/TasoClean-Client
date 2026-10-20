import 'package:flutter/material.dart';
import 'package:k_store/common/widgets/containers/rounded_container.dart';
import 'package:k_store/utils/constants/colors.dart';
import 'package:k_store/utils/helpers/helper_functions.dart';

import '../../../../utils/constants/sizes.dart';

class MCouponCode extends StatelessWidget {
  const MCouponCode({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return MRoundedContainer(
      showBorder: true,
      backgroundColor: dark ? MColors.dark : MColors.white,
      padding: const EdgeInsets.only(top: MSizes.sm, bottom:  MSizes.sm, right: MSizes.sm, left: MSizes.md),
      child: Row(
        children: [
          //Textfield
          Flexible(
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: 'Have a promo code? Enter here.',
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
            )
          ),
    
          //Button
          SizedBox(
            width: 80,
            child: ElevatedButton(
                onPressed: () {}, 
                style: ElevatedButton.styleFrom(
                  foregroundColor: dark ? MColors.white.withOpacity(0.5) : MColors.dark.withOpacity(0.5),
                  backgroundColor: Colors.grey.withOpacity(0.2),
                  side: BorderSide(color: Colors.grey.withOpacity(0.1))
                ),
                child: const Text('Apply')),
          )
        ],
      ),
    );
  }
}