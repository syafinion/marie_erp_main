import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    // Automatically start the scanner when the page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startBarcodeScanner();
    });
  }

  // Fetch ingredient by barcode
  Future<Map<String, dynamic>> fetchIngredientByBarcode(String barcode) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(findIngredientByBarcodeUrl),
        body: jsonEncode({'barcode': barcode}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData;
      } else {
        print('API Error: ${response.body}');
        Get.snackbar('Error', 'Ingredient not found for this barcode');
        return {};
      }
    } catch (e) {
      print('Fetch Error: $e');
      Get.snackbar('Error', 'Failed to fetch ingredient');
      return {};
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // 1) Update the signature of updateStock to accept price:
  Future<void> updateStock({
    required String ingredientId,
    required String type,
    required String quantity,
    required String price, // ← new
  }) async {
    setState(() {
      isLoading = true;
    });

    try {
      final Map<String, dynamic> payload = {
        'ingredient_id': ingredientId,
        'type': type,
        'quantity': int.parse(quantity),
        'price_per_unit': double.parse(price), // ← include price here
        'remarks': 'Stock adjustment via scanner',
        'user_id': null,
      };

      print('Payload sent to API: $payload');

      final response = await http.post(
        Uri.parse(manageStockUrl),
        body: jsonEncode(payload),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        Get.snackbar('Success', 'Stock updated successfully');
      } else {
        print('API Error: ${response.body}');
        Get.snackbar('Error', 'Failed to update stock');
      }
    } catch (e) {
      print('Update Stock Error: $e');
      Get.snackbar('Error', 'An error occurred while updating stock');
    } finally {
      setState(() {
        isLoading = false;
      });
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

    if (result != null) {
      setState(() {
        scannedBarcode = result;
      });
      print('Scanned Barcode: $scannedBarcode'); // Print scanned barcode

      // Fetch ingredient by barcode
      final ingredientData = await fetchIngredientByBarcode(result);

      if (ingredientData.isNotEmpty) {
        final ingredientId = ingredientData['data']['ingredientId'];

        // Show quantity input dialog
        showDialog(
          context: context,
          builder: (context) {
            // Determine form type (stock in or stock out)
            final bool isStockIn = widget.ingredientId == 'stock_in';

            // Extract fields from your 'ingredientData'
            final name = ingredientData['data']['ingredient'] ?? 'Unknown';
            final storageLocation =
                ingredientData['data']['storageLocation'] ?? 'N/A';

            // Parse booleans properly
            bool parseBool(dynamic value) {
              if (value == 1 || value == "1" || value == true) return true;
              return false;
            }

            final isLoose = parseBool(ingredientData['data']['isLoose']);
            final isCarton = parseBool(ingredientData['data']['isCarton']);
            final isBag = parseBool(ingredientData['data']['isBag']);
            final measurement = ingredientData['data']['measurement'] ?? '';

            final double dbUnitPrice = double.tryParse(
                  ingredientData['data']['unitPrice']?.toString() ?? '0.0',
                ) ??
                0.0;

            final String currentDate = DateTime.now().toString().split(' ')[0];

            // Controllers for user input
            final TextEditingController quantityController =
                TextEditingController(text: "1"); // Pre-fill with "1"
            final TextEditingController priceController =
                TextEditingController(text: dbUnitPrice.toStringAsFixed(2));

            double totalCost = 0.0;
            // Build a comma-separated list of the package type(s)
            List<String> packageTypes = [];
            if (isLoose) packageTypes.add('Loose');
            if (isCarton) packageTypes.add('Carton');
            if (isBag) packageTypes.add('Bag');
            final packageTypeText =
                packageTypes.isEmpty ? 'None' : packageTypes.join(', ');

            return AlertDialog(
              content: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: BorderSide(
                    color: isStockIn ? Colors.green : Colors.red,
                    width: 4.0,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      void recalculateTotal() {
                        final q =
                            double.tryParse(quantityController.text.trim()) ??
                                0.0;
                        final p =
                            double.tryParse(priceController.text.trim()) ?? 0.0;
                        setState(() {
                          totalCost = q * p;
                        });
                      }

                      // Trigger immediate recalc when the dialog builds:
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        recalculateTotal();
                      });

                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Item: $name",
                              style: const TextStyle(
                                fontFamily: "Lexand",
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              isStockIn
                                  ? "Current Stock In Date: $currentDate"
                                  : "Current Stock Out Date: $currentDate",
                              style: TextStyle(
                                fontFamily: "Lexand",
                                fontSize: 14,
                                color: isStockIn ? Colors.green : Colors.red,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Storage: $storageLocation",
                              style: const TextStyle(
                                fontFamily: "Lexand",
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Package Type: $packageTypeText",
                              style: const TextStyle(
                                fontFamily: "Lexand",
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Quantity field
                            const Text(
                              "Enter Quantity",
                              style: TextStyle(
                                fontFamily: "Lexand",
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 5),
                            TextFormField(
                              controller: quantityController,
                              keyboardType: TextInputType.number,
                              onChanged: (_) => recalculateTotal(),
                              decoration: InputDecoration(
                                labelText: "Quantity",
                                suffixText: measurement,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(
                                    width: 1.5,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Price field
                            const Text(
                              "Enter Price",
                              style: TextStyle(
                                fontFamily: "Lexand",
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 5),
                            TextFormField(
                              controller: priceController,
                              keyboardType: TextInputType.number,
                              onChanged: (_) => recalculateTotal(),
                              decoration: InputDecoration(
                                labelText: "Price",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(
                                    width: 1.5,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Total
                            Text(
                              "Total: \RM${totalCost.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontFamily: "Lexand",
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Action buttons
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    child: const Text(
                                      "Cancel",
                                      style: TextStyle(
                                        fontFamily: "Lexand",
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: // 2) In the AlertDialog’s Save button:
                                      ElevatedButton(
                                    onPressed: () async {
                                      final qtyText =
                                          quantityController.text.trim();
                                      final priceText =
                                          priceController.text.trim();

                                      if (qtyText.isNotEmpty &&
                                          priceText.isNotEmpty) {
                                        await updateStock(
                                          ingredientId: ingredientId.toString(),
                                          type:
                                              widget.ingredientId == 'stock_in'
                                                  ? 'in'
                                                  : 'out',
                                          quantity: qtyText,
                                          price: priceText, // ← pass price here
                                        );
                                        Navigator.pop(context);
                                      } else {
                                        Get.snackbar('Error',
                                            'Please enter both quantity and price');
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          isStockIn ? Colors.green : Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    child: const Text(
                                      "Save",
                                      style: TextStyle(
                                        fontFamily: "Lexand",
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        );
      } else {
        print('Ingredient not found for barcode: $result');
        Get.snackbar('Error', 'Ingredient not found. Try again.');
        startBarcodeScanner(); // Restart scanner on error
      }
    } else {
      print('No barcode detected.');
      Get.snackbar('Error', 'No barcode detected. Try again.');
      startBarcodeScanner(); // Restart scanner if no barcode detected
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isStockIn = widget.ingredientId == 'stock_in';
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isStockIn ? 'Stock In Barcode' : 'Stock Out Barcode',
          style: const TextStyle(fontFamily: "Lexand"),
        ),
        backgroundColor: isStockIn ? Colors.green : Colors.red,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (scannedBarcode != null)
            Text(
              'Last Scanned Barcode: $scannedBarcode',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else
            const Center(
              child: Text('Scanning...'),
            ),
        ],
      ),
    );
  }
}
