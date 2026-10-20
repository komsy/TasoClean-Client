import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:k_store/common/widgets/appbar/appbar.dart';
import 'package:k_store/features/personalization/controllers/address_controller.dart';
import 'package:k_store/features/personalization/views/address/add_new_address.dart';
import 'package:k_store/features/personalization/views/address/widgets/single_address.dart';
import 'package:k_store/utils/constants/sizes.dart';
import 'package:k_store/utils/helpers/cloud_helper_functions.dart';

import '../../../../utils/constants/colors.dart';

class UserAddressScreen extends StatelessWidget {
  const UserAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AddressController.instance;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: MColors.primary,
        onPressed: () => Get.to(() => const AddAddressScreen()),
        child: const Icon(Iconsax.add, color: MColors.white),
      ),
      appBar: MAppBar(
          title: Text('Addresses',
              style: Theme.of(context).textTheme.headlineSmall),
          showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(MSizes.defaultSpace),
          child: Obx(() => FutureBuilder(
              //Use key to trigger refresh
              key: Key(controller.refreshData.value.toString()),
              future: controller.getAllUserAddresses(),
              builder: (context, snapshot) {
                //Helper functions handle loader, no record or eror message
                final response = MCloudHelperFunctions.checkMultiRecordState(
                    snapshot: snapshot);
                if (response != null) return response;

                final addresses = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: addresses.length,
                  itemBuilder: (_, index) => MSingleAddress(
                    address: addresses[index],
                    onTap: () => controller.selectAddress(addresses[index]),
                  ),
                );
              }),
            ),
        ),
      ),
    );
  }
}
