part of 'sign_up_bloc.dart';

@immutable
sealed class SignUpState {}

final class SignUpInitial extends SignUpState {}

class SignUpLoadingState extends SignUpState{}

class SignUpSuccessState extends SignUpState{}

class SignUpErrorState extends SignUpState{
  String Error;
  SignUpErrorState({required this.Error});
}