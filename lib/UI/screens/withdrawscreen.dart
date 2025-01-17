import 'package:budget_tracker/widget/customsavedbutton.dart';
import 'package:budget_tracker/widget/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DeductScreen extends StatelessWidget {
  final TextEditingController amountController = TextEditingController();
  final double
      totalBalance; // Assuming you have this value passed into this screen

  DeductScreen({required this.totalBalance});

  void saveExpenseToFirestore(BuildContext context) {
    final amount = double.tryParse(amountController.text.trim());

    // Check if the entered amount is valid and not less than or equal to 0
    if (amount == null || amount <= 0) {
      Fluttertoast.showToast(
        msg: "Enter a valid amount",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    // Check if the withdrawal amount is greater than the total balance
    if (amount > totalBalance) {
      Fluttertoast.showToast(
        msg: "Insufficient balance! Please enter a valid amount.",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    final String? userId = FirebaseAuth.instance.currentUser?.uid;

    FirebaseFirestore.instance.collection('transactions').add({
      'type': 'expense',
      'amount': amount,
      'date': DateTime.now().toIso8601String(),
      'userId': userId,
    }).then((_) {
      Fluttertoast.showToast(
        msg: "Expense added successfully!",
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      Navigator.pop(context, amount);
    }).catchError((error) {
      Fluttertoast.showToast(
        msg: "Error adding expense: $error",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set a soft, neutral background color
      backgroundColor: Colors.yellow,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Centered Title with custom style
              SizedBox(height: 10.h),
              Center(
                child: Text(
                  "Withdraw",
                  style: TextStyle(
                    fontSize: 24.sp, // Slightly larger font size for title
                    fontWeight: FontWeight.bold,
                    color:
                        Colors.black87, // Darker color for better readability
                  ),
                ),
              ),
              SizedBox(height: 40.h),

              // Card style for form fields (Amount Input)
              Card(
                elevation: 8, // Card shadow
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // Rounded corners
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    children: [
                      textfield_widget(
                        keyboard:
                            TextInputType.numberWithOptions(decimal: true),
                        Controller: amountController,
                        hinttext: 'Enter Amount',
                        labeltext: 'Amount',
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 80.h),

              // Submit Button with centered styling
              Center(
                child: submitButton(
                  onTap: () => saveExpenseToFirestore(context),
                  label: "Submit",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
