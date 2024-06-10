
import 'package:server_repository/src/models/generic_models/CLocation.dart';

import '../../../server_repository.dart';

abstract class LocationRepository{

  Future<ApiResponse<CLocation>> getLocation(String gpcode);

  Future<ApiResponse<CLocation>> updateLocation(CLocation data);
}