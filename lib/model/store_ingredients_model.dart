class StoreIngredients {
  String? userId;
  String? category;
  List<Data>? data;

  StoreIngredients({this.userId, this.category, this.data});

  StoreIngredients.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    category = json['category'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['category'] = this.category;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  bool? isChecked;
  String? ingredient;
  String? ingredientId;
  String? measurement;
  List<Measurements>? measurements;

  Data(
      {this.isChecked,
      this.ingredient,
      this.ingredientId,
      this.measurement,
      this.measurements});

  Data.fromJson(Map<String, dynamic> json) {
    isChecked = json['isChecked'];
    ingredient = json['ingredient'];
    ingredientId = json['ingredientId'];
    measurement = json['measurement'];
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
    data['ingredientId'] = this.ingredientId;
    data['measurement'] = this.measurement;
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
