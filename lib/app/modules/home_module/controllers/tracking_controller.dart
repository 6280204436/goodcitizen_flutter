

import 'package:good_citizen/app/modules/authentication/models/response_models/forget_password_response_model.dart';
import 'package:good_citizen/app/modules/home_module/models/response_models/start_ride_reponse_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_ringtone_manager/flutter_ringtone_manager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:good_citizen/app/common_data.dart';
import 'package:good_citizen/app/export.dart';
import 'package:good_citizen/app/modules/authentication/models/auth_request_model.dart';
import 'package:good_citizen/app/modules/home_module/controllers/driver_loc_updater.dart';
import 'package:good_citizen/app/modules/home_module/models/data_models/booking_data_model.dart';
import 'package:good_citizen/app/modules/home_module/providers/map_icon_provider.dart';

import 'package:good_citizen/app/push_notifications/fcm_event_listener.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

import '../../../../remote_config.dart';
import '../../../core/external_packages/flutter_polyline/lib/flutter_polyline_points.dart';
import '../../../core/utils/show_bottom_sheet.dart';
import '../../../core/widgets/show_dialog.dart';
import '../../../push_notifications/fcm_navigator.dart';
import '../../authentication/models/response_models/user_response_model.dart';
import '../../location_provider/current_location_provider.dart';
import '../../location_provider/native_location_services.dart';

import '../../profile/models/address_data_model.dart';
import '../../socket_controller/socket_controller.dart';
import '../widgets/ride_request_widget.dart';
import '../widgets/verification_pending_widget.dart';

class TrackingController extends GetxController {
  final GlobalKey<State> dialogKey = GlobalKey();
  RxMap<PolylineId, Polyline> routePolylines = <PolylineId, Polyline>{}.obs;
  Rx<UserResponseModel?> userResponseModel = Rx<UserResponseModel?>(null);
  Rx<StartRideResponse?> startRideResponse = Rx<StartRideResponse?>(null);
  final String locationListenerId = 'home_location';
  IO.Socket? socket;
  // List to maintain historical route points
  final RxList<LatLng> routeCoordinates = <LatLng>[].obs;

  // Flag to determine if we're tracking a route
  RxBool isTrackingRoute = false.obs;

  // Destination information for route calculation
  Rxn<LatLng> destinationLocation = Rxn<LatLng>();

  Marker? driverMarker;
  bool isFirstPolyline = true;
  RxBool isLoading = false.obs;

  bool isSheetOpened = false;
  late FlutterRingtoneManager _flutterRingtoneManager;

  AddressDataModel? _userInitialLocation;
  final Rx<AddressDataModel> _userChangingLocation = AddressDataModel().obs;
  GoogleMapController? mapController;
  final Completer<GoogleMapController> completer = Completer<GoogleMapController>();
  late CameraPosition initialCameraPosition;
  RxMap<MarkerId, Marker> routeMarkers = <MarkerId, Marker>{}.obs;

  Rxn<BookingDataModel> rideRequestModel = Rxn();
  bool isCameraMovedFirstTime = false;
  Timer? _locationUpdateTimer;
  final int _updateIntervalSeconds = 5; // Reduced interval for smoother updates
  String? requestNotificationType;

  // Throttling parameters
  DateTime _lastUpdate = DateTime.now();
  final int _minimumUpdateIntervalMs = 500; // Minimum time between UI updates

  // Minimum distance threshold for adding new points to the polyline
  final double _minimumDistanceThreshold = 5.0; // in meters

  @override
  void onInit() {
    reloadProfile();
    initControllers();
    _loadInitialData();
    _startLocationUpdateTimer();
    socketConnection();
    super.onInit();
  }


  void _startLocationUpdateTimer() {
    // Cancel any existing timer
    _locationUpdateTimer?.cancel();

    // Create a new timer that fires every few seconds
    _locationUpdateTimer = Timer.periodic(Duration(seconds: _updateIntervalSeconds), (timer) {

      routePolylines.refresh();
     routeCoordinates.refresh();
     update();
     print(timer.tick);
      _updateCurrentLocation();
    });

    debugPrint('Location update timer started with interval of $_updateIntervalSeconds seconds');
  }

