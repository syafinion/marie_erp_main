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

  Future<void> updateStock({
    required String ingredientId,
    required String type,
    required String quantity,
  }) async {
    setState(() {
      isLoading = true;
    });

    try {
      // Construct the request payload
      final Map<String, dynamic> payload = {
        'ingredient_id': ingredientId,
        'type': type,
        'quantity': int.parse(quantity), // Ensure quantity is an integer
        'remarks': 'Stock adjustment via scanner', // Optional remarks
        'user_id': null, // Pass null or a valid user_id
      };

      // Debugging: Print the payload
      print('Payload sent to API: $payload');

      // Send the request to the API
      final response = await http.post(
        Uri.parse(manageStockUrl),
        body: jsonEncode(payload),
        headers: {'Content-Type': 'application/json'},
      );

      // Check response status
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

// Join them with commas
            final packageTypeText =
                packageTypes.isEmpty ? 'None' : packageTypes.join(', ');

            return AlertDialog(
              content: StatefulBuilder(
                builder: (context, setState) {
                  void recalculateTotal() {
                    final q =
                        double.tryParse(quantityController.text.trim()) ?? 0.0;
                    final p =
                        double.tryParse(priceController.text.trim()) ?? 0.0;
                    setState(() {
                      totalCost = q * p;
                    });
                  }

                  // 1) Trigger an immediate recalc when the dialog builds:
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
                        Text("Current Stock In Date: $currentDate",
                            style: const TextStyle(
                                fontFamily: "Lexand", fontSize: 14)),
                        const SizedBox(height: 10),
                        Text("Storage: $storageLocation",
                            style: const TextStyle(
                                fontFamily: "Lexand", fontSize: 14)),
                        const SizedBox(height: 10),

                        // Checkboxes using Expanded to prevent overflow
                        // Wrap(
                        //   spacing: 15.0, // Horizontal spacing between items
                        //   runSpacing:
                        //       10.0, // Vertical spacing if wrapped to next line
                        //   children: [
                        //     Row(
                        //       mainAxisSize: MainAxisSize.min,
                        //       children: [
                        //         Checkbox(value: isLoose, onChanged: null),
                        //         const Text("Loose"),
                        //       ],
                        //     ),
                        //     Row(
                        //       mainAxisSize: MainAxisSize.min,
                        //       children: [
                        //         Checkbox(value: isCarton, onChanged: null),
                        //         const Text("Carton"),
                        //       ],
                        //     ),
                        //     Row(
                        //       mainAxisSize: MainAxisSize.min,
                        //       children: [
                        //         Checkbox(value: isBag, onChanged: null),
                        //         const Text("Bag"),
                        //       ],
                        //     ),
                        //   ],
                        // ),

                        // Replace the Wrap(...) with something like:
                        Text(
                          "Package Type: $packageTypeText",
                          style: const TextStyle(
                            fontFamily: "Lexand",
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 10),

                        const SizedBox(height: 10),

                        // Quantity
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

                        // Price
                        const Text(
                          "Enter Price per Bag/Carton/Loose",
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
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (quantityController.text.isNotEmpty) {
                                    await updateStock(
                                      ingredientId: ingredientId.toString(),
                                      type: widget.ingredientId == 'stock_in'
                                          ? 'in'
                                          : 'out',
                                      quantity: quantityController.text.trim(),
                                    );
                                    Navigator.pop(context);
                                  } else {
                                    Get.snackbar(
                                      'Error',
                                      'Please enter a quantity',
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.ingredientId == 'stock_in'
              ? 'Stock In Barcode'
              : 'Stock Out Barcode',
          style: const TextStyle(fontFamily: "Lexand"),
        ),
        backgroundColor: primaryColor,
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
