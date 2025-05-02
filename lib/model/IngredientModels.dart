/*
 * File: IngredientModels.dart
 * Project: Marie ERP
 * Created Date: 2024
 * 
 * Copyright (c) 2024 Group 17
 * 
 * Authors:
 * - All Group 17 Members
 * 
 * Description:
 * Data model class that represents ingredients in the Marie ERP system.
 * Implements JSON serialization/deserialization for API communication and
 * local storage. Handles all ingredient-related attributes including
 * packaging types, measurements, and tracking information.
 * 
 * Features:
 * - JSON serialization/deserialization
 * - Multiple packaging type support (Loose/Carton/Bag)
 * - Measurement system integration
 * - Barcode tracking
 * - Price and weight management
 * - Storage location tracking
 * - User association
 * 
 * Libraries Used:
 * - dart:convert - JSON processing
 * 
 * Dependencies:
 * - create_ingredients_model.dart - For Measurements class
 * 
 * Data Structure:
 * - Basic ingredient information (name, ID)
 * - Packaging information (type, weight)
 * - Tracking data (barcode, location)
 * - Price information
 * - User association
 * 
 * API Integration:
 * - Used in ingredient creation/update endpoints
 * - Supports REST API communication
 * - Handles null safety with default values
 * 
 * Modified/Adapted From:
 * - Flutter JSON serialization patterns
 *   Source: https://docs.flutter.dev/development/data-and-backend/json
 */
import 'package:marie_erp/model/create_ingredients_model.dart';

class IngredientModels {
  bool? isChecked;
  String? ingredient;
  String? ingredientId;
  String? measurement;
  List<Measurements>? measurements;

  // New fields
  bool? isLoose;
  bool? isCarton;
  bool? isBag;
  String? packageWeight;
  String? unitPrice;
  String? storageLocation;
  String? itemCode;

  // Add the barcode field
  String? barcode;
  String? userId;

  IngredientModels({
    this.isChecked,
    this.ingredient,
    this.ingredientId,
    this.measurement,
    this.measurements,
    this.isLoose,
    this.isCarton,
    this.isBag,
    this.packageWeight,
    this.unitPrice,
    this.storageLocation,
    this.itemCode,
    this.barcode,
    this.userId, // Include in constructor
  });

  IngredientModels.fromJson(Map<String, dynamic> json) {
    isChecked = json['isChecked'];
    ingredient = json['ingredient']?.toString();
    ingredientId = json['ingredientId']?.toString();
    measurement = json['measurement']?.toString();
    if (json['measurements'] is List) {
      measurements = (json['measurements'] as List)
          .map((v) => Measurements.fromJson(v))
          .toList();
    }
    isLoose = json['isLoose'] ?? false;
    isCarton = json['isCarton'] ?? false;
    isBag = json['isBag'] ?? false;
    packageWeight = json['packageWeight']?.toString() ?? '';
    unitPrice = json['unitPrice']?.toString() ?? '';
    storageLocation = json['storageLocation']?.toString() ?? '';
    itemCode = json['itemCode']?.toString();
    barcode = json['barcode']?.toString(); // Parse barcode
    userId = json['userId']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['isChecked'] = isChecked;
    data['ingredient'] = ingredient;
    data['ingredientId'] = ingredientId;
    data['measurement'] = measurement;
    if (measurements != null) {
      data['measurements'] = measurements!.map((v) => v.toJson()).toList();
    }
    data['isLoose'] = isLoose;
    data['isCarton'] = isCarton;
    data['isBag'] = isBag;
    data['packageWeight'] = packageWeight;
    data['unitPrice'] = unitPrice;
    data['storageLocation'] = storageLocation;
    data['itemCode'] = itemCode;
    data['barcode'] = barcode; // Include barcode in JSON
    data['userId'] = userId;
    return data;
  }
}
