import 'dart:async';

import 'package:avatar_course2_5_shop/core/storage/remote/firebase/controllers/fb_auth_controller.dart';
import 'package:get/get.dart';
import '../../../../core/constants.dart';
import '../../../../core/storage/local/database/shared_preferences/app_settings_shared_preferences.dart';
import '../../../../route/routes.dart';

class SplashController extends GetxController {
  AppSettingsSharedPreferences appSettingsSharedPreferences =
      AppSettingsSharedPreferences();
  late StreamSubscription _streamSubscription;
  FbAuthController _fbAuthController = FbAuthController();

  @override
  void onInit() {
    super.onInit();
    // appSettingsSharedPreferences.clear();
    Future.delayed(
        const Duration(
          seconds: Constants.splashTime,
        ), () {
      _streamSubscription =
          _fbAuthController.checkUserStatus(({required bool loggedIn}) {
        String route = loggedIn
            ? Routes.homeView
            : appSettingsSharedPreferences.outBoardingViewed
                ? Routes.authenticationView
                : Routes.outBoardingScreen;
            Get.offAllNamed(route);
          });
      // String route = appSettingsSharedPreferences.loggedIn
      //     ? Routes.homeView
      //     : appSettingsSharedPreferences.outBoardingViewed ? Routes
      //     .authenticationView : Routes.outBoardingScreen;
      //
      // Get.offAllNamed(route);
    });
  }
}
