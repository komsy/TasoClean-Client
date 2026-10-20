import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k_store/common/widgets/loaders/circular_loader.dart';
import 'package:k_store/common/widgets/texts/section_heading.dart';
import 'package:k_store/data/repositories/address/address_repository.dart';
import 'package:k_store/features/personalization/models/address_model.dart';
import 'package:k_store/features/personalization/views/address/add_new_address.dart';
import 'package:k_store/features/personalization/views/address/widgets/single_address.dart';
import 'package:k_store/utils/constants/image_strings.dart';
import 'package:k_store/utils/constants/sizes.dart';
import 'package:k_store/utils/helpers/cloud_helper_functions.dart';
import 'package:k_store/utils/helpers/network_manager.dart';
import 'package:k_store/utils/popups/full_screen_loader.dart';
import 'package:k_store/utils/popups/loaders.dart';

class AddressController extends GetxController{
  static AddressController get instance => Get.find();

  final name = TextEditingController();
  final phoneNumber = TextEditingController();
  final street = TextEditingController();
  final postalCode = TextEditingController();
  final city = TextEditingController();
  final state = TextEditingController();
  final country = TextEditingController();
  GlobalKey<FormState> addressFormKey = GlobalKey<FormState>();

  RxBool refreshData = true.obs;
  final Rx<AddressModel> selectedAddress = AddressModel.empty().obs;
  final addressRepository = Get.put(AddressRepository());

  //fetch all user specific adresses
  Future<List<AddressModel>> getAllUserAddresses() async {
    try{
      final addresses = await addressRepository.fetchUserAddresses();
      selectedAddress.value = addresses.firstWhere((element) => element.selectedAddress, orElse: () => AddressModel.empty());
      return addresses;
    } catch (e) {
     MLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
     return [];
    }
  }

  Future selectAddress(AddressModel newSelectedAddress) async {
    try {

      Get.defaultDialog(
        title: '',
        onWillPop: () async {return false;},
        barrierDismissible: false,
        backgroundColor: Colors.transparent,
        content: const MCircularLoader()
      );

      //Clear the "selected" field
      if(selectedAddress.value.id.isNotEmpty){
        await addressRepository.updateSelectedField(selectedAddress.value.id, false);
      }

      //Assign selected address
      newSelectedAddress.selectedAddress = true;
      selectedAddress.value = newSelectedAddress;

      //Set the "selected" field to true for the newly selected address
      await addressRepository.updateSelectedField(selectedAddress.value.id, true);
      Get.back();
    } catch (e) {
     MLoaders.errorSnackBar(title: 'Error in Selection', message: e.toString());
    }
  }


//Show Addresses modalBottomSheet at checkout
Future<dynamic> selectNewAddressPopup(BuildContext context){
  return showModalBottomSheet(
    context: context, 
    builder: (_) => Container (
      padding: const EdgeInsets.all(MSizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MSectionHeading(title: "Select Address", showActionButton: false),
          FutureBuilder(
            future: getAllUserAddresses(),
            builder: (_, snapshot){
              //Helper fn, handle loader, no record or error message
              final response = MCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot);
              if (response != null) return response;

              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) => MSingleAddress(
                  address: snapshot.data![index],
                  onTap: () async { 
                    await selectAddress(snapshot.data![index]);
                    Get.back();
                  }
                )
              );
            },
          ),
          const SizedBox(height: MSizes.defaultSpace * 2),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(onPressed: () => Get.to(() => const AddAddressScreen()), child: const Text('Add New Address'))
          )
        ],
      ),
    )
  );
}
  
  Future addNewaddresses() async {
    try {
      //Start loading
      MFullScreenLoader.openLoadingDialog('Storing Address...', MImages.docerAnimation);

      //Check Internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected){
        MFullScreenLoader.stopLoading();
        return;
      }

      //Form validation
      if(!addressFormKey.currentState!.validate()){
        MFullScreenLoader.stopLoading();
        return;
      }
      
      //Update user's first & last name in the firebase firestore
      final address = AddressModel(
        id: '',
        name: name.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        street: street.text.trim(),
        city: city.text.trim(),
        state: state.text.trim(),
        postalCode: postalCode.text.trim(),
        country: country.text.trim(),
        selectedAddress: true
      );

      final id =  await addressRepository.addAddress(address);

      //Update selected address status
      address.id = id;
      await selectedAddress(address); 

      //Remove loader
      MFullScreenLoader.stopLoading();

      //Show success message
      MLoaders.successSnackBar(title: 'Congratulations', message: 'Your address has been saved successfully.');

      //Refresh address data
      refreshData.toggle();

      //Reset fields
      resetFormFields();

      //Redirect 
      Navigator.of(Get.context!).pop();
    } catch (e) {
      //Remove loader
      MFullScreenLoader.stopLoading();

      //Show some generic error to the user
      MLoaders.errorSnackBar(title: 'Address not fopund', message: e.toString());
    }
  }

  //Fn to reset form fields
  void resetFormFields() {
    name.clear();
    phoneNumber.clear();
    street.clear();
    postalCode.clear();
    city.clear();
    state.clear();
    country.clear();
    addressFormKey.currentState?.reset();
  }


}