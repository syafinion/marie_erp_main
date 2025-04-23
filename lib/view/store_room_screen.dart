import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:marie_erp/constants/color.dart';
import 'package:marie_erp/controller/store_room_controller.dart';
import 'package:marie_erp/view/barcode_print_page.dart';
import 'package:marie_erp/view/barcode_scanner_page.dart';
import 'package:marie_erp/view/groups_screen.dart';
import 'dart:math';
import '../constants/groupes_list.dart';
import '../controller/common_controller.dart';
import '../controller/groups_controller.dart';

class StoreRoomScreen extends StatefulWidget {
  final int? index;

  final List<Item> selectedItems;

  const StoreRoomScreen({super.key, this.index, required this.selectedItems});

  @override
  State<StoreRoomScreen> createState() => _StoreRoomScreenState();
}

class _StoreRoomScreenState extends State<StoreRoomScreen> {
  // New list of demo storage locations
  List<String> locationList = [
    "Pantry",
    "Refrigerator",
    "Freezer",
    "Add new location...",
  ];

// New variable to track the selected storage location
  String? selectedStorageLocation;

  CommonController commonController = Get.find();
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
  TextEditingController ingredientsController = TextEditingController();
  final storage = const FlutterSecureStorage();

  TextEditingController measurementController = TextEditingController();
  var selectedUnit;
  int selectedItems = 0;
  bool isVegetables = false;
  bool isPowder = false;
  bool isSpices = false;
  bool isLentils = false;
  bool isSeafoods = false;
  bool isRice = false;
  bool isOils = false;
  bool isFruits = false;
  bool isMeats = false;
  bool isFlour = false;
  bool isSauces = false;
  bool isBeverages = false;
  bool isDiary = false;
  bool isNotselectedIngeridiants = false;
  String nameOfIngeridiant = "";

  // New variables for checkboxes
  bool isLooseChecked = false;
  bool isCartonChecked = false;
  bool isBagChecked = false;

  // New controllers for additional input fields
  TextEditingController packageWeightController = TextEditingController();
  TextEditingController unitPriceController = TextEditingController();
  TextEditingController storageLocationController = TextEditingController();

  void onItemTapped(int index) {
    setState(() {
      selectedItems = index;
    });
  }

