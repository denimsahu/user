part of 'sign_up_bloc.dart';

@immutable
sealed class SignUpEvent {}

class SignUpSubmitEvent extends SignUpEvent{
  String Username;
  String Password;
  String Password2;
  String PhoneNumber;
  String Email;
  SignUpSubmitEvent({required this.Username, required this.Password,required this.Password2,required this.Email,required this.PhoneNumber});
}
