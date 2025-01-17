import 'package:budget_tracker/UI/Auth/login/login.dart';
import 'package:budget_tracker/UI/Auth/signup/signup.dart';
import 'package:budget_tracker/utils/color.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pro_color.whitecolor,
      appBar: AppBar(
        backgroundColor: pro_color.whitecolor,
        title: const Text(
          'Profile',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: pro_color.blackcolor),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            //profile pic
            Center(
              child: Column(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.grey.shade400),
                    child: Icon(
                      Icons.person,
                      size: 60,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    currentUser.email!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: pro_color.blackcolor,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 70,
            ),

            Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: pro_color.maincolor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut().then((v) {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      });
                    },
                    icon: Icon(Icons.logout, color: pro_color.whitecolor),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Logout',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: pro_color.maincolor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      FirebaseAuth.instance.currentUser!.delete().then((v) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Signup()));
                      });
                    },
                    icon: const Icon(Icons.delete, color: pro_color.whitecolor),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Delete account',
                    style: TextStyle(fontSize: 15, color: pro_color.whitecolor),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
