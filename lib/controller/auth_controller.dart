import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:marie_erp/constants/url.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/LoadingWidget.dart';

class AuthController extends GetxController {
  final storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>?> authUser(
      {String? email, String? password}) async {
    try {
      // Test reachability
      final connectivityTest = await http.get(Uri.parse(endPoint['login']!));
      if (connectivityTest.statusCode != 404) {
        print("API is reachable");
      } else {
        print("API not reachable");
        return null;
      }

      print("-----------------------------");
      print("Request URL: ${endPoint['login']}");
      var body = json.encode({"email": email, "password": password});
      print("Request Body: $body");

      final response = await http.post(
        Uri.parse(endPoint['login']!),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: body,
      );

      print("Response Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        // Convert `userId` to a string before storing
        await storage.write(key: "token", value: result['token']);
        await storage.write(key: "userId", value: result['userId'].toString());
        return result; // Return the parsed JSON
      } else {
        // Handle non-200 responses
        print("Login failed: ${response.body}");
        return null;
      }
    } catch (error) {
      print("Error during login: $error");
      return null;
    }
  }
}
