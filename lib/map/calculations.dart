import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';

LatLngBounds calculateLatLngBounds(LatLng center, double distanceInMeters) {
  const double earthRadius = 6378137.0;

  double lat = center.latitude;
  double lng = center.longitude;

  // Calculate the offset in degrees
  double latOffset = (distanceInMeters / earthRadius) * (180 / pi);
  double lngOffset = (distanceInMeters / (earthRadius * cos(pi * lat / 180))) * (180 / pi);

  LatLng southwest = LatLng(lat - latOffset, lng - lngOffset);
  LatLng northeast = LatLng(lat + latOffset, lng + lngOffset);

  return LatLngBounds(southwest: southwest, northeast: northeast);
}
