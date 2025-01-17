import 'package:budget_tracker/UI/Auth/signup/signup.dart';
import 'package:budget_tracker/UI/screens/homescreen.dart';
import 'package:budget_tracker/utils/color.dart';
import 'package:budget_tracker/utils/flutterfoas.dart';
import 'package:budget_tracker/widget/custombutton_new.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  // Function to handle login logic
  void loginFunction() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
        .then((value) {
      fluttertoas().showpopup(pro_color.maincolor, 'Login successful!');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Homescreen()),
      );
    }).catchError((error) {
      fluttertoas().showpopup(Colors.red, error.message ?? 'Login failed!');
    }).whenComplete(() {
      setState(() => isLoading = false);
    });
  }

  // Email Validator
  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your email';
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) return 'Enter a valid email address';
    return null;
  }

  // Password Validator
  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pro_color.whitecolor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: pro_color.maincolor,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(150),
                    bottomLeft: Radius.circular(150),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.only(left: 20.0, top: 60),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome\nBack',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Hey! Good to see you again',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Login Form
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Email Input
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(
                            fontSize: 15.0, color: Colors.black),
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter your email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: emailValidator,
                      ),
                      const SizedBox(height: 20),

                      // Password Input
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        style: const TextStyle(
                            fontSize: 15.0, color: Colors.black),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: passwordValidator,
                      ),
                      const SizedBox(height: 10),

                      // Forgot Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Forgot password?',
                            style: TextStyle(color: pro_color.maincolor),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Login Button
                      CustomButton(
                        isloading: isLoading,
                        text: 'Log In',
                        onPressed: loginFunction,
                      ),
                      const SizedBox(height: 20),

                      // Sign Up Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account? ",
                            style: TextStyle(color: Colors.black),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Signup()),
                            ),
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                color: pro_color.maincolor,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
