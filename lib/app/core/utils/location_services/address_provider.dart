import 'package:geocoding/geocoding.dart';

import '../../../../remote_config.dart';
import '../../../export.dart';
import '../../../modules/model/lat_lng_model.dart';

Future<Placemark?> getAddressFromLatLng(LatLongModel? latLongModel) async {
  if (latLongModel == null) {
    return null;
  }
print('ate>>>${latLongModel.lat}');
print('ate>>>${latLongModel.long}');
  Placemark? placeMark;
  await placemarkFromCoordinates(latLongModel.lat, latLongModel.long)
      .then((List<Placemark> placemarks) {
    placeMark = placemarks[0];
  }).catchError((e) {
    debugPrint(e);
  });

  return placeMark;
}

Future<List<Location>?> getLocationsFromAddress(String? address) async {
  if (address == null) {
    return null;
  }

  List<Location>? locationsList;
  await locationFromAddress(address).then((List<Location> locations) {
    locationsList = locations;
  }).catchError((e) {
    debugPrint(e.toString());
  });

  return locationsList;
}





Future<List<String?>> getAddressFromLatLng1(double latitude, double longitude) async {

  final String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$googleApiConst";

  try {
    final Dio dio = Dio();
    final Response response = await dio.get(url);

    final Map<String, dynamic> data = json.decode(response.data.toString());

    if (data.containsKey('results') && data['results'] is List && data['results'].isNotEmpty) {
      final Map<String, dynamic> result = data['results'][0];
      final List<dynamic> addressComponents = result['address_components'];

      String? streetAddress;
      String? areaName;
      String? city;

      for (final Map<String, dynamic> component in addressComponents) {
        if (component['types'].contains('street_number')) {
          streetAddress = component['long_name'];
        } else if (component['types'].contains('route')) {
          streetAddress = (streetAddress != null) ? '$streetAddress ${component['long_name']}' : component['long_name'];
        } else if (component['types'].contains('locality')) {
          city = component['long_name'];
        } else if (component['types'].contains('administrative_area_level_2')) {
          areaName = component['long_name'];
        }
      }

      return [streetAddress, areaName, city];
    } else {
      return [null, null, null];
    }
  } catch (e) {
    print('Error: $e');
    return [null, null, null];
  }
}


