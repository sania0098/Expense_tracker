import 'package:budget_tracker/UI/Auth/signup/signup.dart';
import 'package:budget_tracker/UI/screens/homescreen.dart';
import 'package:budget_tracker/utils/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    moveNextScreen();
  }

  void moveNextScreen() {
    final user = FirebaseAuth.instance.currentUser;
    Future.delayed(const Duration(seconds: 5), () {
      print('user: $user');
      if (user == null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Signup()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Homescreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orangeAccent,
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  pro_color.maincolor,
                  Color(0xFFFEE140),
                  pro_color.maincolor
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Icon or Logo
                Container(
                  height: 100.h,
                  width: 100.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [
                        Colors.yellow,
                        Colors.white,
                        Colors.yellow,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet,
                    size: 50,
                    color: Colors.orange,
                  ),
                ),
                SizedBox(height: 20.h),
                // App Name
                Text(
                  'ExpenseEase',
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 10.h),
                // Tagline
                Text(
                  'Track your finances effortlessly',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 50.h),
                // Loading Indicator
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
