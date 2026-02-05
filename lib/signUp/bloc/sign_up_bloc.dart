import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:user/GlobalVariables/Variables.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpInitial()) {
    on<SignUpSubmitEvent>((event, emit) async {
      emit(SignUpLoadingState());
      try{
        if(await firebaseFirestore.collection("Users").doc(event.Username).get().then((value)=> value.exists)){
            throw("Username is Already Taken");
          }
        else{
              await firebaseFirestore.collection("Users").doc(event.Username).set({
                'Username':event.Username,
                'Email':event.Email,
                'PhoneNumber':event.PhoneNumber,
                'Password':sha256.convert(utf8.encode(event.Password.toString())).toString(),
              }).onError((error, stackTrace){throw error.toString();});
              await getStorage.write('Username',event.Username.toString());
              emit(SignUpSuccessState());
          }
      }
      catch(error){
          emit(SignUpErrorState(Error: error.toString()));
        }
    });
  }
}


// check for valid Email while signup