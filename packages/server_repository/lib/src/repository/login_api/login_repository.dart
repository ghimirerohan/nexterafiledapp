
abstract class LoginRepository{

  Future<bool> login({required String username, required String password,
    required int clientId, required int roleId ,required String lang});
}