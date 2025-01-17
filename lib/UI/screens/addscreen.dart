import 'package:budget_tracker/utils/color.dart';
import 'package:budget_tracker/widget/customsavedbutton.dart';
import 'package:budget_tracker/widget/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddScreen extends StatelessWidget {
  final TextEditingController incomeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  void saveToFirestore(BuildContext context) {
    final income = double.tryParse(incomeController.text.trim());
    final description = descriptionController.text.trim();
    if (income == null || description.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please fill in all fields",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }
    FirebaseFirestore.instance.collection('transactions').add({
      'type': 'income',
      'amount': income,
      'description': description,
      'date': DateTime.now().toIso8601String(),
      'userId': FirebaseAuth.instance.currentUser?.uid,
    }).then((_) {
      Fluttertoast.showToast(
        msg: "Income added successfully!",
        backgroundColor: Colors.green,
        textColor: pro_color.whitecolor,
      );
      Navigator.pop(context, income);
    }).catchError((error) {
      Fluttertoast.showToast(
        msg: "Error adding income: $error",
        backgroundColor: pro_color.redcolor,
        textColor: pro_color.whitecolor,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background color or gradient
      backgroundColor: Colors.yellow, // Soft background color
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Title with custom style
              SizedBox(height: 40.h),
              Text(
                "Add Income",
                style: TextStyle(
                  fontSize: 24.sp, // Larger font size for title
                  fontWeight: FontWeight.bold,
                  color: Colors.black87, // Darker text color
                ),
              ),
              SizedBox(height: 30.h),

              // Card style for form fields
              Card(
                elevation: 8, // Card shadow
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // Rounded corners
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.w), // Inner padding for card
                  child: Column(
                    children: [
                      textfield_widget(
                          keyboard:
                              TextInputType.numberWithOptions(decimal: true),
                          Controller: incomeController,
                          hinttext: 'Enter Income amount',
                          labeltext: 'Amount'),
                      SizedBox(height: 20.h),
                      textfield_widget(
                          keyboard: TextInputType.text,
                          Controller: descriptionController,
                          hinttext: 'Enter Description',
                          labeltext: 'Description'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 50.h),

              // Submit button with styling
              submitButton(
                label: 'Submit',
                onTap: () => saveToFirestore(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
