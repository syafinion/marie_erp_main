class Stocks {
  String? id;
  String? restaurant;
  String? category;
  String? item;
  String? stockCount;
  String? planToBuy;
  String? bought;
  String? pricePerUnit;
  String? closingStock;
  String? consumption;
  String? datecreated;
  String? unit;

  // ← new fields for your breakdown
  final int processingPct;
  final int packagingPct;
  final int environmentPct;

  Stocks({
    this.id,
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
    this.unit,
    required this.processingPct,
    required this.packagingPct,
    required this.environmentPct,
  });

  Stocks.fromJson(Map<String, dynamic> json)
      : id = json['id']?.toString(),
        restaurant = json['restaurant']?.toString(),
        category = json['category']?.toString(),
        item = json['item']?.toString(),
        stockCount = json['stockCount']?.toString(),
        planToBuy = json['planToBuy']?.toString(),
        bought = json['bought']?.toString(),
        pricePerUnit = json['pricePerUnit']?.toString(),
        closingStock = json['closingStock']?.toString(),
        consumption = json['consumption']?.toString(),
        datecreated = json['datecreated']?.toString(),
        unit = json['unit']?.toString(),

        // <<< HERE are your three new mappings >>>
        processingPct = json['processing_pct'] is int
            ? json['processing_pct']
            : int.tryParse(json['processing_pct']?.toString() ?? '0') ?? 0,
        packagingPct = json['packaging_pct'] is int
            ? json['packaging_pct']
            : int.tryParse(json['packaging_pct']?.toString() ?? '0') ?? 0,
        environmentPct = json['environment_pct'] is int
            ? json['environment_pct']
            : int.tryParse(json['environment_pct']?.toString() ?? '0') ?? 0;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurant': restaurant,
      'category': category,
      'item': item,
      'stockCount': stockCount,
      'planToBuy': planToBuy,
      'bought': bought,
      'pricePerUnit': pricePerUnit,
      'closingStock': closingStock,
      'consumption': consumption,
      'datecreated': datecreated,
      'unit': unit,
      // and make sure you serialize them back if you ever need to
      'processing_pct': processingPct,
      'packaging_pct': packagingPct,
      'environment_pct': environmentPct,
    };
  }
}
