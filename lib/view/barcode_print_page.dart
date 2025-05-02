/*
 * File: barcode_print_page.dart
 * Project: Marie ERP
 * Created Date: 2024
 * 
 * Copyright (c) 2024 Group 17
 * 
 * Authors:
 * - Syafiq
 * 
 * Description:
 * A Flutter widget that handles barcode printing functionality. This page allows users
 * to connect to a printer via Bluetooth and print barcode labels with item details.
 * 
 * Libraries Used:
 * - flutter/material.dart - Flutter's material design widgets (Standard Flutter Library)
 * - flutter/services.dart - Platform communication (Standard Flutter Library)
 * 
 * Implementation Notes:
 * - Uses MethodChannel for native platform communication with printer hardware
 * - Custom UI components for printer status and barcode preview
 * - Implements error handling and connection status management
 * 
 * Modified/Adapted From:
 * - Bluetooth printer integration based on Flutter's platform channel documentation
 *   Source: https://docs.flutter.dev/platform-integration
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marie_erp/constants/color.dart'; // for primaryColor, borderColor, etc.

class BarcodePrintPage extends StatefulWidget {
  final String barcodeData;
  final String itemCode;
  final String itemName;
  final String storageLocation;

  const BarcodePrintPage({
    Key? key,
    required this.barcodeData,
    required this.itemCode,
    required this.itemName,
    required this.storageLocation,
  }) : super(key: key);

  @override
  _BarcodePrintPageState createState() => _BarcodePrintPageState();
}

class _BarcodePrintPageState extends State<BarcodePrintPage> {
  static const platform = MethodChannel("io.flutter.plugins/printer");

  String _status = "Ready";
  bool _isConnected = false;
  bool _isPrinting = false;

  @override
  void initState() {
    super.initState();
    _refreshConnectionStatus();
  }

  Future<void> _refreshConnectionStatus() async {
    try {
      final ok =
          await platform.invokeMethod<bool>('isPrinterConnected') ?? false;
      // Only update state if connection status actually changed
      if (_isConnected != ok) {
        setState(() {
          _isConnected = ok;
          _status = ok ? "Connected" : "Ready";
        });
      }
    } catch (_) {
      // Maintain previous connection state on error
    }
  }

  Future<void> _connectPrinter() async {
    setState(() => _status = "Connecting…");
    try {
      final result = await platform.invokeMethod<String>('connectPrinter');
      setState(() {
        _status = result ?? "Connected";
        _isConnected = true;
      });
    } on PlatformException catch (err) {
      _showErrorDialog(
          title: "Connection Failed", message: err.message ?? "Unknown");
      setState(() {
        _status = err.message ?? "Connection Failed";
        _isConnected = false;
      });
    }
  }

  /// Returns true if already connected, or becomes connected.
  Future<bool> _ensureConnected() async {
    if (_isConnected) return true;
    await _connectPrinter();
    return _isConnected;
  }

  Future<bool> _checkPrinterConnection() async {
    try {
      final ok = await platform.invokeMethod<bool>('isPrinterConnected');
      return ok == true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _printBarcode() async {
    if (_isPrinting) return;

    try {
      // Skip connection check if already connected
      if (!_isConnected) {
        await _connectPrinter();
        if (!_isConnected) return;
      }

      // Print directly if already connected
      setState(() => _isPrinting = true);
      final result = await platform.invokeMethod<String>(
        'printBarcode',
        {
          'barcodeData': widget.barcodeData,
          'itemCode': widget.itemCode,
          'itemName': widget.itemName,
          'storageLocation': widget.storageLocation,
        },
      );

      // Maintain connection after printing
      setState(() {
        _status = result ?? "Printed";
        _isConnected = true;
      });

      if (result == "Barcode and number printed successfully") {
        Navigator.pop(context, true);
      }
    } catch (e) {
      // Handle errors without resetting connection state
      _showErrorDialog(title: "Print Failed", message: e.toString());
      setState(() => _status = "Print Failed");
    } finally {
      setState(() => _isPrinting = false);
    }
  }

  void _showErrorDialog({required String title, required String message}) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title, style: const TextStyle(fontFamily: 'Lexand')),
        content: Text(message, style: const TextStyle(fontFamily: 'Lexand')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("OK", style: TextStyle(fontFamily: 'Lexand')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text(
          "Print Barcode",
          style: TextStyle(fontFamily: 'Lexand', fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            _buildInfoCard(),
            const SizedBox(height: 24),
            _buildStatusIndicator(),
            const Spacer(),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoRow("Item Code", widget.itemCode),
            const SizedBox(height: 8),
            _infoRow("Item Name", widget.itemName),
            const SizedBox(height: 8),
            _infoRow("Location", widget.storageLocation),
            const Divider(height: 24, thickness: 1),
            Center(
              child: Column(
                children: [
                  const Text(
                    "Barcode Preview",
                    style: TextStyle(
                      fontFamily: 'Lexand',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: borderColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.barcodeData,
                      style: const TextStyle(
                        fontFamily: 'Lexand',
                        fontSize: 20,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            "$label:",
            style: const TextStyle(
              fontFamily: 'Lexand',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: const TextStyle(fontFamily: 'Lexand'),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusIndicator() {
    return Row(
      children: [
        Icon(
          _isConnected ? Icons.check_circle : Icons.error_outline,
          color: _isConnected ? Colors.green : Colors.redAccent,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            "Status: $_status",
            style: const TextStyle(fontFamily: 'Lexand', fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.bluetooth),
            label:
                const Text("Connect", style: TextStyle(fontFamily: 'Lexand')),
            style: ElevatedButton.styleFrom(
              backgroundColor: _isConnected ? Colors.grey : primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: _isConnected ? null : _connectPrinter,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.print),
            label: const Text("Print", style: TextStyle(fontFamily: 'Lexand')),
            style: ElevatedButton.styleFrom(
              backgroundColor: _isPrinting ? Colors.grey : primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: (_isPrinting) ? null : _printBarcode,
          ),
        ),
      ],
    );
  }
}
