
import 'package:server_repository/models.dart';

import '../../../api_response.dart';
import '../../../models.dart';
import '../../data/network/network_api_services.dart';

class CreatelocationApiRepo {

  final NetworkApiService _networkApiService = NetworkApiService<NECreateLocation>();

  Future<NECreateLocation?> postNewLocationDraft(NECreateLocation data) async{
    ApiResponse<NECreateLocation> response = await _networkApiService.getPostApiResponse(data);
    return response.data;

  }

}