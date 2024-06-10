
import 'package:server_repository/src/repository/login_api/login_repository.dart';

import '../../data/network/base_api_services.dart';
import '../../data/network/network_api_services.dart';

class LoginApiRepository implements LoginRepository{

  final BaseApiServices _apiServices = NetworkApiService() ;

  @override
  Future<bool> login ({required String username, required String password,
    required int clientId, required int roleId, required String lang}) async{
   return await _apiServices.authenticate(username: username, password: password, clientId: clientId, roleId: roleId, lang: lang);
  }

}