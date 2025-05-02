/*
 * File: barcode_scanner_page.dart
 * Project: Marie ERP
 * Created Date: 2024
 * 
 * Copyright (c) 2024 Group 17
 * 
 * Authors:
 * Syafiq
 * 
 * Description:
 * A Flutter widget that implements barcode scanning functionality for stock management.
 * Handles both stock-in and stock-out operations with barcode validation, quantity tracking,
 * and price management. Integrates with a backend API for real-time stock updates.
 * 
 * Features:
 * - Barcode scanning using device camera
 * - Real-time stock level tracking
 * - Stock in/out management
 * - Price per unit calculation
 * - Secure API integration with token-based authentication
 * 
 * Libraries Used:
 * - flutter/material.dart - Flutter's material design widgets
 * - flutter/services.dart - Platform services integration
 * - flutter_secure_storage - Secure credential storage
 * - get - State management and navigation
 * - http - API communication
 * - simple_barcode_scanner - Barcode scanning functionality
 * 
 * External Dependencies:
 * - simple_barcode_scanner: ^0.0.1
 *   Source: https://pub.dev/packages/simple_barcode_scanner
 * 
 * API Endpoints Used:
 * - findIngredientByBarcode
 * - manageStock
 * - stockList
 * 
 * Modified/Adapted From:
 * - Flutter barcode scanner implementation guide
 *   Source: https://pub.dev/packages/simple_barcode_scanner/example
 */

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:marie_erp/controller/common_controller.dart';
import 'package:marie_erp/view/groups_screen.dart';
import 'package:marie_erp/view/main_screen.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:marie_erp/constants/url.dart';
import 'package:marie_erp/constants/color.dart';

class BarcodeScannerPage extends StatefulWidget {
  final String ingredientId;

  const BarcodeScannerPage({Key? key, required this.ingredientId})
      : super(key: key);

  @override
  _BarcodeScannerPageState createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  BarcodeViewController? _controller;
  String? scannedBarcode;
  bool isLoading = false;

