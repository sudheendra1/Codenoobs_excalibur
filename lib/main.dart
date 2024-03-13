import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pharmcare/FAno_internet.dart';
import 'package:pharmcare/Firstaid_list.dart';
import 'package:pharmcare/dependency_injection.dart';
import 'package:pharmcare/firebase_options.dart';
import 'package:pharmcare/login_page.dart';
import 'package:pharmcare/network_controller.dart';
import 'package:pharmcare/splash_screen.dart';
import 'package:pharmcare/no_internet.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
  DependencyInjection.init(); // Initialize dependency injection
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Pharmcare',
      theme: ThemeData(useMaterial3: true),
      home: GetBuilder<NetworkController>(
        builder: (controller) {
          if (controller.hasConnection) {
            return StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Splashscreen();
                }
                if (snapshot.hasData) {
                  return const Splashscreen();
                }
                return const Loginpage();
              },
            );
          } else {
            return FirebaseAuth.instance.currentUser!=null? FANI():nointernet();
          }
        },
      ),
    );
  }
}
