
import 'package:idempiere_rest/idempiere_rest.dart';
import 'package:server_repository/server_repository.dart';
import 'package:server_repository/src/models/generic_models/MUser.dart';

import '../../data/network/base_api_services.dart';
import '../../data/network/network_api_services.dart';
import 'user_repository.dart';

class UserApiRepository implements UserRepository {

  final BaseApiServices _apiServices = NetworkApiService<MUser>() ;

  @override
  Future<ApiResponse<MUser>> getUser(String name)async{
    FilterBuilder filter = FilterBuilder()
    .addFilter("name", Operators.eq, name);
    ApiResponse<List<MUser>> queryResult = await _apiServices.getDataApiResponse( filter: filter,select: ['Name']);
    ApiResponse<MUser> returnUser = ApiResponse<MUser>.completed(queryResult.data?[0]);
    return returnUser;

  }


}