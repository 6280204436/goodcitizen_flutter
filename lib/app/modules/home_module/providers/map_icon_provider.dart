import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import '../../../export.dart';
import '../../profile/models/address_data_model.dart';
import '../models/data_models/booking_data_model.dart';

Future<BitmapDescriptor?> _getMarkerImage(String path,
    {double? height, double? width}) async {
  try {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: height?.round(), targetWidth: width?.round());
    ui.FrameInfo fi = await codec.getNextFrame();
    Uint8List? imageData =
        (await fi.image.toByteData(format: ui.ImageByteFormat.png))
            ?.buffer
            .asUint8List();

    return imageData != null ? BitmapDescriptor.fromBytes(imageData) : null;
  } catch (error) {
    return null;
  }
}

Future<Map<MarkerId, Marker>> getBookingMarkers(
    {double? startLat,
    double? startLong,
    double? destLat,
    double? destLong,
    BookingDataModel? bookingDataModel,
    double? currentLat,
    double? currentLng}) async {
  Map<MarkerId, Marker> markers = {};

  if (startLat == null ||
      startLong == null ||
      destLat == null ||
      destLong == null) {
    return {};
  }

  List<AddressDataModel> stopsList = List.generate( bookingDataModel?.stops?.length??0 , (index) =>bookingDataModel!.stops![index]) ;

  BitmapDescriptor? startIcon =
      await _getMarkerImage(isDarkMode.value?icPickUpWhite:icPickIcon, height: height_40, width: height_40);
  BitmapDescriptor? stopIcon = stopsList.isNotEmpty
      ? await _getMarkerImage(icStopPng, height: height_27, width: height_27)
      : null;
  BitmapDescriptor? endIcon = await _getMarkerImage(icDropIcon);

  if (bookingDataModel?.rideStatus == null) {
    /// when the driver is moving from his location to pickup
    MarkerId startMarkerId = const MarkerId("pickup_marker");
    markers.putIfAbsent(
        startMarkerId,
        () => Marker(
              markerId: startMarkerId,
              position: LatLng(startLat, startLong),
              icon: startIcon ?? BitmapDescriptor.defaultMarker,
            ));

    MarkerId endMarkerId = const MarkerId("destination_marker");
    markers.putIfAbsent(
        endMarkerId,
        () => Marker(
              markerId: endMarkerId,
              position: LatLng(destLat, destLong),
              icon: endIcon ?? BitmapDescriptor.defaultMarker,
            ));
  } else if (bookingDataModel?.rideStatus == rideStateAtPickup ||
      bookingDataModel?.rideStatus == rideStateAtStartRide) {
    MarkerId startMarkerId = const MarkerId("pickup_marker");
    markers.putIfAbsent(
        startMarkerId,
        () => Marker(
              markerId: startMarkerId,
              position: LatLng(startLat, startLong),
              icon: startIcon ?? BitmapDescriptor.defaultMarker,
            ));

    MarkerId endMarkerId = const MarkerId("destination_marker");
    markers.putIfAbsent(
        endMarkerId,
        () => Marker(
              markerId: endMarkerId,
              position: LatLng(destLat, destLong),
              icon: endIcon ?? BitmapDescriptor.defaultMarker,
            ));

    for (int i = 0; i < stopsList.length; i++) {
      if (stopsList[i].lat == null ||
          stopsList[i].long == null) {
        continue;
      }

      MarkerId stopId = MarkerId("stop_$i");

      markers.putIfAbsent(
          stopId,
          () => Marker(
                markerId: stopId,
                position: LatLng(stopsList[i].lat!,
                    stopsList[i].long!),
                icon: stopIcon ?? BitmapDescriptor.defaultMarker,
              ));
    }
  } else if (bookingDataModel?.rideStatus == rideStateAtStopOne ||
      bookingDataModel?.rideStatus == rideStateFromStopOne) {
    if (stopsList.isNotEmpty ?? false) {
      final firstStop = stopsList[0];
      stopsList.removeAt(0);
      MarkerId startMarkerId = const MarkerId("pickup_marker");
      markers.putIfAbsent(
          startMarkerId,
          () => Marker(
                markerId: startMarkerId,
                position: LatLng(firstStop.lat ?? 0, firstStop.long ?? 0),
                icon: startIcon ?? BitmapDescriptor.defaultMarker,
              ));

      MarkerId endMarkerId = const MarkerId("destination_marker");
      markers.putIfAbsent(
          endMarkerId,
          () => Marker(
                markerId: endMarkerId,
                position: LatLng(destLat, destLong),
                icon: endIcon ?? BitmapDescriptor.defaultMarker,
              ));

      for (int i = 0; i < stopsList.length; i++) {
        if (stopsList[i].lat == null ||
            stopsList[i].long == null) {
          continue;
        }

        MarkerId stopId = MarkerId("stop_$i");

        markers.putIfAbsent(
            stopId,
            () => Marker(
                  markerId: stopId,
                  position: LatLng(destLat, destLong),
                  icon: stopIcon ?? BitmapDescriptor.defaultMarker,
                ));
      }
    }
  } else if (bookingDataModel?.rideStatus == rideStateAtStopTwo ||
      bookingDataModel?.rideStatus == rideStateFromStopTwo) {
    if ((stopsList.length ?? 0) > 1) {
      final secondStop =stopsList[1];
      stopsList.removeAt(0);
      MarkerId startMarkerId = const MarkerId("pickup_marker");
      markers.putIfAbsent(
          startMarkerId,
          () => Marker(
                markerId: startMarkerId,
                position: LatLng(secondStop.lat ?? 0, secondStop.long ?? 0),
                icon: startIcon ?? BitmapDescriptor.defaultMarker,
              ));

      MarkerId endMarkerId = const MarkerId("destination_marker");
      markers.putIfAbsent(
          endMarkerId,
          () => Marker(
                markerId: endMarkerId,
                position: LatLng(destLat, destLong),
                icon: endIcon ?? BitmapDescriptor.defaultMarker,
              ));
    }
  } else {
    MarkerId startMarkerId = const MarkerId("pickup_marker");
    markers.putIfAbsent(
        startMarkerId,
        () => Marker(
              markerId: startMarkerId,
              position: LatLng(startLat, startLong),
              icon: startIcon ?? BitmapDescriptor.defaultMarker,
            ));

    MarkerId endMarkerId = const MarkerId("destination_marker");
    markers.putIfAbsent(
        endMarkerId,
        () => Marker(
              markerId: endMarkerId,
              position: LatLng(destLat, destLong),
              icon: endIcon ?? BitmapDescriptor.defaultMarker,
            ));

    for (int i = 0; i < stopsList.length; i++) {
      if (stopsList[i].lat == null ||
          stopsList[i].long == null) {
        continue;
      }

      MarkerId stopId = MarkerId("stop_$i");

      markers.putIfAbsent(
          stopId,
          () => Marker(
                markerId: stopId,
                position: LatLng(stopsList[i].lat!,
                    stopsList[i].long!),
                icon: stopIcon ?? BitmapDescriptor.defaultMarker,
              ));
    }
  }

  return markers;
}

Future<Marker?> getMarkerImage(
    {required String image,
      double? lat,
      double? long,
      double? heading,
      double? height,
      double? width,
      String? id}) async {
  if (lat == null || long == null) {
    return null;
  }
  BitmapDescriptor? icon =
  await _getMarkerImage(image, height:height?? height_80, width:width?? height_90);

  return Marker(
      markerId: MarkerId(id ?? "current_location"),
      position: LatLng(lat, long),
      zIndex: 1,
      icon: icon ?? BitmapDescriptor.defaultMarker,
      rotation: heading ?? 0);
}