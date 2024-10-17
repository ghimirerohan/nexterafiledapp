import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../configs/utils.dart';
import '../repo/MapRepo.dart';
import 'map_event.dart';
import 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc({required this.mapRepo})
      : super(MapState(cacheMarkers: [], liveMarkers: [])) {
    on<FetchMarkerEvent>(_fetchMarkers);
    on<UpdateCurrentLocation>(_updateCurrentLocation);
    on<UpdateVisibleRegion>(_updateVisibleRegion);
    on<UpdateLiveMarkers>(_updateLiveMarkers);
    _locliveStream = mapRepo.location.onLocationChanged.listen(
          (location) => add(UpdateCurrentLocation(currentLoc: location)),
    );
  }

  final MapRepo mapRepo;
  late StreamSubscription<LocationData> _locliveStream;

  @override
  Future<void> close() {
    _locliveStream.cancel();
    return super.close();
  }

  Future<void> _updateCurrentLocation(UpdateCurrentLocation event, Emitter<MapState> emit) async {
    List<Marker> _markers = state.cacheMarkers;
    Marker? marker = await mapRepo.getCurrentLocationMarkerFromLocationDataProvided(event.currentLoc!);
    List<Marker> _currentmarkers = List.from(_markers);
    _currentmarkers.add(marker!);
    emit(state.copyWith(liveMarkers: _currentmarkers, currentLocation: event.currentLoc));
  }

  Future<void> _fetchMarkers(FetchMarkerEvent event, Emitter<MapState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      List<Marker> _markers = await mapRepo.getCreatedCustomerLocations();
      Marker? currentLocMarker = await mapRepo.getCurrentLocationMarker();
      LocationData? currentInitialLive = await mapRepo.getCurrentLocationData();
      List<Marker> _currentmarkers = List.from(_markers);
      _currentmarkers.add(currentLocMarker!);
      emit(state.copyWith(
        isLoading: false,
        cacheMarkers: _markers,
        liveMarkers: _currentmarkers,
        currentLocation: currentInitialLive,
      ));
    } catch (e, stacktrace) {
      emit(state.copyWith(isLoading: false));
      Utils.toastMessage(e.toString());
    }
  }

  Future<void> _updateVisibleRegion(UpdateVisibleRegion event, Emitter<MapState> emit) async {
    emit(state.copyWith(visibleRegion: event.visibleRegion));
  }

  Future<void> _updateLiveMarkers(UpdateLiveMarkers event, Emitter<MapState> emit) async {
    emit(state.copyWith(liveMarkers: event.liveMarkers));
  }
}
