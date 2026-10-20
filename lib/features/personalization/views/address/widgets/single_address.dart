import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:k_store/features/personalization/controllers/address_controller.dart';
import 'package:k_store/features/personalization/models/address_model.dart';
import 'package:k_store/utils/constants/colors.dart';
import 'package:k_store/utils/constants/sizes.dart';
import 'package:k_store/utils/helpers/helper_functions.dart';

import '../../../../../common/widgets/containers/rounded_container.dart';

class MSingleAddress extends StatelessWidget {
  const MSingleAddress({super.key, required this.address, required this.onTap});
  
  final AddressModel address;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = AddressController.instance;

    return  Obx( () {
      final selectedAddressId = controller.selectedAddress.value.id;
      final selectedAddress = selectedAddressId == address.id;
      
      return InkWell(
        onTap: onTap,
        child: MRoundedContainer(
          showBorder: true,
          padding: const EdgeInsets.all(MSizes.md),
          width: double.infinity,
          backgroundColor: selectedAddress ? MColors.primary.withOpacity(0.5) : Colors.transparent,
          borderColor: selectedAddress ? Colors.transparent : dark ? MColors.darkerGrey : MColors.grey,
          margin: const EdgeInsets.only(bottom: MSizes.spaceBtwItems),
          child: Stack(
            children: [
              Positioned(
                right: 5,
                top: 0,
                child: Icon(selectedAddress ? Iconsax.tick_circle5 : null, color: selectedAddress ? dark ? MColors.light: MColors.dark : null),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(address.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: MSizes.sm / 2),
                    Text(address.formattedPhoneNo,maxLines: 1,overflow: TextOverflow.ellipsis),
                    const SizedBox(height: MSizes.sm / 2),
                    Text(address.toString(),softWrap: true,),
                  ],
                )
            ],
          ),
        ),
      );
    }
    );
  }
}