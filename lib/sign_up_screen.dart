import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_project/auth_service.dart';
import 'package:todo_project/login_page.dart';

import 'dashboard_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  final _nameKey = GlobalKey<FormState>();
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Name",
              ),
              const SizedBox(
                height: 5,
              ),
              Form(
                key: _nameKey,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter valid Name';
                    }
                    return null;
                  },
                  controller: nameController,
                  decoration: InputDecoration(
                      hintText: "Name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Email",
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
                    onPressed: _signUp,
                    child: const Text(
                      "Sign in",
                      style: TextStyle(color: Colors.white),
                    )),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an Account ?"),
                  GestureDetector(
                    child: const Text(
                      "Log in",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ));
                    },
                  )
                ],
              )
            ],
          ),
        ));
  }

  void _signUp() async {
    if (_emailKey.currentState!.validate() &&
        _nameKey.currentState!.validate() &&
        _passKey.currentState!.validate()) {
      String email = emailController.text.trim();
      String password = passController.text.trim();
      String name = nameController.text.trim();

      User? user =
          await _auth.createUserWithEmailAndPassword(email, password, name);

      if (user != null) {
        print("User is successfully created");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      } else {
        print("User creation failed.");
      }
    }
  }
}
