import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pharmcare/dependency_injection.dart';
import 'package:pharmcare/firebase_options.dart';
import 'package:pharmcare/home_page.dart';
import 'package:pharmcare/login_page.dart';
import 'package:pharmcare/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
  Dpenedency_injection.init();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Pharmcare',
theme: ThemeData(useMaterial3: true),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) {
            if(snapshot.connectionState==ConnectionState.waiting){
              return const Splashscreen();
            }
            if(snapshot.hasData){
              return const Splashscreen();
            }
            return const Loginpage();
          }),
    );
  }
}

