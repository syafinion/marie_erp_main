class CreateIngeIngredient {
  String? userId;
  String? category;
  List<IngredientsData>? ingredientsData;

  CreateIngeIngredient({this.userId, this.category, this.ingredientsData});

  CreateIngeIngredient.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    category = json['category'];
    if (json['ingredientsData'] != null) {
      ingredientsData = <IngredientsData>[];
      json['ingredientsData'].forEach((v) {
        ingredientsData!.add(new IngredientsData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['category'] = this.category;
    if (this.ingredientsData != null) {
      data['ingredientsData'] =
          this.ingredientsData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class IngredientsData {
  bool? isChecked;
  String? ingredient;
  String? measurement;
  String? ingredientId;
  List<Measurements>? measurements;

  IngredientsData(
      {this.isChecked,
      this.ingredient,
      this.measurement,
      this.ingredientId,
      this.measurements});

  IngredientsData.fromJson(Map<String, dynamic> json) {
    isChecked = json['isChecked'];
    ingredient = json['ingredient'];
    measurement = json['measurement'];
    ingredientId = json['ingredientId'];
    if (json['measurements'] != null) {
      measurements = <Measurements>[];
      json['measurements'].forEach((v) {
        measurements!.add(new Measurements.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isChecked'] = this.isChecked;
    data['ingredient'] = this.ingredient;
    data['measurement'] = this.measurement;
    data['ingredientId'] = this.ingredientId;
    if (this.measurements != null) {
      data['measurements'] = this.measurements!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Measurements {
  String? measurementId;
  String? measurement;

  Measurements({this.measurementId, this.measurement});

  Measurements.fromJson(Map<String, dynamic> json) {
    measurementId = json['measurement_id'];
    measurement = json['measurement'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['measurement_id'] = this.measurementId;
    data['measurement'] = this.measurement;
    return data;
  }
}
