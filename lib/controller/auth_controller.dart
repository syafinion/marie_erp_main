import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:marie_erp/constants/url.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/LoadingWidget.dart';

class AuthController extends GetxController {
  final storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>?> authUser({
    required String email,
    required String password,
  }) async {
    try {
      // connectivity test
      final ping = await http.get(Uri.parse(endPoint['login']!));
      if (ping.statusCode != 404) {
        print("API reachable");
      } else {
        print("API not reachable");
        return null;
      }

      final response = await http.post(
        Uri.parse(endPoint['login']!),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: json.encode({'email': email, 'password': password}),
      );

      print("Login response: ${response.statusCode} ${response.body}");
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body) as Map<String, dynamic>;

        // store token, userId and userName
        await storage.write(key: "token", value: result['token']);
        await storage.write(key: "userId", value: result['userId'].toString());

        // if your backend now returns user.name in the JSON:
        final name = (result['user']?['name'] ?? '') as String;
        await storage.write(key: "userName", value: name);

        return result;
      } else {
        print("Login failed: ${response.body}");
        return null;
      }
    } catch (err) {
      print("Error during login: $err");
      return null;
    }
  }
}
