import 'dart:async';

import 'package:auth_repository/auth_repository.dart';
import 'package:next_era_collector/configs/utils.dart';
import 'package:server_repository/server_repository.dart';
import 'package:bloc/bloc.dart';

import 'auth_event.dart';
import 'auth_state.dart';



class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required AuthenticationRepository authenticationRepository,
    required  UserApiRepository userRepository,
  })  : _authenticationRepository = authenticationRepository,
        _userRepository = userRepository,
        super(  AuthenticationState.unknown()) {
    on<AuthenticationStatusChanged>(_onAuthenticationStatusChanged);
    on<AuthenticationLogoutRequested>(_onAuthenticationLogoutRequested);
    _authenticationStatusSubscription = _authenticationRepository.status.listen(
          (status) => add(AuthenticationStatusChanged(status)),
    );
    _userNameSub = _authenticationRepository.username.listen(
          (username) => userName = username,
    );

  }
  late  String userName;
  final AuthenticationRepository _authenticationRepository;
  final UserApiRepository _userRepository;
  late StreamSubscription<AuthenticationStatus>
  _authenticationStatusSubscription;
  late StreamSubscription<String>
  _userNameSub;

  @override
  Future<void> close() {
    _authenticationStatusSubscription.cancel();
    return super.close();
  }

  Future<void> _onAuthenticationStatusChanged(
      AuthenticationStatusChanged event,
      Emitter<AuthenticationState> emit,
      ) async {
    switch (event.status) {
      case AuthenticationStatus.unauthenticated:
        return emit( AuthenticationState.unauthenticated());
      case AuthenticationStatus.authenticated:
        final MUser? user = await _tryGetUser(userName);


        return emit(
          user != null
              ? AuthenticationState.authenticated(user)
              :  AuthenticationState.unauthenticated(),
        );
      case AuthenticationStatus.unknown:
        return emit( AuthenticationState.unknown());
    }
  }

  void _onAuthenticationLogoutRequested(
      AuthenticationLogoutRequested event,
      Emitter<AuthenticationState> emit,
      ) {
    _authenticationRepository.logOut();
  }

  Future<MUser?> _tryGetUser(String user) async {
    final String name = user;
    try {
      final user = await _userRepository.getUser(name);
      return user.data;
    } catch (e) {
      Utils.toastMessage(e.toString());
    }
  }
}
