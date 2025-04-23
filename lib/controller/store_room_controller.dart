import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:http/http.dart' as http;
import 'package:marie_erp/model/StockListModel.dart';

import '../constants/url.dart';
import '../model/IngredientModels.dart';

class StoreRoomController extends GetxController {
  List<dynamic> ingredientsVegetablesList = [];
  List<dynamic> ingredientsPowedersList = [];
  List<dynamic> ingredientsSpicesList = [];
  List<dynamic> ingredientsLentilList = [];
  List<dynamic> ingredientsSeaFoodList = [];
  List<dynamic> ingredientsRicesList = [];
  List<dynamic> ingredientsOilsList = [];
  List<dynamic> ingredientsFruitesList = [];
  List<dynamic> ingredientsMeatsList = [];
  List<dynamic> ingredientsFloursList = [];
  List<dynamic> ingredientsSaucesList = [];
  List<dynamic> ingredientsBeveragesList = [];
  List<dynamic> ingredientsDairyList = [];

  RxList<IngredientModels> ingredientList = <IngredientModels>[].obs;

  //Stock List

  RxList<Stocks> stockList = <Stocks>[].obs;

  final storage = const FlutterSecureStorage();

  Future<dynamic> stroreRoomingredientsList(String category) async {
    print("DEBUG: category passed to function: $category");
    ingredientList.clear();
    try {
      // LoadingWidget.startLoadingWidget();
      var userId = await storage.read(key: "userId");
      print("DEBUG: userId: $userId");
      var token = await storage.read(key: "token");
      print("DEBUG: token: $token");
      var body = json.encode({"userId": userId, "category": category});
      print("DEBUG: Request body: $body");

      if (kDebugMode) {
        print(";;;;;;;;;;;;;;;;;$body");
      }
      print("DEBUG: category passed to storeRoomingredientsList: $category");

      final response = await http.post(Uri.parse(endPoint['ingredientsList']),
          // contentType: "application/json",
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Cookie': 'authorization_token=$token'
          },
          body: body);

      var result = jsonDecode(response.body);
      print(result);
      // Check if the response is successful
      if (response.statusCode == 200) {
        List<IngredientModels> modelList = [];
        if (result["data"]["categoryListing"]["Vegetables"] != null) {
          ingredientsVegetablesList =
              await result["data"]["categoryListing"]["Vegetables"];
          var data = result["data"]["categoryListing"]["Vegetables"] as List;
          for (var element in data) {
            modelList.add(IngredientModels.fromJson(element));
          }
        } else {}
        // print(result["data"]["categoryListing"]["Powders"]);

        if (result["data"]["categoryListing"]["Powders"] != null) {
          ingredientsPowedersList =
              await result["data"]["categoryListing"]["Powders"];
          var data = result["data"]["categoryListing"]["Powders"] as List;
          for (var element in data) {
            modelList.add(IngredientModels.fromJson(element));
          }
        } else {}
        if (result["data"]["categoryListing"]["Spices"] != null) {
          ingredientsSpicesList =
              await result["data"]["categoryListing"]["Spices"];
          var data = result["data"]["categoryListing"]["Spices"] as List;
          for (var element in data) {
            modelList.add(IngredientModels.fromJson(element));
          }
        } else {}
        if (result["data"]["categoryListing"]["Lentils"] != null) {
          ingredientsLentilList =
              await result["data"]["categoryListing"]["Lentils"];
          var data = result["data"]["categoryListing"]["Lentils"] as List;
          for (var element in data) {
            modelList.add(IngredientModels.fromJson(element));
          }
        } else {}
        if (result["data"]["categoryListing"]["Seafoods"] != null) {
          ingredientsSeaFoodList =
              await result["data"]["categoryListing"]["Seafoods"];
          var data = result["data"]["categoryListing"]["Seafoods"] as List;
          for (var element in data) {
            modelList.add(IngredientModels.fromJson(element));
          }
        } else {}
        if (result["data"]["categoryListing"]["Rice"] != null) {
          ingredientsRicesList =
              await result["data"]["categoryListing"]["Rice"];
          var data = result["data"]["categoryListing"]["Rice"] as List;
          for (var element in data) {
            modelList.add(IngredientModels.fromJson(element));
          }
        } else {}
        if (result["data"]["categoryListing"]["Oils"] != null) {
          ingredientsOilsList = await result["data"]["categoryListing"]["Oils"];
          var data = result["data"]["categoryListing"]["Oils"] as List;
          for (var element in data) {
            modelList.add(IngredientModels.fromJson(element));
          }
        } else {}
        if (result["data"]["categoryListing"]["Fruits"] != null) {
          ingredientsFruitesList =
              await result["data"]["categoryListing"]["Fruits"];
          var data = result["data"]["categoryListing"]["Fruits"] as List;
          for (var element in data) {
            modelList.add(IngredientModels.fromJson(element));
          }
        } else {}
        if (result["data"]["categoryListing"]["Meats"] != null) {
          ingredientsMeatsList =
              await result["data"]["categoryListing"]["Meats"];
          var data = result["data"]["categoryListing"]["Meats"] as List;
          for (var element in data) {
            modelList.add(IngredientModels.fromJson(element));
          }
        } else {}
        if (result["data"]["categoryListing"]["Flour"] != null) {
          ingredientsFloursList =
              await result["data"]["categoryListing"]["Flour"];
          var data = result["data"]["categoryListing"]["Flour"] as List;
          for (var element in data) {
            modelList.add(IngredientModels.fromJson(element));
          }
        } else {}
        if (result["data"]["categoryListing"]["Sauces"] != null) {
          ingredientsSaucesList =
              await result["data"]["categoryListing"]["Sauces"];
          var data = result["data"]["categoryListing"]["Sauces"] as List;
          for (var element in data) {
            modelList.add(IngredientModels.fromJson(element));
          }
        } else {}
        if (result["data"]["categoryListing"]["Beverages"] != null) {
          ingredientsBeveragesList =
              await result["data"]["categoryListing"]["Beverages"];
          var data = result["data"]["categoryListing"]["Beverages"] as List;
          for (var element in data) {
            modelList.add(IngredientModels.fromJson(element));
          }
        } else {}
        if (result["data"]["categoryListing"]["Dairy"] != null) {
          ingredientsBeveragesList =
              await result["data"]["categoryListing"]["Dairy"];
          var data = result["data"]["categoryListing"]["Dairy"] as List;
          for (var element in data) {
            modelList.add(IngredientModels.fromJson(element));
          }
        } else {}
        // print(result["data"]["categoryListing"]["Powders"]);
        // ingredientsSpicesList = result["data"]["categoryListing"]["Spices"];
        // print(result["data"]["categoryListing"]["Spices"]);
        ingredientList.value = modelList;
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

  Future<dynamic> storRoomingrediantEdit({
    required String ingredient,
    required String ingredientId,
    required bool isChecked,
    required String? measurement,
    required bool isLoose,
    required bool isCarton,
    required bool isBag,
    required String packageWeight,
    required String unitPrice,
    required String storageLocation,
  }) async {
    try {
      var userId = await storage.read(key: "userId");
      var token = await storage.read(key: "token");

      // Validate measurement
      if (measurement == null || measurement.isEmpty) {
        print("Measurement is null or empty. Aborting request.");
        return null;
      }

      var body = json.encode({
        "userId": userId,
        "data": [
          {
            "isChecked": isChecked,
            "ingredient": ingredient,
            "ingredientId": ingredientId,
            "measurement": measurement,
            "isLoose": isLoose,
            "isCarton": isCarton,
            "isBag": isBag,
            "packageWeight": packageWeight,
            "unitPrice": unitPrice,
            "storageLocation": storageLocation,
            // Include any additional fields as needed
          }
        ]
      });

      print("Request Body: $body");
      print("Endpoint: ${Uri.parse(endPoint['editIngredient'])}");

      final response = await http.post(
        Uri.parse(endPoint['editIngredient']),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Cookie': 'authorization_token=$token'
        },
        body: body,
      );

      var result = jsonDecode(response.body);
      print("Response: $result");

      if (response.statusCode == 200) {
        return result;
      } else {
        print("Error Response: ${response.body}");
        return null;
      }
    } catch (error) {
      print("Error: $error");
      return null;
    }
  }

  Future<dynamic> createIngredient({
    required String category,
    required String ingredient,
    required String measurement,
    required bool isLoose,
    required bool isCarton,
    required bool isBag,
    required String packageWeight,
    // Change this to optional:
    String? unitPrice,
    required String storageLocation,
    required String barcode,
    required String itemCode, // Add the barcode parameter
  }) async {
    try {
      var userId = await storage.read(key: "userId");
      var token = await storage.read(key: "token");

      final body = {
        "userId": userId,
        "category": category,
        "ingredientsData": [
          {
            "isChecked": true,
            "ingredient": ingredient,
            "measurement": measurement,
            "isLoose": isLoose,
            "isCarton": isCarton,
            "isBag": isBag,
            "packageWeight": packageWeight,
            "storageLocation": storageLocation,
            "barcode": barcode,
            "itemCode": itemCode, // Include barcode in the payload
          }
        ]
      };

      print("Request Body: $body");

      final response = await http.post(
        Uri.parse(endPoint['createIngredient']),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Cookie': 'authorization_token=$token',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Error Response: ${response.body}");
        return null;
      }
    } catch (error) {
      print("Error: $error");
      return null;
    }
  }

  Future<dynamic> updateIngredientBarcode({
    required String ingredientId,
    required String barcode,
    required String quantity,
  }) async {
    try {
      var userId = await storage.read(key: "userId");
      var token = await storage.read(key: "token");

      final body = {
        "userId": userId,
        "ingredientId": ingredientId,
        "quantity": quantity,
        "barcode": barcode,
      };

      final response = await http.post(
        Uri.parse(endPoint['updateIngredientBarcode']),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Cookie': 'authorization_token=$token',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Error Response: ${response.body}");
        return null;
      }
    } catch (error) {
      print("Error: $error");
      return null;
    }
  }

  Future<dynamic> saveIngredientAll(String category) async {
    try {
      // LoadingWidget.startLoadingWidget();
      var userId = await storage.read(key: "userId");
      var token = await storage.read(key: "token");

      var innerArray = [];
      for (int i = 0; i < ingredientList.length; i++) {
        var map = {};
        map["isChecked"] = ingredientList[i].isChecked;
        map["ingredient"] = ingredientList[i].ingredient;
        map["ingredientId"] = ingredientList[i].ingredientId;
        map["measurement"] = ingredientList[i].measurement;
        map["measurements"] = ingredientList[i].measurements;
        innerArray.add(map);
      }

      var body = json
          .encode({"userId": userId, "category": category, "data": innerArray});

      if (kDebugMode) {
        print(";;;;;;;;;;;;;;;;;$body");
      }

      final response = await http.post(Uri.parse(endPoint['storeIngredients']),
          // contentType: "application/json",
          headers: {
            'Accept': 'application/json',
            'Cookie': 'authorization_token=$token'
          },
          body: body);

      var result = jsonDecode(response.body);
      print("sfsdfasdfasd");
      print(result);
      // Check if the response is successful
      if (response.statusCode == 200) {
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

  Future<dynamic> saveIngredient(body) async {
    try {
      // LoadingWidget.startLoadingWidget();
      var userId = await storage.read(key: "userId");
      var token = await storage.read(key: "token");

      if (kDebugMode) {
        print(";;;;;;;;;;;;;;;;;$body");
      }

      final response = await http.post(Uri.parse(endPoint['createIngredient']),
          // contentType: "application/json",
          headers: {
            'Accept': 'application/json',
            'Cookie': 'authorization_token=$token'
          },
          body: body);

      // Check if the response is successful
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);

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

  Future<dynamic> stockListApi({String? category, String? item}) async {
    try {
      // LoadingWidget.startLoadingWidget();
      var userId = await storage.read(key: "userId");
      var token = await storage.read(key: "token");
      var body =
          json.encode({"userId": userId, "category": category, "item": item});

      if (kDebugMode) {
        print(";;;;;;;;;;;;;;;;;$body");
      }

      final response = await http.post(Uri.parse(endPoint['stockList']),
          // contentType: "application/json",
          headers: {
            'Accept': 'application/json',
            'Cookie': 'authorization_token=$token'
          },
          body: body);

      var result = jsonDecode(response.body);
      // Check if the response is successful
      print("${result} ==>result");
      if (response.statusCode == 200) {
        StockListModel stockListModel = await StockListModel.fromJson(result);
        if (stockListModel != null) {
          stockList.value = stockListModel.stocks!;
        }
        print("${stockListModel.toJson()} ```````````");
        return result;
      } else if (response.statusCode == 400) {
        print("${response.statusCode} --------> statuscode");
        StockListModel stockListModel = await StockListModel.fromJson(result);
        print("${stockListModel.toJson()} -----?");

        var data = jsonEncode(stockListModel);

        print("${data} --------aaaaaaaaa");

        return data;
      }
    } catch (error) {
      if (kDebugMode) {
        print("${error} error");
      }
      return null;
    }
  }

  Future<dynamic> editStock({
    String? stockId,
    String? stockCount,
    String? planToBuy,
    String? bought,
    String? pricePerUnit,
  }) async {
    try {
      var userId = await storage.read(key: "userId");
      var token = await storage.read(key: "token");

      // Create the ingredientsData object
      var ingredientsData = {
        "stockCount": stockCount,
        "planToBuy": planToBuy,
        "bought": bought,
        "pricePerUnit": pricePerUnit,
      };
      // Create the body JSON structure
      var body = json.encode({
        "userId": userId,
        "stockId": stockId,
        "ingredientsData": ingredientsData,
      });

      if (kDebugMode) {
        print("Request body: $body");
      }

      final response = await http.post(
        Uri.parse(endPoint['stockEdits']),
        headers: {
          'Accept': 'application/json',
          'Cookie': 'authorization_token=$token'
        },
        body: body,
      );

      // Check if the response is successful
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse;
      } else {
        print('Request failed with status: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      // Handle any exceptions that occur
      if (kDebugMode) {
        print('Error in editStock: $error');
      }
      return null;
    }
  }

  Future<dynamic> addStock({
    String? category,
    String? item,
    String? planToBuy,
    String? stockCount,
    String? date,
  }) async {
    try {
      var userId = await storage.read(key: "userId");
      var token = await storage.read(key: "token");
      var body = json.encode({
        "userId": userId,
        "item": item,
        "category": category,
        "ingredientsData": {
          "stockCount": stockCount,
          "planToBuy": planToBuy,
          "date": date,
        }
      });

      if (kDebugMode) {
        print(";;;;;;;;;;;;;;;;;$body");
      }

      final response = await http.post(Uri.parse(endPoint['stockCreate']),
          // contentType: "application/json",
          headers: {
            'Accept': 'application/json',
            'Cookie': 'authorization_token=$token'
          },
          body: body);

      // Check if the response is successful
      if (response.statusCode == 200) {
        // var result = jsonDecode(response.body);

        return true;
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

  Future<dynamic> deleteStock({String? stockId}) async {
    try {
      var userId = await storage.read(key: "userId");
      var token = await storage.read(key: "token");
      var body = json.encode({
        "userId": userId,
        "stockId": stockId,
      });

      if (kDebugMode) {
        print(";;;;;;;;;;;;;;;;;$body");
      }

      final response = await http.post(Uri.parse(endPoint['stockDelete']),
          // contentType: "application/json",
          headers: {
            'Accept': 'application/json',
            'Cookie': 'authorization_token=$token'
          },
          body: body);

      // Check if the response is successful
      if (response.statusCode == 200) {
        // var result = jsonDecode(response.body);

        return true;
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
