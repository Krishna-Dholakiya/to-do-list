import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_project/dashboard_screen.dart';
import 'package:todo_project/sign_up_screen.dart';

import 'auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  final _emailKey = GlobalKey<FormState>();
  final _passKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text(
            "Login Page",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                "Name",
              ),
              const SizedBox(
                height: 5,
              ),
              Form(
                key: _emailKey,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter a valid email!';
                    }
                    return null;
                  },
                  controller: emailController,
                  decoration: InputDecoration(
                      hintText: "Email Address",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text("Password"),
              const SizedBox(
                height: 10,
              ),
              Form(
                key: _passKey,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter a password!';
                    } else if (value.length < 8) {
                      return 'Password must contain at least 8 character';
                    }
                    return null;
                  },
                  obscureText: true,
                  controller: passController,
                  decoration: InputDecoration(
                      hintText: "Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: _loginIn,
                    child: const Text(
                      "Log in",
                      style: TextStyle(color: Colors.white),
                    )),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Create a Account ?"),
                  GestureDetector(
                    child: const Text(
                      "Sign in",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ));
                    },
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: _googleSignIn,
                    child: const Text(
                      "Sign in With Google ",
                      style: TextStyle(color: Colors.white),
                    )),
              ),
              // TextButton(onPressed: () {
              //   signOutGoogle();
              // }, child: Text("Log out"))
            ],
          ),
        ));
  }

  void _loginIn() async {
    if (_emailKey.currentState!.validate() &&
        _passKey.currentState!.validate()) {
      String email = emailController.text.trim();
      String password = passController.text.trim();

      User? user = await _auth.signInWithEmailAndPassword(email, password);

      if (user != null) {
        DocumentSnapshot userDocument = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (userDocument.exists) {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          await preferences.setString('name', userDocument['name']);
          await preferences.setString('email', userDocument['email']);
        }
        print("User is successfully signed in");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      } else {
        print("User sign-in failed.");
      }
    }
  }

  void _googleSignIn() async {
    User? user = await _auth.signInWithGoogle();

    if (user != null) {
      DocumentSnapshot userDocument = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if(userDocument.exists){
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.setString('name', userDocument['name']);
        await preferences.setString('email', userDocument['email']);
      }
      print("User is successfully signed in with Google");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    } else {
      print("Google Sign In Failed");
    }
  }

// void signOutGoogle() async{
//   await FirebaseAuth.instance.signOut();
//   GoogleSignIn googleSignIn = GoogleSignIn();
//   await googleSignIn.signOut();
//
// }
}
