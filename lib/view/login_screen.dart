// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:marie_erp/constants/color.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:marie_erp/controller/auth_controller.dart';
import 'package:marie_erp/view/main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final storage = const FlutterSecureStorage();

  isLoggedIn() async {
    userName.text ="karthickravikumar710@gmail.com";
    password.text ="karthick007";
    var token = await storage.read(key: "token");
    if (token != null) {
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MainScreen(
            index: 0, selectedItems: [],
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    // isLoggedIn();
    super.initState();
  }

  AuthController authController = Get.put(AuthController());
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isUserNameEmpty = true;
  bool isPasswordEmpty = true;
  bool isObsecure = false;

  


  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.06, vertical: height * 0.2),
                child: Column(
                  children: [
                    // SizedBox(height: height * 0.02),
                    SizedBox(
                      child: Image.asset(
                        "assets/mrp_logo.png",
                      ),
                    ),
                    SizedBox(height: height * 0.05),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Welcome to Marie ERP",
                          style: TextStyle(
                              fontFamily: "Lexand",
                              fontSize: height * 0.022,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          child: Image.asset(
                            "assets/hand-icon.png",
                            height: height * 0.022,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: height * 0.02),
                    Text(
                      "Log into your account",
                      style: TextStyle(
                          fontFamily: "Lexand",
                          fontSize: height * 0.017,
                          fontWeight: FontWeight.w300),
                    ),
                    SizedBox(height: height * 0.02),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                      child: SizedBox(
                        height: height * 0.05,
                        child: TextFormField(
                          controller: userName,
                          decoration: InputDecoration(
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                "assets/user_icon.png",
                                height: height * 0.02,
                              ),
                            ),
                            contentPadding: EdgeInsets.only(left: 16.0),
                            // border: InputBorder.none,
                            label: Text(
                              "Username*",
                              style: TextStyle(
                                  color: isUserNameEmpty || userName.text == ""
                                      ? Colors.black45
                                      : Colors.red,
                                  fontFamily: "Lexand",
                                  fontWeight: FontWeight.w300),
                            ),

                            floatingLabelStyle: TextStyle(
                                color: isUserNameEmpty || userName.text == ""
                                    ? borderColor.withOpacity(1.0)
                                    : Colors.red,
                                fontFamily: "Lexand",
                                fontWeight: FontWeight.w300),

                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(
                                    color: isUserNameEmpty
                                        ? borderColor.withOpacity(1.0)
                                        : Colors.red,
                                    width: 1.5)),
                            disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(
                                    color: isUserNameEmpty
                                        ? borderColor.withOpacity(1.0)
                                        : Colors.red,
                                    width: 1.5)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(
                                  color: borderColor.withOpacity(1.0),
                                  width: 1.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(
                                  color: isUserNameEmpty
                                      ? borderColor.withOpacity(1.0)
                                      : Colors.red,
                                  width: 1.5),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              isUserNameEmpty = userName.text.isNotEmpty;
                            });
                          },
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: width * 0.08),
                        child: Text(
                          isUserNameEmpty ? "" : "Username is required*",
                          style: TextStyle(
                              color: Colors.red,
                              fontFamily: "Lexand",
                              fontSize: height * 0.012,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    SizedBox(
                      height: height * 0.05,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                        child: TextFormField(
                          obscureText: isObsecure,
                          obscuringCharacter: "*",
                          controller: password,
                          decoration: InputDecoration(
                            suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  isObsecure = !isObsecure;
                                });
                              },
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(isObsecure
                                      ? Icons.visibility_off
                                      : Icons.visibility)),
                            ),
                            contentPadding: EdgeInsets.only(left: 16.0),
                            // border: InputBorder.none,
                            label: const Text(
                              "Password*",
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontFamily: "Lexand",
                                  fontWeight: FontWeight.w300),
                            ),
                            floatingLabelStyle: TextStyle(
                                color:
                                    isPasswordEmpty ? Colors.black : Colors.red,
                                fontFamily: "Lexand",
                                fontWeight: FontWeight.w300),

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(
                                  color: isPasswordEmpty
                                      ? borderColor.withOpacity(1.0)
                                      : Colors.red,
                                  width: 1.5),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(
                                  color: password.text.isNotEmpty
                                      ? borderColor.withOpacity(1.0)
                                      : Colors.red,
                                  width: 1.5),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(
                                    color: isPasswordEmpty
                                        ? borderColor.withOpacity(1.0)
                                        : borderColor.withOpacity(1.0),
                                    width: 1.5)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(
                                  color: isPasswordEmpty
                                      ? borderColor.withOpacity(1.0)
                                      : Colors.red,
                                  width: 1.5),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              isPasswordEmpty = password.text.isNotEmpty;
                            });
                          },
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: width * 0.08),
                        child: Text(
                          isPasswordEmpty ? " " : "Password is required*",
                          style: TextStyle(
                              color: Colors.red,
                              fontFamily: "Lexand",
                              fontSize: height * 0.012,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    InkWell(
                      onTap: () async {
                        var result = await authController.authUser(
                            email: userName.text, password: password.text);
                        isPasswordEmpty = password.text.isNotEmpty;
                        print("$result Login screen");
                        if (result != null) {
                          AnimatedSnackBar.material(
                            'Successfully Logged',
                            type: AnimatedSnackBarType.success,
                            duration: const Duration(seconds: 2),
                            mobilePositionSettings:
                                const MobilePositionSettings(
                              topOnAppearance: 100,
                              topOnDissapear: 50,
                              // bottomOnAppearance: 100,
                              // bottomOnDissapear: 50,
                              // left: 20,
                              right: 10,
                            ),
                            mobileSnackBarPosition: MobileSnackBarPosition.top,
                            desktopSnackBarPosition:
                                DesktopSnackBarPosition.bottomLeft,
                          ).show(context);
                          await Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MainScreen(
                                index: 0, selectedItems: [],
                              ),
                            ),
                          );
                        } else {
                          AnimatedSnackBar.material(
                            'Invalid Email or Password',
                            type: AnimatedSnackBarType.error,
                            duration: const Duration(seconds: 2),
                            mobilePositionSettings:
                                const MobilePositionSettings(
                              topOnAppearance: 100,
                              topOnDissapear: 50,
                              // bottomOnAppearance: 100,
                              // bottomOnDissapear: 50,
                              // left: 20,
                              right: 10,
                            ),
                            mobileSnackBarPosition: MobileSnackBarPosition.top,
                            desktopSnackBarPosition:
                                DesktopSnackBarPosition.bottomLeft,
                          ).show(context);
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                        child: Container(
                          height: height * 0.05,
                          width: width,
                          decoration: BoxDecoration(
                            color: buttonColor.withOpacity(1.0),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                "Log in",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Lexand",
                                    fontSize: height * 0.016,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
