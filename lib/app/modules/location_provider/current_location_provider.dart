import 'package:get/get.dart';
import 'package:good_citizen/app/core/values/app_constants.dart';
import 'package:good_citizen/app/modules/home_module/controllers/driver_loc_updater.dart';
import 'package:good_citizen/app/modules/home_module/controllers/home_controller.dart';
import 'package:good_citizen/app/modules/location_provider/native_location_services.dart';

import '../../../main.dart';
import '../../core/utils/location_services/address_provider.dart';
import '../../core/utils/location_services/lat_lng_provider.dart';
import '../../core/utils/location_services/location_data_model.dart';
import '../../export.dart';
import '../authentication/models/data_model/user_model.dart';
import '../model/lat_lng_model.dart';
import '../profile/models/address_data_model.dart';

class CurrentLocationProvider extends GetxController {
  bool isLoadingLocation = false;
  bool isCurrentLocationLoaded = false;
  LocationDetailDataModel? locationHintDataModel;
  AddressDataModel? _currentLocation;
  Map<String, Function(AddressDataModel)> onLocationChangeListeners = {};

  @override
  void onInit() {
    loadCurrentLocation();
    _addLocationListener();
    super.onInit();
  }

  void _addLocationListener() {
    Future.delayed(
      const Duration(seconds: 2),
      () {
        _listenToLocationChanges();
      },
    );
  }

  AddressDataModel? getCurrentLocation() {
    return _currentLocation;
  }

  Future loadCurrentLocation(
      {bool showLocDialog = true,
      bool showLoader = false,
      bool forceReload = false,
      bool showLoading = false}) async {
    if (forceReload == false &&
        (_currentLocation?.formattedAddress != null) &&
        (isCurrentLocationLoaded || isLoadingLocation)) {
      isLoadingLocation = false;
      return;
    }
    if (showLoading) {
      customLoader.show(Get.context);
    }
    isLoadingLocation = true;
    _currentLocation = await preferenceManager.getSavedAddress();
    await getCurrentPosition(showLocDialog: showLocDialog, showLoader: false)
        .then((value) async {
      customLoader.hide();
      if (value == null) {
        isLoadingLocation = false;
        return;
      }
      _currentLocation =
          AddressDataModel(lat: value.latitude, long: value.longitude);
      _currentLocation?.setHeading(value.heading);
      _notifyListeners(AddressDataModel(
          lat: value.latitude,
          long: value.longitude,
      ));

      // if (profileDataProvider.userDataModel.value?.status ==
      //         driverStateOnline ||
      //     profileDataProvider.userDataModel.value?.currentBooking != null) {
      //   /// to auto start live tracking the driver
      //   if (Get.isRegistered<HomeController>()) {
      //     if ((profileDataProvider.userDataModel.value?.status ==
      //             driverStateOffline &&
      //         profileDataProvider.userDataModel.value?.currentBooking !=
      //             null)) {
      //       Get.find<HomeController>().goOnline();
      //     } else {
      //       Get.find<HomeController>().goOnline(updateStatus: false);
      //     }
      //   }
      // }

      isCurrentLocationLoaded = true;
      // updateDriverLocation(value.latitude, value.longitude,
      //     heading: value.heading != -1 ? value.heading : null);
      await _getCurrentAddress();
      preferenceManager.saveAddress(_currentLocation);
      isLoadingLocation = false;
    }).onError(
      (error, stackTrace) {
        customLoader.hide();
        isLoadingLocation = false;
      },
    );
  }

  Future _getCurrentAddress() async {
    if (_currentLocation?.lat == null || _currentLocation?.long == null) {
      return;
    }
    // if (Get.context != null) {
    //   customLoader.show(Get.context);
    // }
    await repository
        .getLocationDetailApiCall(
            latLongModel: LatLongModel(
                lat: _currentLocation?.lat, long: _currentLocation?.long))
        .then((value) async {
      customLoader.hide();
      locationHintDataModel = value;
      if (locationHintDataModel != null &&
          ((locationHintDataModel?.results ?? []).isNotEmpty) &&
          (locationHintDataModel?.results?[0].formattedAddress != null &&
              locationHintDataModel?.results?[0].formattedAddress != '')) {
        _currentLocation?.formattedAddress =
            (locationHintDataModel?.results?[0].formattedAddress ?? '')
                .trim()
                .replaceAll('+', '');
      } else {
        getAddressFromLatLng(LatLongModel(
                lat: _currentLocation?.lat, long: _currentLocation?.long))
            .then((placeMark) {
          customLoader.hide();
          _currentLocation?.formattedAddress =
              ('${placeMark?.name ?? ''} ${placeMark?.locality ?? ''} ${placeMark?.administrativeArea ?? ''}'
                      .trim())
                  .trim()
                  .replaceAll('+', '');
        }).onError(
          (error, stackTrace) {
            customLoader.hide();
          },
        );
      }
    }).onError((error, stackTrace) {
      customLoader.hide();
    });
  }

  Future<String?> getLocationDetailFromLatLong(
      {double? lat, double? long}) async {
    String? result;
    await repository
        .getLocationDetailApiCall(
            latLongModel: LatLongModel(
                lat: _currentLocation?.lat, long: _currentLocation?.long))
        .then((value) async {
      customLoader.hide();
      LocationDetailDataModel? locationHintDataModel = value;
      if (locationHintDataModel != null &&
          (locationHintDataModel.results?[0].formattedAddress != null &&
              locationHintDataModel.results?[0].formattedAddress != '')) {
        result = (locationHintDataModel.results?[0].formattedAddress ?? '')
            .trim()
            .replaceAll('+', '');
      }
    });
    return result;
  }

  void startLiveTracking() async {
    NativeLocationServices.startForegroundService();

    // bg.BackgroundLocation.stopLocationService();
    // bg.BackgroundLocation.startLocationService(distanceFilter: 10,forceAndroidLocationManager: true);
    // bg.BackgroundLocation.getLocationUpdates(_notifyListeners);
  }

  void _listenToLocationChanges() {
    // socketController.addSocketEventListener(
    //   event: socketEventUpdateLocation,
    //   onEvent: (data) {
    //     if (data != null) {
    //       final driverData = UserDataModel.fromJson(data);
    //       _notifyListeners(AddressDataModel(
    //           lat: driverData.latitude,
    //           long: driverData.longitude,
    //       ));
    //     }
    //   },
    // );
  }

  void _notifyListeners(AddressDataModel location) {
    for (var fun in onLocationChangeListeners.values) {
      fun.call(location);
    }
  }

  void addOnChangeListener(String id, Function(AddressDataModel) onchangeListener) {
    onLocationChangeListeners.putIfAbsent(id, () => onchangeListener);
  }

  void removeOnChangeListener(String id) {
    onLocationChangeListeners.remove(id);
  }

  @override
  void onClose() {
    // bg.BackgroundLocation.stopLocationService();
    super.onClose();
  }
}
