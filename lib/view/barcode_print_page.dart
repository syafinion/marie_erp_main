import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BarcodePrintPage extends StatefulWidget {
  final String barcodeData;

  // NEW: Add these three
  final String itemCode; // e.g., VEG001
  final String itemName; // e.g., "Tomato"
  final String storageLocation; // e.g., "Chiller"

  const BarcodePrintPage({
    Key? key,
    required this.barcodeData,
    required this.itemCode, // <--
    required this.itemName, // <--
    required this.storageLocation, // <--
  }) : super(key: key);

  @override
  _BarcodePrintPageState createState() => _BarcodePrintPageState();
}

class _BarcodePrintPageState extends State<BarcodePrintPage> {
  static const platform = MethodChannel("io.flutter.plugins/printer");

  String _status = "Ready";

  // Track connection and print states
  bool _isConnected = false;
  bool _isPrinting = false;

  Future<void> _connectPrinter() async {
    try {
      final result = await platform.invokeMethod('connectPrinter');

      if (result == "Printer not paired") {
        // Show a dialog telling user to pair
        if (mounted) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text("Printer Not Paired"),
              content: const Text(
                "Please pair your printer in your device's Bluetooth settings first.",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("OK"),
                ),
              ],
            ),
          );
        }
        setState(() {
          _status = "Printer not paired";
          _isConnected = false;
        });
      } else {
        setState(() {
          _status = result; // e.g. "Connected"
          _isConnected = true;
        });
      }
    } catch (e) {
      setState(() {
        _status = "Connection Failed: $e";
        _isConnected = false;
      });
    }
  }

  Future<void> _printBarcode() async {
    // Only allow printing once at a time
    if (_isPrinting) return;

    // If not connected, show error
    if (!_isConnected) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Printer Not Connected"),
          content: const Text("Please connect to the printer first."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    setState(() => _isPrinting = true);

    try {
      final result = await platform.invokeMethod('printBarcode', {
        'barcodeData': widget.barcodeData,
        'itemCode': widget.itemCode,
        'itemName': widget.itemName,
        'storageLocation': widget.storageLocation,
      });
      setState(() {
        _status = result;
      });

      if (result == "Barcode and number printed successfully") {
        // Pop back
        if (mounted) {
          Navigator.pop(context, true);
        }
      } else if (result == "Printer not paired") {
        setState(() {
          _status = "Printer not paired";
          _isConnected = false;
        });
        // Show pairing dialog
        if (mounted) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text("Printer Not Paired"),
              content: const Text(
                "Please pair your printer in your device's Bluetooth settings first.",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("OK"),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _status = "Print Barcode Failed: $e";
      });
    } finally {
      // Unlock printing
      setState(() => _isPrinting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Print Barcode')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display barcode preview
            Column(
              children: [
                // Show the custom ID, item name, and location
                Text("Item Code: ${widget.itemCode}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                Text("Item Name: ${widget.itemName}"),
                Text("Location: ${widget.storageLocation}"),
                const Text(
                  'Barcode Preview:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      // Placeholder for barcode image
                      Container(
                        height: 100,
                        width: 200,
                        color: Colors.grey[300],
                        alignment: Alignment.center,
                        child: Text(
                          widget.barcodeData,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Status
            Text(
              'Status: $_status',
              style: const TextStyle(fontSize: 16, color: Colors.blue),
            ),
            const SizedBox(height: 20),

            // Buttons
            ElevatedButton(
              onPressed: _connectPrinter,
              child: const Text('Connect Printer'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _printBarcode,
              child: const Text('Print Barcode'),
            ),
          ],
        ),
      ),
    );
  }
}
