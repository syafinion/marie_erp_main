class StockListModel {
  String? userId;
  String? category;
  String? item;
  List<Stocks>? stocks;

  StockListModel({this.userId, this.category, this.item, this.stocks});

  StockListModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    category = json['category'];
    item = json['item'];
    if (json['stocks'] != null) {
      stocks = <Stocks>[];
      json['stocks'].forEach((v) {
        stocks!.add(new Stocks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['category'] = this.category;
    data['item'] = this.item;
    if (this.stocks != null) {
      data['stocks'] = this.stocks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Stocks {
  String? id;
  String? restaurant;
  String? category;
  String? item;
  String? stockCount;
  String? planToBuy;
  String? bought;
  String? pricePerUnit;
  dynamic? closingStock;
  dynamic? consumption;
  String? datecreated;
  String? unit;

  Stocks(
      {this.id,
        this.restaurant,
        this.category,
        this.item,
        this.stockCount,
        this.planToBuy,
        this.bought,
        this.pricePerUnit,
        this.closingStock,
        this.consumption,
        this.datecreated,
        this.unit});

  Stocks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    restaurant = json['restaurant'];
    category = json['category'];
    item = json['item'];
    stockCount = json['stockCount'];
    planToBuy = json['planToBuy'];
    bought = json['bought'];
    pricePerUnit = json['pricePerUnit'];
    closingStock = json['closingStock'];
    consumption = json['consumption'];
    datecreated = json['datecreated'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['restaurant'] = this.restaurant;
    data['category'] = this.category;
    data['item'] = this.item;
    data['stockCount'] = this.stockCount;
    data['planToBuy'] = this.planToBuy;
    data['bought'] = this.bought;
    data['pricePerUnit'] = this.pricePerUnit;
    data['closingStock'] = this.closingStock;
    data['consumption'] = this.consumption;
    data['datecreated'] = this.datecreated;
    data['unit'] = this.unit;
    return data;
  }
}
