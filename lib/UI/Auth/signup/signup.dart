import 'package:budget_tracker/UI/Auth/login/login.dart';
import 'package:budget_tracker/UI/screens/homescreen.dart';
import 'package:budget_tracker/utils/color.dart';
import 'package:budget_tracker/utils/flutterfoas.dart';

import 'package:budget_tracker/widget/custombutton_new.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  bool isAgreed = false;
  final ref = FirebaseFirestore.instance.collection('appuser');
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool is_loading = false;
  signupFunction() {
    is_loading = true;
    setState(() {});
    print('this is user email ${emailController.text.trim()}');
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim())
        .then((v) {
      ref.doc(v.user!.uid).set({
        "currentAmount": 0.0,
        "name": nameController.text.trim().toString(),
        'email': emailController.text.trim().toString(),
        'uid': v.user!.uid
      });

      fluttertoas().showpopup(pro_color.maincolor, 'sigup successfully');

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Homescreen()));
      is_loading = false;
      setState(() {});
    }).onError((error, Stack) {
      fluttertoas().showpopup(pro_color.redcolor, error.toString());
      is_loading = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pro_color.whitecolor,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Welcome Section
              Row(
                children: [
                  Container(
                    height: 250,
                    width: 360,
                    decoration: BoxDecoration(
                      color: pro_color.maincolor,
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(0),
                        topRight: Radius.circular(350),
                        bottomLeft: Radius.circular(450),
                        topLeft: Radius.circular(10),
                      ),
                    ),
                    child: Center(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sign Up',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              'Hello! lets join with us',
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 15,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Signup Form
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: TextFormField(
                          controller: nameController,
                          autofocus: true,
                          style: const TextStyle(
                              fontSize: 15.0, color: Colors.black),
                          decoration: InputDecoration(
                            labelText: 'USER NAME',
                            hintText: 'Username',
                            filled: true,
                            fillColor: Colors.white.withOpacity(.3),
                            contentPadding: const EdgeInsets.only(
                              left: 14.0,
                              bottom: 6.0,
                              top: 8.0,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: pro_color.maincolor),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a username';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: TextFormField(
                          controller: emailController,
                          autofocus: false,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(
                              fontSize: 15.0, color: Colors.black),
                          decoration: InputDecoration(
                            labelText: 'EMAIL ADDRESS',
                            hintText: 'Enter email address',
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.only(
                              left: 14.0,
                              bottom: 6.0,
                              top: 8.0,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: pro_color.maincolor),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                            if (!emailRegex.hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          autofocus: false,
                          style: const TextStyle(
                              fontSize: 15.0, color: Colors.black),
                          decoration: InputDecoration(
                            labelText: 'PASSWORD',
                            hintText: 'Enter password',
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.only(
                              left: 14.0,
                              bottom: 6.0,
                              top: 8.0,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: pro_color.maincolor),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters long';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            Checkbox(
                              value: isAgreed,
                              onChanged: (bool? value) {
                                setState(() {
                                  isAgreed = value ?? false;
                                });
                              },
                            ),
                            const Expanded(
                              child: Text(
                                'I accept the policy and terms',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Signup Button

                      CustomButton(
                          isloading: is_loading,
                          text: 'sign up',
                          onPressed: signupFunction),
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account? ',
                            style: TextStyle(color: Colors.black),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()),
                              );
                            },
                            child: const Text(
                              'Log in',
                              style: TextStyle(
                                color: pro_color.maincolor,
                                decoration: TextDecoration.underline,
                                decorationThickness: 2,
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
