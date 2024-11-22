import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../constants/url.dart';

class GroupsController extends GetxController {
  List category = [];
  List ingredient = [];

  final storage = const FlutterSecureStorage();
  Future selectStock({
    String? userId,
  }) async {
    try {
      // LoadingWidget.startLoadingWidget();
      print("-----------------------------");
      print(endPoint['selectingStock']);
      var userId = await storage.read(key: "userId");
      var token = await storage.read(key: "token");
      var body = json.encode({
        "userId": userId,
      });

      if (kDebugMode) {
        print(body);
      }

      final response = await http.post(Uri.parse(endPoint['selectingStock']),
          // contentType: "application/json",
          headers: {
            'Accept': 'application/json',
            'Cookie': 'authorization_token=$token'
          },
          body: body);

      // Check if the response is successful
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        print(response.statusCode); // Print the status code
        print("...........sivam.....$result");

        // Accessing the status from the response JSON
        var status = result['selectedData'][0]["category"];
        category = result['selectedData'];
        // ingredient = result['selectedData'];
        print(category[0]["category"]);
        // print(ingredient[0]["ingredient"]);
        for (var element in result['selectedData']) {
          print("element;;;;;;;;;;;;;;;;;;;;;;;;;;;;");
          print("ingegeridiants${element["ingredients"] ?? ""}");
          ingredient = element["ingredients"] ?? [];
          print(ingredient);
        }
        print('Status;;;;;;;;;;;;;;;;;;;;: $status');

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

  Future<dynamic> downloadStockCard(String from_date, String to_date) async {
    try {
      // LoadingWidget.startLoadingWidget();
      var userId = await storage.read(key: "userId");
      var token = await storage.read(key: "token");
      var body = json.encode(
          {"userId": userId, "from_date": from_date, "to_date": to_date});

      if (kDebugMode) {
        print(";;;;;;;;;;;;;;;;;$body");
      }

      final response = await http.post(Uri.parse(endPoint['download']),
          // contentType: "application/json",
          headers: {
            'Accept': 'application/json',
            'Cookie': 'authorization_token=$token'
          },
          body: body);

      var result = jsonDecode(response.body);
      print(result);
      // Check if the response is successful
      if (response.statusCode == 200) {
        return result;
      } else {
        return null;
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      return null;
    }
  }
}
