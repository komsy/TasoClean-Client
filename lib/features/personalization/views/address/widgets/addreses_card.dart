import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k_store/features/personalization/controllers/address_controller.dart';
import 'package:k_store/features/personalization/views/address/widgets/single_address.dart';
import 'package:k_store/utils/constants/sizes.dart';
import 'package:k_store/utils/helpers/cloud_helper_functions.dart';


class AddressesCard extends StatelessWidget {
  const AddressesCard({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    final controller = AddressController.instance;
    return SingleChildScrollView(
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
    );
  }
}
