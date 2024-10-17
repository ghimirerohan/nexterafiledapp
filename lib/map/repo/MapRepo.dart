import 'dart:convert';
import 'dart:isolate';

import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:idempiere_rest/idempiere_rest.dart';
import 'package:location/location.dart';
import 'package:server_repository/repository.dart';

class MapRepo {
  final ProcessApiRepository processApiRepository = ProcessApiRepository();
  final Location location = Location();

  Future<LocationData?> getCurrentLocationData() async {
    return await location.getLocation();
  }

  Future<Marker?> getCurrentLocationMarker() async {
    LocationData? loc = await location.getLocation();
    BitmapDescriptor gpsLiveIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(24, 24)), // Adjust size here
      "assets/gpslive.png",
    );

    return Marker(
      markerId: MarkerId("live"),
      position: LatLng(loc!.latitude!, loc.longitude!),
      icon: gpsLiveIcon,
    );
  }

  Future<Marker?> getCurrentLocationMarkerFromLocationDataProvided(LocationData loc) async {
    BitmapDescriptor gpsLiveIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(24, 24)), // Adjust size here
      "assets/gpslive.png",
    );

    return Marker(
      markerId: MarkerId("live"),
      position: LatLng(loc.latitude!, loc.longitude!),
      icon: gpsLiveIcon,
    );
  }

  Future<List<Marker>> getCreatedCustomerLocations() async {
    ProcessSummary? dataFromProcess = await processApiRepository.getLocationReachedMapCSV();
    if (dataFromProcess != null && !dataFromProcess.isError!) {
      String decodedCsv = utf8.decode(base64.decode(dataFromProcess.exportFile!));
      decodedCsv = decodedCsv.replaceAll('\n', '\r\n');

      // Pre-load the icons
      BitmapDescriptor isMadeIcon = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(12, 12)), // Adjust size here
        "assets/greenmarker.png",
      );
      BitmapDescriptor notMadeIcon = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(12, 12)), // Adjust size here
        "assets/redmarker.png",
      );

      final response = ReceivePort();
      await Isolate.spawn(
        _parseCsvAndCreateMarkers,
        [decodedCsv, response.sendPort, isMadeIcon, notMadeIcon],
      );
      return await response.first as List<Marker>;
    } else {
      throw "Error Getting Location CSV";
    }
  }

  static Future<void> _parseCsvAndCreateMarkers(List<dynamic> arguments) async {
    String decodedCsv = arguments[0];
    SendPort sendPort = arguments[1];
    BitmapDescriptor isMadeIcon = arguments[2];
    BitmapDescriptor notMadeIcon = arguments[3];

    List<List<dynamic>> listData = const CsvToListConverter().convert(decodedCsv);
    final List<Marker> markers = [];

    for (var i = 1; i < listData.length && i <= 15000; i++) {
      var row = listData[i];
      LatLng position = LatLng(double.parse(row[1].toString()), double.parse(row[2].toString()));
      Marker marker = Marker(
        markerId: MarkerId("$i"),
        position: position,
        icon: row[3].toString() == "1" ? isMadeIcon : notMadeIcon,
      );
      markers.add(marker);
    }

    sendPort.send(markers);
  }


}
