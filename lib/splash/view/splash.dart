import 'package:flutter/material.dart';
import 'package:user/GlobalVariables/Variables.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _splashState();
}

class _splashState extends State<Splash> {

  void CurrentUser() async {
    if (await getStorage.read("Username") == null) {
      await Future.delayed(Duration(seconds: 1));
      Navigator.popAndPushNamed(context, '/login');
    } else {
      await Future.delayed(Duration(seconds: 1));
      Navigator.popAndPushNamed(context, '/home');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Image.asset(
        "assets/appSplash.jpeg",
        fit: BoxFit.fill,
      ),
    ),
    );
  }
}