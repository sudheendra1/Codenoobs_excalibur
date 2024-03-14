import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pharmcare/login_page.dart';

class Forgot_pass extends StatefulWidget {
  const Forgot_pass({super.key});

  @override
  State<StatefulWidget> createState() {
    return _forgotstate();
  }
}

class _forgotstate extends State<Forgot_pass> {
  TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                controller: email,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[300],
                  labelText: 'Email-ID',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Check your Email to reset password'),
                ));
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Loginpage()));
              },
              child: Text(
                'Send Reset Email',
                style: TextStyle(color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(100, 125, 216, 197),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
            )
          ],
        ),
      ),
    );
  }
}
