import 'package:geolocator/geolocator.dart';
import 'package:good_citizen/app/core/external_packages/google_places/google_places_flutter.dart';
import 'package:good_citizen/app/export.dart';
import 'package:good_citizen/app/modules/home_module/models/response_models/start_ride_reponse_model.dart';
import 'package:good_citizen/app/modules/model/lat_lng_model.dart';
import '../../../core/external_packages/google_places/model/prediction.dart'
    as pre;
import '../../../core/utils/location_detail_providers.dart';
import '../../../core/utils/location_services/location_data_model.dart';
import '../../authentication/models/auth_request_model.dart';

class PicupController extends GetxController {
  LocationDetailDataModel? geoCodeResultForPayout;
  late FocusNode streetDropFocusNode;
  late FocusNode streetFocusNode;
  late TextEditingController streetController;
  late TextEditingController streetDropController;
  LatLongModel? picuplatlong;
  LatLongModel? destinationlatlng;
  RxBool isEdited = false.obs;

  @override
  void onInit() {
    _initControllers();
    streetDropFocusNode.addListener(() {
      if (streetDropFocusNode.hasFocus) {
        streetDropController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: streetDropController.text.length,
        );
      }
    });
    streetFocusNode.addListener(() {
      if (streetFocusNode.hasFocus) {
        streetController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: streetController.text.length,
        );
      }
    });
    super.onInit();
  }

  @override
  void onReady() {
    fetchCurrentLocation();
    super.onReady();
  }

  void _initControllers() {
    streetController = TextEditingController();
    streetFocusNode = FocusNode();
    streetDropController = TextEditingController();
    streetDropFocusNode = FocusNode();
  }

  void onPlaceTap(pre.Prediction postalCodeResponse) async {
    customLoader.show(Get.context);
    await _loadPlaceDetails(postalCodeResponse.placeId);
    customLoader.hide();
  }

  Future _loadPlaceDetails(var placeId) async {
    await repository
        .getLocationDetailApiCall(placeId: placeId)
        .then((value) async {
      LocationDetailDataModel? locationHintDataModel = value;
      print(locationHintDataModel?.results);
      geoCodeResultForPayout = locationHintDataModel;
      _loadAddressDetails();
      customLoader.hide();
    }).onError((error, stackTrace) {
      customLoader.hide();
    });
  }

  Future<void> fetchCurrentLocation() async {
    customLoader.show(Get.context);
    try {
      // Check location permissions
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        customLoader.hide();
        Get.snackbar(
          "Location Error",
          "Location services are disabled. Please enable them.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          customLoader.hide();
          Get.snackbar(
            "Location Error",
            "Location permissions are denied.",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        customLoader.hide();
        Get.snackbar(
          "Location Error",
          "Location permissions are permanently denied.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Fetch current location
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Update pickup coordinates
      picuplatlong =
          LatLongModel(lat: position.latitude, long: position.longitude);

      // Reverse geocode to get address
      await repository
          .getLocationDetailApiCall(latLongModel: picuplatlong)
          .then((value) {
        LocationDetailDataModel? locationHintDataModel = value;
        geoCodeResultForPayout = locationHintDataModel;
        streetController.text =
            (geoCodeResultForPayout?.results?.isNotEmpty ?? false)
                ? geoCodeResultForPayout?.results?.first?.formattedAddress ?? ""
                : "";
        isEdited.value = true;
        customLoader.hide();
      }).onError((error, stackTrace) {
        customLoader.hide();
        Get.snackbar(
          "Location Error",
          "Failed to fetch address: $error",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      });
    } catch (e) {
      customLoader.hide();
      Get.snackbar(
        "Location Error",
        "An error occurred: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void _disposeControllers() {
    streetController.dispose();
    streetFocusNode.dispose();
    streetDropController.dispose();
    streetDropFocusNode.dispose();
  }

  void _loadAddressDetails() {
    isEdited.value = true;
    final street = getStreetNameFromGeocodeResult(geoCodeResultForPayout);
    if (streetFocusNode.hasFocus) {
      print("The FocusNode is currently focused.");
      streetController.text =
          (geoCodeResultForPayout?.results?.isNotEmpty ?? false)
              ? geoCodeResultForPayout?.results?.first?.formattedAddress ?? ""
              : "";
      picuplatlong = getLatLngFromGeocodeResult(geoCodeResultForPayout);
      print("${getLatLngFromGeocodeResult(geoCodeResultForPayout)?.lat}");
    } else {
      print("The FocusNode is not focused.");
      streetDropController.text =
          (geoCodeResultForPayout?.results?.isNotEmpty ?? false)
              ? geoCodeResultForPayout?.results?.first?.formattedAddress ?? ""
              : "";
      destinationlatlng = getLatLngFromGeocodeResult(geoCodeResultForPayout);
      print("${getLatLngFromGeocodeResult(geoCodeResultForPayout)?.lat}");
    }
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void validate() async {
    final pickupText = streetController.text.trim();
    final dropText = streetDropController.text.trim();

    if (pickupText.isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Pickup address cannot be empty",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (dropText.isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Drop address cannot be empty",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    Map<String, dynamic> requestModel = AuthRequestModel.startride(
      pickupLocation: picuplatlong,
      dropLocation: destinationlatlng,
      pickupaddress: pickupText,
      dropaddress: dropText,
    );

    _handleSubmit(requestModel);
  }

  _handleSubmit(var data) {
    repository.startRideApiCall(dataBody: data).then((value) async {
      if (value != null) {
        Get.back();
      }
    }).onError((er, stackTrace) {
      print("$er");
    });
  }

  @override
  void onClose() {
    _disposeControllers();
    super.onClose();
  }
}
