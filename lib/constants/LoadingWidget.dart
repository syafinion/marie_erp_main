import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:marie_erp/constants/color.dart';

class LoadingWidget {
  static endLoadingWidget() {
    Navigator.of(Get.overlayContext!).pop();
  }

  static startLoadingWidget() {
    return Get.defaultDialog(
      backgroundColor: Colors.transparent,
      barrierDismissible: false,
      title: "",
      content: WillPopScope(
        onWillPop: () => null!,
        child: Center(
          child: SpinKitCircle(
            color: primaryColor.withOpacity(1.0),
            size: 50.0,
          ),
        ),
      ),
    );
  }
}