  // API endpoints
  final String findIngredientByBarcodeUrl = endPoint['findIngredientByBarcode'];
  final String manageStockUrl = endPoint['manageStock'];
  final String listStocksUrl = endPoint['stockList'] ?? '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startBarcodeScanner();
    });
  }

  Future<int> fetchCurrentStock(String ingredientId) async {
    if (listStocksUrl.isEmpty) return 0;

    try {
      final response = await http.post(
        Uri.parse(listStocksUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'item': ingredientId}),
      );
      debugPrint(
          'listStocks response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final List stocks = body['stocks'] ?? [];
        if (stocks.isNotEmpty) {
          // assuming your backend returns closingStock key
          return (stocks.last['closingStock'] as num).toInt();
        }
      }
    } catch (e) {
      debugPrint('fetchCurrentStock error: $e');
    }
    return 0;
  }

  Future<Map<String, dynamic>> fetchIngredientByBarcode(String barcode) async {
    setState(() => isLoading = true);
    try {
      final response = await http.post(
        Uri.parse(findIngredientByBarcodeUrl),
        body: jsonEncode({'barcode': barcode}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        Get.snackbar('Error', 'Ingredient not found for this barcode');
        return {};
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch ingredient');
      return {};
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<bool> updateStock({
    required String ingredientId,
    required String type,
    required String quantity,
    required String price,
  }) async {
    setState(() => isLoading = true);

    try {
      // 1) Read stored credentials
      final storage = const FlutterSecureStorage();
      final userId = await storage.read(key: "userId");
      final token = await storage.read(key: "token");

      // 2) Build your payload
      final payload = {
        'ingredient_id': ingredientId,
        'type': type,
        'quantity': int.parse(quantity),
        'price_per_unit': double.parse(price),
        'remarks': 'Stock adjustment via scanner',
        'user_id': userId != null ? int.parse(userId) : null,
      };

      if (kDebugMode) {
        print("→ manageStock payload: ${jsonEncode(payload)}");
      }

      // 3) POST with auth cookie + Accept header
      final response = await http.post(
        Uri.parse(manageStockUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Cookie': 'authorization_token=$token',
        },
        body: jsonEncode(payload),
      );

      // 4) Check for 201 Created
      if (response.statusCode == 201) {
        Get.snackbar('Success', 'Stock updated successfully');
        return true;
      } else {
        debugPrint(
            "manageStock failed (${response.statusCode}): ${response.body}");
        Get.snackbar('Error', 'Failed to update stock');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while updating stock');
      return false;
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> startBarcodeScanner() async {
    // 1) Clear any old scan
    setState(() => scannedBarcode = null);

    String? result;
    bool confirmed = false;

// 2) Keep scanning until we get a confirmed, valid code
    while (!confirmed) {
      try {
        result = await SimpleBarcodeScanner.scanBarcode(
          context,
          barcodeAppBar: const BarcodeAppBar(
            appBarTitle: 'Scan Barcode',
          ),
          isShowFlashIcon: true,
          cameraFace: CameraFace.back,
        ); // ← make sure this closing parenthesis + semicolon is here
      } on PlatformException {
        Navigator.pop(context);
        return;
      }

      // trim off any stray whitespace
      result = result?.trim() ?? '';

      // user hit the plugin’s Cancel (returned empty or all whitespace)
      if (result.isEmpty) {
        Navigator.pop(context);
        return;
      }

      // 3) Basic format check (digits only, 8–13 chars)—tweak to your specs
      if (!RegExp(r'^\d{8,13}$').hasMatch(result)) {
        Get.snackbar('Invalid barcode',
            'That doesn’t look like a valid code. Please try again.');
        continue; // back to scanning
      }

      // 4) Let the user confirm it
      confirmed = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Confirm barcode'),
              content: Text(result!),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: const Text('Rescan'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: const Text('Use this'),
                ),
              ],
            ),
          ) ??
          false;
    }

    setState(() => scannedBarcode = result);

    final ingredientData = await fetchIngredientByBarcode(result!);
    // pull in the very first stock-in from the ingredient record
    final pkgStr = ingredientData['data']['packageWeight']?.toString() ?? '0';
    final int initialWeight = int.tryParse(pkgStr) ?? 0;
    if (ingredientData.isEmpty) {
      Get.snackbar('Error', 'Ingredient not found. Try again.');
      Navigator.pop(context);
      return;
    }

    final ingredientIdRaw = ingredientData['data']['ingredientId'];
    final String ingredientId = ingredientIdRaw.toString();
    // ─── fetch the raw stocks list and pick its closingStock (if any) ─────────────────
    int currentStock;
    try {
      final resp = await http.post(
        Uri.parse(listStocksUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'item': ingredientId}),
      );
      if (resp.statusCode == 200) {
        final map = jsonDecode(resp.body) as Map<String, dynamic>;
        final stocks = (map['stocks'] as List<dynamic>?) ?? [];
        if (stocks.isNotEmpty) {
          // use the server-computed closing stock
          currentStock = (stocks.last['closingStock'] as num).toInt();
        } else {
          // no stock rows yet → fall back
          currentStock = initialWeight;
        }
      } else {
        currentStock = initialWeight;
      }
    } catch (_) {
      currentStock = initialWeight;
    }

    final isStockIn = widget.ingredientId == 'stock_in';
    final name = ingredientData['data']['ingredient'] ?? 'Unknown';
    final storageLocation = ingredientData['data']['storageLocation'] ?? 'N/A';
    final measurement = ingredientData['data']['measurement'] ?? '';
    final dbUnitPrice = double.tryParse(
          ingredientData['data']['unitPrice']?.toString() ?? '0.0',
        ) ??
        0.0;
    final currentDate = DateTime.now().toString().split(' ')[0];

    final quantityController = TextEditingController(text: '1');
    final priceController =
        TextEditingController(text: dbUnitPrice.toStringAsFixed(2));
    double totalCost = 0.0;

    void recalculateTotal() {
      final q = int.tryParse(quantityController.text) ?? 0;
      final p = double.tryParse(priceController.text) ?? 0.0;
      totalCost = q * p;
    }

    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          content: StatefulBuilder(
            builder: (ctx, setStateDialog) {
              void onFieldChange(String _) {
                setStateDialog(() {
                  recalculateTotal();
                });
              }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Item: $name',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    Text('Current Stock: $currentStock $measurement',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text(
                      isStockIn
                          ? 'Stock In Date: $currentDate'
                          : 'Stock Out Date: $currentDate',
                      style: TextStyle(
                          color: isStockIn ? Colors.green : Colors.red),
                    ),
                    const SizedBox(height: 10),
                    Text('Storage: $storageLocation'),
                    const SizedBox(height: 10),
                    const Text('Enter Quantity',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: quantityController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: onFieldChange,
                      decoration: InputDecoration(
                        suffixText: measurement,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (isStockIn) ...[
                      const Text('Enter Price',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: priceController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*'))
                        ],
                        onChanged: onFieldChange,
                        decoration: InputDecoration(
                          labelText: 'Price per unit',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                    Text('Total: RM${totalCost.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            onPressed: () {
                              Navigator.pop(ctx);
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (_) => MainScreen(
                                    selectedItems: Get.find<CommonController>()
                                        .selectedItems,
                                    index: 0,
                                  ),
                                ),
                                (route) => false,
                              );
                            },
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    isStockIn ? Colors.green : Colors.red),
                            onPressed: () async {
                              final qty = int.tryParse(
                                      quantityController.text.trim()) ??
                                  0;
                              final price = isStockIn
                                  ? double.tryParse(
                                          priceController.text.trim()) ??
                                      0.0
                                  : 0.0;

                              if (qty <= 0) {
                                Get.snackbar('Error', 'Quantity must be > 0');
                                return;
                              }

                              if (!isStockIn && qty > currentStock) {
                                Get.snackbar('Error',
                                    'Cannot stock out $qty when only $currentStock in stock');
                                return; // keeps the dialog open for retry
                              }

                              if (isStockIn && price <= 0) {
                                Get.snackbar('Error', 'Price must be > 0');
                                return;
                              }

                              // ✅ RIGHT: call updateStock only once
                              final ok = await updateStock(
                                ingredientId: ingredientId,
                                type: isStockIn ? 'in' : 'out',
                                quantity: qty.toString(),
                                price: price.toString(),
                              ); // if that single call failed, stay in the dialog
                              if (!ok) return;
                              Navigator.pop(ctx);
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (_) => MainScreen(
                                    selectedItems: Get.find<CommonController>()
                                        .selectedItems,
                                    index: 0,
                                  ),
                                ),
                                (route) => false,
                              );
                            },
                            child: const Text('Save'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isStockIn = widget.ingredientId == 'stock_in';
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isStockIn ? 'Stock In Barcode' : 'Stock Out Barcode',
          style: const TextStyle(fontFamily: 'Lexand'),
        ),
        backgroundColor: isStockIn ? Colors.green : Colors.red,
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Text(
                scannedBarcode != null
                    ? 'Last Scanned Barcode: $scannedBarcode'
                    : 'Scanning...',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
