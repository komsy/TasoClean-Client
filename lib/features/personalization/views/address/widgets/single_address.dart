import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tasoclean/features/personalization/controllers/address_controller.dart';
import 'package:tasoclean/features/personalization/models/address_model.dart';
import 'package:tasoclean/utils/constants/colors.dart';
import 'package:tasoclean/utils/constants/sizes.dart';

class MSingleAddress extends StatelessWidget {
  const MSingleAddress({super.key, required this.address, required this.onTap});

  final AddressModel address;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final controller = AddressController.instance;

    return Obx(() {
      final selected = controller.selectedAddress.value?.id == address.id;
      return Card(
        margin: const EdgeInsets.only(bottom: MSizes.spaceBtwItems),
        color: selected ? MColors.primary.withValues(alpha: 0.12) : null,
        child: ListTile(
          onTap: onTap,
          leading: Icon(
            selected ? Iconsax.location_tick5 : Iconsax.location,
            color: MColors.primary,
          ),
          title: Text(address.label),
          subtitle: Text(
            [
              address.fullAddress,
              if (address.details.trim().isNotEmpty) address.details.trim(),
            ].where((line) => line.isNotEmpty).join('\n'),
          ),
          trailing: address.isDefault
              ? const Chip(label: Text('Default'))
              : const Icon(Iconsax.arrow_right_3),
        ),
      );
    });
  }
}
