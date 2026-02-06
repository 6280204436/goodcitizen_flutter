import 'package:app_links/app_links.dart';
import 'package:good_citizen/app/export.dart';

import '../../../services/native_ios_service.dart';
import '../../authentication/models/data_model/user_model.dart';
import '../../authentication/models/response_models/user_response_model.dart';

class SplashController extends GetxController {
  Timer? timer;
  bool isLoading = false;
  // final appLinks = AppLinks();
  final nativeIOSService = Get.put(NativeIOSService());
  // @override
  void onInit() {
    _navigateToNextScreen();
    // appLinks.uriLinkStream.listen((uri) {
    //  print(">>>>>>>>>>>hello deep link" );
    // });
    super.onInit();
  }

  void _navigateToNextScreen() async {
    _loadProfile();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void _loadProfile() {
    isLoading = true;
    update();
    repository.getProfileApiCall().then((value) async {
      isLoading = false;
      update();
      if (value != null) {
        UserResponseModel userResponseModel = value;
        if (userResponseModel.data?.role == "USER") {
          Get.offAllNamed(AppRoutes.homeRouteUser);
          await Future.delayed(Duration(milliseconds: 500));
          final success = await nativeIOSService
              .setAuthToken(userResponseModel.data?.accessToken ?? "");
          if (success) {
          } else {
            print('⚠️ Failed to set auth token, retrying...');
          }
        } else {
          // if(userResponseModel.data.)
          Get.offAllNamed(AppRoutes.homeRoute);
        }
      }
    }).onError((error, stackTrace) {
      isLoading = false;
      Get.offNamed(AppRoutes.welcomeRoute);
      update();
      debugPrint('error>>$error');
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
