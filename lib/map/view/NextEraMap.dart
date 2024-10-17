import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../home/view/home_screen.dart';
import '../bloc/map_bloc.dart';
import '../bloc/map_event.dart';
import '../bloc/map_state.dart';
import '../calculations.dart';

class Nexteramap extends StatefulWidget {
  Nexteramap({super.key});

  @override
  State<Nexteramap> createState() => _NexteramapState();
}

class _NexteramapState extends State<Nexteramap> {
  Completer<GoogleMapController> _completer = Completer();
  LatLngBounds? _currentVisibleRegion;
  LocationData? _initialLocation;

  @override
  void initState() {
    super.initState();
    _fetchInitialLocation();
  }

  Future<void> _fetchInitialLocation() async {
    final mapBloc = context.read<MapBloc>();
    final location = Location();
    _initialLocation = await location.getLocation();

    if (_initialLocation != null) {
      LatLng userLocation = LatLng(_initialLocation!.latitude!, _initialLocation!.longitude!);
      mapBloc.add(UpdateCurrentLocation(currentLoc: _initialLocation));
      _updateVisibleRegion(userLocation);
    }

    mapBloc.add(FetchMarkerEvent());
  }

  void _updateVisibleRegion(LatLng center) {
    LatLngBounds visibleRegion = calculateLatLngBounds(center, 1000); // 1000 meters
    context.read<MapBloc>().add(UpdateVisibleRegion(visibleRegion: visibleRegion));
  }

  _onPressedRefresh() {
    context.read<MapBloc>().add(FetchMarkerEvent());
  }

  void _onCameraIdle() {
    _completer.future.then((controller) {
      controller.getVisibleRegion().then((visibleRegion) {
        setState(() {
          _currentVisibleRegion = visibleRegion;
          _updateLiveMarkers();
        });
      });
    });
  }

  void _updateLiveMarkers() {
    final mapBloc = context.read<MapBloc>();
    final cacheMarkers = mapBloc.state.cacheMarkers;
    final visibleMarkers = cacheMarkers.where((marker) {
      return _currentVisibleRegion!.contains(marker.position);
    }).toList();
    mapBloc.add(UpdateLiveMarkers(liveMarkers: visibleMarkers));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  HomeScreen.route(prevGPCode: null), (route) => false);
            },
          ),
          actions: [
            IconButton(
                onPressed: () {
                  _onPressedRefresh();
                },
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.white,
                  size: 30,
                ))
          ],
          centerTitle: true,
          title: const Text(
            "Reached Locations",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF047857),
        ),
        body: (state.isLoading || state.currentLocation == null)
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : GoogleMap(
          mapType: MapType.hybrid,
          initialCameraPosition: CameraPosition(
              target: LatLng(state.currentLocation!.latitude!,
                  state.currentLocation!.longitude!),
              zoom: 15.9),
          markers: Set<Marker>.of(state.liveMarkers),
          onMapCreated: (GoogleMapController controller) {
            _completer.complete(controller);
          },
          onCameraIdle: _onCameraIdle,
        ),
        floatingActionButton:
        (state.isLoading || state.currentLocation == null)
            ? null
            : FloatingActionButton(
          onPressed: () async {
            GoogleMapController googleMapController =
            await _completer.future;
            googleMapController.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  zoom: 17,
                  target: LatLng(
                    state.currentLocation!.latitude!,
                    state.currentLocation!.longitude!,
                  ),
                ),
              ),
            );
          },
          child: Icon(Icons.gps_fixed),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      );
    });
  }
}
