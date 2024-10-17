import 'package:server_repository/models.dart';

import '../../../api_response.dart';
import '../../data/network/network_api_services.dart';

class ToleApiRepo {
  final NetworkApiService _apiServices = NetworkApiService<NETole>();

  Future<NETole> getToleByID({required int id}) async {
    ApiResponse<NETole> response = await _apiServices.getRecordApiResponse(id);
    if (response.data == null) {
      throw ("Some Thing Wrong to get CLocation");
    }
    return response.data!;
  }
}