  void _updateCurrentLocation()async {
    // Check if we need to throttle updates
    final now = DateTime.now();


    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
    );
    if (position.latitude != null&&position.longitude!=null) {
      final currentLat = position?.latitude;
      final currentLong = position.longitude;

      if (currentLat != null && currentLong != null) {
        // Only update marker if we've moved significantly
        final newPosition = LatLng(currentLat, currentLong);


        // Update driver marker without rebuilding it
        _updateDriverMarker(currentLat, currentLong);

        // Update route if tracking
// showSnackBar(message: "$currentLat,$currentLong");


          _updateRouteWithNewPosition(newPosition, destinationLocation.value!);


        _lastUpdate = now; // Record this update time
      }
    }
  }


  socketConnection() {
    makeSocketConnection(
            (connected, socket) {
          print("Soket>>>>>>${socket}");
        }

    );
  }


  void makeSocketConnection(
      Function(bool connected, Socket socket) onConnected,
      ) {
    if (socket?.connected ?? false) {
      onConnected(true, socket!);
      socket!.onError((data) => debugPrint("checking here ERROR:$data"));
    } else {
      // String? token = preferenceManager.getAuthToken();
      // String? email = userDataModel?.email;

      String? token = preferenceManager.getAuthToken();

      debugPrint("socket token : $token ");
      socket = IO.io(
          baseUrl,
          OptionBuilder()
              .setTransports(['websocket'])
              .setQuery({
            'token': "Bearer $token",
          })
              .setAuth({
            'authtoken': token,
          })
              .setExtraHeaders({
            'token': " $token",
          })
              .enableForceNewConnection()
              .enableReconnection()
              .build());
      socket!.connect();

      socket!.onError((data) => debugPrint("socket ERROR:$data"));
      socket!.onConnect((data) {
        debugPrint("socket onConnect ");
        onConnected(true, socket!);
      });
    }

  }

  void socketDisconnect() {
    socket?.onDisconnect((data) => debugPrint("socket disconnect: $data"));
  }

  void socketDisconnects() async {
    try {
      socket?.clearListeners();
      await socket?.disconnect();
      await socket?.close();

      socket?.dispose();
      socket?.destroy();
      // Proceed with other operations
    } catch (e) {
      // Handle errors here
      debugPrint("socket socketDisconnects error: $e");
      print('Error while closing socket: $e');
    }
  }

  void _updateDriverMarker(double lat, double long) {
    // Check if marker exists already
    final markerId = MarkerId('driver_marker');
    if (routeMarkers.containsKey(markerId)) {
      // Update existing marker position instead of recreating
      final updatedMarker = routeMarkers[markerId]!.copyWith(
        positionParam: LatLng(lat, long),
        rotationParam: _userChangingLocation.value.getHeading ?? 0.0,
      );
      routeMarkers[markerId] = updatedMarker;
    } else {
      // Create new marker only if it doesn't exist
      createMyLocationMarker(lat, long, "CAR");
    }
    // Only call refresh if absolutely necessary
    // routeMarkers.refresh(); // Try to avoid this call if possible
  }

  // Update route with the new position
  void _updateRouteWithNewPosition(LatLng currentPosition, LatLng destination)async {
    // If the route is empty or we've moved significantly, add the point


      // Add the new position to our route history
      await getPolylinePoints(
      originLat:  currentPosition.latitude,
      originLng: currentPosition.longitude,
      destLat:  startRideResponse.value?.data?.dropLocation?.latitude?.toDouble()??0.0,
      destLng:startRideResponse.value?.data?.dropLocation?.longitude?.toDouble()??0.0,
      );
      _updatePolylineWithCurrentRoute();


      // Record the location with timestamp
      final locationData = {
        'lat': currentPosition.latitude,
        'long': currentPosition.longitude,
      };
      socket!.emit('driver_location', locationData);


    // Only move camera if needed (can be optional based on UX preferences)
    if (mapController != null) {
      mapController!.animateCamera(
          CameraUpdate.newLatLng(currentPosition)
      );
    }
  }

  // Calculate distance between two coordinates in meters
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }


// Update polyline using current route coordinates
  void _updatePolylineWithCurrentRoute() {


    // Use a consistent polyline ID
    final PolylineId id = const PolylineId('route_polyline');

    // Batch update - create a new map first, then replace all at once
    final Map<PolylineId, Polyline> updatedPolylines = Map.from(routePolylines);

    final polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: List.from(routeCoordinates), // Create a copy to avoid concurrent modification
      width: 5,
    );

    // Update the map with modified polyline
    updatedPolylines[id] = polyline;

    // Only refresh if polyline actually changed
    // if (!_arePolylinesEqual(routePolylines[id], updatedPolylines[id])) {
      routePolylines = updatedPolylines.obs;

      update();
      // Use a single update call instead of refresh()
    // }
  }

