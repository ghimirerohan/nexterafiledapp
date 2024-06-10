import 'package:server_repository/server_repository.dart';
import 'package:server_repository/src/models/generic_models/RestAuth.dart';

abstract class AuthTokenRepository{

  Future<ApiResponse<RestAuth>> getToken(int userID);
}