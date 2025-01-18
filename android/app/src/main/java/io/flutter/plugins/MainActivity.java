package io.flutter.plugins;

import android.annotation.SuppressLint;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.le.BluetoothLeScanner;
import android.bluetooth.le.ScanCallback;
import android.bluetooth.le.ScanResult;
import android.graphics.Point;
import android.os.Build; // Import Build
import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.NonNull;

import com.ctaiot.ctprinter.ctpl.CTPL;
import com.ctaiot.ctprinter.ctpl.Device;
import com.ctaiot.ctprinter.ctpl.RespCallback;
import com.ctaiot.ctprinter.ctpl.CTPL.Port;
import com.ctaiot.ctprinter.ctpl.param.BarCode;

import java.util.Set;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "io.flutter.plugins/printer";
    private static final String TAG = "MainActivity";

    private BluetoothAdapter bluetoothAdapter;
    private BluetoothLeScanner bluetoothLeScanner;
    private ScanCallback bleScanCallback;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        bluetoothAdapter = BluetoothAdapter.getDefaultAdapter();

        // Initialize CTPL
        CTPL.getInstance().init(getApplication(), new RespCallback() {
            @Override
            public void onConnectRespsonse(int port, int reason) {
                Log.d(TAG, "Connection result: Port=" + port + ", Reason=" + reason);
                Toast.makeText(MainActivity.this,
                        "Connection result: Port=" + port + ", Reason=" + reason,
                        Toast.LENGTH_SHORT).show();
            }

            @Override
            public void onDataResponse(java.util.HashMap<String, String> result) {
                Log.d(TAG, "Data response: " + result);
            }

            @Override
            public boolean autoSPPBond() {
                return true;
            }
        });

        // Flutter Method Channel
        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL)
            .setMethodCallHandler((call, result) -> {
                switch (call.method) {
                    case "connectPrinter":
                        connectPrinter(result);
                        break;

                    case "printSampleText":
                        printSampleText(result);
                        break;

                    case "printBarcode":
                        // Retrieve all arguments from the call
                        String barcodeData = call.argument("barcodeData");
                        String itemCode = call.argument("itemCode");
                        String itemName = call.argument("itemName");
                        String storageLocation = call.argument("storageLocation");

                        // Pass them all to printBarcode
                        printBarcode(result, barcodeData, itemCode, itemName, storageLocation);
                        break;

                    case "searchBluetoothDevices":
                        searchBluetoothDevices(result);
                        break;

                    default:
                        result.notImplemented();
                }
            });
    }

    private void connectPrinter(MethodChannel.Result result) {
        try {
            if (!isBluetoothEnabled()) {
                result.error("BLUETOOTH_DISABLED",
                             "Enable Bluetooth and try again.",
                             null);
                return;
            }

            Set<BluetoothDevice> pairedDevices = bluetoothAdapter.getBondedDevices();
            if (pairedDevices.isEmpty()) {
                result.error("NO_PAIRED_DEVICES",
                             "No paired Bluetooth devices found.",
                             null);
                return;
            }

            BluetoothDevice targetDevice = null;
            for (BluetoothDevice device : pairedDevices) {
                Log.d(TAG, "Paired device: " + device.getName() + " - " + device.getAddress());
                if (device.getName() != null && device.getName().contains("CT")) {
                    // Adjust "CT" to match the printer's name or ID
                    targetDevice = device;
                    break;
                }
            }

            if (targetDevice == null) {
                result.error("PRINTER_NOT_FOUND",
                             "Printer not found among paired devices.",
                             null);
                return;
            }

            // Use Device class to connect
            Device printerDevice = new Device();
            printerDevice.setBluetoothMacAddr(targetDevice.getAddress());
            printerDevice.setPort(Port.SPP); // Use SPP for Bluetooth

            CTPL.getInstance().connect(printerDevice);

            result.success("Connected to printer: " + targetDevice.getName());
        } catch (Exception e) {
            Log.e(TAG, "Connection error", e);
            result.error("CONNECTION_ERROR", e.getMessage(), null);
        }
    }

    private void printSampleText(MethodChannel.Result result) {
        try {
            CTPL.getInstance()
                .setSize(50, 50)
                .drawText(new Point(10, 10), 1, 1, "Hello Printer")
                .print(1)
                .execute();
            result.success("Printed successfully");
        } catch (Exception e) {
            Log.e(TAG, "Printing failed", e);
            result.error("PRINT_ERROR", e.getMessage(), null);
        }
    }


    // We'll define a small helper method to compute the X-position to center text
    private int getCenteredX(String text, int paperWidthPx, int textScale) {
        // Approximate character width in pixels: about 8px per char at scale=1
        // If scale=2, each char ~ 16px, etc.
        int charWidthPx = 8 * textScale;
        int textWidthPx = text.length() * charWidthPx;
        // Center horizontally
        return (paperWidthPx - textWidthPx) / 2;
    }

    private void printBarcode(MethodChannel.Result result,
                          String barcodeData,
                          String itemCode,
                          String itemName,
                          String storageLocation) {
    try {
        // Basic validation
        if (barcodeData == null || barcodeData.isEmpty()) {
            result.error("INVALID_DATA","Barcode data is missing or empty.",null);
            return;
        }
        if (itemCode == null) itemCode = "";
        if (itemName == null) itemName = "";
        if (storageLocation == null) storageLocation = "";

        // Paper size in mm
        int paperWidth = 50;    // 50mm wide
        int paperHeight = 80;   // 80mm tall (adjust as desired)
        CTPL.getInstance().setSize(paperWidth, paperHeight);

        // We'll keep your existing barcode logic
        int barcodeHeight = 80;
        int barcodeWidth = 300;
        int paperWidthPx = paperWidth * 8;  // convert mm to ~dots (8 dots per mm)
        int leftMargin = (paperWidthPx - barcodeWidth) / 2;

        // Draw the barcode near the top
        CTPL.getInstance().drawBarCode(
                new Point(leftMargin, 10),
                barcodeHeight,
                BarCode.CODE_128,
                null,
                null,
                2,   // narrow bar width
                4,   // wide bar width
                barcodeData
        );

        // Now we'll print four lines of text below it, all **centered** and bigger
        // Let's define a bigger text scale: (2, 2)
        int scale = 2;
        int textY = 100; // start printing text below the barcode

        // 1) "Barcode: 123456..."
        String line1 = "Barcode: " + barcodeData;
        int xLine1 = getCenteredX(line1, paperWidthPx, scale);
        CTPL.getInstance().drawText(
                new Point(xLine1, textY),
                scale, scale,
                line1
        );

        // 2) "Item Code: VEG001"
        textY += 40; // move down for next line
        String line2 = "Item Code: " + itemCode;
        int xLine2 = getCenteredX(line2, paperWidthPx, scale);
        CTPL.getInstance().drawText(
                new Point(xLine2, textY),
                scale, scale,
                line2
        );

        // 3) "Item Name: Tomato"
        textY += 40;
        String line3 = "Item Name: " + itemName;
        int xLine3 = getCenteredX(line3, paperWidthPx, scale);
        CTPL.getInstance().drawText(
                new Point(xLine3, textY),
                scale, scale,
                line3
        );

        // 4) "Location: Chiller"
        textY += 40;
        String line4 = "Location: " + storageLocation;
        int xLine4 = getCenteredX(line4, paperWidthPx, scale);
        CTPL.getInstance().drawText(
                new Point(xLine4, textY),
                scale, scale,
                line4
        );

        // Finally, print
        CTPL.getInstance()
                .print(1)
                .execute();

        result.success("Barcode and number printed successfully");
    } catch (Exception e) {
        Log.e(TAG, "Printing barcode failed", e);
        result.error("PRINT_ERROR", e.getMessage(), null);
    }
}

    private void searchBluetoothDevices(MethodChannel.Result result) {
        if (!isBluetoothEnabled()) {
            result.error("BLUETOOTH_DISABLED", "Enable Bluetooth and try again.", null);
            return;
        }

        if (bluetoothAdapter != null && Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            bluetoothLeScanner = bluetoothAdapter.getBluetoothLeScanner();
            bleScanCallback = new ScanCallback() {
                @Override
                public void onScanResult(int callbackType, ScanResult scanResult) {
                    BluetoothDevice device = scanResult.getDevice();
                    if (device.getName() != null) {
                        Log.d(TAG, "Found BLE device: " + device.getName() + " - " + device.getAddress());
                    }
                }
            };

            bluetoothLeScanner.startScan(bleScanCallback);
            result.success("BLE scan started");
        } else {
            result.error("BLE_NOT_SUPPORTED", "BLE not supported on this device.", null);
        }
    }

    private boolean isBluetoothEnabled() {
        return bluetoothAdapter != null && bluetoothAdapter.isEnabled();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (bluetoothLeScanner != null && bleScanCallback != null) {
            bluetoothLeScanner.stopScan(bleScanCallback);
        }
    }
}
