class IngredientModels {
  bool? isChecked;
  String? ingredient;
  String? ingredientId;
  String? measurement;
  List<Measurements>? measurements;

  IngredientModels(
      {this.isChecked,
        this.ingredient,
        this.ingredientId,
        this.measurement,
        this.measurements});

  IngredientModels.fromJson(Map<String, dynamic> json) {
    isChecked = json['isChecked'];
    ingredient = json['ingredient'].toString();
    ingredientId = json['ingredientId'].toString();
    measurement = json['measurement'].toString();
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
    measurementId = json['measurement_id'].toString();
    measurement = json['measurement'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['measurement_id'] = this.measurementId;
    data['measurement'] = this.measurement;
    return data;
  }
}
