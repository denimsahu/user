part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class LoginSubmitEvent extends LoginEvent {
  String Username;
  String Password;
  LoginSubmitEvent({required this.Username,required this.Password});
}

