import 'package:get/get.dart';
import 'package:tasoclean/features/authentication/screens/login/login.dart';
import 'package:tasoclean/features/authentication/screens/onboarding/onboarding.dart';
import 'package:tasoclean/features/authentication/screens/password_configuration/forgot_password.dart';
import 'package:tasoclean/features/authentication/screens/sigup/signup.dart';
import 'package:tasoclean/features/authentication/screens/sigup/verify_email.dart';
import 'package:tasoclean/features/personalization/views/address/address.dart';
import 'package:tasoclean/features/personalization/views/profile/profile.dart';
import 'package:tasoclean/features/personalization/views/settings/settings.dart';
import 'package:tasoclean/features/shop/screens/cart/cart.dart';
import 'package:tasoclean/features/shop/screens/checkout/checkout.dart';
import 'package:tasoclean/features/shop/screens/home/home.dart';
import 'package:tasoclean/features/shop/screens/order/Order.dart';
import 'package:tasoclean/features/shop/screens/product_reviews/product_reviews.dart';
import 'package:tasoclean/features/shop/screens/store/store.dart';
import 'package:tasoclean/features/shop/screens/wishlist/wishlist.dart';
import 'package:tasoclean/routes/routes.dart';

class AppRoutes {
  static final pages = [
    GetPage(name: MRoutes.home, page: () => const HomeScreen()),
    GetPage(name: MRoutes.store, page: () => const StoreScreen()),
    GetPage(name: MRoutes.favourites, page: () => const FavouriteScreen()),
    GetPage(name: MRoutes.settings, page: () => const SettingsScreen()),
    GetPage(
        name: MRoutes.productReviews, page: () => const ProductReviewsScreen()),
    GetPage(name: MRoutes.order, page: () => const OrderScreen()),
    GetPage(name: MRoutes.checkout, page: () => const CheckoutScreen()),
    GetPage(name: MRoutes.cart, page: () => const CartScreen()),
    GetPage(name: MRoutes.userProfile, page: () => const ProfileScreen()),
    GetPage(name: MRoutes.userAddress, page: () => const UserAddressScreen()),
    GetPage(name: MRoutes.signup, page: () => const SignupScreen()),
    GetPage(name: MRoutes.verifyEmail, page: () => const VerifyEmailScreen()),
    GetPage(name: MRoutes.signIn, page: () => const LoginScreen()),
    GetPage(name: MRoutes.forgetPassword, page: () => const ForgetPassword()),
    GetPage(name: MRoutes.onBoarding, page: () => const OnBoardingScreen()),
  ];
}