// Compare polylines to prevent unnecessary updates
  bool _arePolylinesEqual(Polyline? p1, Polyline? p2) {
    if (p1 == null || p2 == null) return p1 == p2;
    if (p1.points.length != p2.points.length) return false;

    // Compare key properties
    if (p1.color != p2.color || p1.width != p2.width) return false;

    // Sample comparison of point sets (for efficiency, you might only check first/last/count)
    // For complete comparison, you'd need to check all points
    return p1.points.first == p2.points.first &&
        p1.points.last == p2.points.last;
  }


  void initControllers() async {
    _flutterRingtoneManager = FlutterRingtoneManager();
    if (!Get.isRegistered<CurrentLocationProvider>()) {
      currentLocationProvider = Get.put(CurrentLocationProvider());
    }
  }

  @override
  void onReady() {
    debugPrint("onReady Call=>");
    // reloadProfile(showLoader: true);
    _listenToNewRideSocket();
    _listenToBookingAcceptedSocket();
    _checkForNewRides();

    _userChangingLocation.value = AddressDataModel(
        lat: _userInitialLocation?.lat, long: _userInitialLocation?.long);
    _userChangingLocation.value.setHeading(_userInitialLocation?.getHeading);

    // checkLocationAlwaysAllowed();
    loadProfile();
    super.onReady();
  }

  // Calculate a route between two points (origin and destination)
  Future<void> getPolylinePoints({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
    String? apiKey, // Your Google Maps API key
    bool resetRoute = true, // Whether to reset the current route
  }) async {
    // Set up destination for future tracking updates
    destinationLocation.value = LatLng(destLat, destLng);
    isTrackingRoute.value = true;

    // Reset route if needed
    if (resetRoute) {
      routeCoordinates.clear();
      routeCoordinates.add(LatLng(originLat, originLng)); // Add starting point
    }

    try {
      // Option 1: Using the flutter_polyline_points package with the updated API
      PolylinePoints polylinePoints = PolylinePoints();

      // Create the request object required by the updated API
      PolylineWayPoint? origin = PolylineWayPoint(
        location: "${originLat},${originLng}",
        stopOver: false,
      );

      PolylineWayPoint? destination = PolylineWayPoint(
        location: "${destLat},${destLng}",
        stopOver: false,
      );

      // Use the updated method with the correct parameters
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        request: PolylineRequest(
          origin: PointLatLng(originLat, originLng),
          destination: PointLatLng(destLat, destLng),
          mode: TravelMode.drive,
        ),
        googleApiKey: apiKey ?? "AIzaSyBioMK31w2-759jRzfev6Tpkdj9pe2eKrw",
      );

      // Process the polyline points if available
      if (result.points.isNotEmpty) {
        // Replace existing route with the calculated one
        routeCoordinates.clear();

        // Add all points from the API response
        for (var point in result.points) {
          routeCoordinates.add(LatLng(point.latitude, point.longitude));
        }

        // Update the polyline with the new route
        _updatePolylineWithCurrentRoute();

        // Move camera to show the route
        if (mapController != null) {
          LatLngBounds bounds = _createBoundsFromPoints(routeCoordinates);
          mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
        }
      } else {
        // Fallback to direct line if no route points returned
        debugPrint('No points found in polyline result, using direct line');
        _createDirectLine(originLat, originLng, destLat, destLng);
      }
    } catch (e) {
      debugPrint('Error getting polyline points: $e');
      // If the polyline points API fails, try the direct API call as a fallback
      await getDirectionsFromApi(
          originLat: originLat,
          originLng: originLng,
          destLat: destLat,
          destLng: destLng,
          apiKey: apiKey
      );
    }
  }

  // Alternative approach using direct API call for more reliability
  Future<void> getDirectionsFromApi({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
    String? apiKey, // Your Google Maps API key
  }) async {
    try {
      final String url =
          'https://maps.googleapis.com/maps/api/directions/json?'
          'origin=$originLat,$originLng'
          '&destination=$destLat,$destLng'
          '&key=${apiKey ?? "AIzaSyBioMK31w2-759jRzfev6Tpkdj9pe2eKrw"}';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded['status'] == 'OK') {
          // Set destination for future tracking
          destinationLocation.value = LatLng(destLat, destLng);
          isTrackingRoute.value = true;

          // Decode polyline points
          final points = PolylinePoints().decodePolyline(
              decoded['routes'][0]['overview_polyline']['points']
          );

          // Clear existing route
          routeCoordinates.clear();

          // Add all points from the API response
          for (var point in points) {
            routeCoordinates.add(LatLng(point.latitude, point.longitude));
          }

          // Update the polyline with the new route
          _updatePolylineWithCurrentRoute();

          // Update camera to show the entire route
          if (mapController != null && routeCoordinates.isNotEmpty) {
            LatLngBounds bounds = _createBoundsFromPoints(routeCoordinates);
            mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
          }
        } else {
          debugPrint('API returned status: ${decoded['status']}');
          _createDirectLine(originLat, originLng, destLat, destLng);
        }
      } else {
        debugPrint('API request failed with status: ${response.statusCode}');
        _createDirectLine(originLat, originLng, destLat, destLng);
      }
    } catch (e) {
      debugPrint('Error fetching directions: $e');
      _createDirectLine(originLat, originLng, destLat, destLng);
    }
  }

  // Helper method to create a direct line between two points as fallback
  void _createDirectLine(double originLat, double originLng, double destLat, double destLng) {
    // Set destination for future tracking
    destinationLocation.value = LatLng(destLat, destLng);
    isTrackingRoute.value = true;

    // Create a simple direct line
    routeCoordinates.clear();
    routeCoordinates.add(LatLng(originLat, originLng));
    routeCoordinates.add(LatLng(destLat, destLng));

    // Update the polyline
    _updatePolylineWithCurrentRoute();

    // if (mapController != null) {
    //   LatLngBounds bounds = _createBoundsFromPoints(routeCoordinates);
    //   mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    // }
  }

  // Helper method to create bounds for camera
  LatLngBounds _createBoundsFromPoints(List<LatLng> points) {
    double? x0, x1, y0, y1;

    for (LatLng point in points) {
      if (x0 == null) {
        x0 = x1 = point.latitude;
        y0 = y1 = point.longitude;
      } else {
        if (point.latitude > x1!) x1 = point.latitude;
        if (point.latitude < x0) x0 = point.latitude;
        if (point.longitude > y1!) y1 = point.longitude;
        if (point.longitude < y0!) y0 = point.longitude;
      }
    }

    return LatLngBounds(
      northeast: LatLng(x1!, y1!),
      southwest: LatLng(x0!, y0!),
    );
  }

  void createMyLocationMarker(lat, long, type) async {
    final imagePath = getMarkerImagePath(type);
    final markerId = MarkerId('driver_marker');

    // Check if marker already exists
    bool markerExists = routeMarkers.containsKey(markerId);

    final marker = await getMarkerImage(
      image: imagePath,
      height: type == "BIKE" ? height_30 : height_80,
      width: type == "BIKE" ? height_30 : height_90,
      lat: lat,
      long: long,
      // heading: _userChangingLocation.value.getHeading
    );

    if (marker != null) {
      // Update existing marker or add new one
      routeMarkers[markerId] = marker;

      // Only refresh if needed to avoid unnecessary UI updates
      if (!markerExists) {
        routeMarkers.refresh();
      }
    }
  }

  void loadProfile() {
    isLoading.value = true;
    update();
    repository.getProfileApiCall().then((value) async {
      update();
      if (value != null) {
        userResponseModel.value = value;
        update();
        isLoading.value = false;
        if (userResponseModel?.value?.data?.rideid != null) {
          _loadCurrentRideDetails();
        }
      }
    }).onError((error, stackTrace) {
      isLoading.value = false;
      update();
      debugPrint('error>>$error');
    });
  }

  void _loadCurrentRideDetails() {
    repository.getRideDetailsApiCall(userResponseModel?.value?.data?.rideid).then((value) async {
      update();
      if (value != null) {
        startRideResponse.value = value;

        // Create marker for pickup location
        if (startRideResponse.value?.data?.pickupLocation?.latitude != null &&
            startRideResponse.value?.data?.pickupLocation?.longitude != null) {
          createMyLocationMarker(
              startRideResponse.value?.data?.pickupLocation?.latitude,
              startRideResponse.value?.data?.pickupLocation?.longitude,
              "CAR"
          );
        }

        update();

        // Initialize route tracking if we have both pickup and dropoff locations
        if (startRideResponse.value?.data?.pickupLocation?.latitude != null &&
            startRideResponse.value?.data?.pickupLocation?.longitude != null &&
            startRideResponse.value?.data?.dropLocation?.latitude != null &&
            startRideResponse.value?.data?.dropLocation?.longitude != null) {

          // Get the initial route
          getPolylinePoints(
              originLat: startRideResponse.value?.data?.pickupLocation?.latitude ?? 0.0,
              originLng: startRideResponse.value?.data?.pickupLocation?.longitude ?? 0.0,
              destLat: startRideResponse.value?.data?.dropLocation?.latitude ?? 0.0,
              destLng: startRideResponse.value?.data?.dropLocation?.longitude ?? 0.0
          );
        }
      }
    }).onError((error, stackTrace) {
      isLoading.value = false;
      update();
      debugPrint('error>>$error');
    });
  }

  void validate(String? id) async {
    _handleSubmit(id);
  }

  _handleSubmit(String? id) {
    repository.endRideApiCall(id: id).then((value) async {
      if (value != null) {
        ForgetPasswordResponseModel forgetPasswordResponseModel = value;
        showSnackBar(message: forgetPasswordResponseModel.message ?? "");

        // Clean up route tracking
        isTrackingRoute.value = false;
        destinationLocation.value = null;
        routeCoordinates.clear();

        // Clear maps and reload
        loadProfile();
        routePolylines.clear();
        routeMarkers.clear();
        routePolylines.refresh();
        routeMarkers.refresh();
      }
    }).onError((er, stackTrace) {
      print("$er");
    });
  }

  void _checkForNewRides() {
    // Implementation for socket events
  }

  // void checkLocationAlwaysAllowed() async {
  //   final hasPermission = await _hasBgLocationAccess();
  //   if (profileDataProvider.userDataModel.value?.status == driverStateOnline &&
  //       hasPermission == false) {
  //     /// to make driver offline again if bg location denied
  //     _updateDriverStatus(driverStateOffline);
  //   }
  // }

  Future reloadProfile({bool showLoader = true}) async {
    if (showLoader) {
      customLoader.show(Get.context);
    }

    await repository.loadProfile().then((value) async {
      if (value != null) {
        userResponseModel = value;
        update();
        customLoader.hide();
      }
      customLoader.hide();
    }).onError((error, stackTrace) {
      customLoader.hide();
    });
  }

  void _loadInitialData() {
    listenToDriverLocationChanges();
    _userInitialLocation = currentLocationProvider.getCurrentLocation();
    initialCameraPosition = CameraPosition(
        target: LatLng(_userInitialLocation?.lat ?? 30.707600,
            _userInitialLocation?.long ?? 76.715126),
        zoom: initialMapZoom);
  }

  onMapCreated(GoogleMapController controller) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _moveCamera();
    });
    if (mapController != null) {
      return;
    }
    mapController = controller;
    if (!completer.isCompleted) {
      completer.complete(mapController);
    }
  }

  void onMapTap(LatLng latLng) {
    mapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: initialMapZoom)));
  }

  void moveToCurrentLocation() async {
    // if (profileDataProvider.userDataModel.value?.status == driverStateOffline) {
    //   await currentLocationProvider.loadCurrentLocation(
    //       forceReload: true, showLoader: true, showLoading: true);
    // }

    if (currentLocationProvider.getCurrentLocation()?.lat != null &&
        currentLocationProvider.getCurrentLocation()?.long != null) {
      mapController?.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(
                  _userChangingLocation.value.lat ??
                      currentLocationProvider.getCurrentLocation()!.lat!,
                  _userChangingLocation.value.long ??
                      currentLocationProvider.getCurrentLocation()!.long!),
              zoom: initialMapZoom)));
    }
    // updateDriverLocation(
    //     _userChangingLocation.value.lat, _userChangingLocation.value.long,
    //     isSocket: false);
  }

  void onCameraMove(CameraPosition position) {
    // Optional: Add any specific behavior when camera moves
  }

  void listenToDriverLocationChanges() {
    currentLocationProvider.addOnChangeListener(
        locationListenerId, _onDriverLocationChange);
  }

  void _onDriverLocationChange(AddressDataModel locationData) {
    _userChangingLocation.value.lat = locationData.lat;
    _userChangingLocation.value.long = locationData.long;

    callPrinter('Heading>>> ${_userChangingLocation.value.getHeading}');

    if (isCameraMovedFirstTime == false) {
      isCameraMovedFirstTime = true;
      // _moveCamera();
    }
  }


  void _moveCamera() {
    if (_userChangingLocation.value.lat != null &&
        _userChangingLocation.value.long != null) {
      mapController?.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(_userChangingLocation.value.lat!,
                  _userChangingLocation.value.long!),
              zoom: initialMapZoom)));
    }
  }

  Future<bool> goOnline({bool updateStatus = true}) async {
    HapticFeedback.lightImpact();

    bool? result = await _showBgLocationWarning();
    if (result == true) {
      currentLocationProvider.startLiveTracking();
    }
    return result ?? false;
  }

  void _showVerificationSheet() {
    showCommonBottomSheet(
        width: Get.width,
        height: height_210,
        showHeaderContainer: false,
        topRadius: radius_6,
        // onHideSheet: () {
        //   profileDataProvider.reloadProfile(showLoader: false);
        // },
    );
        // child: const VerificationPendingWidget());
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

  void goOffline() async {
    isLoading.value = true;
    HapticFeedback.lightImpact();
    // await profileDataProvider.reloadProfile(showLoader: false);
    //
    // if (profileDataProvider.userDataModel.value?.currentBooking != null &&
    //     profileDataProvider.userDataModel.value?.currentBooking?.bookingStatus == bookingStatusAccepted &&
    //     ((profileDataProvider.userDataModel.value?.currentBooking?.paymentReceived ?? false) == false)) {
    //   isLoading.value = false;
    //   showSnackBar(message: keyCantGoOffline);
    //   return;
    // }

    // _updateDriverStatus(driverStateOffline);
  }

  // void _updateDriverStatus(var state) async {
  //   isLoading.value = true;
  //   await Future.delayed(const Duration(milliseconds: 500));
  //   final data = AuthRequestModel.updateDriverStateRequest(state: state);
  //   repository.updateDriverStateApiCall(dataBody: data, showLoader: false).then((value) {
  //     isLoading.value = false;
  //     profileDataProvider.userDataModel.value?.status = state;
  //     profileDataProvider.updateData(profileDataProvider.userDataModel.value);
  //
  //     if (state == driverStateOnline &&
  //         profileDataProvider.userDataModel.value?.isBankAdded == false) {
  //       showSnackBar(message: keyPlsAddBankInfo);
  //     }
  //
  //     if (state == driverStateOffline) {
  //       NativeLocationServices.stopForegroundService();
  //     }
  //   }).onError((error, stackTrace) {
  //     isLoading.value = false;
  //     if (error.toString() == accountStatusAmountPending) {
  //       _showAmountPendingDialog();
  //     } else {
  //       showSnackBar(message: error.toString(), isWarning: true);
  //     }
  //   });
  // }

  void _showAmountPendingDialog() {
    showAlertDialog(
        title: keyPaymentPending.tr,
        buttonText: keyPayNow.tr,
        onTap: () {
          Get.back();
          Get.toNamed(AppRoutes.walletRoute);
        },
        subtitle: keyPaymentPendingDes.tr);
  }

  void _onAssignBooking() async {
    // Implementation for booking assignment
  }

  // void _onDispatchNotification() async {
  //   await profileDataProvider.reloadProfile(showLoader: false);
  // }

  void _listenToBookingAcceptedSocket() {
    // Socket event listener implementation
  }

  void _listenToNewRideSocket() {
    // Socket event listener implementation
  }

  void onCancelNotification(var bookingId) {
    // Handle cancel notification
  }

  void onRequestCancelled(var bookingId) {
    if ((isSheetOpened || (Get.isBottomSheetOpen == true)) &&
        bookingId == rideRequestModel.value?.sId) {
      Get.back(); //to hide sheet
      isSheetOpened = false;
      _stopSound();
      _removeRideData();
      _showRideCancelledDialog();
    }
  }

  void onNewRequestWidget() {
    _playSound();
  }

  void onNewRequestWidgetHide({bool closeSheet = true}) {
    isSheetOpened = false;
    if (closeSheet) {
      Get.back(); //to hide sheet
    }

    _stopSound();
  }

  void onAcceptRide() async {
    if (Get.currentRoute != AppRoutes.homeRoute) {
      Get.until((route) => Get.currentRoute == AppRoutes.homeRoute);
      await Future.delayed(const Duration(milliseconds: 350));
    }
    repository.acceptBookingApiCall(id: rideRequestModel.value?.sId).then(
          (value) {
        isSheetOpened = false;
        FcmNavigator.clearOldNotifications();
        Get.back();
        _stopSound();
        if (Get.currentRoute == AppRoutes.tripDetailRoute) {
          Get.offNamed(AppRoutes.ongoingRideRoute,
              arguments: {argId: rideRequestModel.value?.sId});
        } else {
          Get.toNamed(AppRoutes.ongoingRideRoute,
              arguments: {argId: rideRequestModel.value?.sId});
        }
      },
    ).onError(
          (error, stackTrace) {
        Get.back(); //to hide sheet
        isSheetOpened = false;
        _stopSound();
        _removeRideData();
        if (error.toString() == errorCodeRideCancelled) {
          _showRideCancelledDialog();
        } else {
          showSnackBar(message: error.toString(), isWarning: true, seconds: 3);
        }
      },
    );
  }

  void _showRideCancelledDialog() {
    showAlertDialog(
        title: keyRideCancelledTitle.tr,
        buttonText: keyOK.tr,
        onTap: () {
          Get.back();
        },
        subtitle: keyRideCancelledDes.tr);
  }


  void _removeRideData({int removeAfter = 700}) {
    Future.delayed(
      Duration(milliseconds: removeAfter),
          () {
        if (!isSheetOpened) {
          rideRequestModel.value = null;
        }
      },
    );
  }

  void onDeclineRide() {
    repository.declineBookingApiCall(id: rideRequestModel.value?.sId).then(
          (value) {
        isSheetOpened = false;
        Get.back(); //to hide sheet
        _stopSound();
        _removeRideData(removeAfter: 0);
        FcmNavigator.clearOldNotifications();
      },
    ).onError(
          (error, stackTrace) {
        Get.back(); //to hide sheet
        isSheetOpened = false;
        _stopSound();
        showSnackBar(message: error.toString(), isWarning: true);
        _removeRideData(removeAfter: 0);
      },
    );
  }

  void onTimerChange(String timeStamp) {}

  void _playSound() async {
    _flutterRingtoneManager.playAudioAsset(ringtoneAudioPath);
  }

  void _stopSound() {
    _flutterRingtoneManager.stop();
  }

  @override
  void onClose() {
    _removeListeners();
    socket?.disconnect();
    socket?.close();
    socket?.destroy();
    _locationUpdateTimer?.cancel();
    super.onClose();
  }

  void _removeListeners() {
    currentLocationProvider.removeOnChangeListener(locationListenerId);
  }
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
              borderRadius: BorderRadius.circular(radius_8)),
          child: Container(
            decoration: BoxDecoration(
                color: isDarkMode.value
                    ? AppColors.whiteLight
                    : AppColors.whiteAppColor,
                borderRadius: BorderRadius.circular(radius_8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextView(
                    text: keyBgLocationNotGranted.tr,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    textStyle: textStyleTitleLarge()!.copyWith(
                      fontWeight: FontWeight.w600,
                    )).paddingOnly(top: margin_6),
                TextView(
                    text: keyPlsProvideBgAccess.tr,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    textStyle: textStyleBodyLarge()!
                        .copyWith(fontWeight: FontWeight.w500))
                    .paddingOnly(top: margin_6, bottom: margin_8),
                _rowIconWidget(icon: '1.', text: keyOpenTheSettingsApps.tr),
                _rowIconWidget(icon: '2.', text: keySelectLocationServ.tr),
                _rowIconWidget(icon: '3.', text: keyChangeLocPermission.tr)
                    .paddingOnly(bottom: margin_3),
                CustomMaterialButton(
                  onTap: () {
                    Get.back();
                    Geolocator.openLocationSettings();
                  },
                  buttonText: keyGoToSettings.tr,
                  buttonHeight: height_34,
                )
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

// Future _requestBgLocationAccess() async {
//   bool isGranted = false;
//   if (await _hasBgLocationAccess()) {
//     isGranted = true;
//   } else {
//
//
//
//
//     if (Platform.isAndroid) {
//       if (await Permission.locationAlways.isDenied) {
//         await Permission.locationAlways.request();
//       }
//
//       else {
//         _onBgLocationDenied();
//       }
//     } else {
//       _onBgLocationDenied(
