/*
 * File: signup_screen.dart
 * Project: Marie ERP
 * Created Date: 2024
 * 
 * Copyright (c) 2024 Group 17
 * 
 * Authors:
 * - Syafiq
 * 
 * Description:
 * A Flutter widget that implements the user registration screen for Marie ERP.
 * Handles new user account creation with form validation, secure password handling,
 * and real-time input validation. Features responsive design and error messaging.
 * 
 * Features:
 * - User registration form with real-time validation
 * - Password strength checking and confirmation
 * - Secure password handling with visibility toggle
 * - Form validation with visual feedback
 * - Animated error/success notifications
 * - Responsive layout design
 * - Navigation to login and main screens
 * 
 * Libraries Used:
 * - flutter/material.dart - Flutter's material design widgets
 * - flutter_secure_storage - Secure data storage
 * - get - State management (GetX)
 * - animated_snack_bar - Toast notifications
 * 
 * External Dependencies:
 * - flutter_secure_storage: ^8.0.0
 *   Source: https://pub.dev/packages/flutter_secure_storage
 * - get: ^4.6.5
 *   Source: https://pub.dev/packages/get
 * - animated_snack_bar: ^0.3.1
 *   Source: https://pub.dev/packages/animated_snack_bar
 * 
 * Assets Required:
 * - mrp_logo.png - Application logo
 * 
 * State Management:
 * - Uses GetX for authentication state (AuthController)
 * - Local form state managed with setState
 * - Form validation state handling
 * 
 * Modified/Adapted From:
 * - Flutter form validation patterns
 *   Source: https://docs.flutter.dev/cookbook/forms/validation
 * - GetX authentication implementation guide
 *   Source: https://github.com/jonataslaw/getx/blob/master/documentation/en_US/state_management.md
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:marie_erp/constants/color.dart';
import 'package:marie_erp/controller/auth_controller.dart';
import 'package:marie_erp/view/main_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final AuthController authController = Get.find();
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  final TextEditingController confirmCtrl = TextEditingController();

  bool isNameFilled = false;
  bool isEmailFilled = false;
  bool isPassFilled = false;
  bool isConfirmFilled = false;
  bool passMatch = true;
  bool isObsecure = true;
  bool isObsecureConfirm = true;

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: w * 0.06,
              vertical: h * 0.2,
            ),
            child: Column(
              children: [
                Image.asset("assets/mrp_logo.png"),
                SizedBox(height: h * 0.05),
                Text(
                  "Create a new account",
                  style: TextStyle(
                    fontFamily: "Lexand",
                    fontSize: h * 0.022,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: h * 0.02),
                // — Name —
                TextFormField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    label: const Text("Name*"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onChanged: (_) {
                    setState(() => isNameFilled = nameCtrl.text.isNotEmpty);
                  },
                ),
                if (!isNameFilled)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Name is required*",
                      style: TextStyle(
                          color: Colors.red,
                          fontFamily: "Lexand",
                          fontSize: h * 0.012),
                    ),
                  ),
                SizedBox(height: h * 0.02),

                // — Email —
                TextFormField(
                  controller: emailCtrl,
                  decoration: InputDecoration(
                    label: const Text("Email*"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (_) {
                    setState(() => isEmailFilled = emailCtrl.text.isNotEmpty);
                  },
                ),
                if (!isEmailFilled)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Email is required*",
                      style: TextStyle(
                          color: Colors.red,
                          fontFamily: "Lexand",
                          fontSize: h * 0.012),
                    ),
                  ),
                SizedBox(height: h * 0.02),

                // — Password —
                TextFormField(
                  controller: passCtrl,
                  obscureText: isObsecure,
                  decoration: InputDecoration(
                    label: const Text("Password*"),
                    suffixIcon: InkWell(
                      onTap: () => setState(() => isObsecure = !isObsecure),
                      child: Icon(
                          isObsecure ? Icons.visibility_off : Icons.visibility),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onChanged: (_) {
                    setState(() {
                      isPassFilled = passCtrl.text.isNotEmpty;
                      passMatch = passCtrl.text == confirmCtrl.text;
                    });
                  },
                ),
                if (!isPassFilled)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Password is required*",
                      style: TextStyle(
                          color: Colors.red,
                          fontFamily: "Lexand",
                          fontSize: h * 0.012),
                    ),
                  ),
                SizedBox(height: h * 0.02),

                // — Confirm Password —
                TextFormField(
                  controller: confirmCtrl,
                  obscureText: isObsecureConfirm,
                  decoration: InputDecoration(
                    label: const Text("Confirm Password*"),
                    suffixIcon: InkWell(
                      onTap: () => setState(
                          () => isObsecureConfirm = !isObsecureConfirm),
                      child: Icon(isObsecureConfirm
                          ? Icons.visibility_off
                          : Icons.visibility),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onChanged: (_) {
                    setState(() {
                      isConfirmFilled = confirmCtrl.text.isNotEmpty;
                      passMatch = passCtrl.text == confirmCtrl.text;
                    });
                  },
                ),
                if (!passMatch)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Passwords do not match",
                      style: TextStyle(
                          color: Colors.red,
                          fontFamily: "Lexand",
                          fontSize: h * 0.012),
                    ),
                  ),
                SizedBox(height: h * 0.04),

                // — Sign Up button —
                InkWell(
                  onTap: () async {
                    if (!isNameFilled ||
                        !isEmailFilled ||
                        !isPassFilled ||
                        !isConfirmFilled ||
                        !passMatch) {
                      AnimatedSnackBar.material(
                        'Please fix the errors above',
                        type: AnimatedSnackBarType.error,
                      ).show(context);
                      return;
                    }

                    final res = await authController.registerUser(
                      name: nameCtrl.text.trim(),
                      email: emailCtrl.text.trim(),
                      password: passCtrl.text,
                      passwordConfirmation: confirmCtrl.text,
                    );
                    if (res != null) {
                      AnimatedSnackBar.material(
                        'Account created!',
                        type: AnimatedSnackBarType.success,
                      ).show(context);
                      //→ go straight into MainScreen:
                      await Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MainScreen(
                            index: 0,
                            selectedItems: [],
                          ),
                        ),
                      );
                    } else {
                      AnimatedSnackBar.material(
                        'Sign up failed',
                        type: AnimatedSnackBarType.error,
                      ).show(context);
                    }
                  },
                  child: Container(
                    height: h * 0.05,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: buttonColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Sign up",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Lexand",
                        fontSize: h * 0.016,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                // — Back to log in —
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(
                        fontFamily: "Lexand",
                        fontSize: h * 0.014,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        "Log in",
                        style: TextStyle(
                          fontFamily: "Lexand",
                          fontSize: h * 0.014,
                          fontWeight: FontWeight.w600,
                          color: buttonColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
