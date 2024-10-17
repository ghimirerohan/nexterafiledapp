import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapState extends Equatable {
  final bool isLoading;
  final List<Marker> cacheMarkers;
  final List<Marker> liveMarkers;
  final LocationData? currentLocation;
  final LatLngBounds? visibleRegion;

  const MapState({
    this.isLoading = false,
    required this.cacheMarkers,
    required this.liveMarkers,
    this.currentLocation,
    this.visibleRegion,
  });

  MapState copyWith({
    bool? isLoading,
    List<Marker>? cacheMarkers,
    List<Marker>? liveMarkers,
    LocationData? currentLocation,
    LatLngBounds? visibleRegion,
  }) {
    return MapState(
      isLoading: isLoading ?? this.isLoading,
      cacheMarkers: cacheMarkers ?? this.cacheMarkers,
      liveMarkers: liveMarkers ?? this.liveMarkers,
      currentLocation: currentLocation ?? this.currentLocation,
      visibleRegion: visibleRegion ?? this.visibleRegion,
    );
  }

  @override
  List<Object?> get props => [isLoading, cacheMarkers, liveMarkers, currentLocation, visibleRegion];
}
