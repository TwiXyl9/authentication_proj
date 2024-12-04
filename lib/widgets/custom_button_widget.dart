import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String btnText;
  final Function()? onTap;
  final Color btnColor;
  final double width;
  final double margin;
  const CustomButton({
    super.key,
    required this.btnText,
    required this.onTap,
    required this.btnColor,
    this.width = 200,
    this.margin = 20
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        margin: EdgeInsets.all(margin),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: btnColor,
            borderRadius: BorderRadius.circular(8)
        ),
        child: Text(
          btnText,
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16
          ),
        ),
      ),
    );
  }
}