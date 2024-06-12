import 'package:flutter/material.dart';

class Validators {
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }

  String? validateConfirmPassword(String? value, String? value2) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != value2) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? validateRollNo(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your roll number';
    }
    final RegExp rollNoRegex = RegExp(r'^\d{4}-\d{2}-\d{3}-\d{3}$');
    if (!rollNoRegex.hasMatch(value)) {
      return 'Please enter a valid roll number format (e.g., 1604-20-733-309)';
    }
    return null;
  }

  String? validateCollege(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your college name';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    final RegExp phoneRegex = RegExp(r'^[0-9]{10}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }
}
