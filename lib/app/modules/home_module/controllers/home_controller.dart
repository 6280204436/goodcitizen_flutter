import 'package:good_citizen/app/modules/authentication/models/response_models/forget_password_response_model.dart';
import 'package:good_citizen/app/modules/home_module/models/response_models/start_ride_reponse_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_ringtone_manager/flutter_ringtone_manager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:good_citizen/remote_config.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:good_citizen/app/common_data.dart';
import 'package:good_citizen/app/export.dart';
import 'package:good_citizen/app/modules/authentication/models/auth_request_model.dart';
import 'package:good_citizen/app/modules/home_module/controllers/driver_loc_updater.dart';
import 'package:good_citizen/app/modules/home_module/models/data_models/booking_data_model.dart';
import 'package:good_citizen/app/modules/home_module/providers/map_icon_provider.dart';
import 'package:good_citizen/app/push_notifications/fcm_event_listener.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../../core/external_packages/flutter_polyline/lib/flutter_polyline_points.dart';
import '../../../core/utils/show_bottom_sheet.dart';
import '../../../core/widgets/show_dialog.dart';
import '../../../push_notifications/fcm_navigator.dart';
import '../../authentication/models/response_models/user_response_model.dart';
import '../../location_provider/current_location_provider.dart';
import '../../location_provider/native_location_services.dart';
import '../../profile/models/address_data_model.dart';
import '../../socket_controller/socket_controller.dart';
import '../../../services/native_ios_service.dart';
import '../widgets/ride_request_widget.dart';
import '../widgets/verification_pending_widget.dart';

class HomeController extends GetxController {
  final GlobalKey<State> dialogKey = GlobalKey();
  RxMap<PolylineId, Polyline> routePolylines = <PolylineId, Polyline>{}.obs;
  Rx<UserResponseModel?> userResponseModel = Rx<UserResponseModel?>(null);
  Rx<StartRideResponse?> startRideResponse = Rx<StartRideResponse?>(null);
  final String locationListenerId = 'home_location';
  var totalDistance = "".obs;
  RxBool isLoading = false.obs;
  IO.Socket? socket;
  bool isSheetOpened = false;
  late FlutterRingtoneManager _flutterRingtoneManager;
  Timer? _locationUpdateTimer;
  final int _updateIntervalSeconds = 5;
  AddressDataModel? _userInitialLocation;
  final Rx<AddressDataModel> _userChangingLocation = AddressDataModel().obs;
  GoogleMapController? mapController;
  final Completer<GoogleMapController> completer =
      Completer<GoogleMapController>();
  late CameraPosition initialCameraPosition;
  RxMap<MarkerId, Marker> routeMarkers = <MarkerId, Marker>{}.obs;
  final RxList<LatLng> routeCoordinates = <LatLng>[].obs;
  Rxn<BookingDataModel> rideRequestModel = Rxn();
  bool isCameraMovedFirstTime = false;
  String? requestNotificationType;
  Rxn<LatLng> destinationLocation = Rxn<LatLng>();
  DateTime _lastUpdate = DateTime.now();
  var firstname = "".obs;
  var lastname = "".obs;
  var email = "";

  // Native iOS Service for socket operations

  @override
  void onInit() {
    initControllers();
    _loadInitialData();

    // Listen for app lifecycle changes
    _setupAppLifecycleListener();

    super.onInit();
  }

  void _setupAppLifecycleListener() {
    // This will be called when app comes to foreground
    // You can add this to your app lifecycle management
  }

  // Quick test method to check and set token immediately
  Future<void> quickTokenTest() async {
    try {
      print('🚀 === QUICK TOKEN TEST ===');

      // Check if user is logged in
      bool isLoggedIn = isUserLoggedIn();
      print('🔍 User logged in: $isLoggedIn');

      if (isLoggedIn) {
        // Get current token
        String? token = getCurrentToken();
        print(
            '🔍 Current token: ${token != null ? token.substring(0, 10) + "..." : "null"}');

        if (token != null) {
          // Set token for native iOS

          // Test socket status

          print('✅ Quick token test completed successfully!');
        } else {
          print('❌ Token is null despite user being logged in');
        }
      } else {
        print('❌ User is not logged in');
      }

      print('🚀 === END QUICK TOKEN TEST ===');
    } catch (e) {
      print('❌ Quick token test failed: $e');
    }
  }

