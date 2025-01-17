import 'package:budget_tracker/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class submitButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  const submitButton({
    Key? key,
    required this.onTap,
    this.label = "SAVE",
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: pro_color.maincolor,
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
