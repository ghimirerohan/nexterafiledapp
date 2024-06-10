


import 'package:auth_repository/auth_repository.dart';

sealed class AuthenticationEvent {
  const AuthenticationEvent();
}

final class AuthenticationStatusChanged extends AuthenticationEvent {
  const AuthenticationStatusChanged(this.status);

  final AuthenticationStatus status;
}

final class AuthenticationLogoutRequested extends AuthenticationEvent {}
