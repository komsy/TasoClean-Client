import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tasoclean/common/widgets/appbar/appbar.dart';
import 'package:tasoclean/features/personalization/controllers/address_controller.dart';
import 'package:tasoclean/utils/constants/sizes.dart';
import 'package:tasoclean/utils/validators/validation.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final controller = AddressController.instance;

  @override
  void initState() {
    super.initState();
    controller.useCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MAppBar(
        title: Text('Add new location'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(MSizes.defaultSpace),
        child: Form(
          key: controller.addressFormKey,
          child: Column(
            children: [
              TextFormField(
                controller: controller.label,
                validator: (value) =>
                    MValidator.validateEmptyText('Location name', value),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.tag),
                  labelText: 'Location name (Home, Work, etc.)',
                ),
              ),
              const SizedBox(height: MSizes.spaceBtwInputFields),
              TextFormField(
                controller: controller.addressLine,
                validator: (value) =>
                    MValidator.validateEmptyText('Address', value),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.building_31),
                  labelText: 'Address',
                ),
              ),
              const SizedBox(height: MSizes.spaceBtwInputFields),
              TextFormField(
                controller: controller.details,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.info_circle),
                  labelText: 'Apartment, landmark (optional)',
                ),
              ),
              const SizedBox(height: MSizes.spaceBtwInputFields),
              TextFormField(
                controller: controller.city,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.building),
                  labelText: 'City (optional)',
                ),
              ),
              const SizedBox(height: MSizes.spaceBtwItems),
              Obx(
                () => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Iconsax.location),
                  title: Text(
                    controller.hasFormLocation.value
                        ? 'Map location set'
                        : 'Map location not set',
                  ),
                  subtitle: const Text(
                    'Use your current location as this address pin.',
                  ),
                  trailing: IconButton(
                    tooltip: 'Use current location',
                    onPressed: controller.useCurrentLocation,
                    icon: const Icon(Iconsax.gps),
                  ),
                ),
              ),
              const SizedBox(height: MSizes.defaultSpace),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.addNewaddresses,
                  child: const Text('Save location'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
