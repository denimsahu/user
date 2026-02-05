part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginInitialState extends LoginState {}

class LoginSuccessState extends LoginState{}

class LoginErrorState extends LoginState {
  String errorMessage;
  LoginErrorState({required this.errorMessage});
}

class LoginLoadingState extends LoginState{}

