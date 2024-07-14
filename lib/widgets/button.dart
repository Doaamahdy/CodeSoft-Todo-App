import 'package:flutter/material.dart';
import 'package:todo_app/screens/themes.dart';

class MyButton extends StatelessWidget {
  final String label;
  final Function()? onTap;
  final double? width;
  final double? height;

  const MyButton(
      {required this.label, required this.onTap, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? 100,
        height: height ?? 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: primaryColor,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
