import 'dart:async';
import 'package:auth_repository/services/storage/local_storage.dart';
import 'package:idempiere_rest/idempiere_rest.dart';
import 'package:server_repository/repository.dart';
import 'package:server_repository/server_repository.dart';



enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  final _controller = StreamController<AuthenticationStatus>();
  final _username = StreamController<String>();
  final UserApiRepository userApiRepository = UserApiRepository();
  final LoginApiRepository loginApiRepository = LoginApiRepository();
  final LocalStorage storage = LocalStorage();




  Stream<String> get username async*{
    yield* _username.stream;
  }

  Stream<AuthenticationStatus> get status async* {
    String? userName = await storage.readValue("username");
    String? userId = await storage.readValue("userid");
    String? restAuthToken = await storage.readValue("restauthtoken");
    if((userName != null && userName != 'null'
        && userName != '' ) &&
        (restAuthToken != null && restAuthToken != 'null'
            && restAuthToken != '' )
        &&
        (userId != null && userId != 'null'
            && userId != '' )
    ){
      await IdempiereClient().setRestAuthOfUser(int.parse(userId), restAuthToken, 1000000, 1000003, "en-GB");
      _controller.add(AuthenticationStatus.authenticated );
      _username.add(userName as String);
    }else{
      yield AuthenticationStatus.unauthenticated;
    }
    yield* _controller.stream;
  }

  Future<void> logOut() async{
    await storage.clearValue("username");
    await storage.clearValue("restauthtoken");
    await storage.clearValue("userid");
    _controller.add(AuthenticationStatus.unauthenticated );
  }
  Future<void> logIn({
    required String username,
    required String password,
  }) async {
    bool auth = await loginApiRepository.login(username: username, password: password,
        clientId: 1000000, roleId: 1000003, lang: "en-GB");
    if(auth){
      storage.clearValue("username");
      storage.clearValue("restauthtoken");
      storage.clearValue("userid");
      ApiResponse<MUser>? user = await userApiRepository.getUser(username);
      if(user != null){
        storage.setValue("username", username);
        storage.setValue("userid", user!.data!.id!.toString());
        AuthTokenApiRepo auth = AuthTokenApiRepo();
        ApiResponse<RestAuth>? response = await auth.getToken(user!.data!.id!);
        if(response != null){
          storage.setValue("restauthtoken" , response.data!.token!);
        }
      }
      _controller.add(AuthenticationStatus.authenticated );
      _username.add(username);
    }
  }



  void dispose() => _controller.close();
}
