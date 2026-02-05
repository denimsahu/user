import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:user/GlobalVariables/Variables.dart';
import 'package:user/GlobalWidgets/CustomBigElevatedButton.dart';
import 'package:user/GlobalWidgets/CustomBigText.dart';
import 'package:user/GlobalWidgets/CustomSmallText.dart';
import 'package:user/GlobalWidgets/CustomTextFiledWithIcon.dart';
import 'package:user/login/login_bloc/login_bloc.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  
  TextEditingController UserNameController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.grey.shade300,
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              margin: EdgeInsets.symmetric(horizontal:10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Container(
                          height: MediaQuery.of(context).size.height * 0.35,
                          child: Lottie.asset("assets/loginScreenBusAnimation.json")
                        ),
                      CustomBigText(text: "Login",fontSize: 30),
                      CustomBigText(
                          text: "To Find Out Where Is Your Bus!",
                          // fontWeight: FontWeight.normal,
                          fontSize: 23.0
                          ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal:20.0),
                    child: Column(
                      children: [
                        CustomTextFieldWithIcon(context: context, Icons: Icons.person, controller: UserNameController,HintText: "Username"),
                        SizedBox(height: MediaQuery.of(context).size.height*0.025,),
                        CustomTextFieldWithIcon(context: context, Icons: Icons.key, controller: PasswordController, HintText: "Password", obscureText: true,),
                        SizedBox(height: MediaQuery.of(context).size.height*0.04,),
                        BlocBuilder<LoginBloc, LoginState>(
                          builder: (context, state) {
                            return Text.rich(
                              style:TextStyle(fontSize: 15.0),
                              TextSpan(children: [
                                TextSpan(text: "Don't have an Account? "),
                                TextSpan(text: "SignUp.",style: TextStyle(color: state is LoginLoadingState?Colors.grey.shade700:Colors.blue),recognizer:TapGestureRecognizer()..onTap=state is LoginLoadingState?null:(){
                                  Navigator.pushNamed(context, "/signUp");
                                })
                              ])
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  BlocConsumer<LoginBloc, LoginState>(
                    listener: (context, state) {
                      if (state is LoginErrorState) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(state.errorMessage),
                          padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                          duration: Duration(seconds: 2),
                        ));
                      }
                      else if(state is LoginSuccessState){
                        Navigator.of(context).popAndPushNamed('/home');
                      }
                    },
                    builder: (context, state) {
                      return CustomBigElevatedButton(
                        context: context,
                        color: state is LoginLoadingState? Colors.amber.shade100:Colors.amber.shade300,
                        text: state is LoginLoadingState?null:"Login",
                        child: state is LoginLoadingState?LottieBuilder.asset("assets/loadingDots.json"):null,
                        onPressed: state is LoginLoadingState?(){null;}:() {
                          if(UserNameController.text.isEmpty || PasswordController.text.isEmpty){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill in Username and Password")));
                          }
                          else if(UserNameController.text.length<3 || !RegExp(r'^\S*$').hasMatch(UserNameController.text)){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid Username")));
                          }
                          else if(PasswordController.text.length<10){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid Password")));
                          }
                          else{
                            context.read<LoginBloc>().add(LoginSubmitEvent(
                                Username: UserNameController.value.text.toString(),
                                Password: PasswordController.value.text.toString()
                            ));
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
  }
}
