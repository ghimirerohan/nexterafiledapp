import 'package:geolocator/geolocator.dart';
import 'package:idempiere_rest/idempiere_rest.dart';
import 'package:open_location_code/open_location_code.dart';
import 'package:server_repository/models.dart';
import 'package:server_repository/repository.dart';

import 'GeoLocatorRepo.dart';

class AddnewlocationRepo {
  CreatelocationApiRepo createlocationApiRepo = CreatelocationApiRepo();
  ProcessApiRepository processApiRepository = ProcessApiRepository();

  Future<bool> postNewLocation(
      {required int ne_qrlocationadd_id,
      required String ward,
      required String tole,
      String? street,
      String? owner}) async {
    NECreateLocation createLocation = NECreateLocation(<String, dynamic>{});

    createLocation.neQrlocationAddID =
        NeQrlocationAddID(id: ne_qrlocationadd_id);
    createLocation.ward = Ward(id: ward, identifier: ward);
    createLocation.toleDevelopmentCommittee = tole;
    createLocation.streetname = street ?? "No Street";
    createLocation.houseOwnerName = owner ?? "No Owner";

    Position position = await determinePosition();

    createLocation.locLatitude = position.latitude.toStringAsPrecision(6);
    createLocation.locLongitude = position.longitude.toStringAsPrecision(6);

    final code = PlusCode.encode(
      LatLng(position.latitude, position.longitude),
    );
    createLocation.gpCode = code.toString();
    NECreateLocation? result =
        await createlocationApiRepo.postNewLocationDraft(createLocation);
    if (result != null) {
      ProcessSummary? ps = await processApiRepository.verifyLocationDataOfQR(
          ne_createlocation_ID: result!.id!);
      if (ps != null) {
        if (!ps.isError!) {
          return true;
        }
      }
    }
    return false;
  }
}
