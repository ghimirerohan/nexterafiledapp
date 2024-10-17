

import 'package:server_repository/models.dart';

import '../../../api_response.dart';
import '../../../models.dart';
import '../../data/network/network_api_services.dart';

class CreateToleApiRepo {

  final NetworkApiService _networkApiService = NetworkApiService<NECreateTole>();

  Future<NECreateTole?> postNewToleDraft(NECreateTole data) async{
    ApiResponse<NECreateTole> response = await _networkApiService.getPostApiResponse(data);
    return response.data;

  }

}