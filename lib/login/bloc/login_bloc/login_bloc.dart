


import 'package:auth_repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:next_era_collector/configs/utils.dart';


import '../../model/email.dart';
import '../../model/password.dart';
import 'login_events.dart';
import 'login_states.dart';



class LoginBloc extends Bloc<MyFormEvent, MyFormState> {

  LoginBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const MyFormState()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<EmailUnfocused>(_onEmailUnfocused);
    on<PasswordUnfocused>(_onPasswordUnfocused);
    on<FormSubmitted>(_onFormSubmitted);
  }

  final AuthenticationRepository _authenticationRepository;
  void _onEmailChanged(EmailChanged event, Emitter<MyFormState> emit) {
    final email = Email.dirty(event.email);
    emit(
      state.copyWith(
        email: email.valid ? email : Email.pure(event.email),
        status: Formz.validate([email, state.password]),
      ),
    );
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<MyFormState> emit) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password.valid ? password : Password.pure(event.password),
        status: Formz.validate([state.email, password]),
      ),
    );
  }

  void _onEmailUnfocused(EmailUnfocused event, Emitter<MyFormState> emit) {
    final email = Email.dirty(state.email.value);
    emit(
      state.copyWith(
        email: email,
        status: Formz.validate([email, state.password]),
      ),
    );
  }

  void _onPasswordUnfocused(
      PasswordUnfocused event,
      Emitter<MyFormState> emit,
      ) {
    final password = Password.dirty(state.password.value);
    emit(
      state.copyWith(
        password: password,
        status: Formz.validate([state.email, password]),
      ),
    );
  }

  Future<void> _onFormSubmitted(
      FormSubmitted event,
      Emitter<MyFormState> emit,
      ) async {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    emit(
      state.copyWith(
        email: email,
        password: password,
        status: Formz.validate([email, password]),
      ),
    );
    if (state.status.isValidated) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      try{
        await _authenticationRepository.logIn(username: state.email.value, password: state.password.value);
        emit(state.copyWith(status: FormzStatus.submissionSuccess));
      }catch(e , stacktrace){
        print(stacktrace);
        Utils.flushBarErrorMessage(e.toString(), event.context);
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    }
  }
}
