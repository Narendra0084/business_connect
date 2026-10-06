import 'package:flutter/material.dart';

class ReusableWidgets {
  static buildInputTextFieldBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: Colors.white),
      borderRadius: BorderRadius.circular(16),
    );
  }
}
