import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:marie_erp/constants/color.dart';
import 'package:marie_erp/controller/common_controller.dart';
import 'package:marie_erp/view/barcode_scanner_page.dart';
import 'package:marie_erp/view/groups_screen.dart';
import 'package:marie_erp/view/stock_card_screen.dart';
import 'package:marie_erp/view/store_room_screen.dart';
import 'package:marie_erp/view/storeroom_page.dart';

import 'login_screen.dart';

class MainScreen extends StatefulWidget {
  final int? index;
  final List<Item> selectedItems;
  const MainScreen({super.key, this.index, required this.selectedItems});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  CommonController commonController = Get.put(CommonController());
  int selectedIndex = 0;

  void onItemTapped(int index) async {
    selectedIndex = index;
    if (selectedIndex == 1) {
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(
            selectedItems: commonController.selectedItems,
            index: 1,
          ),
        ),
      );
    }

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    selectedIndex = widget.index!;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: IndexedStack(
        index: selectedIndex,
        children: [
          const GroupsScreen(),
          StoreRoomScreen(selectedItems: widget.selectedItems),
          const StockCardScreen(),
          _buildScanScreen(), // Placeholder for the sliding options
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: primaryColor.withOpacity(1.0),
        iconSize: height * 0.03,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
          color: primaryColor.withOpacity(1.0),
          fontFamily: "Lexand",
        ),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            activeIcon: Image(
              image: const AssetImage("assets/bottom_group.png"),
              color: primaryColor.withOpacity(1.0),
              height: height * 0.02,
            ),
            icon: Image(
              image: const AssetImage("assets/bottom_group.png"),
              height: height * 0.02,
            ),
            label: 'Groups',
          ),
          BottomNavigationBarItem(
            activeIcon: Image(
              image: const AssetImage("assets/bottom_home.png"),
              color: primaryColor.withOpacity(1.0),
              height: height * 0.02,
            ),
            icon: Image(
              image: const AssetImage("assets/bottom_home.png"),
              height: height * 0.02,
            ),
            label: 'Storeroom',
          ),
          BottomNavigationBarItem(
            activeIcon: Image(
              image: const AssetImage("assets/bottom_stockcard.png"),
              color: primaryColor.withOpacity(1.0),
              height: height * 0.02,
            ),
            icon: Image(
              image: const AssetImage("assets/bottom_stockcard.png"),
              height: height * 0.02,
            ),
            label: 'Stockcards',
          ),
          BottomNavigationBarItem(
            activeIcon: Image(
              image: const AssetImage("assets/bottom_scan.jpeg"),
              color: primaryColor.withOpacity(1.0),
              height: height * 0.02,
            ),
            icon: Image(
              image: const AssetImage("assets/bottom_scan.jpeg"),
              height: height * 0.02,
            ),
            label: 'Scan',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: (index) {
          if (index == 3) {
            // If the Scan option is selected, show a sliding panel
            Navigator.of(context).push(
              PageRouteBuilder(
                opaque: false,
                pageBuilder: (context, _, __) => SlideInOptionsScreen(),
              ),
            );
          } else {
            onItemTapped(index);
          }
        },
      ),
    );
  }

// Function to build the scan screen
  Widget _buildScanScreen() {
    return Center(
      child: Text("Scan screen placeholder"),
    );
  }
}

// Separate screen for sliding options
class SlideInOptionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.add_box, color: primaryColor),
                title: Text("Stock In", style: TextStyle(fontFamily: "Lexand")),
                onTap: () {
                  Navigator.of(context).pop(); // Close the panel
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => BarcodeScannerPage(
                        ingredientId:
                            'stock_in', // Pass identifier for stock in
                      ),
                    ),
                  );
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.remove_circle, color: primaryColor),
                title:
                    Text("Stock Out", style: TextStyle(fontFamily: "Lexand")),
                onTap: () {
                  Navigator.of(context).pop(); // Close the panel
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => BarcodeScannerPage(
                        ingredientId:
                            'stock_out', // Pass identifier for stock out
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
