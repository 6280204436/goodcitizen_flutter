import 'package:good_citizen/app/core/values/theme_controller.dart';
import 'package:good_citizen/app/export.dart';
import 'package:good_citizen/app/modules/home_module/controllers/home_controller.dart';
// import 'package:good_citizen/app/modules/ongoing_ride/controllers/ongoing_ride_controller.dart';
import 'package:good_citizen/app/modules/socket_controller/socket_controller.dart';
import 'app/modules/location_provider/current_location_provider.dart';
import 'app/modules/location_provider/native_location_services.dart';
import 'app/push_notifications/fcm_navigator.dart';

class UserStatusController extends SuperController {
  bool isInBackground = false;
  @override
  void onDetached() {
    // isAppInForeground = false;
    // if (Get.isRegistered<SocketController>()) {
    //   socketController.socketEmit(event: socketEventCloseConnection);
    // }
    // if (profileDataProvider.userDataModel.value?.status == driverStateOffline) {
    //   NativeLocationServices.stopForegroundService();
    // }
  }

  @override
  void onInactive() {
    // isAppInForeground = false;
  }

  @override
  void onPaused() {
    isInBackground = true;
    // isAppInForeground = false;
  }

  @override
  void onResumed() {
    if (isInBackground) {
      _refreshSocket();
      isInBackground = false;
    }

    // isAppInForeground = true;
    _checkForNewRides();
    _checkRideStatus();
    _checkLocation();
    _loadLocationData();
    _forceReRenderMap();
  }

  @override
  void onHidden() {
    // isAppInForeground = false;
  }

  void _refreshSocket() {
    // if (Get.isRegistered<SocketController>()) {
    //   socketController.reConnectSocket();
    // }
  }

  void _checkLocation() {
    // if (Get.isRegistered<HomeController>()) {
    //   Get.find<HomeController>().checkLocationAlwaysAllowed();
    // }
  }

  void _loadLocationData() async {
    if (Get.isRegistered<CurrentLocationProvider>()) {
      await currentLocationProvider.loadCurrentLocation(showLocDialog: false);
    }
  }

  void _checkForNewRides() {
    // if (Get.isRegistered<SocketController>()) {
    //   socketController.socketEmit(event: socketEventNewRideRequest);
    // }
  }


  void _checkRideStatus() async {
    // await profileDataProvider.reloadProfile(showLoader: false);
    // if (Get.isRegistered<HomeController>() && avoidBookingCheckOnProfileReload==false) {
    //   Get.find<HomeController>().checkForCurrentBooking();
    // }
  }

  void _forceReRenderMap() {
    if (Platform.isAndroid) {
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().mapController?.setMapStyle(Get.find<ThemeController>().getMapTheme());
      }
      // if (Get.isRegistered<OngoingRideController>()) {
      //   Get.find<OngoingRideController>().mapController?.setMapStyle(Get.find<ThemeController>().getMapTheme());
      // }
    }
  }


}
void disableBookingCheckInProfile()
{

  /// disables for temp 5 seconds
  avoidBookingCheckOnProfileReload=true;
  Future.delayed(const Duration(seconds: 5),() {
    avoidBookingCheckOnProfileReload=false;
    /// to avoid checking current booking in super controller
  },);
}

