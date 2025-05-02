/*
 * File: auth_controller.dart
 * Project: Marie ERP
 * Created Date: 2024
 * 
 * Copyright (c) 2024 Group 17
 * 
 * Authors:
 * - All Group 17 Members
 * 
 * Description:
 * Authentication controller class that handles user registration and login
 * functionality for the Marie ERP system. Implements secure token storage,
 * API communication, and user session management using GetX state management.
 * 
 * Features:
 * - User authentication (login/register)
 * - Secure token management
 * - User session persistence
 * - API connectivity testing
 * - Error handling and validation
 * - User data storage (ID, name, token)
 * 
 * Libraries Used:
 * - get - State management (GetX)
 * - http - API communication
 * - flutter_secure_storage - Secure token storage
 * - dart:convert - JSON processing
 * 
 * External Dependencies:
 * - get: ^4.6.5
 *   Source: https://pub.dev/packages/get
 * - http: ^0.13.5
 *   Source: https://pub.dev/packages/http
 * - flutter_secure_storage: ^8.0.0
 *   Source: https://pub.dev/packages/flutter_secure_storage
 * 
 * API Endpoints:
 * - POST /login - User authentication
 * - POST /register - User registration
 * 
 * Security Features:
 * - Secure token storage
 * - Password confirmation
 * - API response validation
 * - Error handling
 * 
 * Modified/Adapted From:
 * - GetX controller patterns
 *   Source: https://github.com/jonataslaw/getx/blob/master/documentation/en_US/state_management.md
 * - Flutter secure storage implementation
 *   Source: https://pub.dev/packages/flutter_secure_storage/example
 */

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

        // correctly grab the ID from result['user']['id']
        final uid = result['user']?['id']?.toString() ?? '';
        await storage.write(key: "userId", value: uid);

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

  /// Call your new `/register` endpoint
  Future<Map<String, dynamic>?> registerUser({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      // 1) ping test (optional)
      final ping = await http.get(Uri.parse(endPoint['register']!));
      if (ping.statusCode == 404) return null;

      // 2) actual register call
      final response = await http.post(
        Uri.parse(endPoint['register']!),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        }),
      );

      if (response.statusCode == 201) {
        final result = jsonDecode(response.body) as Map<String, dynamic>;

        // store token & user info
        await storage.write(key: 'token', value: result['token']);
        final uid = result['user']?['id']?.toString() ?? '';
        await storage.write(key: 'userId', value: uid);
        final uname = (result['user']?['name'] ?? '') as String;
        await storage.write(key: 'userName', value: uname);

        return result;
      } else {
        // server‐side validation errors or email taken
        print("Register failed: ${response.statusCode} ${response.body}");
        return null;
      }
    } catch (err) {
      print("Error during register: $err");
      return null;
    }
  }
}
