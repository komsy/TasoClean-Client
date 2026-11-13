import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:latlong2/latlong.dart';
import 'package:tasoclean/common/widgets/appbar/appbar.dart';
import 'package:tasoclean/features/personalization/controllers/address_controller.dart';
import 'package:tasoclean/features/personalization/models/address_model.dart';
import 'package:tasoclean/features/personalization/views/address/add_new_address.dart';
import 'package:tasoclean/features/personalization/views/address/widgets/single_address.dart';
import 'package:tasoclean/utils/constants/colors.dart';
import 'package:tasoclean/utils/constants/sizes.dart';

class UserAddressScreen extends StatefulWidget {
  const UserAddressScreen({super.key});

  @override
  State<UserAddressScreen> createState() => _UserAddressScreenState();
}

class _UserAddressScreenState extends State<UserAddressScreen> {
  final controller = AddressController.instance;

  @override
  void initState() {
    super.initState();
    controller.loadAddresses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: MColors.primary,
        onPressed: () => Get.to(() => const AddAddressScreen()),
        child: const Icon(Iconsax.add, color: MColors.white),
      ),
      appBar: MAppBar(
        title: Text('Addresses', style: Theme.of(context).textTheme.headlineSmall),
        showBackArrow: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final selected = controller.selectedAddress.value;
        return RefreshIndicator(
          onRefresh: controller.loadAddresses,
          child: ListView(
            padding: const EdgeInsets.all(MSizes.defaultSpace),
            children: [
              _buildMap(selected),
              const SizedBox(height: MSizes.spaceBtwItems),
              if (controller.locationError.value.isNotEmpty)
                _LocationMessage(
                  message: controller.locationError.value,
                  onRetry: controller.loadAddresses,
                ),
              if (selected != null) ...[
                Text(
                  'Showing location',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: MSizes.sm),
                _SelectedLocationCard(address: selected),
              ],
              const SizedBox(height: MSizes.spaceBtwSections),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Saved locations',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Refresh locations',
                    onPressed: controller.loadAddresses,
                    icon: const Icon(Iconsax.refresh),
                  ),
                ],
              ),
              if (controller.addresses.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: MSizes.spaceBtwItems),
                  child: Text('No saved locations yet. Add one to see it here.'),
                )
              else
                ...controller.addresses.map(
                  (address) => MSingleAddress(
                    address: address,
                    onTap: () => controller.selectAddress(address),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildMap(AddressModel? address) {
    if (address == null) {
      return Container(
        height: 260,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: MColors.lightGrey,
          borderRadius: BorderRadius.circular(MSizes.cardRadiusLg),
        ),
        child: const Icon(Iconsax.location_slash, size: 40),
      );
    }

    final point = LatLng(address.latitude, address.longitude);
    return ClipRRect(
      borderRadius: BorderRadius.circular(MSizes.cardRadiusLg),
      child: SizedBox(
        height: 260,
        child: FlutterMap(
          key: ValueKey('${address.latitude},${address.longitude}'),
          options: MapOptions(initialCenter: point, initialZoom: 15),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.tasoclean',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: point,
                  width: 48,
                  height: 48,
                  child: const Icon(
                    Iconsax.location5,
                    size: 42,
                    color: MColors.primary,
                  ),
                ),
              ],
            ),
            const RichAttributionWidget(
              attributions: [
                TextSourceAttribution('OpenStreetMap contributors'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectedLocationCard extends StatelessWidget {
  const _SelectedLocationCard({required this.address});

  final AddressModel address;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Iconsax.location, color: MColors.primary),
        title: Text(address.label),
        subtitle: Text(
          [
            if (address.fullAddress.isNotEmpty) address.fullAddress,
            '${address.latitude.toStringAsFixed(5)}, '
                '${address.longitude.toStringAsFixed(5)}',
          ].join('\n'),
        ),
      ),
    );
  }
}

class _LocationMessage extends StatelessWidget {
  const _LocationMessage({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.errorContainer,
      child: ListTile(
        title: Text(message),
        trailing: IconButton(
          tooltip: 'Retry',
          onPressed: onRetry,
          icon: const Icon(Iconsax.refresh),
        ),
      ),
    );
  }
}