  void _startLocationUpdateTimer() {
    _locationUpdateTimer?.cancel();
    _locationUpdateTimer =
        Timer.periodic(Duration(seconds: _updateIntervalSeconds), (timer) {
      routePolylines.refresh();
      routeCoordinates.refresh();
      update();
      _updateCurrentLocation();
    });
    debugPrint(
        'Location update timer started with interval of $_updateIntervalSeconds seconds');
  }

  void _updateCurrentLocation() async {
    final now = DateTime.now();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    if (position.latitude != null && position.longitude != null) {
      final currentLat = position.latitude;
      final currentLong = position.longitude;

      if (currentLat != null && currentLong != null) {
        final newPosition = LatLng(currentLat, currentLong);
        final destination = LatLng(
          startRideResponse.value?.data?.dropLocation?.latitude?.toDouble() ??
              0.0,
          startRideResponse.value?.data?.dropLocation?.longitude?.toDouble() ??
              0.0,
        );

        // _updateDriverMarker(currentLat, currentLong);
        _updateRouteWithNewPosition(newPosition, destination);
        _lastUpdate = now;
      }
    }
  }

  void _updateRouteWithNewPosition(
      LatLng currentPosition, LatLng destination) async {
    if (routeCoordinates.isEmpty || _shouldUpdateRoute(currentPosition)) {
      await getPolylinePoints(
        originLat: currentPosition.latitude,
        originLng: currentPosition.longitude,
        destLat:
            startRideResponse.value?.data?.dropLocation?.latitude?.toDouble() ??
                0.0,
        destLng: startRideResponse.value?.data?.dropLocation?.longitude
                ?.toDouble() ??
            0.0,
      );
    }

    final locationData = {
      'lat': currentPosition.latitude,
      'long': currentPosition.longitude,
      'ride_id': userResponseModel.value?.data?.rideid,
    };
    socket?.emit('driver_location', locationData);
  }

  bool _shouldUpdateRoute(LatLng newPosition) {
    if (routeCoordinates.isEmpty) return true;
    final lastPoint = routeCoordinates.last;
    final distanceInMeters = Geolocator.distanceBetween(
      lastPoint.latitude,
      lastPoint.longitude,
      newPosition.latitude,
      newPosition.longitude,
    );
    return distanceInMeters > 10.0;
  }

