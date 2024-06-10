
import 'package:server_repository/src/data/data.dart';
import 'package:server_repository/src/models/generic_models/MUser.dart';

abstract class UserRepository {

  Future<ApiResponse<MUser>> getUser(String name);

}