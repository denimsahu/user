import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:user/GlobalVariables/Variables.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitialState()) {
    on<LoginSubmitEvent>((event, emit) async {
      emit(LoginLoadingState());
      try{
          DocumentSnapshot User = await firebaseFirestore.collection("Users").doc(event.Username).get();
          if(User.exists){
            if(User.get("Password")==sha256.convert(utf8.encode(event.Password.toString())).toString()){
              getStorage.write("Username", event.Username.toString());
              emit(LoginSuccessState());
            }
            else{
              throw("Wrong Password");
            }
          }
          else{
            throw("User Dosen't Exists");
          }
      }
      catch (Error){
        emit(LoginErrorState(errorMessage: Error.toString()));
      }
    });
  }
}
