package io.flutter.plugins;

import android.Manifest;                          
import android.content.pm.PackageManager;
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
    private MethodChannel.Result pendingConnectResult;
    private String pendingDeviceName;
    private BluetoothAdapter bluetoothAdapter;
    private BluetoothLeScanner bluetoothLeScanner;
    private ScanCallback bleScanCallback;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        bluetoothAdapter = BluetoothAdapter.getDefaultAdapter();

        CTPL.getInstance().init(getApplication(), new RespCallback() {
            @Override
            public void onConnectRespsonse(int port, int reason) {
                Log.d(TAG, "onConnectRespsonse(port=" + port + ", reason=" + reason + ")");
                if (pendingConnectResult == null) return;
                if (reason == 0) {
                    pendingConnectResult.success("Connected to printer: " + pendingDeviceName);
                } else {
                    pendingConnectResult.error(
                      "CONNECTION_FAILED",
                      "CTPL reason code: " + reason,
                      null
                    );
                }
                pendingConnectResult = null;
            }

            @Override
            public void onDataResponse(java.util.HashMap<String, String> result) {
                Log.d(TAG, "onDataResponse: " + result);
            }

            @Override
            public boolean autoSPPBond() {
                return true;
            }
        });

        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL)
            .setMethodCallHandler((call, result) -> {
                switch (call.method) {
                    case "connectPrinter":
                        connectPrinter(result);
                        break;
                    case "isPrinterConnected":
                        result.success(CTPL.getInstance().isConnected());
                        break;
                    case "printSampleText":
                        printSampleText(result);
                        break;
                    case "printBarcode":
                        // <-- HERE
                        String barcodeData     = call.argument("barcodeData");
                        String itemCode        = call.argument("itemCode");
                        String itemName        = call.argument("itemName");
                        String storageLocation = call.argument("storageLocation");
                        printBarcode(
                          result,
                          barcodeData,
                          itemCode,
                          itemName,
                          storageLocation
                        );
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
            // On Android 12+ you still need BLUETOOTH_CONNECT at runtime
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                if (checkSelfPermission(Manifest.permission.BLUETOOTH_CONNECT)
                        != PackageManager.PERMISSION_GRANTED) {
                    requestPermissions(
                        new String[]{ Manifest.permission.BLUETOOTH_CONNECT },
                        1001
                    );
                    return; // ask permission first
                }
            }
    
            // If we're already connected, simply report success
            if (CTPL.getInstance().isConnected()) {
                result.success("Already connected: " + pendingDeviceName);
                return;
            }
    
            // Standard Bluetooth checks
            if (!isBluetoothEnabled()) {
                result.error("BLUETOOTH_DISABLED", "Enable Bluetooth and try again.", null);
                return;
            }
            Set<BluetoothDevice> paired = bluetoothAdapter.getBondedDevices();
            if (paired.isEmpty()) {
                result.error("NO_PAIRED_DEVICES", "No paired Bluetooth devices found.", null);
                return;
            }
    
            // Find your “CT” printer
            BluetoothDevice target = null;
            for (BluetoothDevice d : paired) {
                if (d.getName()!=null && d.getName().contains("CT")) {
                    target = d; break;
                }
            }
            if (target==null) {
                result.error("PRINTER_NOT_FOUND", "Printer not found among paired devices.", null);
                return;
            }
    
            // Hold onto the result until onConnectResponse
            pendingConnectResult = result;
            pendingDeviceName     = target.getName();
    
            // Kick off async connect
            Device printerDevice = new Device();
            printerDevice.setBluetoothMacAddr(target.getAddress());
            printerDevice.setPort(Port.SPP);  // or Port.LE
            CTPL.getInstance().connect(printerDevice);
    
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
        int narrowBar = 2;
        int wideBar = 2;
        int dataLength = barcodeData.length();
        int totalModules = 11 * (dataLength + 3); // CODE128 formula
        int barcodeWidth = totalModules * narrowBar;
        int paperWidthPx = paperWidth * 8; // Convert mm to dots (8 dots/mm)
        int leftMargin = (paperWidthPx - barcodeWidth) / 2;

        // Draw the barcode centered
        int barcodeHeight = 80;
        CTPL.getInstance().drawBarCode(
                new Point(leftMargin, 10),
                barcodeHeight,
                BarCode.CODE_128,
                null,
                null,
                narrowBar,
                wideBar,
                barcodeData
        );

// Centered text below the barcode
int scale = 2;
int textY = 10 + barcodeHeight + 20;

         // Print each line centered
         String[] lines = {
            "      " + barcodeData,
            "      " + itemCode,
            "      " + itemName,
            "      " + storageLocation
    };

    for (String line : lines) {
        int x = getCenteredX(line, paperWidthPx, scale);
        CTPL.getInstance().drawText(
                new Point(x, textY),
                scale, scale,
                line
        );
        textY += 40;
    }

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