import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object?> get props => [];
}

class FetchMarkerEvent extends MapEvent {}

class UpdateCurrentLocation extends MapEvent {
  final LocationData? currentLoc;

  const UpdateCurrentLocation({this.currentLoc});

  @override
  List<Object?> get props => [currentLoc];
}

class UpdateVisibleRegion extends MapEvent {
  final LatLngBounds visibleRegion;

  const UpdateVisibleRegion({required this.visibleRegion});

  @override
  List<Object?> get props => [visibleRegion];
}

class UpdateLiveMarkers extends MapEvent {
  final List<Marker> liveMarkers;

  const UpdateLiveMarkers({required this.liveMarkers});

  @override
  List<Object?> get props => [liveMarkers];
}
