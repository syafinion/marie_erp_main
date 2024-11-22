import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:get/get.dart';
import 'package:marie_erp/controller/store_room_controller.dart'; // Import your controller

class BarcodeScannerPage extends StatefulWidget {
  final String ingredientId;

  BarcodeScannerPage({required this.ingredientId});

  @override
  _BarcodeScannerPageState createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  String? barcode;
  final StoreRoomController storeRoomController =
      Get.find<StoreRoomController>();

  @override
  void initState() {
    super.initState();
    scanBarcode(); // Start scanning when page loads
  }

  Future<void> scanBarcode() async {
    try {
      var result = await BarcodeScanner.scan();
      setState(() {
        barcode = result.rawContent;
      });

      if (barcode != null && barcode!.isNotEmpty) {
        // Send barcode to backend to update the ingredient
        await updateIngredientBarcode(barcode!);
        // Show success message and navigate back
        Get.snackbar('Success', 'Barcode added successfully');
        Navigator.pop(context);
      } else {
        // Handle scan cancellation or failure
        Get.snackbar('Error', 'No barcode detected');
        Navigator.pop(context);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to scan barcode');
      Navigator.pop(context);
    }
  }

  Future<void> updateIngredientBarcode(String barcode) async {
    await storeRoomController.updateIngredientBarcode(
      ingredientId: widget.ingredientId,
      barcode: barcode,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Barcode'),
      ),
      body: Center(
        child:
            barcode == null ? Text('Scanning...') : Text('Barcode: $barcode'),
      ),
    );
  }
}
