import 'package:avatar_course2_5_shop/config/dependancy_injection.dart';
import 'package:avatar_course2_5_shop/core/storage/local/database/shared_preferences/app_settings_shared_preferences.dart';
import 'package:avatar_course2_5_shop/core/storage/remote/firebase/controllers/fb_auth_controller.dart';
import 'package:avatar_course2_5_shop/features/home/data/data_source/home_api_controller.dart';
import 'package:avatar_course2_5_shop/features/home/presentation/model/home_model.dart';
import 'package:avatar_course2_5_shop/features/product_details/domain/model/product_details_model.dart';
import 'package:avatar_course2_5_shop/features/product_details/domain/use_case/product_details_use_case.dart';
import 'package:avatar_course2_5_shop/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_render_dialog/flutter_state_render_dialog.dart';
import 'package:get/get.dart';
import '../../../../core/constants.dart';
import '../../../../core/resources/manager_assets.dart';
import '../../../../core/resources/manager_height.dart';
import '../../../../core/resources/manager_width.dart';
import '../model/category_model.dart';

class HomeController extends GetxController {
  List<CategoryModel> categories = [];
  HomeModel homeModel = HomeModel(data: [], success: true, status: 200);
  ProductDetailsModel productDetailsModel =
      ProductDetailsModel(data: [], success: true, status: 200);
  HomeApiController homeApiController = HomeApiController();
  AppSettingsSharedPreferences appSettingsSharedPreferences =
      AppSettingsSharedPreferences();
  List<HomeDataModel> featuredProducts = [];
  List<HomeDataModel> discountedProducts = [];
  ProductDetailsUseCaseImplementation productDetailsUseCase =
      instance<ProductDetailsUseCaseImplementation>();
  FbAuthController _fbAuthController = FbAuthController();

  @override
  void onInit() {
    super.onInit();
    readCategories();
    readHome();
  }

  performLogout() {
    dialogRender(
      context: Get.context!,
      stateRenderType: StateRenderType.popUpLoadingState,
      message: 'Loading...',
      title: '',
    );
    _fbAuthController.logout();
    Get.back();
    if (!_fbAuthController.loggedIn()) {
      dialogRender(
        context: Get.context!,
        stateRenderType: StateRenderType.popUpSuccessState,
        message: 'Logout Successfully',
        title: '',
      );

      Get.back();
      Get.offAllNamed(Routes.authenticationView);
    } else {
      dialogRender(
        context: Get.context!,
        stateRenderType: StateRenderType.popUpErrorState,
        message: 'Logout Failed',
        title: '',
      );
      Get.back();
    }
  }

  readCategories() async {
    categories = await homeApiController.categories(context: Get.context!);
    update();
  }

  readHome() async {
    homeModel = await homeApiController.home(context: Get.context!);
    for (HomeDataModel item in homeModel.data) {
      if (item.featured == 1) {
        featuredProducts.add(item);
      }

      if (item.discount > 0) {
        discountedProducts.add(item);
      }
    }
    update();
  }

  readProductDetails(int id) async {
    BuildContext context = Get.context!;
    (await productDetailsUseCase.execute(ProductDetailsUseCaseInput(id: id)))
        .fold((l) {
      dialogRender(
        context: context,
        stateRenderType: StateRenderType.popUpErrorState,
        message: l.message,
        title: '',
      );
    }, (r) {
      productDetailsModel = r;
    });
    update();
  }

  Widget image({required String courseAvatar, String? defaultImage}) {
    if (isURLValid(courseAvatar)) {
      return Image.network(
        courseAvatar,
        fit: BoxFit.fill,
        width: double.infinity,
      );
    }

    return Image.asset(
      defaultImage ?? ManagerAssets.product,
      fit: BoxFit.fill,
      width: ManagerWidth.w156,
      height: ManagerHeight.h148,
    );
  }

  String productPrice(String price, String unit) {
    return ' \$ $price \\$unit'.toUpperCase();
  }

  String productRating(String rate) {
    return '($rate)';
  }

  int bestItemsCard(int length) {
    return length > 4 ? 4 : length;
  }

  productDetails(BuildContext context, int productId) {
    readProductDetails(productId);
    Navigator.pushNamed(context, Routes.itemDetails);
  }
}
