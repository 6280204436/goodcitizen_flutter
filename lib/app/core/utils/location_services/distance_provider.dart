import 'dart:math';


double toRadians(double degrees) {
  return degrees * pi / 180.0;
}

double? getDistanceBwPoints({
  double? latitude1,
  double? longitude1,
  double? latitude2,
  double? longitude2,
}) {
  if (latitude1 == null ||
      longitude1 == null ||
      latitude2 == null ||
      longitude2 == null) {
    return null;
  }

  // Earth's radius in kilometers
  const earthRadiusKm = 6371;

  // Convert latitude and longitude from degrees to radians
  final lat1 = toRadians(latitude1);
  final lon1 = toRadians(longitude1);
  final lat2 = toRadians(latitude2);
  final lon2 = toRadians(longitude2);

  // Difference in latitudes and longitudes
  final dLat = lat2 - lat1;
  final dLon = lon2 - lon1;

  // Haversine formula
  final a = pow(sin(dLat / 2), 2) +
      cos(lat1) * cos(lat2) * pow(sin(dLon / 2), 2);
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));

  // Distance calculation
  return earthRadiusKm * c;
}