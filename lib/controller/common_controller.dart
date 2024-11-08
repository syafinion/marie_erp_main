import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:http/http.dart' as http;
import 'package:marie_erp/view/login_screen.dart';

import '../constants/url.dart';
import '../view/groups_screen.dart';

class CommonController extends GetxController {
  String restuarantName = "";
  final storage = const FlutterSecureStorage();

  @override
  void onInit() async {
    print("call onInit");  // this line not printing
    for (int i = 0; i < ingredientsList.length; i++) {
      String key = 'isChecked_${ingredientsList[i].name}';
      String? value = await storage.read(key: key);
      ingredientsList[i].isChecked = (value == 'true')?true:false;
    }
    ingredientsList.refresh();
    update();
    super.onInit();
  }

  RxList<Item> selectedItems = <Item>[].obs;
  RxList<Item> ingredientsList = <Item>[
    Item(name: 'Vegetables', imageName: 'assets/food1.png',isChecked: false),
    Item(name: 'Powders', imageName: 'assets/food2.png',isChecked: false),
    Item(name: 'Spices', imageName: 'assets/food3.png',isChecked: false),
    Item(name: 'Lentils', imageName: 'assets/food4.png',isChecked: false),
    Item(name: 'Seafoods', imageName: 'assets/food5.png',isChecked: false),
    Item(name: 'Rice', imageName: 'assets/food6.png',isChecked: false),
    Item(name: 'Oils', imageName: 'assets/food7.png',isChecked: false),
    Item(name: 'Fruits', imageName: 'assets/food8.png',isChecked: false),
    Item(name: 'Meats', imageName: 'assets/food9.png',isChecked: false),
    Item(name: 'Flour', imageName: 'assets/food10.png',isChecked: false),
    Item(name: 'Sauces', imageName: 'assets/food11.png',isChecked: false),
    Item(name: 'Beverages', imageName: 'assets/food12.png',isChecked: false),
    Item(name: 'Dairy', imageName: 'assets/food13.png',isChecked: false),
  ].obs;

  Future<dynamic> commomDataGet() async {
    try {
      // LoadingWidget.startLoadingWidget();
      print("-----------------------------");
      // print(endPoint['common']);
      var userId = await storage.read(key: "userId");
      var token = await storage.read(key: "token");
      var body = json.encode({
        "userId": userId,
      });
      if (kDebugMode) {
        print(";;;;;;;;;;;;;;;;;$body");
        print(Uri.parse(endPoint['common']));
      }
      final response = await http.post(Uri.parse(endPoint['common']),
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
        print(":::::::::::::::::::${result["Data"]["0"]["restaurantName"]}");
        restuarantName = result["Data"]["0"]["restaurantName"];
        await storage.write(key: "currency", value: result["Data"]["0"]["currency"]);
        // currency
        return result;
      } else if (response.statusCode == 400) {
        // PopupDialogs.displayErrorOnlyMessage(result["message"]);
        await storage.delete(key: "token");
        Get.off(const LoginScreen());
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
