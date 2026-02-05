import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:user/GlobalWidgets/CustomBigElevatedButton.dart';
import 'package:user/GlobalWidgets/CustomBigText.dart';
import 'package:user/GlobalWidgets/CustomSmallText.dart';
import 'package:user/GlobalWidgets/CustomTextFiledWithIcon.dart';
import 'package:user/signUp/bloc/sign_up_bloc.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController UserNameController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();
  TextEditingController Password2Controller = TextEditingController();
  TextEditingController EmailController = TextEditingController();
  TextEditingController PhoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.grey.shade200,
          body: SingleChildScrollView(
            child: SafeArea(
              child: Container(
                margin: EdgeInsets.symmetric(vertical:10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Lottie.asset(
                            "assets/signupScreenAnimation.json",height: MediaQuery.of(context).size.height*0.23),
                        SizedBox(height: MediaQuery.of(context).size.height*0.025,),
                        CustomBigText(text: "Where Is Your Bus?"),
                        CustomSmallText(
                            text: "Signup To Find Out!"),
                        SizedBox(height: MediaQuery.of(context).size.height*0.025,)
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal:28.0),
                      child: Column(
                        children: [
                          CustomTextFieldWithIcon(
                            context:context,
                            Icons:Icons.person,
                            controller:UserNameController,
                            HintText:"Create Username",
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                          CustomTextFieldWithIcon(
                            obscureText: true,
                                context:context,
                                Icons:Icons.key,
                                controller:PasswordController,
                                HintText:"Create Password",
                              ),
                          SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                          CustomTextFieldWithIcon(
                                obscureText: true,
                                context:context,
                                Icons:Icons.key,
                                controller:Password2Controller,
                                HintText:"Password Again",
                              ),
                          SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                          CustomTextFieldWithIcon(
                                keyboardType: TextInputType.emailAddress,
                                context:context,
                                Icons:Icons.email,
                                controller:EmailController,
                                HintText:"Your Email Address",
                              ),
                          SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                          CustomTextFieldWithIcon(
                            keyboardType: TextInputType.phone,
                            context:context,
                            Icons:Icons.phone,
                            controller:PhoneController,
                            HintText:"Your Phone Number",
                            maxLength: 10,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height*0.06,),
                    BlocConsumer<SignUpBloc, SignUpState>(
                      listener: (context, state) {
                        if (state is SignUpErrorState) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(state.Error.toString()),
                            padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                            duration: Duration(seconds: 2),
                          ));
                        }
                        else if(state is SignUpSuccessState){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Account Created Successfully!!!")));
                          Navigator.of(context).pop();
                          Navigator.of(context).popAndPushNamed("/home");
                        }
                      },
                      builder: (context, state) {
                        return CustomBigElevatedButton(
                          context: context,
                          color: state is SignUpLoadingState?Colors.amber.shade100 :Colors.amber.shade300,
                          onPressed: state is SignUpLoadingState?(){null;}:() {
                            if(UserNameController.text.isEmpty || PasswordController.text.isEmpty || Password2Controller.text.isEmpty ||EmailController.text.isEmpty ||PhoneController.text.isEmpty){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please Fill Up All Feilds")));
                            }
                            else if (PasswordController.text != Password2Controller.text){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Both Password Dosen't Match")));
                            }
                            else if (UserNameController.text.length<3){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Username is too Short")));
                            }
                            else if (!RegExp(r'^\S*$').hasMatch(UserNameController.text)){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Username cannot conatain white spaces")));
                            }
                            else if (PasswordController.text.length<10){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password is too Short")));
                            }
                            else if(!RegExp(r'^\S.*\S$').hasMatch(PasswordController.text)){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password Cannot Start or End With White Spaces")));
                            }
                            else if (!RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$').hasMatch(EmailController.text)){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid Email Address")));
                            }
                            else if(PhoneController.text.length!=10){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid Phone Number")));
                            }
                            else{
                              context.read<SignUpBloc>().add(SignUpSubmitEvent(
                                  Username: UserNameController.value.text.toString(),
                                  Password: PasswordController.value.text.toString(),
                                  Password2: Password2Controller.value.text.toString(),
                                  Email: EmailController.value.text.toString(),
                                  PhoneNumber: PhoneController.value.text.toString(),
                              ));
                            }
                          },
                          text: state is SignUpLoadingState?null:"Sign Up",
                          child: state is SignUpLoadingState?LottieBuilder.asset("assets/loadingDots.json"):null
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
  }
}
