import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:user/firebase_options.dart';
import 'package:user/home/bloc/home_bloc.dart';
import 'package:user/home/view/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:user/login/login_bloc/login_bloc.dart';
import 'package:user/login/view/loginScreen.dart';
import 'package:user/search/bloc/search_bloc.dart';
import 'package:user/signUp/bloc/sign_up_bloc.dart';
import 'package:user/signUp/view/signUp.dart';
import 'package:user/splash/bloc/splash_bloc.dart';
import 'package:user/splash/view/splash.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(),
        ),
        BlocProvider(
          create: (context) => HomeBloc(),
        ),
        BlocProvider(
          create: (context) => SplashBloc(),
        ),
        BlocProvider(
          create: (context) => SignUpBloc(),
        ),
      ],
      child: GetMaterialApp(
        routes: {
          "/":(context)=>const Splash(),
          "/home":(context)=>const Home(),
          "/login":(context)=>const Login(),
          "/signUp":(context)=>const SignUp(),
        },
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
    ),
    );
  }
}