  GroupsController groupsController = Get.put(GroupsController());
  StoreRoomController storeRoomController = Get.put(StoreRoomController());
  late List<bool> isCheckedList =
      List.generate(groups.length, (index) => false);

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) => getData());
    super.initState();
  }

  getData() async {
    commonController.selectedItems.clear();
    commonController.selectedItems.refresh();
    for (int i = 0; i < commonController.ingredientsList.length; i++) {
      if (commonController.ingredientsList[i].isChecked!) {
        commonController.selectedItems.add(commonController.ingredientsList[i]);
      }
    }

    if (commonController.selectedItems.isNotEmpty) {
      nameOfIngeridiant = commonController.selectedItems[0].name!;
      // Deselect all items
      for (int i = 0; i < isCheckedList.length; i++) {
        isCheckedList[i] = false;
      }
      // Select the tapped item
      isCheckedList[0] = true;

      // Set your individual flags accordingly
      isVegetables = nameOfIngeridiant == "Vegetables";
      isPowder = nameOfIngeridiant == "Powders";
      isSpices = nameOfIngeridiant == "Spices";
      isLentils = nameOfIngeridiant == "Lentils";
      isSeafoods = nameOfIngeridiant == "Seafoods";
      isRice = nameOfIngeridiant == "Rice";
      isOils = nameOfIngeridiant == "Oils";
      isFruits = nameOfIngeridiant == "Fruits";
      isMeats = nameOfIngeridiant == "Meats";
      isFlour = nameOfIngeridiant == "Flour";
      isSauces = nameOfIngeridiant == "Sauces";
      isBeverages = nameOfIngeridiant == "Beverages";
      isDiary = nameOfIngeridiant == "Diary";
      await storeRoomController.stroreRoomingredientsList(nameOfIngeridiant);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    TextEditingController ingredientsEditController = TextEditingController();
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: scaffoldkey,
        appBar: AppBar(
          surfaceTintColor: Colors.white,
          title: Text(
            "Pick your ingredients from the table.",
            style: TextStyle(
                fontFamily: "Lexand",
                fontSize: height * 0.018,
                fontWeight: FontWeight.w500),
          ),
        ),
        body: SizedBox(
          height: height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (commonController.selectedItems.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          nameOfIngeridiant,
                          style: TextStyle(
                              color: primaryColor.withOpacity(1.0),
                              fontFamily: "Lexand",
                              fontSize: height * 0.018,
                              fontWeight: FontWeight.w500),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                final parentContext = context;
                                // Reset checkbox values
                                isLooseChecked = false;
                                isCartonChecked = false;
                                isBagChecked = false;

                                // Clear controllers
                                ingredientsController.clear();
                                selectedUnit = null;
                                packageWeightController.clear();
                                unitPriceController.clear();
                                storageLocationController.clear();

                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: StatefulBuilder(
                                        builder: (context, setState) {
                                          return SingleChildScrollView(
                                            child: Column(children: [
                                              // Text(
                                              //   "Add an Ingredient or Unit of Measure",
                                              //   style: TextStyle(
                                              //     fontFamily: "Lexand",
                                              //     fontSize: height * 0.015,
                                              //     color: Colors.black,
                                              //     fontWeight: FontWeight.bold,
                                              //   ),
                                              // ),
                                              SizedBox(height: height * 0.02),

                                              // TextFormField for ingredient name
                                              SizedBox(
                                                height: height * 0.05,
                                                child: TextFormField(
                                                  style: TextStyle(
                                                    fontFamily: "Lexand",
                                                    fontSize: height * 0.018,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  controller:
                                                      ingredientsController,
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                            left: 16.0),
                                                    hintStyle: TextStyle(
                                                      fontFamily: "Lexand",
                                                      fontSize: height * 0.014,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                                    hintText: "10kg Tomato",
                                                    floatingLabelStyle:
                                                        const TextStyle(
                                                      fontFamily: "Lexand",
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                      borderSide:
                                                          const BorderSide(
                                                              width: 1.5),
                                                    ),
                                                    disabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.0),
                                                      borderSide:
                                                          const BorderSide(
                                                              width: 1.5),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.0),
                                                      borderSide: BorderSide(
                                                        color: borderColor
                                                            .withOpacity(1.0),
                                                        width: 1.5,
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.0),
                                                      borderSide:
                                                          const BorderSide(
                                                              width: 1.5),
                                                    ),
                                                  ),
                                                  onChanged: (value) {
                                                    setState(() {});
                                                  },
                                                ),
                                              ),
                                              SizedBox(height: height * 0.02),

                                              // Moved the checkboxes here, below the ingredient name
                                              Wrap(
                                                spacing: 10.0,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Checkbox(
                                                        value: isLooseChecked,
                                                        onChanged:
                                                            (bool? value) {
                                                          setState(() {
                                                            isLooseChecked =
                                                                value ?? false;
                                                          });
                                                        },
                                                      ),
                                                      Text("Loose"),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Checkbox(
                                                        value: isCartonChecked,
                                                        onChanged:
                                                            (bool? value) {
                                                          setState(() {
                                                            isCartonChecked =
                                                                value ?? false;
                                                          });
                                                        },
                                                      ),
                                                      Text("Carton"),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Checkbox(
                                                        value: isBagChecked,
                                                        onChanged:
                                                            (bool? value) {
                                                          setState(() {
                                                            isBagChecked =
                                                                value ?? false;
                                                          });
                                                        },
                                                      ),
                                                      Text("Bag"),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: height * 0.02),

                                              // Dropdown for measurement
                                              Container(
                                                height: height * 0.05,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0),
                                                  border: Border.all(
                                                    color: borderColor
                                                        .withOpacity(1.0),
                                                    width: 1.5,
                                                  ),
                                                ),
                                                child: DropdownButtonFormField<
                                                    String>(
                                                  hint: Text(
                                                    "Select measurement",
                                                    style: TextStyle(
                                                      fontFamily: "Lexand",
                                                      fontSize: height * 0.014,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10),
                                                  value: selectedUnit,
                                                  iconEnabledColor:
                                                      primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0),
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      selectedUnit = newValue!;
                                                    });
                                                  },
                                                  items: <String>[
                                                    'kg',
                                                    'litre',
                                                    'unit',
                                                  ].map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(
                                                        value,
                                                        style: TextStyle(
                                                          fontFamily: "Lexand",
                                                          fontSize:
                                                              height * 0.018,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    contentPadding:
                                                        EdgeInsets.zero,
                                                    floatingLabelStyle:
                                                        TextStyle(
                                                      fontFamily: "Lexand",
                                                      fontSize: height * 0.013,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: height * 0.02),

                                              // TextFormField for package weight
                                              SizedBox(
                                                height: height * 0.05,
                                                child: TextFormField(
                                                  style: TextStyle(
                                                    fontFamily: "Lexand",
                                                    fontSize: height * 0.018,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  controller:
                                                      packageWeightController,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        "Enter package weight",
                                                    hintStyle: TextStyle(
                                                      fontFamily: "Lexand",
                                                      fontSize: height * 0.014,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                                    floatingLabelStyle:
                                                        TextStyle(
                                                      fontFamily: "Lexand",
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                            left: 16.0),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                      borderSide:
                                                          const BorderSide(
                                                              width: 1.5),
                                                    ),
                                                    disabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.0),
                                                      borderSide:
                                                          const BorderSide(
                                                              width: 1.5),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.0),
                                                      borderSide: BorderSide(
                                                        color: borderColor
                                                            .withOpacity(1.0),
                                                        width: 1.5,
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.0),
                                                      borderSide:
                                                          const BorderSide(
                                                              width: 1.5),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: height * 0.02),

                                              // TextFormField for unit price
                                              // SizedBox(
                                              //   height: height * 0.05,
                                              //   child: TextFormField(
                                              //     controller:
                                              //         unitPriceController,
                                              //     decoration: InputDecoration(
                                              //       hintText:
                                              //           "Enter unit price",
                                              //       contentPadding:
                                              //           const EdgeInsets.only(
                                              //               left: 16.0),
                                              //       border: OutlineInputBorder(
                                              //         borderRadius:
                                              //             BorderRadius.circular(
                                              //                 15.0),
                                              //         borderSide:
                                              //             const BorderSide(
                                              //                 width: 1.5),
                                              //       ),
                                              //     ),
                                              //   ),
                                              // ),
                                              // SizedBox(height: height * 0.02),

                                              // TextFormField for storage location
                                              // Replace your storage location TextFormField with this dropdown
                                              SizedBox(
                                                height: height * 0.05,
                                                child: DropdownButtonFormField<
                                                    String>(
                                                  value:
                                                      selectedStorageLocation,
                                                  hint: Text(
                                                    "Select storage location",
                                                    style: TextStyle(
                                                      fontFamily: "Lexand",
                                                      fontSize: height * 0.014,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                                  ),
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 16.0),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                      borderSide:
                                                          const BorderSide(
                                                              width: 1.5),
                                                    ),
                                                  ),
                                                  items: locationList
                                                      .map((String location) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: location,
                                                      child: Text(
                                                        location,
                                                        style: TextStyle(
                                                          fontFamily: "Lexand",
                                                          fontSize:
                                                              height * 0.016,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  onChanged:
                                                      (String? newValue) {
                                                    if (newValue ==
                                                        "Add new location...") {
                                                      // Show a dialog to add a new location
                                                      showDialog(
                                                        context: context,
                                                        builder:
                                                            (BuildContext ctx) {
                                                          String newLocation =
                                                              "";
                                                          return AlertDialog(
                                                            title: Text(
                                                                "Add a New Location"),
                                                            content: TextField(
                                                              onChanged:
                                                                  (value) {
                                                                newLocation =
                                                                    value;
                                                              },
                                                              decoration:
                                                                  InputDecoration(
                                                                hintText:
                                                                    "Enter location name",
                                                              ),
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      ctx); // Dismiss the dialog
                                                                },
                                                                child: Text(
                                                                    "Cancel"),
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  if (newLocation
                                                                      .trim()
                                                                      .isNotEmpty) {
                                                                    // Add the new location to the list
                                                                    setState(
                                                                        () {
                                                                      locationList.insert(
                                                                          locationList.length -
                                                                              1,
                                                                          newLocation);
                                                                      // Set it as the selected location
                                                                      selectedStorageLocation =
                                                                          newLocation;
                                                                    });
                                                                  }
                                                                  Navigator.pop(
                                                                      ctx); // Dismiss the dialog
                                                                },
                                                                child: Text(
                                                                    "Save"),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    } else {
                                                      // Just set the selected value
                                                      setState(() {
                                                        selectedStorageLocation =
                                                            newValue;
                                                      });
                                                    }
                                                  },
                                                ),
                                              ),

                                              SizedBox(height: height * 0.02),

                                              // Buttons
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: InkWell(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    width *
                                                                        0.02),
                                                        child: Container(
                                                          height: height * 0.04,
                                                          width: width,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              color: buttonColor
                                                                  .withOpacity(
                                                                      1.0),
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.0),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Center(
                                                              child: Text(
                                                                "Cancel",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      "Lexand",
                                                                  fontSize:
                                                                      height *
                                                                          0.011,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: InkWell(
                                                      onTap: () async {
                                                        if (selectedUnit ==
                                                                null ||
                                                            ingredientsController
                                                                .text
                                                                .trim()
                                                                .isEmpty ||
                                                            packageWeightController
                                                                .text
                                                                .trim()
                                                                .isEmpty ||
                                                            selectedStorageLocation ==
                                                                null ||
                                                            selectedStorageLocation!
                                                                .trim()
                                                                .isEmpty) {
                                                          // Show an error message, e.g.:
                                                          Get.snackbar('Error',
                                                              'All fields are required');
                                                          return;
                                                        }

                                                        // 1) Grab the itemName & storage location FIRST
                                                        String tempItemName =
                                                            ingredientsController
                                                                .text
                                                                .trim();
                                                        String
                                                            tempStorageLocation =
                                                            selectedStorageLocation!
                                                                .trim();

                                                        // Generate a random 12-digit barcode
                                                        String
                                                            generatedBarcode =
                                                            List.generate(
                                                          12,
                                                          (_) => Random()
                                                              .nextInt(10),
                                                        ).join();

                                                        // 2) Generate a custom ID: e.g., "VEG" + a random 3-digit number
                                                        //    (You could get more fancy, e.g. increment from a DB, etc.)
                                                        String customID = "VEG" +
                                                            (Random().nextInt(
                                                                        900) +
                                                                    100)
                                                                .toString();

                                                        var result =
                                                            await storeRoomController
                                                                .createIngredient(
                                                          category:
                                                              nameOfIngeridiant,
                                                          ingredient:
                                                              tempItemName,
                                                          measurement:
                                                              selectedUnit,
                                                          isLoose:
                                                              isLooseChecked,
                                                          isCarton:
                                                              isCartonChecked,
                                                          isBag: isBagChecked,
                                                          packageWeight:
                                                              packageWeightController
                                                                  .text,
                                                          storageLocation:
                                                              tempStorageLocation,
                                                          barcode:
                                                              generatedBarcode,
                                                          itemCode:
                                                              customID, // Replace with dynamically generated barcode
                                                        );

                                                        if (result != null) {
                                                          // Clear controllers
                                                          ingredientsController
                                                              .clear();
                                                          packageWeightController
                                                              .clear();
                                                          selectedStorageLocation =
                                                              null;
                                                          selectedUnit = null;
                                                          isLooseChecked =
                                                              false;
                                                          isCartonChecked =
                                                              false;
                                                          isBagChecked = false;
                                                          setState(() {});
                                                          Navigator.pop(
                                                              context);
                                                          await storeRoomController
                                                              .stroreRoomingredientsList(
                                                            nameOfIngeridiant,
                                                          );

                                                          // 4) Pass the custom ID (VEGxxx), item name, and storage location to BarcodePrintPage
                                                          Navigator.push(
                                                            parentContext,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  BarcodePrintPage(
                                                                barcodeData:
                                                                    generatedBarcode,
                                                                itemCode:
                                                                    customID, // <-- New
                                                                itemName:
                                                                    tempItemName,
                                                                storageLocation:
                                                                    tempStorageLocation,
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                      },
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    width *
                                                                        0.02),
                                                        child: Container(
                                                          height: height * 0.04,
                                                          width: width,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: buttonColor
                                                                .withOpacity(
                                                                    1.0),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.0),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Center(
                                                              child: Text(
                                                                "Save",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontFamily:
                                                                      "Lexand",
                                                                  fontSize:
                                                                      height *
                                                                          0.011,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ]),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Icon(
                                Icons.add_to_photos_outlined,
                                size: height * 0.03,
                              ),
                            ),
                            SizedBox(width: width * 0.02),
                            InkWell(
                              onTap: () async {
                                await storeRoomController
                                    .saveIngredientAll(nameOfIngeridiant);
                                await storeRoomController
                                    .stroreRoomingredientsList(
                                        nameOfIngeridiant);
                              },
                              child: Icon(
                                Icons.save,
                                size: height * 0.03,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                SizedBox(
                  height: height * 0.02,
                ),
                commonController.selectedItems.isEmpty
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height / 1.5,
                        child: Center(
                          child: Text(
                            "Please select any group!",
                            style: TextStyle(
                              fontFamily: "Lexand",
                              fontSize: height * 0.024,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: height * 0.73,
                                  width: width * 0.2,
                                  child: ListView.builder(
                                    itemCount:
                                        commonController.selectedItems.length,
                                    itemBuilder: ((context, index) {
                                      return InkWell(
                                        onTap: () async {
                                          setState(() {
                                            nameOfIngeridiant = commonController
                                                .selectedItems[index].name!;
                                            // Deselect all items
                                            for (int i = 0;
                                                i < isCheckedList.length;
                                                i++) {
                                              isCheckedList[i] = false;
                                            }
                                            // Select the tapped item
                                            isCheckedList[index] = true;

                                            // Set your individual flags accordingly
                                            isVegetables = nameOfIngeridiant ==
                                                "Vegetables";
                                            isPowder =
                                                nameOfIngeridiant == "Powders";
                                            isSpices =
                                                nameOfIngeridiant == "Spices";
                                            isLentils =
                                                nameOfIngeridiant == "Lentils";
                                            isSeafoods =
                                                nameOfIngeridiant == "Seafoods";
                                            isRice =
                                                nameOfIngeridiant == "Rice";
                                            isOils =
                                                nameOfIngeridiant == "Oils";
                                            isFruits =
                                                nameOfIngeridiant == "Fruits";
                                            isMeats =
                                                nameOfIngeridiant == "Meats";
                                            isFlour =
                                                nameOfIngeridiant == "Flour";
                                            isSauces =
                                                nameOfIngeridiant == "Sauces";
                                            isBeverages = nameOfIngeridiant ==
                                                "Beverages";
                                            isDiary =
                                                nameOfIngeridiant == "Diary";
                                          });
                                          await storeRoomController
                                              .stroreRoomingredientsList(
                                                  nameOfIngeridiant);
                                          setState(() {});
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            height: height * 0.07,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: isCheckedList[index]
                                                    ? borderColor
                                                        .withOpacity(1.0)
                                                    : Colors.white,
                                              ),
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(100.0),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: width * 0.03),
                                              child: Image.asset(
                                                commonController
                                                    .selectedItems[index]
                                                    .imageName!,
                                                height: height * 0.05,
                                                width: width * 0.05,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: SizedBox(
                                height: height * 0.7,
                                child: Obx(
                                  () => ListView.builder(
                                    itemCount: storeRoomController
                                        .ingredientList.length,
                                    itemBuilder: (
                                      context,
                                      i,
                                    ) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: InkWell(
                                          onTap: () {
                                            storeRoomController
                                                    .ingredientList[i]
                                                    .isChecked =
                                                !storeRoomController
                                                    .ingredientList[i]
                                                    .isChecked!;
                                            storeRoomController.ingredientList
                                                .refresh();
                                          },
                                          child: Container(
                                            width: width,
                                            margin: EdgeInsets.only(bottom: 2),
                                            decoration: BoxDecoration(
                                              color: storeRoomController
                                                      .ingredientList[i]
                                                      .isChecked!
                                                  ? primaryColor
                                                      .withOpacity(1.0)
                                                  : (i % 2 == 0)
                                                      ? borderColor
                                                          .withAlpha(50)
                                                      : primaryColor
                                                          .withAlpha(50),
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    storeRoomController
                                                        .ingredientList[i]
                                                        .ingredient!,
                                                    style: TextStyle(
                                                      fontFamily: "Lexand",
                                                      fontSize: height * 0.015,
                                                      color: storeRoomController
                                                              .ingredientList[i]
                                                              .isChecked!
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      selectedUnit =
                                                          storeRoomController
                                                              .ingredientList[i]
                                                              .measurement;
                                                      isLooseChecked =
                                                          storeRoomController
                                                                  .ingredientList[
                                                                      i]
                                                                  .isLoose ??
                                                              false;
                                                      isCartonChecked =
                                                          storeRoomController
                                                                  .ingredientList[
                                                                      i]
                                                                  .isCarton ??
                                                              false;
                                                      isBagChecked =
                                                          storeRoomController
                                                                  .ingredientList[
                                                                      i]
                                                                  .isBag ??
                                                              false;

                                                      // Initialize the controllers with existing values
                                                      packageWeightController
                                                          .text = storeRoomController
                                                              .ingredientList[i]
                                                              .packageWeight ??
                                                          '';
                                                      unitPriceController.text =
                                                          storeRoomController
                                                                  .ingredientList[
                                                                      i]
                                                                  .unitPrice ??
                                                              '';
                                                      storageLocationController
                                                          .text = storeRoomController
                                                              .ingredientList[i]
                                                              .storageLocation ??
                                                          '';
                                                      ingredientsEditController
                                                              .text =
                                                          storeRoomController
                                                                  .ingredientList[
                                                                      i]
                                                                  .ingredient ??
                                                              '';

                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            content:
                                                                StatefulBuilder(
                                                              builder: (context,
                                                                  setState) {
                                                                return SingleChildScrollView(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        "Edit Ingredient",
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                "Lexand",
                                                                            fontSize: height *
                                                                                0.014,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.black),
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              20),
                                                                      SizedBox(
                                                                        height: height *
                                                                            0.05,
                                                                        child:
                                                                            TextFormField(
                                                                          style:
                                                                              TextStyle(
                                                                            fontFamily:
                                                                                "Lexand",
                                                                            fontSize:
                                                                                height * 0.018,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                          ),
                                                                          controller:
                                                                              ingredientsEditController,
                                                                          decoration:
                                                                              InputDecoration(
                                                                            contentPadding:
                                                                                const EdgeInsets.only(left: 16.0),
                                                                            label:
                                                                                Text(
                                                                              "",
                                                                              style: TextStyle(
                                                                                fontFamily: "Lexand",
                                                                                fontSize: height * 0.018,
                                                                                fontWeight: FontWeight.w300,
                                                                              ),
                                                                            ),
                                                                            floatingLabelStyle:
                                                                                const TextStyle(
                                                                              fontFamily: "Lexand",
                                                                              fontWeight: FontWeight.w300,
                                                                            ),
                                                                            border:
                                                                                OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(15.0),
                                                                              borderSide: const BorderSide(width: 1.5),
                                                                            ),
                                                                            disabledBorder:
                                                                                OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(30.0),
                                                                              borderSide: const BorderSide(width: 1.5),
                                                                            ),
                                                                            enabledBorder:
                                                                                OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(30.0),
                                                                              borderSide: BorderSide(
                                                                                color: borderColor.withOpacity(1.0),
                                                                                width: 1.5,
                                                                              ),
                                                                            ),
                                                                            focusedBorder:
                                                                                OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(30.0),
                                                                              borderSide: const BorderSide(width: 1.5),
                                                                            ),
                                                                          ),
                                                                          onChanged:
                                                                              (value) {
                                                                            setState(() {});
                                                                          },
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              height * 0.02),
                                                                      Container(
                                                                        height: height *
                                                                            0.05,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(30.0),
                                                                          border:
                                                                              Border.all(
                                                                            color:
                                                                                borderColor.withOpacity(1.0),
                                                                            width:
                                                                                1.5,
                                                                          ),
                                                                        ),
                                                                        child: DropdownButtonFormField<
                                                                            String>(
                                                                          hint:
                                                                              Text(
                                                                            "Select measurement",
                                                                            style:
                                                                                TextStyle(
                                                                              fontFamily: "Lexand",
                                                                              fontSize: height * 0.018,
                                                                              fontWeight: FontWeight.w300,
                                                                            ),
                                                                          ),
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              left: 10,
                                                                              bottom: 5,
                                                                              right: 10),
                                                                          value:
                                                                              selectedUnit,
                                                                          iconEnabledColor:
                                                                              primaryColor,
                                                                          borderRadius:
                                                                              BorderRadius.circular(30.0),
                                                                          onChanged:
                                                                              (String? newValue) {
                                                                            setState(() {
                                                                              selectedUnit = newValue!;
                                                                            });
                                                                          },
                                                                          items:
                                                                              <String>[
                                                                            'kg',
                                                                            'litre',
                                                                            'unit'
                                                                          ].map<DropdownMenuItem<String>>((String value) {
                                                                            return DropdownMenuItem<String>(
                                                                              value: value,
                                                                              child: Padding(
                                                                                padding: EdgeInsets.symmetric(horizontal: 10),
                                                                                child: Text(
                                                                                  value,
                                                                                  style: TextStyle(
                                                                                    fontFamily: "Lexand",
                                                                                    fontSize: height * 0.018,
                                                                                    fontWeight: FontWeight.w300,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          }).toList(),
                                                                          decoration:
                                                                              InputDecoration(
                                                                            border:
                                                                                InputBorder.none,
                                                                            contentPadding:
                                                                                EdgeInsets.zero,
                                                                            floatingLabelStyle:
                                                                                TextStyle(
                                                                              fontFamily: "Lexand",
                                                                              fontSize: height * 0.013,
                                                                              fontWeight: FontWeight.w300,
                                                                            ),
                                                                          ),
                                                                          alignment:
                                                                              Alignment.topLeft,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              height * 0.02),
                                                                      // Add TextFormField for packageWeight
                                                                      SizedBox(
                                                                        height: height *
                                                                            0.05,
                                                                        child:
                                                                            TextFormField(
                                                                          controller:
                                                                              packageWeightController,
                                                                          decoration:
                                                                              InputDecoration(
                                                                            hintText:
                                                                                "Enter package weight",
                                                                            contentPadding:
                                                                                const EdgeInsets.only(left: 16.0),
                                                                            border:
                                                                                OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(15.0),
                                                                              borderSide: const BorderSide(width: 1.5),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              height * 0.02),
                                                                      // Add TextFormField for unitPrice
                                                                      // SizedBox(
                                                                      //   height: height *
                                                                      //       0.05,
                                                                      //   child:
                                                                      //       TextFormField(
                                                                      //     controller:
                                                                      //         unitPriceController,
                                                                      //     decoration:
                                                                      //         InputDecoration(
                                                                      //       hintText:
                                                                      //           "Enter unit price",
                                                                      //       contentPadding:
                                                                      //           const EdgeInsets.only(left: 16.0),
                                                                      //       border:
                                                                      //           OutlineInputBorder(
                                                                      //         borderRadius: BorderRadius.circular(15.0),
                                                                      //         borderSide: const BorderSide(width: 1.5),
                                                                      //       ),
                                                                      //     ),
                                                                      //   ),
                                                                      // ),
                                                                      SizedBox(
                                                                          height:
                                                                              height * 0.02),
                                                                      // Add TextFormField for storageLocation
                                                                      SizedBox(
                                                                        height: height *
                                                                            0.05,
                                                                        child:
                                                                            TextFormField(
                                                                          controller:
                                                                              storageLocationController,
                                                                          decoration:
                                                                              InputDecoration(
                                                                            hintText:
                                                                                "Enter storage location",
                                                                            contentPadding:
                                                                                const EdgeInsets.only(left: 16.0),
                                                                            border:
                                                                                OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(15.0),
                                                                              borderSide: const BorderSide(width: 1.5),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              height * 0.02),
                                                                      // Use Wrap instead of Row for checkboxes
                                                                      Wrap(
                                                                        spacing:
                                                                            10.0,
                                                                        children: [
                                                                          Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            children: [
                                                                              Checkbox(
                                                                                value: isLooseChecked,
                                                                                onChanged: (bool? value) {
                                                                                  setState(() {
                                                                                    isLooseChecked = value ?? false;
                                                                                  });
                                                                                },
                                                                              ),
                                                                              Text("Loose"),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            children: [
                                                                              Checkbox(
                                                                                value: isCartonChecked,
                                                                                onChanged: (bool? value) {
                                                                                  setState(() {
                                                                                    isCartonChecked = value ?? false;
                                                                                  });
                                                                                },
                                                                              ),
                                                                              Text("Carton"),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            children: [
                                                                              Checkbox(
                                                                                value: isBagChecked,
                                                                                onChanged: (bool? value) {
                                                                                  setState(() {
                                                                                    isBagChecked = value ?? false;
                                                                                  });
                                                                                },
                                                                              ),
                                                                              Text("Bag"),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height: height *
                                                                            0.02,
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                InkWell(
                                                                              onTap: () {
                                                                                Navigator.pop(context);
                                                                              },
                                                                              child: Padding(
                                                                                padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                                                                                child: Container(
                                                                                  height: height * 0.04,
                                                                                  width: width,
                                                                                  decoration: BoxDecoration(
                                                                                    border: Border.all(color: buttonColor.withOpacity(1.0)),
                                                                                    borderRadius: BorderRadius.circular(15.0),
                                                                                  ),
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: Center(
                                                                                      child: Text(
                                                                                        "Cancel",
                                                                                        style: TextStyle(color: buttonColor.withOpacity(1.0), fontFamily: "Lexand", fontSize: height * 0.011, fontWeight: FontWeight.w700),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                InkWell(
                                                                              onTap: () async {
                                                                                if (selectedUnit == null || ingredientsEditController.text == '' || packageWeightController.text == '' || selectedStorageLocation == null || selectedStorageLocation!.trim().isEmpty) {
                                                                                  // Show an error message
                                                                                  return;
                                                                                }
                                                                                await storeRoomController.storRoomingrediantEdit(
                                                                                  ingredient: ingredientsEditController.text,
                                                                                  ingredientId: storeRoomController.ingredientList[i].ingredientId!,
                                                                                  isChecked: storeRoomController.ingredientList[i].isChecked!,
                                                                                  measurement: selectedUnit,
                                                                                  isLoose: isLooseChecked,
                                                                                  isCarton: isCartonChecked,
                                                                                  isBag: isBagChecked,
                                                                                  packageWeight: packageWeightController.text,
                                                                                  unitPrice: unitPriceController.text,
                                                                                  storageLocation: storageLocationController.text,
                                                                                );
                                                                                setState(() {});
                                                                                Navigator.pop(context);
                                                                                await storeRoomController.stroreRoomingredientsList(nameOfIngeridiant);
                                                                              },
                                                                              child: Padding(
                                                                                padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                                                                                child: Container(
                                                                                  height: height * 0.04,
                                                                                  width: width,
                                                                                  decoration: BoxDecoration(
                                                                                    color: buttonColor.withOpacity(1.0),
                                                                                    borderRadius: BorderRadius.circular(15.0),
                                                                                  ),
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: Center(
                                                                                      child: Text(
                                                                                        "Save",
                                                                                        style: TextStyle(color: Colors.white, fontFamily: "Lexand", fontSize: height * 0.011, fontWeight: FontWeight.w700),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Icon(
                                                      Icons.edit,
                                                      size: 20,
                                                      color: storeRoomController
                                                              .ingredientList[i]
                                                              .isChecked!
                                                          ? Colors.white
                                                          : Colors.black,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )),
                          )
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
