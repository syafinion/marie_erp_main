import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:marie_erp/constants/color.dart';
import 'package:marie_erp/controller/common_controller.dart';
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

  void onItemTapped(int index) async{
    selectedIndex = index;
    if(selectedIndex==1){
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

    setState(() {

    });
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
          const GroupsScreen(), // Replace LoginScreen with your actual screens
          StoreRoomScreen(selectedItems: widget.selectedItems),
          // StoreRoomPage(),
          const StockCardScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        // showSelectedLabels: true,
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
              image: const AssetImage(
                "assets/bottom_group.png",
              ),
              color: primaryColor.withOpacity(1.0),
              height: height * 0.02,
            ),
            icon: Image(
              image: const AssetImage(
                "assets/bottom_group.png",
              ),
              height: height * 0.02,
            ),
            label: 'Groups',
          ),
          BottomNavigationBarItem(
            activeIcon: Image(
              image: const AssetImage(
                "assets/bottom_home.png",
              ),
              color: primaryColor.withOpacity(1.0),
              height: height * 0.02,
            ),
            icon: Image(
              image: const AssetImage(
                "assets/bottom_home.png",
              ),
              height: height * 0.02,
            ),
            label: 'Storeroom',
          ),
          BottomNavigationBarItem(
            activeIcon: Image(
              image: const AssetImage(
                "assets/bottom_stockcard.png",
              ),
              color: primaryColor.withOpacity(1.0),
              height: height * 0.02,
            ),
            icon: Image(
              image: const AssetImage(
                "assets/bottom_stockcard.png",
              ),
              height: height * 0.02,
            ),
            label: 'Stockcards',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: onItemTapped,
      ),
    );
  }
}
