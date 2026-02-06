import 'package:good_citizen/app/export.dart';
import 'package:good_citizen/app/modules/authentication/models/response_models/user_response_model.dart';
import 'package:good_citizen/app/modules/profile/views/change_theme_view.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../location_provider/current_location_provider.dart';
import '../../location_provider/native_location_services.dart';
import '../../socket_controller/socket_controller.dart';
import 'currency_language_controller.dart';

class MyDocumentViewController extends GetxController {
  bool isLoading = false;
  bool isFromRideScreen = false;
  Rx<UserResponseModel?> userResponseModel = Rx<UserResponseModel?>(null);
  late TextEditingController confimPasswordController;
  late FocusNode confirmFocusNode;

  var useremail="".obs;
  var name="".obs;
  var loyaltyPoints="0".obs;

  @override
  void onInit() {
    confimPasswordController = TextEditingController();
    confirmFocusNode = FocusNode();


    super.onInit();
  }


  @override
  void onReady() {
    loadProfile();
    super.onReady();
  }


  Future<void> goToWebPage(String urlString) async {
    final Uri _url = Uri.parse(urlString);
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  void loadProfile() {
    customLoader.show(Get.context);

    repository.getProfileApiCall().then((value) async {

      update();
      if (value != null) {
        userResponseModel.value = value;
        update();
        print(userResponseModel?.value?.data?.email);
        useremail.value= userResponseModel?.value?.data?.email??"";
        name.value= "${userResponseModel?.value?.data?.firstname??""} ${userResponseModel?.value?.data?.lastname??""}"??"";
        if(userResponseModel?.value?.data?.loyaltypoint!=null){
          loyaltyPoints.value=userResponseModel?.value?.data?.loyaltypoint.toString()??"0";

        }
        loyaltyPoints.refresh();
       confimPasswordController.text=userResponseModel?.value?.data?.hospitalDoc??"";
        customLoader.hide();


      }
    }).onError((error, stackTrace) {

      customLoader.hide();
      update();
      debugPrint('error>>$error');
    });
  }

  void logout() {
    repository.logoutApiCall().then((value) {
      if (value != null) {
        preferenceManager.clearLoginData();

        Get.offAllNamed(AppRoutes.loginRoute);

      }
    }).onError((error, stackTrace) {
      showSnackBar(message: error.toString());
    });
  }

  void DeleteAccount() {
    repository.DeleteAccount().then((value) {
      if (value != null) {
        preferenceManager.clearLoginData();

        Get.offAllNamed(AppRoutes.loginRoute);

      }
    }).onError((error, stackTrace) {
      showSnackBar(message: error.toString());
    });
  }


  void changeTheme() {
    Get.dialog(const ChangeThemeView());
  }

  @override
  void onClose() {
    Get.delete<MyDocumentViewController>();
    super.onClose();
  }

}