/*
 * File: StockListModel.dart
 * Project: Marie ERP
 * Created Date: 2024
 * 
 * Copyright (c) 2024 Group 17
 * 
 * Authors:
 * - All Group 17 Members
 * 
 * Description:
 * Data model class representing stock transactions and inventory records in the Marie ERP system.
 * Implements comprehensive stock tracking with wastage breakdown analytics and JSON
 * serialization/deserialization for API communication. Handles both numerical and
 * string-based data types with proper type conversion.
 * 
 * Features:
 * - Complete stock transaction tracking
 * - Wastage breakdown analytics
 *   - Processing waste percentage
 *   - Packaging waste percentage
 *   - Environmental waste percentage
 * - Price and quantity management
 * - Date-based record keeping
 * - Restaurant and category association
 * - Unit measurement tracking
 * - User attribution
 * 
 * Data Structure:
 * - Transaction identifiers (id, restaurant, category)
 * - Stock quantities (stockCount, planToBuy, bought)
 * - Financial tracking (pricePerUnit)
 * - Inventory management (closingStock, consumption)
 * - Temporal data (datecreated)
 * - Waste analytics (processingPct, packagingPct, environmentPct)
 * 
 * Type Handling:
 * - String to int conversion for percentages
 * - Null safety implementation
 * - Default value handling
 * - Type checking for numeric fields
 * 
 * API Integration:
 * - Supports REST API communication
 * - Bidirectional JSON conversion
 * - Robust error handling for missing fields
 * 
 * Modified/Adapted From:
 * - Flutter JSON serialization patterns
 *   Source: https://docs.flutter.dev/development/data-and-backend/json
 * - Null safety implementation guide
 *   Source: https://dart.dev/null-safety/understanding-null-safety
 */

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
  String? userId;

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
    this.userId,
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
            : int.tryParse(json['environment_pct']?.toString() ?? '0') ?? 0,
        userId = json['userId']?.toString();

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
