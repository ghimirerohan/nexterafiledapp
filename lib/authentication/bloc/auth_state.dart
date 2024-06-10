
import 'package:auth_repository/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:server_repository/server_repository.dart';

class AuthenticationState extends Equatable {
  // Changed from const to a regular constructor
  AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
    MUser? user,
  }) : user = user ?? MUser.empty();

  // Removed const keyword
  AuthenticationState.unknown() : this._();

  // Removed const keyword
  AuthenticationState.authenticated(MUser user)
      : this._(status: AuthenticationStatus.authenticated, user: user);

  // Removed const keyword
  AuthenticationState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated);

  final AuthenticationStatus status;
  final MUser user;

  @override
  List<Object> get props => [status, user];
}

