
import 'package:k_store/utils/constants/image_strings.dart';

import '../../features/shop/models/banner_model.dart';
import '../../routes/routes.dart';

class MDummyData {

  //Banners
  static final List<BannerModel> banners = [
    BannerModel(imageUrl: MImages.banner1, targetScreen: MRoutes.order, active: false),
    BannerModel(imageUrl: MImages.banner2, targetScreen: MRoutes.cart, active: true),
    BannerModel(imageUrl: MImages.banner3, targetScreen: MRoutes.favourites, active: true),
    BannerModel(imageUrl: MImages.banner4, targetScreen: MRoutes.search, active: true),
    BannerModel(imageUrl: MImages.banner5, targetScreen: MRoutes.settings, active: true),
    BannerModel(imageUrl: MImages.banner6, targetScreen: MRoutes.userAddress, active: true),
    BannerModel(imageUrl: MImages.banner7, targetScreen: MRoutes.checkout, active: false),
  ];
}