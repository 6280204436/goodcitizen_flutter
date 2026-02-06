
import 'package:good_citizen/app/core/external_packages/flutter_polyline/lib/src/models/response_model.dart';

import 'package:good_citizen/app/export.dart';



import '../flutter_polyline_points.dart';


class PolylineUtils {
  ///Get the encoded string from google directions api
  ///
  Future<PolylineResult> getRouteBetweenCoordinates({
    required PolylineRequest request,
    String? googleApiKey,
    bool isForDistance = false,
  }) async {
    request.validateKey(googleApiKey);

    final headers = {
      'Content-Type': 'application/json',
      'X-Goog-Api-Key': googleApiKey ?? '',
      'X-Goog-FieldMask': isForDistance
          ? 'routes.distanceMeters'
          : 'routes.polyline.encodedPolyline'
    };

    var response = await repository.dioClient?.post(
        'https://routes.googleapis.com/directions/v2:computeRoutes',
        options: Options(headers: headers),
        data: request.getParams(),
        isLoading: false);

    final responseModel = NewPolylineResponseModel.fromJson(response);

    if ((responseModel.routes ?? []).isEmpty ||
        (responseModel.routes?.first.polyline?.encodedPolyline == null)) {
      return PolylineResult(points: [], totalDistanceValue: 0);
    }

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolylineResult = polylinePoints
        .decodePolyline(responseModel.routes!.first.polyline!.encodedPolyline!);
    return PolylineResult(
        points: decodedPolylineResult,
        totalDistanceValue: responseModel.routes?.first.distanceMeters,
        totalDurationValue: responseModel.routes?.first.duration);
  }
}
