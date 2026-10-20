import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k_store/common/widgets/appbar/appbar.dart';
import 'package:k_store/common/widgets/shimmers/vertical_product_shimmer.dart';
import 'package:k_store/features/shop/controllers/products/all_products_controller.dart';
import 'package:k_store/features/shop/models/product_model.dart';
import 'package:k_store/utils/constants/sizes.dart';
import 'package:k_store/utils/helpers/cloud_helper_functions.dart';

import '../../../../common/widgets/products/sortable/sortable_products.dart';

class AllProducts extends StatelessWidget {
  const AllProducts({super.key, required this.title, this.query, this.futureMethod});

  final String title;
  final Query? query;
  final Future<List<ProductModel>>? futureMethod;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AllProductsController());
    
    return Scaffold(
      appBar: MAppBar(title: Text(title), showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(MSizes.defaultSpace),
          child: FutureBuilder(
            future: futureMethod ?? controller.fetchProductsByQuery(query),
            builder: (context, snapshot) {
              //Check the state of the FutureBuilder snapshot
              const loader = MVerticalProductShimmer();

              final widget = MCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot, loader: loader);

              ///Return appropriate widget based on snapshot state
              if (widget !=null) return widget;

              // if(snapshot.connectionState == ConnectionState.waiting) {
              //   return loader;
              // }
              // if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
              //   return const Center(child: Text('No Data Found!'));
              // }
              // if (snapshot.hasError) {
              //   return const Center(child: Text('Something went wrong getting all products'));
              // }

              //Products found!
              final products = snapshot.data!;
              return MSortableProducts(products: products);
            }
          ),
        ),
      ),
    );
  }
}
