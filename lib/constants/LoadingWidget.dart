/*
 * File: LoadingWidget.dart
 * Project: Marie ERP
 * Created Date: 2024
 * 
 * Copyright (c) 2024 Group 17
 * 
 * Authors:
 * - All Group 17 Members
 * 
 * Description:
 * A utility class that provides loading indicator widgets for the Marie ERP system.
 * Implements a centralized loading animation using SpinKit for consistent loading
 * states across the application. Features customizable spinner with barrier control.
 * 
 * Features:
 * - Centralized loading indicator
 * - Customizable spinner animation
 * - Modal barrier control
 * - Back button handling
 * - Transparent background
 * - Primary color integration
 * 
 * Libraries Used:
 * - flutter/material.dart - Flutter's material design widgets
 * - get - Dialog management (GetX)
 * - flutter_spinkit - Loading animations
 * 
 * External Dependencies:
 * - get: ^4.6.5
 *   Source: https://pub.dev/packages/get
 * - flutter_spinkit: ^5.1.0
 *   Source: https://pub.dev/packages/flutter_spinkit
 * 
 * Usage:
 * - Start loading: LoadingWidget.startLoadingWidget()
 * - End loading: LoadingWidget.endLoadingWidget()
 * 
 * Modified/Adapted From:
 * - Flutter SpinKit implementation guide
 *   Source: https://pub.dev/packages/flutter_spinkit/example
 * - GetX dialog patterns
 *   Source: https://github.com/jonataslaw/getx/blob/master/documentation/en_US/dialog.md
 */

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
