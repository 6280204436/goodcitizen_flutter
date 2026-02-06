import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:good_citizen/app/modules/home_module/models/data_models/booking_data_model.dart';

import '../../../../remote_config.dart';
import '../../../core/external_packages/flutter_polyline/lib/flutter_polyline_points.dart';
import '../../../export.dart';
import '../../profile/models/address_data_model.dart';

Future<Map<PolylineId, Polyline>> getBookingPolyline(
    {BookingDataModel? bookingDataModel,
    double? currentLat,
    double? currentLng}) async {
  if (bookingDataModel?.pickupLat == null ||
      bookingDataModel?.pickupLong == null ||
      bookingDataModel?.dropLat == null ||
      bookingDataModel?.dropLong == null ||
      currentLat == null ||
      currentLng == null) {
    return {};
  }

  late double startLat;
  late double startLong;
  late double destLat;
  late double destLong;
  List<PolylineWayPoint> pointsList = [];

  List<AddressDataModel> stopsList = List.generate(
      bookingDataModel?.stops?.length ?? 0,
      (index) => bookingDataModel!.stops![index]);

  if (bookingDataModel?.rideStatus == null) {
    /// when the driver is moving from his location to pickup
    startLat = currentLat;
    startLong = currentLng;
    destLat = bookingDataModel!.pickupLat!;
    destLong = bookingDataModel.pickupLong!;
  } else if ( bookingDataModel?.rideStatus == rideStateAtPickup ||
      bookingDataModel?.rideStatus == rideStateAtStartRide ) {
    startLat =currentLat?? bookingDataModel!.pickupLat!;
    startLong =currentLng?? bookingDataModel!.pickupLong!;
    destLat = bookingDataModel!.dropLat!;
    destLong = bookingDataModel.dropLong!;

    pointsList = List.generate(
        stopsList.length,
        (index) => PolylineWayPoint(
            location: "${stopsList[index].lat},${stopsList[index].long}"));
  } else if (bookingDataModel?.rideStatus == rideStateAtStopOne ||
      bookingDataModel?.rideStatus == rideStateFromStopOne) {
    if (stopsList.isNotEmpty) {
      final firstStop = stopsList[0];

      startLat =currentLat?? firstStop.lat ?? 0;
      startLong =currentLng?? firstStop.long ?? 0;
      destLat = bookingDataModel!.dropLat!;
      destLong = bookingDataModel.dropLong!;
      stopsList.removeAt(0);
      pointsList = List.generate(
          stopsList.length,
          (index) => PolylineWayPoint(
              location: "${stopsList[index].lat},${stopsList[index].long}"));
    }
  } else if (bookingDataModel?.rideStatus == rideStateAtStopTwo ||
      bookingDataModel?.rideStatus == rideStateFromStopTwo) {
    if ((stopsList.length) > 1) {
      final secondStop = stopsList[1];
      startLat =currentLat?? secondStop.lat ?? 0;
      startLong =currentLng?? secondStop.long ?? 0;
      destLat = bookingDataModel!.dropLat!;
      destLong = bookingDataModel.dropLong!;
    }
  } else {
    startLat =currentLat?? bookingDataModel!.pickupLat!;
    startLong =currentLng?? bookingDataModel!.pickupLong!;
    destLat = bookingDataModel!.dropLat!;
    destLong = bookingDataModel.dropLong!;

    pointsList = List.generate(
        stopsList.length,
        (index) => PolylineWayPoint(
            location: "${stopsList[index].lat},${stopsList[index].long}"));
  }

  PolylinePoints polylinePoints = PolylinePoints();
  final result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: googleApiConst,
      request: PolylineRequest(
          origin: PointLatLng(startLat, startLong),
          destination: PointLatLng(destLat, destLong),
          mode: TravelMode.drive,
          wayPoints: pointsList)
  );

  List<LatLng> polylineCoordinates = [];
  if (result.points.isNotEmpty) {
    for (PointLatLng point in result.points) {
      polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    }
  }
  Map<PolylineId, Polyline> polyLines = {};
  PolylineId id = const PolylineId("poly");
  Polyline polyline = Polyline(
      polylineId: id,
      color: isDarkMode.value?Colors.white:AppColors.appColor,
      points: polylineCoordinates,
      // patterns: [
      //   PatternItem.dash(height_8),
      //   PatternItem.gap(height_5),
      //   // Length of the gap between dash// Another dash to form a repeating pattern
      // ],
      width: height_3.round());
  polyLines[id] = polyline;
  return polyLines;
}

