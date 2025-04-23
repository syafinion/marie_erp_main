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
    this.barcode, // Include in constructor
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
    return data;
  }
}
