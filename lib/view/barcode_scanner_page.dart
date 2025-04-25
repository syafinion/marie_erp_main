import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  Future<void> updateStock({
    required String ingredientId,
    required String type,
    required String quantity,
    required String price,
  }) async {
    setState(() => isLoading = true);
    try {
      final payload = {
        'ingredient_id': ingredientId,
        'type': type,
        'quantity': int.parse(quantity),
        'price_per_unit': double.parse(price),
        'remarks': 'Stock adjustment via scanner',
        'user_id': null,
      };

      final response = await http.post(
        Uri.parse(manageStockUrl),
        body: jsonEncode(payload),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        Get.snackbar('Success', 'Stock updated successfully');
      } else {
        Get.snackbar('Error', 'Failed to update stock');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while updating stock');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> startBarcodeScanner() async {
    final String? result = await SimpleBarcodeScanner.scanBarcode(
      context,
      barcodeAppBar: const BarcodeAppBar(
        appBarTitle: 'Scan Barcode',
        enableBackButton: true,
      ),
      isShowFlashIcon: true,
      cameraFace: CameraFace.back,
    );

    if (result == null) {
      Navigator.pop(context);
      return;
    }

    setState(() => scannedBarcode = result);
    final ingredientData = await fetchIngredientByBarcode(result);
    if (ingredientData.isEmpty) {
      Get.snackbar('Error', 'Ingredient not found. Try again.');
      Navigator.pop(context);
      return;
    }

    final ingredientIdRaw = ingredientData['data']['ingredientId'];
    final String ingredientId = ingredientIdRaw.toString();
    final int currentStock = await fetchCurrentStock(ingredientId);
    debugPrint('currentStock=$currentStock for $ingredientId');
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
                              if (isStockIn && price <= 0) {
                                Get.snackbar('Error', 'Price must be > 0');
                                return;
                              }

                              await updateStock(
                                ingredientId: ingredientId.toString(),
                                type: isStockIn ? 'in' : 'out',
                                quantity: qty.toString(),
                                price: price.toString(),
                              );

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
