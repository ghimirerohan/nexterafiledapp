
import 'package:server_repository/models.dart';

import '../../../api_response.dart';
import '../../../models.dart';
import '../../data/network/network_api_services.dart';

class CreatelocationApiRepo {

  final NetworkApiService _networkApiService = NetworkApiService<NECreateLocation>();

  Future<bool> postNewLocationDraft(NECreateLocation data) async{
    ApiResponse<NECreateLocation> response = await _networkApiService.getPostApiResponse(data);
    if(response.data != null){
      if(response.data!.id != null){
      return true;
      }
      else
        {
          return false;
        }
    }
    return false;

  }

}