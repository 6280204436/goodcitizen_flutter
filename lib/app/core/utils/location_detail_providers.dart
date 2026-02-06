

import '../../modules/model/lat_lng_model.dart';
import 'location_services/location_data_model.dart';

LatLongModel? getLatLngFromGeocodeResult(
    LocationDetailDataModel? geocodeResult) {
  if (geocodeResult == null) {
    return null;
  }

  final List<Results?> results = geocodeResult.results ?? [];
  for (var result in results) {
    final geometry = result?.geometry;

    return LatLongModel(
        lat: geometry?.location?.lat, long: geometry?.location?.lng);
  }

  return null;
}

String? getPropertyNameFromGeocodeResult(
    LocationDetailDataModel? geocodeResult) {
  if (geocodeResult == null) {
    return null;
  }

  final results = geocodeResult.results as List<dynamic>;

  for (var result in results) {
    final addressComponents = result.addressComponents as List<dynamic>;

    for (var component in addressComponents) {
      final types = component.types as List<dynamic>;
      if (types.contains('premise') || types.contains('street_number')) {
        return component.longName as String?;
      }
    }
  }
  return null;
}

String? getStreetNameFromGeocodeResult(LocationDetailDataModel? geocodeResult) {
  if (geocodeResult == null) {
    return null;
  }

  final results = geocodeResult.results as List<dynamic>;

  List<String?> list = [];

  for (var result in results) {
    final addressComponents = result.addressComponents as List<dynamic>;

    for (var component in addressComponents) {
      final types = component.types as List<dynamic>;
      if (types.contains('street_number') || types.contains('route')) {
        list.add(component.longName as String?);
      } else if (list.isEmpty && types.contains('neighborhood')) {
        list.add(component.longName as String?);
      }
    }
  }
  return list.join(' ');
}

String? getAreaNameFromGeocodeResult(LocationDetailDataModel? geocodeResult) {
  if (geocodeResult == null) {
    return null;
  }

  final results = geocodeResult.results as List<dynamic>;

  for (var result in results) {
    final addressComponents = result.addressComponents as List<dynamic>;

    for (var component in addressComponents) {
      final types = component.types as List<dynamic>;
      if (types.contains('sublocality') || types.contains('locality')) {
        return component.longName as String?;
      }
    }
  }
  return null;
}

String? getCityNameFromGeocodeResult(LocationDetailDataModel? geocodeResult) {
  if (geocodeResult == null) {
    return null;
  }

  final results = geocodeResult.results as List<dynamic>;

  for (var result in results) {
    final addressComponents = result.addressComponents as List<dynamic>;

    for (var component in addressComponents) {
      final types = component.types as List<dynamic>;
      if (types.contains('locality')) {
        return component.longName as String?;
      }
    }
  }
  return null;
}

String? getStateNameFromGeocodeResult(LocationDetailDataModel? geocodeResult) {
  if (geocodeResult == null) {
    return null;
  }

  final results = geocodeResult.results as List<dynamic>;

  for (var result in results) {
    final addressComponents = result.addressComponents as List<dynamic>;

    for (var component in addressComponents) {
      final types = component.types as List<dynamic>;
      if (types.contains('administrative_area_level_1')) {
        return component.longName as String?;
      }
    }
  }
  return null;
}


String? getStateCodeFromGeocodeResult(LocationDetailDataModel? geocodeResult) {
  if (geocodeResult == null) {
    return null;
  }

  final results = geocodeResult.results as List<dynamic>;

  for (var result in results) {
    final addressComponents = result.addressComponents as List<dynamic>;

    for (var component in addressComponents) {
      final types = component.types as List<dynamic>;
      if (types.contains('administrative_area_level_1')) {
        return component.shortName as String?;
      }
    }
  }
  return null;
}




String? getPostalCodeFromGeocodeResult(LocationDetailDataModel? geocodeResult) {
  if (geocodeResult == null) {
    return null;
  }

  final results = geocodeResult.results as List<dynamic>;

  for (var result in results) {
    final addressComponents = result.addressComponents as List<dynamic>;

    for (var component in addressComponents) {
      final types = component.types as List<dynamic>;
      if (types.contains('postal_code')) {
        return component.longName as String?;
      }
    }
  }
  return null;
}

String? getCountryNameFromGeocodeResult(
    LocationDetailDataModel? geocodeResult) {
  if (geocodeResult == null) {
    return null;
  }
  final results = geocodeResult.results as List<dynamic>;

  for (var result in results) {
    final addressComponents = result.addressComponents as List<dynamic>;

    for (var component in addressComponents) {
      final types = component.types as List<dynamic>;
      if (types.contains('country')) {
        return component.longName as String?;
      }
    }
  }
  return null;
}

String? getCountryCodeFromGeocodeResult(
    LocationDetailDataModel? geocodeResult) {
  if (geocodeResult == null) {
    return null;
  }
  final results = geocodeResult.results as List<dynamic>;

  for (var result in results) {
    final addressComponents = result.addressComponents as List<dynamic>;

    for (var component in addressComponents) {
      final types = component.types as List<dynamic>;
      if (types.contains('country')) {
        return component.shortName as String?;
      }
    }
  }
  return null;
}

/*List<String>? list = currentAddress.value?.address?.split(',');
if((currentAddress.value?.address?.contains('-')??false) &&(list==null || list.isEmpty|| list.length==1)   )
{
list = currentAddress.value?.address?.split('-');
}
if (list != null && list.isNotEmpty) {
final index = countriesList.indexWhere((element) =>
element.title?.toLowerCase() == list?.last.trim().toLowerCase());
if (index != -1) {
selectedCountry.value = countriesList[index];
} else {
_fetchCountryName();
}


switch (list.length) {
case 1:
{
streetController.text = list[0].trim();
}
case 2:
{
streetController.text = list[0].trim();
flatController.text = list[1].trim();
}
case 3:
{
streetController.text = list[0].trim();
flatController.text = list[1].trim();
cityController.text = list[3].trim();
}
default:
{
streetController.text = list[0].trim();
flatController.text = list[1].trim();
cityController.text = list[3].trim();
list.removeAt(0);
list.removeAt(1);
list.removeAt(2);
list.removeAt(list.length-1);
stateController.text = list.join(', ').trim();
}
}


}*/
