import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:marie_erp/constants/color.dart';
import 'package:marie_erp/controller/groups_controller.dart';
import 'package:marie_erp/view/login_screen.dart';
import 'package:marie_erp/view/main_screen.dart';

import '../constants/groupes_list.dart';
import '../controller/common_controller.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({Key? key}) : super(key: key);

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  CommonController commonController = Get.find();
  GroupsController groupsController = Get.put(GroupsController());
   
  late List<bool> isCheckedList; // Initialize in initState
  final storage = const FlutterSecureStorage();
  var restaurantName = "";
  var firstLetter = "";

  List<GroupsList> groups = [
    GroupsList(name: 'Vegetables', imageName: 'assets/food1.png'),
    GroupsList(name: 'Powders', imageName: 'assets/food2.png'),
    GroupsList(name: 'Spices', imageName: 'assets/food3.png'),
    GroupsList(name: 'Lentils', imageName: 'assets/food4.png'),
    GroupsList(name: 'Seafoods', imageName: 'assets/food5.png'),
    GroupsList(name: 'Rice', imageName: 'assets/food6.png'),
    GroupsList(name: 'Oils', imageName: 'assets/food7.png'),
    GroupsList(name: 'Fruits', imageName: 'assets/food8.png'),
    GroupsList(name: 'Meats', imageName: 'assets/food9.png'),
    GroupsList(name: 'Flour', imageName: 'assets/food10.png'),
    GroupsList(name: 'Sauces', imageName: 'assets/food11.png'),
    GroupsList(name: 'Beverages', imageName: 'assets/food12.png'),
    GroupsList(name: 'Dairy', imageName: 'assets/food13.png'),
  ];

  // Initialize selectedItems list from storage
  List<String> selectedItems = [];

  getCommonData() async {
    await commonController.commomDataGet(); // Await the result
    restaurantName = await commonController.restuarantName;
    firstLetter = restaurantName.substring(0, 1);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getCommonData();
    // Initialize isCheckedList based on groups length
    isCheckedList = List.generate(groups.length, (index) => false);
    loadCheckboxState(); // Load initial checkbox state
  }

  Future<void> loadCheckboxState() async {
    // Load isCheckedList and selectedItems from storage
    //  for (int i = 0; i < commonController.ingredientsList.length; i++) {
    //   String key = 'isChecked_${commonController.ingredientsList[i].name}';
    //   String? value = await storage.read(key: key);
    //   commonController.ingredientsList[i].isChecked = (value == 'true')?true:false;
      
    // }
    // for (int i = 0; i < groups.length; i++) {
    //   String key = 'isChecked_${groups[i].name}';
    //   String? value = await storage.read(key: key);
    //   setState(() {
    //     isCheckedList[i] = value == 'true';
    //   });
    // }
    // String? selectedItemsString = await storage.read(key: 'selectedItems');
    // if (selectedItemsString != null && selectedItemsString.isNotEmpty) {
    //   setState(() {
    //     selectedItems = selectedItemsString.split(',');
    //   });
    // }
  }

  Future<void> saveCheckboxState(int index, bool value) async {
    String key = 'isChecked_${groups[index].name}';

    // Update isCheckedList locally
    setState(() {
      isCheckedList[index] = value;
    });

    if (value) {
      // Add to selectedItems list if not already present
      if (!selectedItems.contains(groups[index].name)) {
        setState(() {
          selectedItems.add(groups[index].name);
        });
      }
    } else {
      // Remove from selectedItems list
      setState(() {
        selectedItems.remove(groups[index].name);
      });
    }

    // Store updated isCheckedList and selectedItems in storage
    await storage.write(key: key, value: value.toString());
    await storage.write(key: 'selectedItems', value: selectedItems.join(','));
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leadingWidth: width * 0.4,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Image.asset(
                  "assets/mrp2.png",
                ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: PopupMenuButton<String>(
              icon: CircleAvatar(
                backgroundColor: Colors.orange,
                child: Text(
                  firstLetter.toString(),
                  style: TextStyle(fontSize: height * 0.025),
                ),
              ),
              onSelected: (String value) {
                if (value == 'logout') {
                  // Handle logout action here
                  logout();
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'name',
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.person, color: Colors.orange),
                      SizedBox(width: 10),
                      SizedBox(
                        width: width * 0.25,
                        child: Text(
                          restaurantName.toString(),
                          style: TextStyle(fontSize: height * 0.015),
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'logout',
                  child: InkWell(
                    onTap: logout,
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.exit_to_app, color: Colors.orange),
                        SizedBox(width: width * 0.04),
                        Text('Logout'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Select the food used in your recipes.",
                    style: TextStyle(
                        fontFamily: "Lexand",
                        fontSize: height * 0.018,
                        fontWeight: FontWeight.w700),
                  ),
                  InkWell(
                    onTap: () async {
                      print("${selectedItems} --> selected");
                   
                      await Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainScreen(
                            selectedItems: commonController.selectedItems,
                            index: 1,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                      child: Image.asset(
                        "assets/right-icon.png",
                        height: height * 0.026,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: height * 0.02),
              Container(
                height: height * 0.75,
                child:Obx(() =>  GridView.builder(
                  shrinkWrap: true,
                  itemCount: commonController.ingredientsList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1.5,
                            color: isCheckedList[index]
                                ? primaryColor.withOpacity(1.0)
                                : borderColor.withOpacity(1.0),
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Checkbox(
                                  side: BorderSide(width: width * 0.001),
                                  activeColor: Colors.green,
                                  focusColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  value: commonController.ingredientsList[index].isChecked,
                                  onChanged: (value) async {
                                    commonController.ingredientsList[index].isChecked = value ?? false;
                                    
                                    setState(() {
                                      isCheckedList[index] = value ?? false;
                                    });
                                    await saveCheckboxState(
                                        index, value ?? false);
                                  },
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.03),
                              child: Image.asset(
                                commonController.ingredientsList[index].imageName!,
                                height: height * 0.1,
                              ),
                            ),
                            Text(
                              commonController.ingredientsList[index].name!,
                              style: TextStyle(
                                fontFamily: "Lexand",
                                fontSize: height * 0.018,
                                fontWeight: FontWeight.w700,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 3.5,
                  ),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void logout() async {
    // Clear all stored checkbox states and selected items on logout
    // for (int i = 0; i < groups.length; i++) {
    //   await storage.delete(key: 'isChecked_${groups[i].name}');
    // }
    await storage.delete(key: 'token');
    Get.offAll(LoginScreen());
  }
}
class Item {
   String? name;
   String? imageName;
   bool? isChecked;

  Item({this.name, this.imageName,this.isChecked});
}