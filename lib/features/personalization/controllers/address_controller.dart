import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:tasoclean/common/widgets/texts/section_heading.dart';
import 'package:tasoclean/data/repositories/address/address_repository.dart';
import 'package:tasoclean/features/personalization/models/address_model.dart';
import 'package:tasoclean/features/personalization/views/address/add_new_address.dart';
import 'package:tasoclean/features/personalization/views/address/widgets/single_address.dart';
import 'package:tasoclean/utils/constants/image_strings.dart';
import 'package:tasoclean/utils/constants/sizes.dart';
import 'package:tasoclean/utils/helpers/network_manager.dart';
import 'package:tasoclean/utils/popups/full_screen_loader.dart';
import 'package:tasoclean/utils/popups/loaders.dart';

class AddressController extends GetxController {
  static AddressController get instance => Get.find();

  final label = TextEditingController();
  final addressLine = TextEditingController();
  final details = TextEditingController();
  final city = TextEditingController();
  final GlobalKey<FormState> addressFormKey = GlobalKey<FormState>();
  final RxList<AddressModel> addresses = <AddressModel>[].obs;
  final Rxn<AddressModel> selectedAddress = Rxn<AddressModel>();
  final RxBool isLoading = true.obs;
  final RxBool refreshData = true.obs;
  final RxBool hasFormLocation = false.obs;
  final RxString locationError = ''.obs;
  final addressRepository = Get.put(AddressRepository());

  double? _formLatitude;
  double? _formLongitude;

  Future<void> loadAddresses() async {
    isLoading.value = true;
    locationError.value = '';

    List<AddressModel> fetchedAddresses;
    try {
      fetchedAddresses = await addressRepository.fetchUserAddresses();
    } catch (error) {
      addresses.clear();
      try {
        await _selectCurrentLocation();
        locationError.value =
            'Saved addresses could not be loaded. Showing your current location.';
        MLoaders.errorSnackBar(
          title: 'Address loading failed',
          message: error.toString(),
        );
      } catch (locationFailure) {
        selectedAddress.value = null;
        locationError.value =
            'Could not load saved addresses or your current location. $locationFailure';
        MLoaders.errorSnackBar(
          title: 'Location unavailable',
          message: locationError.value,
        );
      }
      isLoading.value = false;
      return;
    }

    addresses.assignAll(fetchedAddresses);
    AddressModel? defaultAddress;
    for (final address in fetchedAddresses) {
      if (address.isDefault && _hasCoordinates(address)) {
        defaultAddress = address;
        break;
      }
    }

    if (defaultAddress != null) {
      selectedAddress.value = defaultAddress;
    } else {
      try {
        await _selectCurrentLocation();
      } catch (error) {
        selectedAddress.value = null;
        locationError.value = error.toString();
        MLoaders.errorSnackBar(
          title: 'Location unavailable',
          message: error.toString(),
        );
      }
    }
    isLoading.value = false;
  }

  Future<List<AddressModel>> getAllUserAddresses() =>
      addressRepository.fetchUserAddresses();

  Future<void> selectAddress(AddressModel address) async {
    try {
      if (!_hasCoordinates(address)) {
        throw Exception('This address does not have a valid map location.');
      }
      await addressRepository.setDefaultAddress(address.id);
      final selected = address.copyWith(isDefault: true);
      addresses.assignAll(
        addresses
            .map((item) => item.copyWith(isDefault: item.id == address.id)),
      );
      selectedAddress.value = selected;
    } catch (error) {
      MLoaders.errorSnackBar(
        title: 'Address selection failed',
        message: error.toString(),
      );
    }
  }

  Future<void> _selectCurrentLocation() async {
    final position = await _getCurrentPosition();
    selectedAddress.value = AddressModel(
      label: 'Current location',
      addressLine: 'Your device location',
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  Future<Position> _getCurrentPosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception(
          'Turn on location services to find your current location.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      throw Exception('Location permission was denied.');
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permission is disabled. Enable it in your device settings.',
      );
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }

  Future<void> useCurrentLocation() async {
    try {
      final position = await _getCurrentPosition();
      _formLatitude = position.latitude;
      _formLongitude = position.longitude;
      hasFormLocation.value = true;
    } catch (error) {
      MLoaders.errorSnackBar(
        title: 'Location unavailable',
        message: error.toString(),
      );
    }
  }

  Future<void> addNewaddresses() async {
    var loadingDialogOpen = false;
    try {
      if (!addressFormKey.currentState!.validate()) return;
      if (_formLatitude == null || _formLongitude == null) {
        await useCurrentLocation();
      }
      if (_formLatitude == null || _formLongitude == null) {
        throw Exception('Set a map location before saving this address.');
      }

      MFullScreenLoader.openLoadingDialog(
        'Storing Address...',
        MImages.docerAnimation,
      );
      loadingDialogOpen = true;
      if (!await NetworkManager.instance.isConnected()) {
        MFullScreenLoader.stopLoading();
        loadingDialogOpen = false;
        MLoaders.warningSnackBar(
          title: 'No internet connection',
          message: 'Connect to the internet to save this location.',
        );
        return;
      }

      await addressRepository.addAddress(
        AddressModel(
          label: label.text.trim(),
          addressLine: addressLine.text.trim(),
          details: details.text.trim(),
          city: city.text.trim(),
          latitude: _formLatitude!,
          longitude: _formLongitude!,
          isDefault: addresses.isEmpty,
        ),
      );

      MFullScreenLoader.stopLoading();
      loadingDialogOpen = false;
      MLoaders.successSnackBar(
        title: 'Address saved',
        message: 'Your address has been saved successfully.',
      );
      refreshData.toggle();
      resetFormFields();
      Get.back();
      await loadAddresses();
    } catch (error) {
      if (loadingDialogOpen) MFullScreenLoader.stopLoading();
      MLoaders.errorSnackBar(
        title: 'Address could not be saved',
        message: error.toString(),
      );
    }
  }

  Future<dynamic> selectNewAddressPopup(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(MSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MSectionHeading(
              title: 'Select Address',
              showActionButton: false,
            ),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: addresses.length,
                  itemBuilder: (_, index) => MSingleAddress(
                    address: addresses[index],
                    onTap: () async {
                      await selectAddress(addresses[index]);
                      Get.back();
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: MSizes.defaultSpace),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.to(() => const AddAddressScreen()),
                child: const Text('Add New Address'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void resetFormFields() {
    label.clear();
    addressLine.clear();
    details.clear();
    city.clear();
    _formLatitude = null;
    _formLongitude = null;
    hasFormLocation.value = false;
    addressFormKey.currentState?.reset();
  }

  bool _hasCoordinates(AddressModel address) =>
      address.latitude.isFinite &&
      address.longitude.isFinite &&
      address.latitude >= -90 &&
      address.latitude <= 90 &&
      address.longitude >= -180 &&
      address.longitude <= 180 &&
      (address.latitude != 0 || address.longitude != 0);

  @override
  void onClose() {
    label.dispose();
    addressLine.dispose();
    details.dispose();
    city.dispose();
    super.onClose();
  }
}
