import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:marie_erp/constants/color.dart';
import 'package:marie_erp/controller/store_room_controller.dart';
import 'package:marie_erp/model/IngredientModels.dart';
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
  // inside _StoreRoomScreenState
  /// a 3-letter code for each category
  final Map<String, String> _categoryPrefixes = {
    'Vegetables': 'VEG',
    'Powders': 'POW',
    'Spices': 'SPI',
    'Lentils': 'LEN',
    'Seafoods': 'SEA',
    'Rice': 'RIC',
    'Oils': 'OIL',
    'Fruits': 'FRT',
    'Meats': 'MEA',
    'Flour': 'FLR',
    'Sauces': 'SAU',
    'Beverages': 'BEV',
    'Diary': 'DAI', // you spelled it “Diary” in Dart, so I used DAI
  };

  /// Ask the user to confirm, then delete via controller and reload.
  void _confirmDelete(IngredientModels item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete Ingredient?'),
        content: Text('Are you sure you want to delete "${item.ingredient}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await storeRoomController
                  .deleteIngredientByBarcode(item.barcode!);
              if (success) {
                // ←──── CHANGED HERE ─────────────────────────────
                storeRoomController.ingredientList
                    .removeWhere((e) => e.barcode == item.barcode);
                storeRoomController.ingredientList.refresh();

                Get.snackbar(
                  'Deleted',
                  '"${item.ingredient}" has been removed.',
                  snackPosition: SnackPosition.BOTTOM,
                );
              } else {
                Get.snackbar(
                  'Error',
                  'Could not delete ingredient.',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.redAccent,
                  colorText: Colors.white,
                );
              }
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // New list of demo storage locations

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
    storeRoomController.fetchStorageLocations();
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
    final maxDropdownWidth = MediaQuery.of(context).size.width * 0.8;
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
                                    builder: (ctx) => StatefulBuilder(
                                        builder: (ctx, setState) => AlertDialog(
                                              insetPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 24,
                                                      vertical: 24),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              contentPadding: EdgeInsets.zero,
                                              content: ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  // limit dialog to at most 80% of screen height
                                                  maxHeight: MediaQuery.of(ctx)
                                                          .size
                                                          .height *
                                                      0.8,
                                                ),
                                                child: SingleChildScrollView(
                                                  // this still lets you scroll if content + keyboard insets exceed the maxHeight
                                                  padding: EdgeInsets.only(
                                                    bottom: MediaQuery.of(ctx)
                                                        .viewInsets
                                                        .bottom,
                                                  ),
                                                  child: FractionallySizedBox(
                                                    widthFactor: 0.9,
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 20,
                                                          vertical: 24),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            'Add Ingredient',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Lexand',
                                                              fontSize: height *
                                                                  0.022,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  primaryColor,
                                                            ),
                                                          ),
                                                          SizedBox(height: 20),

                                                          // Ingredient name
                                                          TextFormField(
                                                            controller:
                                                                ingredientsController,
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  'Ingredient',
                                                              hintText:
                                                                  'e.g. 10kg tomato',
                                                              hintStyle: TextStyle(
                                                                  color: Colors
                                                                          .grey[
                                                                      600]),
                                                              floatingLabelBehavior:
                                                                  FloatingLabelBehavior
                                                                      .always,
                                                              contentPadding:
                                                                  EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          16,
                                                                      vertical:
                                                                          12),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(height: 16),

                                                          // Measurement + Weight row

                                                          Row(
                                                            children: [
                                                              // <-- Measurement
                                                              Flexible(
                                                                fit: FlexFit
                                                                    .loose,
                                                                child:
                                                                    DropdownButtonFormField<
                                                                        String>(
                                                                  isExpanded:
                                                                      true,
                                                                  value:
                                                                      selectedUnit,
                                                                  hint: Text(
                                                                    'Measurement',
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                  items: [
                                                                    'kg',
                                                                    'litre',
                                                                    'unit'
                                                                  ]
                                                                      .map((u) => DropdownMenuItem(
                                                                          value:
                                                                              u,
                                                                          child:
                                                                              Text(u)))
                                                                      .toList(),
                                                                  onChanged: (v) =>
                                                                      setState(() =>
                                                                          selectedUnit =
                                                                              v),
                                                                  decoration:
                                                                      InputDecoration(
                                                                    isDense:
                                                                        true,
                                                                    contentPadding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            12,
                                                                        vertical:
                                                                            8),
                                                                    border:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),

                                                              SizedBox(
                                                                  width: 12),

                                                              // <-- Weight
                                                              Expanded(
                                                                child:
                                                                    TextFormField(
                                                                  controller:
                                                                      packageWeightController,
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .number,
                                                                  inputFormatters: [
                                                                    FilteringTextInputFormatter
                                                                        .digitsOnly, // ← only 0–9
                                                                  ],
                                                                  decoration:
                                                                      InputDecoration(
                                                                    labelText:
                                                                        'Weight',
                                                                    hintText:
                                                                        'e.g. 10',
                                                                    hintStyle: TextStyle(
                                                                        color: Colors
                                                                            .grey[600]),
                                                                    floatingLabelBehavior:
                                                                        FloatingLabelBehavior
                                                                            .always,
                                                                    isDense:
                                                                        true,
                                                                    contentPadding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            12,
                                                                        vertical:
                                                                            8),
                                                                    border:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15),
                                                                    ),
                                                                  ),
                                                                  // optional: if you wrap in a Form and want to validate…
                                                                  validator:
                                                                      (val) {
                                                                    if (val ==
                                                                            null ||
                                                                        val.isEmpty)
                                                                      return 'Please enter weight';
                                                                    if (!RegExp(
                                                                            r'^\d+$')
                                                                        .hasMatch(
                                                                            val))
                                                                      return 'Only numbers allowed';
                                                                    return null;
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),

                                                          SizedBox(height: 16),

                                                          // Containers
                                                          Wrap(
                                                            spacing: 16,
                                                            children: [
                                                              ChoiceChip(
                                                                label: Text(
                                                                    'Loose'),
                                                                selected:
                                                                    isLooseChecked,
                                                                onSelected:
                                                                    (v) =>
                                                                        setState(
                                                                            () {
                                                                  isLooseChecked =
                                                                      v;
                                                                  isCartonChecked =
                                                                      false;
                                                                  isBagChecked =
                                                                      false;
                                                                }),
                                                              ),
                                                              ChoiceChip(
                                                                label: Text(
                                                                    'Carton'),
                                                                selected:
                                                                    isCartonChecked,
                                                                onSelected:
                                                                    (v) =>
                                                                        setState(
                                                                            () {
                                                                  isCartonChecked =
                                                                      v;
                                                                  isLooseChecked =
                                                                      false;
                                                                  isBagChecked =
                                                                      false;
                                                                }),
                                                              ),
                                                              ChoiceChip(
                                                                label:
                                                                    Text('Bag'),
                                                                selected:
                                                                    isBagChecked,
                                                                onSelected:
                                                                    (v) =>
                                                                        setState(
                                                                            () {
                                                                  isBagChecked =
                                                                      v;
                                                                  isLooseChecked =
                                                                      false;
                                                                  isCartonChecked =
                                                                      false;
                                                                }),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 16),

                                                          // Storage location
                                                          ConstrainedBox(
                                                            constraints:
                                                                BoxConstraints(
                                                                    maxWidth:
                                                                        maxDropdownWidth),
                                                            child: Obx(() {
                                                              final locs =
                                                                  storeRoomController
                                                                      .locationList;
                                                              return DropdownButtonFormField<
                                                                  String>(
                                                                isExpanded:
                                                                    true,
                                                                value: locs.contains(
                                                                        selectedStorageLocation)
                                                                    ? selectedStorageLocation
                                                                    : null,
                                                                hint: Text(
                                                                    'Storage Location'),
                                                                items: locs
                                                                    .map((loc) {
                                                                  return DropdownMenuItem(
                                                                    value: loc,
                                                                    child: Text(
                                                                        loc,
                                                                        overflow:
                                                                            TextOverflow.ellipsis),
                                                                  );
                                                                }).toList(),
                                                                onChanged:
                                                                    (newValue) async {
                                                                  if (newValue ==
                                                                      'Add new location...') {
                                                                    String?
                                                                        newLoc;
                                                                    try {
                                                                      newLoc =
                                                                          await showDialog<
                                                                              String>(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (ctx) =>
                                                                                AlertDialog(
                                                                          insetPadding: EdgeInsets.symmetric(
                                                                              horizontal: 40,
                                                                              vertical: 24),
                                                                          shape:
                                                                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                                          contentPadding:
                                                                              EdgeInsets.zero,
                                                                          content:
                                                                              FractionallySizedBox(
                                                                            widthFactor:
                                                                                0.9,
                                                                            child:
                                                                                ConstrainedBox(
                                                                              constraints: BoxConstraints(
                                                                                maxHeight: MediaQuery.of(ctx).size.height * 0.6,
                                                                              ),
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.all(20),
                                                                                child: Column(
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  children: [
                                                                                    Text('Add Location', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                                                                    SizedBox(height: 12),
                                                                                    TextField(
                                                                                      controller: storageLocationController,
                                                                                      decoration: InputDecoration(hintText: 'Enter location name'),
                                                                                    ),
                                                                                    SizedBox(height: 12),
                                                                                    Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                                                      children: [
                                                                                        TextButton(
                                                                                          onPressed: () => Navigator.pop(ctx),
                                                                                          child: Text('Cancel'),
                                                                                        ),
                                                                                        ElevatedButton(
                                                                                          onPressed: () {
                                                                                            final t = storageLocationController.text.trim();
                                                                                            if (t.isNotEmpty) Navigator.pop(ctx, t);
                                                                                          },
                                                                                          child: Text('Add'),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    } catch (_) {
                                                                      newLoc =
                                                                          null;
                                                                    }

                                                                    if (newLoc !=
                                                                        null) {
                                                                      final idx =
                                                                          locs.indexOf(
                                                                              'Add new location...');
                                                                      storeRoomController
                                                                          .locationList
                                                                          .insert(
                                                                        idx >= 0
                                                                            ? idx
                                                                            : locs.length,
                                                                        newLoc,
                                                                      );
                                                                      setState(() =>
                                                                          selectedStorageLocation =
                                                                              newLoc);
                                                                      storeRoomController
                                                                          .createLocation(
                                                                              newLoc);
                                                                    }
                                                                  } else {
                                                                    setState(() =>
                                                                        selectedStorageLocation =
                                                                            newValue);
                                                                  }
                                                                },
                                                                decoration:
                                                                    InputDecoration(
                                                                  contentPadding:
                                                                      EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              16),
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            15),
                                                                  ),
                                                                ),
                                                              );
                                                            }),
                                                          ),
                                                          SizedBox(height: 24),

                                                          // Buttons
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        context),
                                                                child: Text(
                                                                    'Cancel'),
                                                              ),
                                                              SizedBox(
                                                                  width: 12),
                                                              ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            15),
                                                                  ),
                                                                ),
                                                                onPressed:
                                                                    () async {
                                                                  // ─── VALIDATION ─────────────────────────────────────────
                                                                  if (ingredientsController.text.trim().isEmpty ||
                                                                      selectedUnit ==
                                                                          null ||
                                                                      packageWeightController
                                                                          .text
                                                                          .trim()
                                                                          .isEmpty ||
                                                                      selectedStorageLocation ==
                                                                          null) {
                                                                    Get.snackbar(
                                                                        'Error',
                                                                        'All fields are required');
                                                                    return;
                                                                  }

                                                                  // ─── BUILD YOUR DATA ─────────────────────────────────────
                                                                  final ingName =
                                                                      ingredientsController
                                                                          .text
                                                                          .trim();
                                                                  final loc =
                                                                      selectedStorageLocation!;
                                                                  final barcode =
                                                                      List.generate(
                                                                          12,
                                                                          (_) =>
                                                                              Random().nextInt(10)).join();
                                                                  // pick the right prefix for this category (fallback to first 3 letters)
                                                                  final prefix = _categoryPrefixes[
                                                                          nameOfIngeridiant] ??
                                                                      nameOfIngeridiant
                                                                          .substring(
                                                                              0,
                                                                              3)
                                                                          .toUpperCase();
                                                                  final code =
                                                                      '$prefix${Random().nextInt(900) + 100}';

                                                                  // ─── CALL CREATE INGREDIENT API ──────────────────────────
                                                                  final result =
                                                                      await storeRoomController
                                                                          .createIngredient(
                                                                    category:
                                                                        nameOfIngeridiant,
                                                                    ingredient:
                                                                        ingName,
                                                                    measurement:
                                                                        selectedUnit!,
                                                                    isLoose:
                                                                        isLooseChecked,
                                                                    isCarton:
                                                                        isCartonChecked,
                                                                    isBag:
                                                                        isBagChecked,
                                                                    packageWeight:
                                                                        packageWeightController
                                                                            .text
                                                                            .trim(),
                                                                    storageLocation:
                                                                        loc,
                                                                    barcode:
                                                                        barcode,
                                                                    itemCode:
                                                                        code,
                                                                  );

                                                                  if (result ==
                                                                      null) {
                                                                    Get.snackbar(
                                                                        'Error',
                                                                        'Failed to save ingredient');
                                                                    return;
                                                                  }

                                                                  // ─── CLOSE THE DIALOG ───────────────────────────────────
                                                                  Navigator.pop(
                                                                      context);

                                                                  // ─── RELOAD YOUR LIST ───────────────────────────────────
                                                                  await storeRoomController
                                                                      .stroreRoomingredientsList(
                                                                          nameOfIngeridiant);

                                                                  // ─── NAVIGATE TO PRINT PAGE ─────────────────────────────
                                                                  final didPrint =
                                                                      await Navigator
                                                                          .push<
                                                                              bool>(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (_) =>
                                                                              BarcodePrintPage(
                                                                        barcodeData:
                                                                            barcode,
                                                                        itemCode:
                                                                            code,
                                                                        itemName:
                                                                            ingName,
                                                                        storageLocation:
                                                                            loc,
                                                                      ),
                                                                    ),
                                                                  );

                                                                  // ─── IF PRINT FAILED, ROLL BACK ─────────────────────────
                                                                  if (didPrint !=
                                                                      true) {
                                                                    await storeRoomController
                                                                        .deleteIngredientByBarcode(
                                                                            barcode);
                                                                    Get.snackbar(
                                                                        'Print failed',
                                                                        'Your ingredient was removed');
                                                                    await storeRoomController
                                                                        .stroreRoomingredientsList(
                                                                            nameOfIngeridiant);
                                                                  }
                                                                },
                                                                child: Text(
                                                                    'Save'),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )));
                              },
                              child: Icon(
                                Icons.add_to_photos_outlined,
                                size: height * 0.03,
                              ),
                            ),
                            SizedBox(width: width * 0.02),
                            // InkWell(
                            //   onTap: () async {
                            //     await storeRoomController
                            //         .saveIngredientAll(nameOfIngeridiant);
                            //     await storeRoomController
                            //         .stroreRoomingredientsList(
                            //             nameOfIngeridiant);
                            //   },
                            //   // child: Icon(
                            //   //   Icons.save,
                            //   //   size: height * 0.03,
                            //   // ),
                            // )
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
                                              margin:
                                                  EdgeInsets.only(bottom: 2),
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
                                                          fontSize:
                                                              height * 0.015,
                                                          color: storeRoomController
                                                                  .ingredientList[
                                                                      i]
                                                                  .isChecked!
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              final item =
                                                                  storeRoomController
                                                                      .ingredientList[i];
                                                              // 1) prefill all your controllers, including unitPrice:
                                                              ingredientsEditController
                                                                      .text =
                                                                  item.ingredient ??
                                                                      '';
                                                              selectedUnit = item
                                                                  .measurement;
                                                              packageWeightController
                                                                      .text =
                                                                  item.packageWeight ??
                                                                      '';
                                                              unitPriceController
                                                                      .text =
                                                                  item.unitPrice ??
                                                                      '';
                                                              isLooseChecked =
                                                                  item.isLoose ??
                                                                      false;
                                                              isCartonChecked =
                                                                  item.isCarton ??
                                                                      false;
                                                              isBagChecked =
                                                                  item.isBag ??
                                                                      false;
                                                              selectedStorageLocation =
                                                                  item.storageLocation;

                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder: (ctx) =>
                                                                    StatefulBuilder(
                                                                        builder:
                                                                            (ctx,
                                                                                setState) {
                                                                  return AlertDialog(
                                                                      insetPadding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              24,
                                                                          vertical:
                                                                              24),
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(
                                                                              20)),
                                                                      contentPadding:
                                                                          EdgeInsets
                                                                              .zero,
                                                                      content: ConstrainedBox(
                                                                          constraints: BoxConstraints(
                                                                            maxHeight:
                                                                                MediaQuery.of(ctx).size.height * 0.8,
                                                                          ),
                                                                          child: SingleChildScrollView(
                                                                            padding:
                                                                                EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
                                                                            child:
                                                                                FractionallySizedBox(
                                                                              widthFactor: 0.9,
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                                                                                child: Column(
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  children: [
                                                                                    Text('Edit Ingredient',
                                                                                        style: TextStyle(
                                                                                          fontFamily: 'Lexand',
                                                                                          fontSize: MediaQuery.of(context).size.height * 0.022,
                                                                                          fontWeight: FontWeight.bold,
                                                                                          color: primaryColor,
                                                                                        )),
                                                                                    SizedBox(height: 20),

                                                                                    // ─── Name ────────────────────────────────────────────────
                                                                                    TextFormField(
                                                                                      controller: ingredientsEditController,
                                                                                      decoration: InputDecoration(
                                                                                        labelText: 'Ingredient',
                                                                                        hintText: 'e.g. 10kg tomato',
                                                                                        hintStyle: TextStyle(color: Colors.grey[600]),
                                                                                        floatingLabelBehavior: FloatingLabelBehavior.always,
                                                                                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                                                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(height: 16),

                                                                                    // ─── Measurement + Weight ─────────────────────────────────
                                                                                    Row(
                                                                                      children: [
                                                                                        Flexible(
                                                                                          fit: FlexFit.loose,
                                                                                          child: DropdownButtonFormField<String>(
                                                                                            isExpanded: true,
                                                                                            value: selectedUnit,
                                                                                            hint: Text('Measurement', overflow: TextOverflow.ellipsis),
                                                                                            items: [
                                                                                              'kg',
                                                                                              'litre',
                                                                                              'unit'
                                                                                            ].map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                                                                                            onChanged: (v) => setState(() => selectedUnit = v),
                                                                                            decoration: InputDecoration(
                                                                                              isDense: true,
                                                                                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        SizedBox(width: 12),
                                                                                        Expanded(
                                                                                          child: TextFormField(
                                                                                            controller: packageWeightController,
                                                                                            decoration: InputDecoration(
                                                                                              labelText: 'Weight',
                                                                                              hintText: 'e.g. 10',
                                                                                              hintStyle: TextStyle(color: Colors.grey[600]),
                                                                                              floatingLabelBehavior: FloatingLabelBehavior.always,
                                                                                              isDense: true,
                                                                                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    SizedBox(height: 16),

                                                                                    // ─── Unit Price ───────────────────────────────────────────
                                                                                    TextFormField(
                                                                                      controller: unitPriceController,
                                                                                      keyboardType: TextInputType.number,
                                                                                      decoration: InputDecoration(
                                                                                        labelText: 'Unit Price',
                                                                                        floatingLabelBehavior: FloatingLabelBehavior.always,
                                                                                        isDense: true,
                                                                                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(height: 16),

                                                                                    // ─── Choice Chips ─────────────────────────────────────────
                                                                                    Wrap(
                                                                                      spacing: 16,
                                                                                      children: [
                                                                                        ChoiceChip(
                                                                                          label: Text('Loose'),
                                                                                          selected: isLooseChecked,
                                                                                          onSelected: (v) => setState(() {
                                                                                            isLooseChecked = v;
                                                                                            isCartonChecked = false;
                                                                                            isBagChecked = false;
                                                                                          }),
                                                                                        ),
                                                                                        ChoiceChip(
                                                                                          label: Text('Carton'),
                                                                                          selected: isCartonChecked,
                                                                                          onSelected: (v) => setState(() {
                                                                                            isCartonChecked = v;
                                                                                            isLooseChecked = false;
                                                                                            isBagChecked = false;
                                                                                          }),
                                                                                        ),
                                                                                        ChoiceChip(
                                                                                          label: Text('Bag'),
                                                                                          selected: isBagChecked,
                                                                                          onSelected: (v) => setState(() {
                                                                                            isBagChecked = v;
                                                                                            isLooseChecked = false;
                                                                                            isCartonChecked = false;
                                                                                          }),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    SizedBox(height: 16),

// ─── Storage Location ─────────────────────────────────────────────────
                                                                                    ConstrainedBox(
                                                                                      constraints: BoxConstraints(maxWidth: maxDropdownWidth),
                                                                                      child: Obx(() {
                                                                                        final locs = storeRoomController.locationList;
                                                                                        return DropdownButtonFormField<String>(
                                                                                          isExpanded: true,
                                                                                          value: locs.contains(selectedStorageLocation) ? selectedStorageLocation : null,
                                                                                          hint: Text('Storage Location'),
                                                                                          items: locs.map((loc) {
                                                                                            return DropdownMenuItem(
                                                                                              value: loc,
                                                                                              child: Text(loc, overflow: TextOverflow.ellipsis),
                                                                                            );
                                                                                          }).toList(),
                                                                                          selectedItemBuilder: (ctx) => locs.map((loc) {
                                                                                            return Text(loc, overflow: TextOverflow.ellipsis);
                                                                                          }).toList(),
                                                                                          onChanged: (newValue) async {
                                                                                            if (newValue == 'Add new location...') {
                                                                                              final newLoc = await showDialog<String>(
                                                                                                context: context,
                                                                                                builder: (ctx) => AlertDialog(
                                                                                                  insetPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 24),
                                                                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                                                                  contentPadding: EdgeInsets.zero,
                                                                                                  content: FractionallySizedBox(
                                                                                                    widthFactor: 0.9, // lock it to 90% of screen width
                                                                                                    child: Padding(
                                                                                                      padding: const EdgeInsets.all(20),
                                                                                                      child: Column(
                                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                                        children: [
                                                                                                          Text('Add Location',
                                                                                                              style: TextStyle(
                                                                                                                fontSize: 18,
                                                                                                                fontWeight: FontWeight.bold,
                                                                                                              )),
                                                                                                          SizedBox(height: 12),
                                                                                                          TextField(
                                                                                                            controller: storageLocationController,
                                                                                                            decoration: InputDecoration(hintText: 'Enter location name'),
                                                                                                          ),
                                                                                                          SizedBox(height: 12),
                                                                                                          Row(
                                                                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                                                                            children: [
                                                                                                              TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel')),
                                                                                                              ElevatedButton(
                                                                                                                onPressed: () {
                                                                                                                  final t = storageLocationController.text.trim();
                                                                                                                  if (t.isNotEmpty) Navigator.pop(ctx, t);
                                                                                                                },
                                                                                                                child: Text('Add'),
                                                                                                              ),
                                                                                                            ],
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              );

                                                                                              storageLocationController.clear();
                                                                                              if (newLoc != null) {
                                                                                                final idx = locs.indexOf('Add new location...');
                                                                                                storeRoomController.locationList.insert(
                                                                                                  idx >= 0 ? idx : locs.length,
                                                                                                  newLoc,
                                                                                                );
                                                                                                setState(() => selectedStorageLocation = newLoc);
                                                                                                // fire off API in background
                                                                                                storeRoomController.createLocation(newLoc);
                                                                                              }
                                                                                            } else {
                                                                                              setState(() => selectedStorageLocation = newValue);
                                                                                            }
                                                                                          },
                                                                                          decoration: InputDecoration(
                                                                                            contentPadding: EdgeInsets.symmetric(horizontal: 16),
                                                                                            border: OutlineInputBorder(
                                                                                              borderRadius: BorderRadius.circular(15),
                                                                                            ),
                                                                                          ),
                                                                                        );
                                                                                      }),
                                                                                    ),

                                                                                    // ─── Buttons ────────────────────────────────────────────────
                                                                                    SizedBox(height: 24),
                                                                                    Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                                                      children: [
                                                                                        TextButton(
                                                                                          onPressed: () => Navigator.pop(ctx),
                                                                                          child: Text('Cancel'),
                                                                                        ),
                                                                                        SizedBox(width: 12),
                                                                                        ElevatedButton(
                                                                                          style: ElevatedButton.styleFrom(
                                                                                            shape: RoundedRectangleBorder(
                                                                                              borderRadius: BorderRadius.circular(15),
                                                                                            ),
                                                                                          ),
                                                                                          onPressed: () async {
                                                                                            // ─── Validation ─────────────────────────
                                                                                            if (ingredientsEditController.text.trim().isEmpty || selectedUnit == null || packageWeightController.text.trim().isEmpty || unitPriceController.text.trim().isEmpty || selectedStorageLocation == null) {
                                                                                              Get.snackbar('Error', 'All fields are required');
                                                                                              return;
                                                                                            }

                                                                                            // ─── Call your API ──────────────────────
                                                                                            final resp = await storeRoomController.storRoomingrediantEdit(
                                                                                              ingredient: ingredientsEditController.text.trim(),
                                                                                              ingredientId: item.ingredientId!,
                                                                                              isChecked: item.isChecked ?? false,
                                                                                              measurement: selectedUnit!,
                                                                                              isLoose: isLooseChecked,
                                                                                              isCarton: isCartonChecked,
                                                                                              isBag: isBagChecked,
                                                                                              packageWeight: packageWeightController.text.trim(),
                                                                                              unitPrice: unitPriceController.text.trim(),
                                                                                              storageLocation: selectedStorageLocation!,
                                                                                            );

                                                                                            if (resp == null) {
                                                                                              Get.snackbar('Error', 'Failed to update ingredient');
                                                                                              return;
                                                                                            }

                                                                                            // ─── Refresh & close ───────────────────
                                                                                            Navigator.pop(ctx);
                                                                                            await storeRoomController.stroreRoomingredientsList(nameOfIngeridiant);
                                                                                          },
                                                                                          child: Text('Save'),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          )));
                                                                }),
                                                              );
                                                            },
                                                            child: Icon(
                                                              Icons.edit,
                                                              size: 20,
                                                              color: storeRoomController
                                                                      .ingredientList[
                                                                          i]
                                                                      .isChecked!
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
                                                            ),
                                                          ),

                                                          SizedBox(width: 16),

                                                          // ─── Delete button ────────────────────
                                                          InkWell(
                                                            onTap: () => _confirmDelete(
                                                                storeRoomController
                                                                    .ingredientList[i]),
                                                            child: Icon(
                                                              Icons
                                                                  .delete_outline,
                                                              size: 20,
                                                              color: storeRoomController
                                                                      .ingredientList[
                                                                          i]
                                                                      .isChecked!
                                                                  ? Colors
                                                                      .white70
                                                                  : Colors
                                                                      .redAccent,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ]),
                                              ),
                                            ),
                                          ));
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
