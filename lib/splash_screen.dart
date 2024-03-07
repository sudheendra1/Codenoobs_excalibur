import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmcare/home_page.dart';

class Splashscreen extends StatefulWidget{
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 3), () {
      Navigator.push(context, PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>Homepage(),transitionDuration: Duration.zero,reverseTransitionDuration: Duration.zero));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(height: 1000,decoration: BoxDecoration(color: Color.fromARGB(100, 125, 216, 197),),child: Image.asset('assets/images/Transparent_logo.png'),),);
  }
}