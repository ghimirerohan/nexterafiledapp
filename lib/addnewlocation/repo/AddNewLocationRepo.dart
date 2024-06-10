
import 'package:geolocator/geolocator.dart';
import 'package:open_location_code/open_location_code.dart';
import 'package:server_repository/models.dart';
import 'package:server_repository/repository.dart';

import 'GeoLocatorRepo.dart';

class AddnewlocationRepo{

  CreatelocationApiRepo createlocationApiRepo = CreatelocationApiRepo();

  Future<bool> postNewLocation({required int ne_qrlocationadd_id,
    required String ward , required String tole , String? street , String? owner
}) async{
    NECreateLocation createLocation = NECreateLocation(<String,dynamic>{});

    createLocation.neQrlocationAddID = NeQrlocationAddID(id:ne_qrlocationadd_id );
    createLocation.ward = Ward(id: ward , identifier: ward);
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
    bool result = await createlocationApiRepo.postNewLocationDraft(createLocation);

    return result;

  }
}