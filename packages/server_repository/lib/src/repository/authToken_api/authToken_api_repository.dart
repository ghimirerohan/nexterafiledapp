
import 'package:idempiere_rest/idempiere_rest.dart';
import 'package:server_repository/src/models/generic_models/RestAuth.dart';

import '../../../server_repository.dart';
import '../../data/network/base_api_services.dart';
import '../../data/network/network_api_services.dart';
import 'authToken_repository.dart';

class AuthTokenApiRepo implements AuthTokenRepository{
  final BaseApiServices _apiServices = NetworkApiService<RestAuth>() ;

  @override
  Future<ApiResponse<RestAuth>> getToken(int userID) async{
    FilterBuilder filter = FilterBuilder().
    addFilter("ad_user_id", Operators.eq, userID);
    ApiResponse<List<RestAuth>> queryResult = await _apiServices.getDataApiResponse(filter: filter,select: ['Token']);
    ApiResponse<RestAuth> returnToken = ApiResponse<RestAuth>.completed(queryResult.data?[0]);
    return returnToken;
  }
  
}