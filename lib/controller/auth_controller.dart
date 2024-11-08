import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:marie_erp/constants/url.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/LoadingWidget.dart';

class AuthController extends GetxController {
  final storage = const FlutterSecureStorage();
  Future authUser({String? email, String? password}) async {
    try {
      // LoadingWidget.startLoadingWidget();
      print("-----------------------------");
      print(endPoint['login']);
      var body = json.encode({"email": email, "password": password});
      print(body);

      final response = await http.post(Uri.parse(endPoint['login']),
          // contentType: "application/json",
          headers: {'Accept': 'application/json'},
          body: body);
      var result = jsonDecode(response.body);
      print(response.statusCode); // Print the status code
      print(".......$result");
      // Check if the response is successful
      if (response.statusCode == 200) {

        storage.write(key: "token", value: result['token']);
        storage.write(key: "userId", value: result['userId']);

        // Accessing the status from the response JSON
        var status = result['status'];
        print('Status: $status');
        var token = await storage.read(key: "token");
        print(token);

        // if (kDebugMode) {
        //   print('result login body...............');
        // }
        // if (kDebugMode) {
        //   print(result["is_stepper_completed"]);
        // }

        // LoadingWidget.endLoadingWidget();

        return result;
      } else {
        // LoadingWidget.endLoadingWidget();
        // PopupDialogs.displayErrorOnlyMessage(result["message"]);
        return null;
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      // LoadingWidget.endLoadingWidget();
      // PopupDialogs.displayErrorOnlyMessage(StringHelper.aPI_Crashed);
      return null;
    }
  }
}
