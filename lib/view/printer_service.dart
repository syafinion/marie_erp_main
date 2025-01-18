// import 'dart:typed_data';

// import 'package:flutter/material.dart';

// class PrinterServiceView extends StatelessWidget {
//   final String printerAddress;
//   final String barcodeData;

//   const PrinterServiceView({
//     Key? key,
//     required this.printerAddress,
//     required this.barcodeData,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: () {
//         _connectAndPrint();
//       },
//       child: const Text('Print Barcode'),
//     );
//   }

//   Future<void> _connectAndPrint() async {
//     // Directly interact with Android code via FlutterActivity
//     WidgetsBinding.instance.platformDispatcher.views.first
//         .performPlatformMessage(
//       'printer_service/connectAndPrint',
//       ByteData(0),
//       null,
//     );
//   }
// }
