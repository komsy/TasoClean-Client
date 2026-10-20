import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:k_store/features/personalization/controllers/address_controller.dart';
import 'package:k_store/utils/constants/sizes.dart';
import 'package:k_store/utils/validators/validation.dart';

import '../../../../common/widgets/appbar/appbar.dart';

class AddAddressScreen extends StatelessWidget {
  const AddAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AddressController.instance;
    
    return Scaffold(
      appBar: const MAppBar(title: Text('Add new Address'), showBackArrow: true,),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(MSizes.defaultSpace),
        child: Form(
          key: controller.addressFormKey,
          child: Column(
            children: [
              TextFormField( 
                controller: controller.name,
                validator: (value) => MValidator.validateEmptyText('Name', value),
                decoration: const InputDecoration(prefixIcon: Icon(Iconsax.user), labelText: 'Name')),
              const SizedBox(height: MSizes.spaceBtwInputFields),
              TextFormField( 
                controller: controller.phoneNumber,
                validator: MValidator.validatePhoneNumber,
                decoration: const InputDecoration(prefixIcon: Icon(Iconsax.mobile), labelText: 'PhoneNumber')),
              const SizedBox(height: MSizes.spaceBtwInputFields),
              Row(
                children: [
                  Expanded(child: TextFormField( 
                    controller: controller.street,
                    validator: (value) => MValidator.validateEmptyText('Street', value),
                    decoration: const InputDecoration(prefixIcon: Icon(Iconsax.building_31), labelText: 'Street'))),
                  const SizedBox(width: MSizes.spaceBtwInputFields),
                  Expanded(child: TextFormField( 
                    controller: controller.postalCode,
                    validator: (value) => MValidator.validateEmptyText('Postal Code', value),
                    decoration: const InputDecoration(prefixIcon: Icon(Iconsax.code), labelText: 'Postal Code'))),
                ],
              ),
              const SizedBox(height: MSizes.spaceBtwInputFields),
              Row(
                children: [
                  Expanded(child: TextFormField( 
                    controller: controller.city,
                    validator: (value) => MValidator.validateEmptyText('City', value),
                    decoration: const InputDecoration(prefixIcon: Icon(Iconsax.building), labelText: 'City'))),
                  const SizedBox(width: MSizes.spaceBtwInputFields),
                  Expanded(child: TextFormField( 
                    controller: controller.state,
                    validator: (value) => MValidator.validateEmptyText('State', value),
                    decoration: const InputDecoration(prefixIcon: Icon(Iconsax.activity), labelText: 'State'))),
                ],
              ),
              const SizedBox(height: MSizes.spaceBtwInputFields),
              TextFormField( 
                controller: controller.country,
                validator: (value) => MValidator.validateEmptyText('Country', value),
                decoration: const InputDecoration(prefixIcon: Icon(Iconsax.global), labelText: 'Country')),
              const SizedBox(height: MSizes.defaultSpace),
              SizedBox(width: double.infinity, child: ElevatedButton(onPressed:  ()=> controller.addNewaddresses(), child: const Text('Save'))),

            ],
          ),
        ),
      ),
    );
  }
}