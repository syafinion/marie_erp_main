/*
 * File: main_screen.dart
 * Project: Marie ERP
 * Created Date: 2024
 * 
 * Copyright (c) 2024 Group 17
 * 
 * Authors:
 * - All Group 17 Members
 * 
 * Description:
 * Main navigation screen of the Marie ERP application that implements a bottom
 * navigation bar for switching between major features. Handles navigation between
 * Groups, Storeroom, Stockcards, and Scanning functionality with smooth transitions
 * and state persistence.
 * 
 * Features:
 * - Bottom navigation with 4 main sections
 * - IndexedStack for preserving screen states
 * - Slide-up panel for scan options
 * - Animated navigation transitions
 * - State persistence between navigation
 * - Responsive layout design
 * 
 * Libraries Used:
 * - flutter/material.dart - Flutter's material design widgets
 * - get - State management (GetX)
 * - flutter/foundation.dart - Key Flutter primitives
 * 
 * External Dependencies:
 * - get: ^4.6.5
 *   Source: https://pub.dev/packages/get
 * 
 * Assets Required:
 * - bottom_group.png - Groups tab icon
 * - bottom_home.png - Storeroom tab icon
 * - bottom_stockcard.png - Stockcards tab icon
 * - bottom_scan.jpeg - Scan tab icon
 * 
 * State Management:
 * - Uses GetX for common state (CommonController)
 * - Local navigation state managed with setState
 * - Persistent selected items state
 * 
 * Modified/Adapted From:
 * - Flutter bottom navigation implementation guide
 *   Source: https://docs.flutter.dev/cookbook/design/bottom-navigation
 * - GetX navigation patterns
 *   Source: https://github.com/jonataslaw/getx/blob/master/documentation/en_US/route_management.md
 */

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

class SlideInOptionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Keep full‐screen semi‐transparent overlay
      backgroundColor: Colors.black.withOpacity(0.5),
      body: GestureDetector(
        // Tapping anywhere outside the card closes the panel
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(),
        child: Center(
          // Inner GestureDetector absorbs taps so the card itself doesn’t close
          child: GestureDetector(
            onTap: () {},
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Icon(Icons.add_box, color: Colors.green),
                    title: Text("Stock In",
                        style: TextStyle(fontFamily: "Lexand")),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => BarcodeScannerPage(
                            ingredientId: 'stock_in',
                          ),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.remove_circle, color: Colors.red),
                    title: Text("Stock Out",
                        style: TextStyle(fontFamily: "Lexand")),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => BarcodeScannerPage(
                            ingredientId: 'stock_out',
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
