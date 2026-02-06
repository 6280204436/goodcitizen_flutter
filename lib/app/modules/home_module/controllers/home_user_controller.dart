import 'package:geolocator/geolocator.dart';
import 'package:good_citizen/app/export.dart';
import 'package:good_citizen/app/modules/location_provider/current_location_provider.dart';

import '../../../core/widgets/show_dialog.dart';
import '../../authentication/models/response_models/user_response_model.dart';
import '../../profile/models/response_models/notification_model.dart';

class HomeUserController extends GetxController {
  final GlobalKey<State> dialogKey = GlobalKey();
  var islist = "true".obs;
  var isselected = "true".obs;
  var firstname = "".obs;
  var lastname = "".obs;
  var email = "";
  Rx<NotificationResponse?> notificationResponse =
      Rx<NotificationResponse?>(null);
  UserResponseModel? userResponseModel;

  @override
  void onInit() {
    initControllers();

    super.onInit();
  }

  void initControllers() async {
    print("Socket Controller call");

    if (Platform.isAndroid) {
      bool? result = await _showBgLocationWarning();

      if (result == true) {
        if (!Get.isRegistered<CurrentLocationProvider>() &&
            Platform.isAndroid) {
          currentLocationProvider = Get.put(CurrentLocationProvider());
          currentLocationProvider.startLiveTracking();
        }
      }
    }
    getNotification();
  }

  Future getNotification({bool showLoader = true}) async {
    debugPrint("Inside the notification history");
    try {
      if (showLoader) {
        customLoader.show(Get.context);
      }

      await repository.getNotifications({
        "status": isselected.value == "true" ? "STARTED" : "COMPLETED",
        "pagination": 0,
        "limit": 10
      }).then((value) async {
        notificationResponse.value = value;
        print("value,>>>>>>>>>>>>>>$value");

        customLoader.hide();
      }).onError((error, stackTrace) {
        customLoader.hide();
      });
    } catch (e) {
      print(">>>>>>>>>>>>>$e");
    }
  }

  Future _showBgLocationWarning() async {
    bool result = false;
    if (await _hasBgLocationAccess()) {
      result = true;
    } else if ((await _hasBgLocationAccess() == false)) {
      await showAlertDialogNew(
        title: keyAlert.tr,
        buttonText: keyAccept.tr,
        subtitle: keyBgLocAlert.tr,
        onTap: () async {
          result = false;
          Get.back();
          _onBgLocationDenied();
        },
      );
    }
    return result;
  }

  Future<void> _onBgLocationDenied() async {
    await Get.dialog(
      Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: Get.width * 0.8),
            decoration: BoxDecoration(
              color: isDarkMode.value ? Colors.black : AppColors.whiteAppColor,
              borderRadius: BorderRadius.circular(radius_8),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: isDarkMode.value
                    ? AppColors.whiteLight
                    : AppColors.whiteAppColor,
                borderRadius: BorderRadius.circular(radius_8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextView(
                    text: keyBgLocationNotGranted.tr,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    textStyle: textStyleTitleLarge()!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ).paddingOnly(top: margin_6),
                  TextView(
                    text: keyPlsProvideBgAccess.tr,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    textStyle: textStyleBodyLarge()!
                        .copyWith(fontWeight: FontWeight.w500),
                  ).paddingOnly(top: margin_6, bottom: margin_8),
                  _rowIconWidget(icon: '1.', text: keyOpenTheSettingsApps.tr),
                  _rowIconWidget(icon: '2.', text: keySelectLocationServ.tr),
                  _rowIconWidget(icon: '3.', text: keyChangeLocPermission.tr)
                      .paddingOnly(bottom: margin_3),
                  CustomMaterialButton(
                    onTap: () async {
                      Get.back();

                      // Open device location settings
                      await Geolocator.openLocationSettings();

                      // Recheck permission status
                      LocationPermission permission =
                          await Geolocator.checkPermission();

                      if (permission == LocationPermission.always) {
                        // Optional: warn user about background tracking
                        bool? result = await _showBgLocationWarning();

                        if (result == true) {
                          // Start live tracking if provider not registered
                          if (!Get.isRegistered<CurrentLocationProvider>()) {
                            currentLocationProvider =
                                Get.put(CurrentLocationProvider());
                          }
                          currentLocationProvider.startLiveTracking();
                        }
                      } else {
                        // You may show a toast/snackbar if permission still not granted
                        Get.snackbar("Permission not granted",
                            "Background location access is still required.");
                      }
                    },
                    buttonText: keyGoToSettings.tr,
                    buttonHeight: height_34,
                  ),
                ],
              ).paddingSymmetric(vertical: margin_12, horizontal: margin_12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rowIconWidget({String? icon, String? text}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.centerRight,
            child: TextView(
              text: icon ?? '',
              textStyle:
                  textStyleBodyLarge()!.copyWith(fontWeight: FontWeight.w500),
              textAlign: TextAlign.left,
            ),
          ),
        ),
        Expanded(
          flex: 8,
          child: TextView(
            text: text ?? '',
            maxLines: 5,
            textStyle:
                textStyleBodyLarge()!.copyWith(fontWeight: FontWeight.w500),
            textAlign: TextAlign.left,
          ).paddingOnly(left: margin_5),
        )
      ],
    ).paddingOnly(bottom: margin_7);
  }

  Future<bool> _hasBgLocationAccess() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (serviceEnabled == false) {
      return false;
    }

    if (Platform.isAndroid) {
      return (await Permission.locationAlways.isGranted);
    } else {
      final permission = await Geolocator.checkPermission();

      return (permission == LocationPermission.always);
    }
  }

  @override
  void onReady() {
    debugPrint("onReady Call=>");
    loadProfile();

    super.onReady();
  }

  void loadProfile() {
    customLoader.show(Get.context);

    repository.getProfileApiCall().then((value) async {
      update();
      if (value != null) {
        userResponseModel = value;
        update();

        firstname.value = userResponseModel?.data?.firstname ?? "";
        lastname.value = userResponseModel?.data?.lastname ?? "";
        email = userResponseModel?.data?.email ?? "";
        firstname.refresh();
        lastname.refresh();

        currentLocationProvider = Get.put(CurrentLocationProvider());
        currentLocationProvider.startLiveTracking();
        customLoader.hide();
      }
    }).onError((error, stackTrace) {
      customLoader.hide();
      update();
      debugPrint('error>>$error');
    });
  }

  @override
  void onClose() {
    super.onClose();
  }
}