Future<Map<PolylineId, Polyline>> getPolylineForRideRoute(
    {double? pickUpLat,
    double? pickUpLong,
    double? destLat,
    double? destLong,
    List<AddressDataModel>? stops}) async {
  if (pickUpLat == null ||
      pickUpLong == null ||
      destLat == null ||
      destLong == null) {
    return {};
  }

  List<PolylineWayPoint> pointsList = List.generate(
      stops?.length ?? 0,
      (index) => PolylineWayPoint(
          location: "${stops?[index].lat},${stops?[index].long}"));

  PolylinePoints polylinePoints = PolylinePoints();
  final result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: googleApiConst,
      request: PolylineRequest(
          origin: PointLatLng(pickUpLat, pickUpLong),
          destination: PointLatLng(destLat, destLong),
          mode: TravelMode.drive,
          wayPoints: pointsList)
  );
  List<LatLng> polylineCoordinates = [];
  if (result.points.isNotEmpty) {
    for (PointLatLng point in result.points) {
      polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    }
  }
  Map<PolylineId, Polyline> polyLines = {};
  PolylineId id = const PolylineId("poly");
  Polyline polyline = Polyline(
      polylineId: id,
      color: isDarkMode.value?Colors.white:AppColors.appColor,
      points: polylineCoordinates,
      // patterns: [
      //   PatternItem.dash(height_8),
      //   PatternItem.gap(height_5),
      //   // Length of the gap between dash// Another dash to form a repeating pattern
      // ],
      width: height_3.round());
  polyLines[id] = polyline;
  return polyLines;
}

/// used for opening maps navigation
/// the returned list contains lat long for start and destination
List<AddressDataModel> getStartEndForOpeningMaps(
    {BookingDataModel? bookingDataModel,
    double? currentLat,
    double? currentLng}) {
  if (bookingDataModel?.pickupLat == null ||
      bookingDataModel?.pickupLong == null ||
      bookingDataModel?.dropLat == null ||
      bookingDataModel?.dropLong == null ||
      currentLat == null ||
      currentLng == null) {
    return [];
  }

  late double startLat;
  late double startLong;
  late double destLat;
  late double destLong;

  List<AddressDataModel> stopsList = List.generate(
      bookingDataModel?.stops?.length ?? 0,
      (index) => bookingDataModel!.stops![index]);

  if (bookingDataModel?.rideStatus == null) {
    /// when the driver is moving from his location to pickup
    startLat = currentLat;
    startLong = currentLng;
    destLat = bookingDataModel!.pickupLat!;
    destLong = bookingDataModel.pickupLong!;
  } else if (bookingDataModel?.rideStatus == rideStateAtPickup ||
      bookingDataModel?.rideStatus == rideStateAtStartRide) {
    startLat = bookingDataModel!.pickupLat!;
    startLong = bookingDataModel.pickupLong!;
    destLat =
        stopsList.isNotEmpty ? stopsList[0].lat! : bookingDataModel.dropLat!;
    destLong =
        stopsList.isNotEmpty ? stopsList[0].long! : bookingDataModel.dropLong!;
  } else if (bookingDataModel?.rideStatus == rideStateAtStopOne ||
      bookingDataModel?.rideStatus == rideStateFromStopOne) {
    if (stopsList.isNotEmpty) {
      final firstStop = stopsList[0];

      startLat = firstStop.lat ?? 0;
      startLong = firstStop.long ?? 0;
      destLat =  stopsList.length==2 ? stopsList[1].lat! : bookingDataModel!.dropLat!;
      destLong =stopsList.length==2 ? stopsList[1].long! : bookingDataModel!.dropLong!;
      stopsList.removeAt(0);
    }
  } else if (bookingDataModel?.rideStatus == rideStateAtStopTwo ||
      bookingDataModel?.rideStatus == rideStateFromStopTwo) {
    if ((stopsList.length) > 1) {
      final secondStop = stopsList[1];
      startLat = secondStop.lat ?? 0;
      startLong = secondStop.long ?? 0;
      destLat = bookingDataModel!.dropLat!;
      destLong = bookingDataModel.dropLong!;
    }
  } else {
    startLat = bookingDataModel!.pickupLat!;
    startLong = bookingDataModel.pickupLong!;
    destLat = bookingDataModel.dropLat!;
    destLong = bookingDataModel.dropLong!;
  }

  return [
    AddressDataModel(lat: startLat, long: startLong),
    AddressDataModel(lat: destLat, long: destLong)
  ];
}