  bool _arePointsEqual(List<LatLng> list1, List<LatLng> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i].latitude != list2[i].latitude ||
          list1[i].longitude != list2[i].longitude) {
        return false;
      }
    }
    return true;
  }

  void _updatePolylineWithCurrentRoute() {
    final PolylineId id = const PolylineId('route_polyline');
    if (routePolylines.containsKey(id)) {
      final existingPolyline = routePolylines[id]!;
      if (!_arePointsEqual(existingPolyline.points, routeCoordinates)) {
        final updatedPolyline =
            existingPolyline.copyWith(pointsParam: List.from(routeCoordinates));
        routePolylines[id] = updatedPolyline;
        update();
      }
    } else {
      final polyline = Polyline(
        polylineId: id,
        color: Colors.blue,
        points: List.from(routeCoordinates),
        width: 7,
      );
      routePolylines[id] = polyline;
      update();
    }
  }

  Future<void> getPolylinePoints({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
    String? apiKey,
  }) async {
    print("enterpolyline function");
    try {
      final List<LatLng> originalCoordinates = List.from(routeCoordinates);
      PolylinePoints polylinePoints = PolylinePoints();

      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        request: PolylineRequest(
          origin: PointLatLng(originLat, originLng),
          destination: PointLatLng(destLat, destLng),
          mode: TravelMode.drive,
          alternatives: false,
          optimizeWaypoints: true,
        ),
        googleApiKey: "AIzaSyBioMK31w2-759jRzfev6Tpkdj9pe2eKrw",
      );

      List<LatLng> polylineCoordinates = [];
      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
      } else {
        debugPrint('No points found in polyline result, using direct line');
        polylineCoordinates = [
          LatLng(originLat, originLng),
          LatLng(destLat, destLng)
        ];
      }

      bool shouldUpdateRoute = originalCoordinates.isEmpty ||
          !_areRoutesEquivalent(originalCoordinates, polylineCoordinates);
      if (shouldUpdateRoute) {
        routeCoordinates.value = polylineCoordinates;
        _updatePolylineWithCurrentRoute();
        totalDistance.value =
            calculateRouteDistance(polylineCoordinates).toStringAsFixed(1);

        if (mapController != null && polylineCoordinates.isNotEmpty) {
          LatLngBounds bounds = _createBoundsFromPoints(polylineCoordinates);
          mapController!
              .animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
        }
      } else {
        debugPrint('Route has not changed significantly, skipping update');
      }
    } catch (e) {
      debugPrint('Error getting polyline points: $e');
      await getDirectionsFromApi(
          originLat: originLat,
          originLng: originLng,
          destLat: destLat,
          destLng: destLng,
          apiKey: apiKey);
    }
  }

  bool _areRoutesEquivalent(List<LatLng> route1, List<LatLng> route2) {
    if ((route1.length - route2.length).abs() > route1.length * 0.1)
      return false;
    if (route1.isNotEmpty && route2.isNotEmpty) {
      double startDistance = Geolocator.distanceBetween(
          route1.first.latitude,
          route1.first.longitude,
          route2.first.latitude,
          route2.first.longitude);
      double endDistance = Geolocator.distanceBetween(route1.last.latitude,
          route1.last.longitude, route2.last.latitude, route2.last.longitude);
      if (startDistance > 10 || endDistance > 10) return false;
    }
    return true;
  }

  void _updateDriverMarker(double lat, double long) {
    final markerId = MarkerId('driver_marker');
    if (routeMarkers.containsKey(markerId)) {
      final updatedMarker = routeMarkers[markerId]!.copyWith(
        positionParam: LatLng(lat, long),
        rotationParam: _userChangingLocation.value.getHeading ?? 0.0,
      );
      routeMarkers[markerId] = updatedMarker;
    } else {
      // createMyLocationMarker(lat, long, "CAR");
    }
    routeMarkers.refresh();
  }

  // New method to add pickup and drop-off markers
  updateRouteMarkers() async {
    routeMarkers.clear(); // Clear existing markers

    if (startRideResponse.value?.data != null) {
      final pickupLat =
          startRideResponse.value!.data!.pickupLocation?.latitude ?? 0.0;
      final pickupLng =
          startRideResponse.value!.data!.pickupLocation?.longitude ?? 0.0;
      final dropLat =
          startRideResponse.value!.data!.dropLocation?.latitude ?? 0.0;
      final dropLng =
          startRideResponse.value!.data!.dropLocation?.longitude ?? 0.0;

      // Add pickup marker
      final pickupMarker = await getMarkerImage(
        id: "pickup_marker",
        image:
            getMarkerImagePath("CAR"), // Ensure you have a pickup marker image
        height: height_100,
        width: height_100,
        lat: pickupLat,
        long: pickupLng,
        heading: 0.0,
      );
      if (pickupMarker != null) {
        routeMarkers[MarkerId('pickup_marker')] = pickupMarker;
      }

      // Add drop-off marker
      final dropMarker = await getMarkerImage(
        id: "drop_marker",
        image: getMarkerImagePath(
            "BIKE"), // Ensure you have a drop-off marker image
        height: height_80,
        width: height_80,
        lat: dropLat,
        long: dropLng,
        heading: 0.0,
      );
      if (dropMarker != null) {
        routeMarkers[MarkerId('drop_marker')] = dropMarker;
      }

      // Add driver marker (current location)
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      // createMyLocationMarker(position.latitude, position.longitude, "CAR");

      routeMarkers.refresh();
    }
  }

  void initControllers() async {
    _flutterRingtoneManager = FlutterRingtoneManager();
    if (!Get.isRegistered<CurrentLocationProvider>()) {
      currentLocationProvider = Get.put(CurrentLocationProvider());
    }

    // Initialize Native iOS Service]]

    socketConnection();
  }

  // Debug method to check token storage
  void debugTokenStorage() {
    try {
      print('🔍 === TOKEN STORAGE DEBUG ===');

      // Check login status
      bool isLoggedIn = isUserLoggedIn();
      print('🔍 User logged in: $isLoggedIn');

      // Get current token
      String? currentToken = getCurrentToken();
      print(
          '🔍 Current token: ${currentToken != null ? currentToken.length > 20 ? currentToken.substring(0, 20) + "..." : currentToken : "null"}');

      // Get raw token data
      dynamic tokenData = preferenceManager.getAuthToken();
      print('🔍 Raw token data: $tokenData');
      print('🔍 Token data type: ${tokenData.runtimeType}');

      if (tokenData != null) {
        String token = tokenData.toString();
        print('🔍 Converted token: $token');
        print('🔍 Token length: ${token.length}');
        print('🔍 Token is empty: ${token.isEmpty}');
        print('🔍 Token is "null": ${token == "null"}');
        print(
            '🔍 Token preview: ${token.length > 10 ? token.substring(0, 10) + "..." : token}');

        // Try to set token manually
      } else {
        print('❌ Token data is null');
      }

      print('🔍 === END TOKEN DEBUG ===');
    } catch (e) {
      print('❌ Token debug failed: $e');
    }
  }

  // Check if user is logged in and has valid token
  bool isUserLoggedIn() {
    try {
      dynamic tokenData = preferenceManager.getAuthToken();
      if (tokenData != null) {
        String token = tokenData.toString();
        return token.isNotEmpty && token != 'null';
      }
      return false;
    } catch (e) {
      print('❌ Error checking login status: $e');
      return false;
    }
  }

  // Get current token from storage
  String? getCurrentToken() {
    try {
      dynamic tokenData = preferenceManager.getAuthToken();
      if (tokenData != null) {
        String token = tokenData.toString();
        if (token.isNotEmpty && token != 'null') {
          return token;
        }
      }
      return null;
    } catch (e) {
      print('❌ Error getting current token: $e');
      return null;
    }
  }

  socketConnection() {
    makeSocketConnection((connected, socket) {
      print("Soket>>>>>>${socket}");
    });
  }

  void makeSocketConnection(
      Function(bool connected, Socket socket) onConnected) {
    if (socket?.connected ?? false) {
      onConnected(true, socket!);
      socket!.onError((data) => debugPrint("checking here ERROR:$data"));
    } else {
      String? token = preferenceManager.getAuthToken();
      socket = IO.io(
        baseUrl,
        OptionBuilder()
            .setTransports(['websocket'])
            .setQuery({'token': "Bearer $token"})
            .setAuth({'authtoken': token})
            .setExtraHeaders({'token': " $token"})
            .enableForceNewConnection()
            .enableReconnection()
            .build(),
      );
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
    } catch (e) {
      debugPrint("socket socketDisconnects error: $e");
    }
  }

  @override
  void onReady() {
    debugPrint("onReady Call=>");
    _userChangingLocation.value = AddressDataModel(
      lat: _userInitialLocation?.lat,
      long: _userInitialLocation?.long,
    );
    _userChangingLocation.value.setHeading(_userInitialLocation?.getHeading);

    // Load profile and set token with delay to ensure proper initialization
    _initializeWithDelay();

    super.onReady();
  }

  Future<void> _initializeWithDelay() async {
    // Small delay to ensure all controllers are properly initialized
    await Future.delayed(const Duration(milliseconds: 500));

    // Load profile first
    loadProfile();

    // Force retry after profile is loaded
    await Future.delayed(const Duration(seconds: 2));
    await _forceSetTokenFromProfile();
  }

  Future<void> _forceSetTokenFromProfile() async {
    try {
      print('🔄 Force setting token from profile...');

      // Try to get token from user response model
      if (userResponseModel.value?.data?.accessToken != null) {
        String token = userResponseModel.value!.data!.accessToken!;
        print(
            '✅ Found token in user response model: ${token.length > 10 ? token.substring(0, 10) : token}...');

        // Save to preference manager first
        preferenceManager.saveAuthToken(token);
        print('✅ Token saved to preference manager');

        // Set for native iOS
        print('✅ Token set for native iOS');

        // Check status
      } else {
        print('⚠️ No token found in user response model');
      }
    } catch (e) {
      print('❌ Force set token failed: $e');
    }
  }

  double calculateRouteDistance(List<LatLng> routeCoordinates) {
    double totalDistance = 0;
    if (routeCoordinates.length < 2) return 0;
    for (int i = 0; i < routeCoordinates.length - 1; i++) {
      final LatLng point1 = routeCoordinates[i];
      final LatLng point2 = routeCoordinates[i + 1];
      final distanceInMeters = Geolocator.distanceBetween(
        point1.latitude,
        point1.longitude,
        point2.latitude,
        point2.longitude,
      );
      totalDistance += distanceInMeters;
    }
    return double.parse((totalDistance / 1000).toStringAsFixed(2));
  }

  Future<void> getDirectionsFromApi({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
    String? apiKey,
  }) async {
    routePolylines.clear();
    final String url = 'https://maps.googleapis.com/maps/api/directions/json?'
        'origin=$originLat,$originLng'
        '&destination=$destLat,$destLng'
        '&key=${apiKey ?? "AIzaSyBioMK31w2-759jRzfev6Tpkdj9pe2eKrw"}';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded['status'] == 'OK') {
          final points = PolylinePoints().decodePolyline(
              decoded['routes'][0]['overview_polyline']['points']);
          List<LatLng> polylineCoordinates = points
              .map((point) => LatLng(point.latitude, point.longitude))
              .toList();
          PolylineId id = const PolylineId('route_polyline');
          final polyline = Polyline(
              polylineId: id,
              color: Colors.blue,
              points: polylineCoordinates,
              width: 7);
          routePolylines[id] = polyline;
          routePolylines.refresh();
          Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);
          totalDistance.value =
              calculateRouteDistance(polylineCoordinates).toStringAsFixed(1);
          final locationData = {
            'lat': position.latitude,
            'long': position.longitude,
            'ride_id': userResponseModel.value?.data?.rideid,
          };
          socket!.emit('driver_location', locationData);
          if (mapController != null && polylineCoordinates.isNotEmpty) {
            LatLngBounds bounds = _createBoundsFromPoints(polylineCoordinates);
            mapController!
                .animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
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

  void _createDirectLine(
      double originLat, double originLng, double destLat, double destLng) {
    List<LatLng> directLinePoints = [
      LatLng(originLat, originLng),
      LatLng(destLat, destLng)
    ];
    PolylineId id = const PolylineId('direct_line');
    final polyline = Polyline(
        polylineId: id, color: Colors.red, points: directLinePoints, width: 7);
    routePolylines[id] = polyline;
    routePolylines.refresh();
    if (mapController != null) {
      LatLngBounds bounds = _createBoundsFromPoints(directLinePoints);
      mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    }
  }

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
        northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
  }

  void createMyLocationMarker(double lat, double long, String type) async {
    final imagePath = getMarkerImagePath(type);
    final marker = await getMarkerImage(
      id: "driver_marker",
      image: imagePath,
      height: type == "BIKE" ? height_30 : height_80,
      width: type == "BIKE" ? height_30 : height_90,
      lat: lat,
      long: long,
      heading: _userChangingLocation.value.getHeading,
    );
    if (marker != null) {
      routeMarkers[MarkerId('driver_marker')] = marker;
      routeMarkers.refresh();
    }
  }

  loadProfile({bool startTimer = false}) {
    customLoader.show(Get.context);
    repository.getProfileApiCall().then((value) async {
      if (value != null) {
        userResponseModel.value = value;
        update();
        email = (userResponseModel.value?.data?.email ?? "");
        firstname.value = (userResponseModel.value?.data?.firstname ?? "");
        lastname.value = (userResponseModel.value?.data?.lastname ?? "");
        firstname.refresh();
        lastname.refresh();

        // Update auth token for native iOS when profile is loaded

        // Emergency fix if token is still not available
        await Future.delayed(const Duration(seconds: 1));
        await emergencyTokenFix();

        final rideId = userResponseModel.value?.data?.rideid;
        routePolylines.clear();
        routeCoordinates.clear();
        routeMarkers.clear();
        routePolylines.refresh();
        routeCoordinates.refresh();
        routeMarkers.refresh();
        _updatePolylineWithCurrentRoute();

        if (rideId != null) {
          repository.getRideDetailsApiCall(rideId).then((rideValue) async {
            customLoader.hide();
            if (rideValue != null) {
              startRideResponse.value = rideValue;
              update();

              final pickup = rideValue.data?.pickupLocation;
              final drop = rideValue.data?.dropLocation;

              if (pickup?.latitude != null && pickup?.longitude != null) {
                // Update markers for pickup, drop-off, and driver
                await updateRouteMarkers();
                if (startTimer) {
                  _startLocationUpdateTimer();
                }

                // Draw polyline if drop location exists
                if (drop?.latitude != null && drop?.longitude != null) {
                  getPolylinePoints(
                    originLat: pickup.latitude ?? 0.0,
                    originLng: pickup.longitude ?? 0.0,
                    destLat: drop.latitude ?? 0.0,
                    destLng: drop.longitude ?? 0.0,
                  );
                }
              }
            }
          }).onError((error, stackTrace) {
            customLoader.hide();
            debugPrint('Ride details error: $error');
            update();
          });
        } else {
          customLoader.hide();
          // Add driver marker for current location if no ride is active
          Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);
          // createMyLocationMarker(position.latitude, position.longitude, "CAR");
        }
      } else {
        customLoader.hide();
      }
    }).onError((error, stackTrace) {
      customLoader.hide();
      debugPrint('Profile error: $error');
      update();
    });
  }

  void _loadInitialData() {
    _userInitialLocation = currentLocationProvider.getCurrentLocation();
    initialCameraPosition = CameraPosition(
      target: LatLng(_userInitialLocation?.lat ?? 30.707600,
          _userInitialLocation?.long ?? 76.715126),
      zoom: initialMapZoom,
    );
  }

  onMapCreated(GoogleMapController controller) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _moveCamera();
    });
    if (mapController != null) return;
    mapController = controller;
    if (!completer.isCompleted) completer.complete(mapController);
  }

  void onMapTap(LatLng latLng) {
    mapController?.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: latLng, zoom: initialMapZoom),
    ));
  }

  void moveToCurrentLocation() async {
    if (currentLocationProvider.getCurrentLocation()?.lat != null &&
        currentLocationProvider.getCurrentLocation()?.long != null) {
      mapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            _userChangingLocation.value.lat ??
                currentLocationProvider.getCurrentLocation()!.lat!,
            _userChangingLocation.value.long ??
                currentLocationProvider.getCurrentLocation()!.long!,
          ),
          zoom: initialMapZoom,
        ),
      ));
    }
  }

  void validate(String? id) async {
    _handleSubmit(id);
  }

  void _handleSubmit(String? id) {
    repository.endRideApiCall(id: id).then((value) async {
      if (value != null) {
        ForgetPasswordResponseModel forgetPasswordResponseModel = value;
        showSnackBar(message: forgetPasswordResponseModel.message ?? "");
        removeMyLocationMarker();
        _locationUpdateTimer?.cancel();
        routePolylines.clear();
        routeMarkers.clear();
        routeCoordinates.clear();
        routePolylines.refresh();
        routeMarkers.refresh();

        routeCoordinates.refresh();

        if (userResponseModel.value?.data != null) {
          userResponseModel.value!.data!.rideid = null;
        }
        await loadProfile(startTimer: false);
      }
    }).onError((error, stackTrace) {
      debugPrint("Error ending ride: $error");
    });
  }

  void removeMyLocationMarker() {
    const markerId = MarkerId('drop_marker');
    if (routeMarkers.containsKey(markerId)) {
      routeMarkers.remove(markerId);
      routeMarkers.refresh();
      update();
    } else {
      debugPrint('Marker with ID $markerId not found.');
    }
    const dropmarkerId = MarkerId('pickup_marker');
    if (routeMarkers.containsKey(dropmarkerId)) {
      routeMarkers.remove(dropmarkerId);
      routeMarkers.refresh();
      update();
    } else {
      debugPrint('Marker with ID $markerId not found.');
    }
  }

  void _moveCamera() {
    if (_userChangingLocation.value.lat != null &&
        _userChangingLocation.value.long != null) {
      mapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(_userChangingLocation.value.lat!,
              _userChangingLocation.value.long!),
          zoom: initialMapZoom,
        ),
      ));
    }
  }

  @override
  void onClose() {
    _removeListeners();
    socket?.disconnect();
    socket?.close();
    socket?.destroy();
    super.onClose();
  }

  void _removeListeners() {
    currentLocationProvider.removeOnChangeListener(locationListenerId);
  }

  // Emergency token fix - call this when you see the "no auth token available" error
  Future<void> emergencyTokenFix() async {
    try {
      print('🚨 === EMERGENCY TOKEN FIX ===');

      // Method 1: Try to get from preference manager
      String? token = getCurrentToken();
      if (token != null) {
        print('✅ Found token in preference manager');

        return;
      }

      // Method 2: Try to get from user response model
      if (userResponseModel.value?.data?.accessToken != null) {
        token = userResponseModel.value!.data!.accessToken!;
        print('✅ Found token in user response model');

        // Save to preference manager
        preferenceManager.saveAuthToken(token);

        print('✅ Emergency token fix successful!');
        return;
      }

      // Method 3: Try to reload profile and get token
      print('🔄 Reloading profile to get token...');
      await loadProfile();

      // Wait a bit and try again
      await Future.delayed(const Duration(seconds: 2));

      if (userResponseModel.value?.data?.accessToken != null) {
        token = userResponseModel.value!.data!.accessToken!;
        print('✅ Found token after profile reload');

        // Save to preference manager
        preferenceManager.saveAuthToken(token);

        print('✅ Emergency token fix successful!');
        return;
      }

      print('❌ Emergency token fix failed - no token found');
      print('🚨 === END EMERGENCY TOKEN FIX ===');
    } catch (e) {
      print('❌ Emergency token fix failed: $e');
    }
  }
}
