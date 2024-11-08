import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:marie_erp/constants/color.dart';
import 'package:marie_erp/controller/store_room_controller.dart';

import '../constants/groupes_list.dart';
import '../controller/common_controller.dart';
import '../controller/groups_controller.dart';
import 'groups_screen.dart';

class StoreRoomScreen extends StatefulWidget {
  final int? index;
  final List<Item> selectedItems;
  const StoreRoomScreen({super.key, this.index, required this.selectedItems});

  @override
  State<StoreRoomScreen> createState() => _StoreRoomScreenState();
}

class _StoreRoomScreenState extends State<StoreRoomScreen> {
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
    // getStoreroomIngeridiant();
    // print(commonController.selectedItems[0].name);
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
      // print(storeRoomController
      //     .ingredientsPowedersList);
      setState(() {});
    }
  }

  // bool showAllItems = false;

  @override
  Widget build(BuildContext context) {
    // scaffoldkey.currentState!.openDrawer();
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    TextEditingController ingredientsEditController = TextEditingController();
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: scaffoldkey,
        appBar: AppBar(
          surfaceTintColor: Colors.white,
          // leading: InkWell(
          //   onTap: () {
          //     // scaffoldkey.currentState!.openDrawer();
          //   },
          //   child: Icon(
          //     Icons.arrow_back_ios_rounded,
          //     size: height * 0.039,
          //   ),
          // ),
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
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      // insetPadding: EdgeInsets.all(0.0),
                                      content: SizedBox(
                                        // width: double.maxFinite,
                                        height: height *
                                            0.25, // Ensure the AlertDialog content has a fixed width
                                        child: Column(
                                          children: [
                                            Text(
                                                    "Add an Ingredient or Unit of Measure",
                                                    style: TextStyle(
                                                        fontFamily: "Lexand",
                                                        fontSize:
                                                            height * 0.015,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                            SizedBox(height: height * 0.02),
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
                                                  // suffixIcon: Padding(
                                                  //   padding: const EdgeInsets.all(8.0),
                                                  //   child: Image.asset(
                                                  //     "assets/user_icon.png",
                                                  //     height: height * 0.02,
                                                  //   ),
                                                  // ),
                                                  contentPadding:
                                                      const EdgeInsets.only(
                                                          left: 16.0),
                                                          hintStyle:  TextStyle(
                                                      fontFamily: "Lexand",
                                                      fontSize: height * 0.014,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                                  hintText: "Enter the ingredient name",
                                                  floatingLabelStyle:
                                                      const TextStyle(
                                                    fontFamily: "Lexand",
                                                    fontWeight: FontWeight.w300,
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
                                            Container(
                                              height: height * 0.05,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
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
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 10,),
                                                value: selectedUnit,
                                                iconEnabledColor: primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    selectedUnit = newValue!;
                                                  });
                                                },
                                                items: <String>[
                                                  'kg',
                                                  'litre',
                                                  'unit'
                                                ].map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      // alignment: AlignmentDirectional.topStart,
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
                                                  },
                                                ).toList(),
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  floatingLabelStyle: TextStyle(
                                                    fontFamily: "Lexand",
                                                    fontSize: height * 0.013,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                                // Aligns the dropdown value vertically centered within the container
                                                // alignment: Alignment.topCenter,
                                              ),
                                            ),
                                            SizedBox(
                                              height: height * 0.02,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: InkWell(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  width * 0.02),
                                                      child: Container(
                                                        height: height * 0.04,
                                                        width: width,
                                                        decoration:
                                                            BoxDecoration(
                                                          // color: buttonColor
                                                          //     .withOpacity(1.0),
                                                          border: Border.all(color: buttonColor
                                                              .withOpacity(1.0)),
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
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      "Lexand",
                                                                  fontSize:
                                                                      height *
                                                                          0.011,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
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
                                                      var result =
                                                          await storeRoomController
                                                              .createIngredient(
                                                                  nameOfIngeridiant,
                                                                  ingredientsController
                                                                      .text,
                                                                  selectedUnit);
                                                      if (result != null) {
                                                        ingredientsController
                                                            .clear();
                                                            selectedUnit= null;
                                                            setState(() {
                                                              
                                                            });
                                                        Navigator.pop(context);
                                                        await storeRoomController
                                                            .stroreRoomingredientsList(
                                                                nameOfIngeridiant);
                                                      }
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  width * 0.02),
                                                      child: Container(
                                                        height: height * 0.04,
                                                        width: width,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: buttonColor
                                                              .withOpacity(1.0),
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
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontFamily:
                                                                      "Lexand",
                                                                  fontSize:
                                                                      height *
                                                                          0.011,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
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
                               await storeRoomController.saveIngredientAll(nameOfIngeridiant);
                               await storeRoomController.stroreRoomingredientsList(nameOfIngeridiant);
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

                                            // print(storeRoomController
                                            //     .ingredientsPowedersList);
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
                                    child: Obx(() => ListView.builder(
                                      // shrinkWrap: true,
                                      itemCount: storeRoomController
                                          .ingredientList.length,
                                      itemBuilder: (
                                        context,
                                        i,
                                      ) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: InkWell(
                                                onTap: () {
                                                  storeRoomController
                                                                .ingredientList[
                                                            i].isChecked =
                                                        !storeRoomController
                                                                .ingredientList[
                                                            i].isChecked!;
                                                  storeRoomController
                                                                .ingredientList.refresh();
                                                },
                                                child: Container(
                                                  width: width,
                                                  margin: EdgeInsets.only(bottom: 2),
                                                  // height: height*0.05,
                                                  decoration: BoxDecoration(
                                                    color: storeRoomController
                                                                .ingredientList[
                                                            i].isChecked!
                                                        ? primaryColor
                                                            .withOpacity(1.0)
                                                        : (i%2==0)?borderColor.withAlpha(50): primaryColor.withAlpha(50),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          storeRoomController
                                                                  .ingredientList[
                                                              i].ingredient!,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "Lexand",
                                                            fontSize:
                                                                height * 0.015,
                                                                color: storeRoomController
                                                                .ingredientList[
                                                            i].isChecked!?Colors.white:Colors.black,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            selectedUnit = storeRoomController.ingredientList[i].measurement;
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return AlertDialog(
                                                                  // insetPadding: EdgeInsets.all(0.0),
                                                                  content:
                                                                      SizedBox(
                                                                    // width: double.maxFinite,
                                                                    height: height *
                                                                        0.25, // Ensure the AlertDialog content has a fixed width
                                                                    child:
                                                                        Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                                "Edit Ingredients",
                                                                                style: TextStyle(fontFamily: "Lexand", fontSize: height * 0.014, fontWeight: FontWeight.bold,color: Colors.black),
                                                                              ),
                                                                        SizedBox(
                                                                            height:20),
                                                                        SizedBox(
                                                                          height:
                                                                              height * 0.05,
                                                                          child:
                                                                              TextFormField(
                                                                            style:
                                                                                TextStyle(
                                                                              fontFamily: "Lexand",
                                                                              fontSize: height * 0.018,
                                                                              fontWeight: FontWeight.w500,
                                                                            ),
                                                                            controller: ingredientsEditController =
                                                                                TextEditingController(text: storeRoomController.ingredientList[i].ingredient),
                                                                            decoration:
                                                                                InputDecoration(
                                                                              // suffixIcon: Padding(
                                                                              //   padding: const EdgeInsets.all(8.0),
                                                                              //   child: Image.asset(
                                                                              //     "assets/user_icon.png",
                                                                              //     height: height * 0.02,
                                                                              //   ),
                                                                              // ),
                                                                              contentPadding: const EdgeInsets.only(left: 16.0),
                                                                              label: Text(
                                                                                "",
                                                                                style: TextStyle(
                                                                                  fontFamily: "Lexand",
                                                                                  fontSize: height * 0.018,
                                                                                  fontWeight: FontWeight.w300,
                                                                                ),
                                                                              ),
                                                                              floatingLabelStyle: const TextStyle(
                                                                                fontFamily: "Lexand",
                                                                                fontWeight: FontWeight.w300,
                                                                              ),
                                                                              border: OutlineInputBorder(
                                                                                borderRadius: BorderRadius.circular(15.0),
                                                                                borderSide: const BorderSide(width: 1.5),
                                                                              ),
                                                                              disabledBorder: OutlineInputBorder(
                                                                                borderRadius: BorderRadius.circular(30.0),
                                                                                borderSide: const BorderSide(width: 1.5),
                                                                              ),
                                                                              enabledBorder: OutlineInputBorder(
                                                                                borderRadius: BorderRadius.circular(30.0),
                                                                                borderSide: BorderSide(
                                                                                  color: borderColor.withOpacity(1.0),
                                                                                  width: 1.5,
                                                                                ),
                                                                              ),
                                                                              focusedBorder: OutlineInputBorder(
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
                                                                          height:
                                                                              height * 0.05,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(30.0),
                                                                            border:
                                                                                Border.all(
                                                                              color: borderColor.withOpacity(1.0),
                                                                              width: 1.5,
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              DropdownButtonFormField<String>(
                                                                            hint:
                                                                                Text(
                                                                              "Select measurement",
                                                                              style: TextStyle(
                                                                                fontFamily: "Lexand",
                                                                                fontSize: height * 0.018,
                                                                                fontWeight: FontWeight.w300,
                                                                              ),
                                                                            ),
                                                                            padding:
                                                                                const EdgeInsets.only(left: 10, bottom: 5,right: 10),
                                                                            value:
                                                                                selectedUnit,
                                                                                iconEnabledColor: primaryColor,
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
                                                                            ].map<DropdownMenuItem<String>>(
                                                                              (String value) {
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
                                                                              },
                                                                            ).toList(),
                                                                            decoration:
                                                                                InputDecoration(
                                                                              border: InputBorder.none,
                                                                              contentPadding: EdgeInsets.zero,
                                                                              floatingLabelStyle: TextStyle(
                                                                                fontFamily: "Lexand",
                                                                                fontSize: height * 0.013,
                                                                                fontWeight: FontWeight.w300,
                                                                              ),
                                                                            ),
                                                                            // Aligns the dropdown value vertically centered within the container
                                                                            alignment:
                                                                                Alignment.topLeft,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              height * 0.02,
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            Expanded(
                                                                              child: InkWell(
                                                                                onTap: () {
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: Padding(
                                                                                  padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                                                                                  child: Container(
                                                                                    height: height * 0.04,
                                                                                    width: width,
                                                                                    decoration: BoxDecoration(
                                                                                      // color: buttonColor.withOpacity(1.0),
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
                                                                              child: InkWell(
                                                                                onTap: () async {
                                                                                  await storeRoomController.storRoomingrediantEdit(
                                                                                    ingredientsEditController.text,
                                                                                    storeRoomController.ingredientList[i].ingredientId!,
                                                                                    storeRoomController.ingredientList[i].isChecked!,
                                                                                    selectedUnit,
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
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          },
                                                          child: Icon(
                                                            Icons.edit,
                                                            size: 20,
                                                            color:storeRoomController
                                                                .ingredientList[
                                                            i].isChecked!?Colors.white:Colors.black,
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
                                  )
                                  ),
                                )
                              
                          // isVegetables
                          //     ? Expanded(
                          //         flex: 3,
                          //         child: SizedBox(
                          //           height: height * 0.7,
                          //           child: ListView.builder(
                          //             // shrinkWrap: true,
                          //             itemCount: storeRoomController
                          //                 .ingredientList.length,
                          //             itemBuilder: (
                          //               context,
                          //               i,
                          //             ) {
                          //               return Padding(
                          //                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          //                 child: InkWell(
                          //                       onTap: () {
                          //                         setState(() {
                          //                           storeRoomController
                          //                                       .ingredientList[
                          //                                   i]["isChecked"] =
                          //                               !storeRoomController
                          //                                       .ingredientList[
                          //                                   i]["isChecked"];
                          //                         });

                          //                         showDialog(
                          //                           context: context,
                          //                           builder: (context) {
                          //                             return AlertDialog(
                          //                               // insetPadding: EdgeInsets.all(0.0),
                          //                               content: SizedBox(
                          //                                 // width: double.maxFinite,
                          //                                 height: height *
                          //                                     0.3, // Ensure the AlertDialog content has a fixed width
                          //                                 child: Column(
                          //                                   children: [
                          //                                     Row(
                          //                                       children: [
                          //                                         InkWell(
                          //                                           onTap: () {
                          //                                             Navigator.pop(
                          //                                                 context);
                          //                                             // scaffoldkey.currentState!.openDrawer();
                          //                                           },
                          //                                           child: Icon(
                          //                                             Icons
                          //                                                 .arrow_back_ios_rounded,
                          //                                             size: height *
                          //                                                 0.039,
                          //                                           ),
                          //                                         ),
                          //                                         Expanded(
                          //                                           child: Text(
                          //                                             "Pick your ingredients from the table.",
                          //                                             style: TextStyle(
                          //                                                 fontFamily:
                          //                                                     "Lexand",
                          //                                                 fontSize: height *
                          //                                                     0.018,
                          //                                                 fontWeight:
                          //                                                     FontWeight.w500),
                          //                                           ),
                          //                                         ),
                          //                                       ],
                          //                                     ),
                          //                                     SizedBox(
                          //                                         height:
                          //                                             height *
                          //                                                 0.02),
                          //                                     SizedBox(
                          //                                       height: height *
                          //                                           0.05,
                          //                                       child:
                          //                                           TextFormField(
                          //                                         style:
                          //                                             TextStyle(
                          //                                           fontFamily:
                          //                                               "Lexand",
                          //                                           fontSize:
                          //                                               height *
                          //                                                   0.018,
                          //                                           fontWeight:
                          //                                               FontWeight
                          //                                                   .w500,
                          //                                         ),
                          //                                         controller: ingredientsEditController =
                          //                                             TextEditingController(
                          //                                                 text: storeRoomController.ingredientList[i]
                          //                                                     [
                          //                                                     "ingredient"]),
                          //                                         decoration:
                          //                                             InputDecoration(
                          //                                           // suffixIcon: Padding(
                          //                                           //   padding: const EdgeInsets.all(8.0),
                          //                                           //   child: Image.asset(
                          //                                           //     "assets/user_icon.png",
                          //                                           //     height: height * 0.02,
                          //                                           //   ),
                          //                                           // ),
                          //                                           contentPadding:
                          //                                               const EdgeInsets
                          //                                                   .only(
                          //                                                   left:
                          //                                                       16.0),
                          //                                           label: Text(
                          //                                             "Ingredients",
                          //                                             style:
                          //                                                 TextStyle(
                          //                                               fontFamily:
                          //                                                   "Lexand",
                          //                                               fontSize:
                          //                                                   height *
                          //                                                       0.018,
                          //                                               fontWeight:
                          //                                                   FontWeight.w300,
                          //                                             ),
                          //                                           ),
                          //                                           floatingLabelStyle:
                          //                                               const TextStyle(
                          //                                             fontFamily:
                          //                                                 "Lexand",
                          //                                             fontWeight:
                          //                                                 FontWeight
                          //                                                     .w300,
                          //                                           ),
                          //                                           border:
                          //                                               OutlineInputBorder(
                          //                                             borderRadius:
                          //                                                 BorderRadius.circular(
                          //                                                     15.0),
                          //                                             borderSide:
                          //                                                 const BorderSide(
                          //                                                     width: 1.5),
                          //                                           ),
                          //                                           disabledBorder:
                          //                                               OutlineInputBorder(
                          //                                             borderRadius:
                          //                                                 BorderRadius.circular(
                          //                                                     30.0),
                          //                                             borderSide:
                          //                                                 const BorderSide(
                          //                                                     width: 1.5),
                          //                                           ),
                          //                                           enabledBorder:
                          //                                               OutlineInputBorder(
                          //                                             borderRadius:
                          //                                                 BorderRadius.circular(
                          //                                                     30.0),
                          //                                             borderSide:
                          //                                                 BorderSide(
                          //                                               color: borderColor
                          //                                                   .withOpacity(1.0),
                          //                                               width:
                          //                                                   1.5,
                          //                                             ),
                          //                                           ),
                          //                                           focusedBorder:
                          //                                               OutlineInputBorder(
                          //                                             borderRadius:
                          //                                                 BorderRadius.circular(
                          //                                                     30.0),
                          //                                             borderSide:
                          //                                                 const BorderSide(
                          //                                                     width: 1.5),
                          //                                           ),
                          //                                         ),
                          //                                         onChanged:
                          //                                             (value) {
                          //                                           setState(
                          //                                               () {});
                          //                                         },
                          //                                       ),
                          //                                     ),
                          //                                     SizedBox(
                          //                                         height:
                          //                                             height *
                          //                                                 0.02),
                          //                                     Container(
                          //                                       height: height *
                          //                                           0.05,
                          //                                       decoration:
                          //                                           BoxDecoration(
                          //                                         borderRadius:
                          //                                             BorderRadius
                          //                                                 .circular(
                          //                                                     30.0),
                          //                                         border: Border
                          //                                             .all(
                          //                                           color: borderColor
                          //                                               .withOpacity(
                          //                                                   1.0),
                          //                                           width: 1.5,
                          //                                         ),
                          //                                       ),
                          //                                       child:
                          //                                           DropdownButtonFormField<
                          //                                               String>(
                          //                                         hint: Text(
                          //                                           "Select measurement",
                          //                                           style:
                          //                                               TextStyle(
                          //                                             fontFamily:
                          //                                                 "Lexand",
                          //                                             fontSize:
                          //                                                 height *
                          //                                                     0.018,
                          //                                             fontWeight:
                          //                                                 FontWeight
                          //                                                     .w300,
                          //                                           ),
                          //                                         ),
                          //                                         padding:
                          //                                             const EdgeInsets
                          //                                                 .only(
                          //                                                 left:
                          //                                                     0,
                          //                                                 bottom:
                          //                                                     5),
                          //                                         value:
                          //                                             selectedUnit,
                          //                                         borderRadius:
                          //                                             BorderRadius
                          //                                                 .circular(
                          //                                                     30.0),
                          //                                         onChanged:
                          //                                             (String?
                          //                                                 newValue) {
                          //                                           setState(
                          //                                               () {
                          //                                             selectedUnit =
                          //                                                 newValue!;
                          //                                           });
                          //                                         },
                          //                                         items: <String>[
                          //                                           'kg',
                          //                                           'litre',
                          //                                           'unit'
                          //                                         ].map<
                          //                                             DropdownMenuItem<
                          //                                                 String>>(
                          //                                           (String
                          //                                               value) {
                          //                                             return DropdownMenuItem<
                          //                                                 String>(
                          //                                               value:
                          //                                                   value,
                          //                                               child:
                          //                                                   Padding(
                          //                                                 padding:
                          //                                                     EdgeInsets.symmetric(horizontal: width * 0.01),
                          //                                                 child:
                          //                                                     Text(
                          //                                                   value,
                          //                                                   style:
                          //                                                       TextStyle(
                          //                                                     fontFamily: "Lexand",
                          //                                                     fontSize: height * 0.018,
                          //                                                     fontWeight: FontWeight.w300,
                          //                                                   ),
                          //                                                 ),
                          //                                               ),
                          //                                             );
                          //                                           },
                          //                                         ).toList(),
                          //                                         decoration:
                          //                                             InputDecoration(
                          //                                           border:
                          //                                               InputBorder
                          //                                                   .none,
                          //                                           contentPadding:
                          //                                               EdgeInsets
                          //                                                   .zero,
                          //                                           floatingLabelStyle:
                          //                                               TextStyle(
                          //                                             fontFamily:
                          //                                                 "Lexand",
                          //                                             fontSize:
                          //                                                 height *
                          //                                                     0.013,
                          //                                             fontWeight:
                          //                                                 FontWeight
                          //                                                     .w300,
                          //                                           ),
                          //                                         ),
                          //                                         // Aligns the dropdown value vertically centered within the container
                          //                                         alignment:
                          //                                             Alignment
                          //                                                 .topCenter,
                          //                                       ),
                          //                                     ),
                          //                                     SizedBox(
                          //                                       height: height *
                          //                                           0.02,
                          //                                     ),
                          //                                     Row(
                          //                                       children: [
                          //                                         Expanded(
                          //                                           child:
                          //                                               InkWell(
                          //                                             onTap:
                          //                                                 () {
                          //                                               Navigator.pop(
                          //                                                   context);
                          //                                             },
                          //                                             child:
                          //                                                 Padding(
                          //                                               padding:
                          //                                                   EdgeInsets.symmetric(horizontal: width * 0.02),
                          //                                               child:
                          //                                                   Container(
                          //                                                 height:
                          //                                                     height * 0.04,
                          //                                                 width:
                          //                                                     width,
                          //                                                 decoration:
                          //                                                     BoxDecoration(
                          //                                                   color:
                          //                                                       buttonColor.withOpacity(1.0),
                          //                                                   borderRadius:
                          //                                                       BorderRadius.circular(15.0),
                          //                                                 ),
                          //                                                 child:
                          //                                                     Padding(
                          //                                                   padding:
                          //                                                       const EdgeInsets.all(8.0),
                          //                                                   child:
                          //                                                       Center(
                          //                                                     child: Text(
                          //                                                       "Cancel",
                          //                                                       style: TextStyle(color: Colors.white, fontFamily: "Lexand", fontSize: height * 0.011, fontWeight: FontWeight.w700),
                          //                                                     ),
                          //                                                   ),
                          //                                                 ),
                          //                                               ),
                          //                                             ),
                          //                                           ),
                          //                                         ),
                          //                                         Expanded(
                          //                                           child:
                          //                                               InkWell(
                          //                                             onTap:
                          //                                                 () async {
                          //                                               await storeRoomController
                          //                                                   .storRoomingrediantEdit(
                          //                                                 ingredientsEditController
                          //                                                     .text,
                          //                                                 storeRoomController.ingredientList[i]
                          //                                                     [
                          //                                                     "ingredientId"],
                          //                                                 storeRoomController.ingredientList[i]
                          //                                                     [
                          //                                                     "isChecked"],
                          //                                                 selectedUnit,
                          //                                               );
                          //                                               await storeRoomController
                          //                                                   .stroreRoomingredientsList(nameOfIngeridiant);
                          //                                             },
                          //                                             child:
                          //                                                 Padding(
                          //                                               padding:
                          //                                                   EdgeInsets.symmetric(horizontal: width * 0.02),
                          //                                               child:
                          //                                                   Container(
                          //                                                 height:
                          //                                                     height * 0.04,
                          //                                                 width:
                          //                                                     width,
                          //                                                 decoration:
                          //                                                     BoxDecoration(
                          //                                                   color:
                          //                                                       buttonColor.withOpacity(1.0),
                          //                                                   borderRadius:
                          //                                                       BorderRadius.circular(15.0),
                          //                                                 ),
                          //                                                 child:
                          //                                                     Padding(
                          //                                                   padding:
                          //                                                       const EdgeInsets.all(8.0),
                          //                                                   child:
                          //                                                       Center(
                          //                                                     child: Text(
                          //                                                       "Save",
                          //                                                       style: TextStyle(color: Colors.white, fontFamily: "Lexand", fontSize: height * 0.011, fontWeight: FontWeight.w700),
                          //                                                     ),
                          //                                                   ),
                          //                                                 ),
                          //                                               ),
                          //                                             ),
                          //                                           ),
                          //                                         )
                          //                                       ],
                          //                                     )
                          //                                   ],
                          //                                 ),
                          //                               ),
                          //                             );
                          //                           },
                          //                         );
                          //                       },
                          //                       child: Container(
                          //                         width: width,
                          //                         // height: height*0.05,
                          //                         decoration: BoxDecoration(
                          //                           color: storeRoomController
                          //                                       .ingredientList[
                          //                                   i]["isChecked"]
                          //                               ? primaryColor
                          //                                   .withOpacity(1.0)
                          //                               : Colors.white,
                          //                           borderRadius:
                          //                               BorderRadius.circular(
                          //                                   10.0),
                          //                         ),
                          //                         child: Padding(
                          //                           padding:
                          //                               const EdgeInsets.all(
                          //                                   8.0),
                          //                           child: Row(
                          //                             mainAxisAlignment:
                          //                                 MainAxisAlignment
                          //                                     .spaceBetween,
                          //                             children: [
                          //                               Text(
                          //                                 storeRoomController
                          //                                         .ingredientList[
                          //                                     i]["ingredient"],
                          //                                 style: TextStyle(
                          //                                   fontFamily:
                          //                                       "Lexand",
                          //                                   fontSize:
                          //                                       height * 0.013,
                          //                                   fontWeight:
                          //                                       FontWeight.w700,
                          //                                 ),
                          //                               ),
                          //                               InkWell(
                          //                                 onTap: () {
                          //                                   showDialog(
                          //                                     context: context,
                          //                                     builder:
                          //                                         (context) {
                          //                                       return AlertDialog(
                          //                                         // insetPadding: EdgeInsets.all(0.0),
                          //                                         content:
                          //                                             SizedBox(
                          //                                           // width: double.maxFinite,
                          //                                           height: height *
                          //                                               0.3, // Ensure the AlertDialog content has a fixed width
                          //                                           child:
                          //                                               Column(
                          //                                             children: [
                          //                                               Row(
                          //                                                 children: [
                          //                                                   InkWell(
                          //                                                     onTap: () {
                          //                                                       Navigator.pop(context);
                          //                                                       // scaffoldkey.currentState!.openDrawer();
                          //                                                     },
                          //                                                     child: Icon(
                          //                                                       Icons.arrow_back_ios_rounded,
                          //                                                       size: height * 0.039,
                          //                                                     ),
                          //                                                   ),
                          //                                                   Expanded(
                          //                                                     child: Text(
                          //                                                       "Pick your ingredients from the table.",
                          //                                                       style: TextStyle(fontFamily: "Lexand", fontSize: height * 0.018, fontWeight: FontWeight.w500),
                          //                                                     ),
                          //                                                   ),
                          //                                                 ],
                          //                                               ),
                          //                                               SizedBox(
                          //                                                   height:
                          //                                                       height * 0.02),
                          //                                               SizedBox(
                          //                                                 height:
                          //                                                     height * 0.05,
                          //                                                 child:
                          //                                                     TextFormField(
                          //                                                   style:
                          //                                                       TextStyle(
                          //                                                     fontFamily: "Lexand",
                          //                                                     fontSize: height * 0.018,
                          //                                                     fontWeight: FontWeight.w500,
                          //                                                   ),
                          //                                                   controller: ingredientsEditController =
                          //                                                       TextEditingController(text: storeRoomController.ingredientList[i]["ingredient"]),
                          //                                                   decoration:
                          //                                                       InputDecoration(
                          //                                                     // suffixIcon: Padding(
                          //                                                     //   padding: const EdgeInsets.all(8.0),
                          //                                                     //   child: Image.asset(
                          //                                                     //     "assets/user_icon.png",
                          //                                                     //     height: height * 0.02,
                          //                                                     //   ),
                          //                                                     // ),
                          //                                                     contentPadding: const EdgeInsets.only(left: 16.0),
                          //                                                     label: Text(
                          //                                                       "Ingredients",
                          //                                                       style: TextStyle(
                          //                                                         fontFamily: "Lexand",
                          //                                                         fontSize: height * 0.018,
                          //                                                         fontWeight: FontWeight.w300,
                          //                                                       ),
                          //                                                     ),
                          //                                                     floatingLabelStyle: const TextStyle(
                          //                                                       fontFamily: "Lexand",
                          //                                                       fontWeight: FontWeight.w300,
                          //                                                     ),
                          //                                                     border: OutlineInputBorder(
                          //                                                       borderRadius: BorderRadius.circular(15.0),
                          //                                                       borderSide: const BorderSide(width: 1.5),
                          //                                                     ),
                          //                                                     disabledBorder: OutlineInputBorder(
                          //                                                       borderRadius: BorderRadius.circular(30.0),
                          //                                                       borderSide: const BorderSide(width: 1.5),
                          //                                                     ),
                          //                                                     enabledBorder: OutlineInputBorder(
                          //                                                       borderRadius: BorderRadius.circular(30.0),
                          //                                                       borderSide: BorderSide(
                          //                                                         color: borderColor.withOpacity(1.0),
                          //                                                         width: 1.5,
                          //                                                       ),
                          //                                                     ),
                          //                                                     focusedBorder: OutlineInputBorder(
                          //                                                       borderRadius: BorderRadius.circular(30.0),
                          //                                                       borderSide: const BorderSide(width: 1.5),
                          //                                                     ),
                          //                                                   ),
                          //                                                   onChanged:
                          //                                                       (value) {
                          //                                                     setState(() {});
                          //                                                   },
                          //                                                 ),
                          //                                               ),
                          //                                               SizedBox(
                          //                                                   height:
                          //                                                       height * 0.02),
                          //                                               Container(
                          //                                                 height:
                          //                                                     height * 0.05,
                          //                                                 decoration:
                          //                                                     BoxDecoration(
                          //                                                   borderRadius:
                          //                                                       BorderRadius.circular(30.0),
                          //                                                   border:
                          //                                                       Border.all(
                          //                                                     color: borderColor.withOpacity(1.0),
                          //                                                     width: 1.5,
                          //                                                   ),
                          //                                                 ),
                          //                                                 child:
                          //                                                     DropdownButtonFormField<String>(
                          //                                                   hint:
                          //                                                       Text(
                          //                                                     "Select measurement",
                          //                                                     style: TextStyle(
                          //                                                       fontFamily: "Lexand",
                          //                                                       fontSize: height * 0.018,
                          //                                                       fontWeight: FontWeight.w300,
                          //                                                     ),
                          //                                                   ),
                          //                                                   padding:
                          //                                                       const EdgeInsets.only(left: 10, bottom: 5),
                          //                                                   value:
                          //                                                       selectedUnit,
                          //                                                   borderRadius:
                          //                                                       BorderRadius.circular(30.0),
                          //                                                   onChanged:
                          //                                                       (String? newValue) {
                          //                                                     setState(() {
                          //                                                       selectedUnit = newValue!;
                          //                                                     });
                          //                                                   },
                          //                                                   items:
                          //                                                       <String>[
                          //                                                     'kg',
                          //                                                     'litre',
                          //                                                     'unit'
                          //                                                   ].map<DropdownMenuItem<String>>(
                          //                                                     (String value) {
                          //                                                       return DropdownMenuItem<String>(
                          //                                                         value: value,
                          //                                                         child: Padding(
                          //                                                           padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                          //                                                           child: Text(
                          //                                                             value,
                          //                                                             style: TextStyle(
                          //                                                               fontFamily: "Lexand",
                          //                                                               fontSize: height * 0.018,
                          //                                                               fontWeight: FontWeight.w300,
                          //                                                             ),
                          //                                                           ),
                          //                                                         ),
                          //                                                       );
                          //                                                     },
                          //                                                   ).toList(),
                          //                                                   decoration:
                          //                                                       InputDecoration(
                          //                                                     border: InputBorder.none,
                          //                                                     contentPadding: EdgeInsets.zero,
                          //                                                     floatingLabelStyle: TextStyle(
                          //                                                       fontFamily: "Lexand",
                          //                                                       fontSize: height * 0.013,
                          //                                                       fontWeight: FontWeight.w300,
                          //                                                     ),
                          //                                                   ),
                          //                                                   // Aligns the dropdown value vertically centered within the container
                          //                                                   alignment:
                          //                                                       Alignment.topCenter,
                          //                                                 ),
                          //                                               ),
                          //                                               SizedBox(
                          //                                                 height:
                          //                                                     height * 0.02,
                          //                                               ),
                          //                                               Row(
                          //                                                 children: [
                          //                                                   Expanded(
                          //                                                     child: InkWell(
                          //                                                       onTap: () {
                          //                                                         Navigator.pop(context);
                          //                                                       },
                          //                                                       child: Padding(
                          //                                                         padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                          //                                                         child: Container(
                          //                                                           height: height * 0.04,
                          //                                                           width: width,
                          //                                                           decoration: BoxDecoration(
                          //                                                             color: buttonColor.withOpacity(1.0),
                          //                                                             borderRadius: BorderRadius.circular(15.0),
                          //                                                           ),
                          //                                                           child: Padding(
                          //                                                             padding: const EdgeInsets.all(8.0),
                          //                                                             child: Center(
                          //                                                               child: Text(
                          //                                                                 "Cancel",
                          //                                                                 style: TextStyle(color: Colors.white, fontFamily: "Lexand", fontSize: height * 0.011, fontWeight: FontWeight.w700),
                          //                                                               ),
                          //                                                             ),
                          //                                                           ),
                          //                                                         ),
                          //                                                       ),
                          //                                                     ),
                          //                                                   ),
                          //                                                   Expanded(
                          //                                                     child: InkWell(
                          //                                                       onTap: () async {
                          //                                                         await storeRoomController.storRoomingrediantEdit(
                          //                                                           ingredientsEditController.text,
                          //                                                           storeRoomController.ingredientList[i]["ingredientId"],
                          //                                                           storeRoomController.ingredientList[i]["isChecked"],
                          //                                                           selectedUnit,
                          //                                                         );
                          //                                                         setState(() {});
                          //                                                         Navigator.pop(context);
                          //                                                         await storeRoomController.stroreRoomingredientsList(nameOfIngeridiant);
                          //                                                       },
                          //                                                       child: Padding(
                          //                                                         padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                          //                                                         child: Container(
                          //                                                           height: height * 0.04,
                          //                                                           width: width,
                          //                                                           decoration: BoxDecoration(
                          //                                                             color: buttonColor.withOpacity(1.0),
                          //                                                             borderRadius: BorderRadius.circular(15.0),
                          //                                                           ),
                          //                                                           child: Padding(
                          //                                                             padding: const EdgeInsets.all(8.0),
                          //                                                             child: Center(
                          //                                                               child: Text(
                          //                                                                 "Save",
                          //                                                                 style: TextStyle(color: Colors.white, fontFamily: "Lexand", fontSize: height * 0.011, fontWeight: FontWeight.w700),
                          //                                                               ),
                          //                                                             ),
                          //                                                           ),
                          //                                                         ),
                          //                                                       ),
                          //                                                     ),
                          //                                                   )
                          //                                                 ],
                          //                                               )
                          //                                             ],
                          //                                           ),
                          //                                         ),
                          //                                       );
                          //                                     },
                          //                                   );
                          //                                 },
                          //                                 child: const Icon(
                          //                                   Icons.edit,
                          //                                   size: 20,
                          //                                   color: Colors.black,
                          //                                 ),
                          //                               )
                          //                             ],
                          //                           ),
                          //                         ),
                          //                       ),
                          //                     ),
                          //               );
                          //             },
                          //           ),
                          //         ),
                          //       )
                          //     : isPowder
                          //         ? Expanded(
                          //             flex: 3,
                          //             child: SingleChildScrollView(
                          //               child: SizedBox(
                          //                 height: height * 0.7,
                          //                 child: ListView.builder(
                          //                   // shrinkWrap: true,
                          //                   itemCount: storeRoomController
                          //                       .ingredientsPowedersList.length,
                          //                   itemBuilder: (
                          //                     context,
                          //                     i,
                          //                   ) {
                          //                     return Padding(
                          //                       padding:
                          //                           const EdgeInsets.all(8.0),
                          //                       child: Column(
                          //                         crossAxisAlignment:
                          //                             CrossAxisAlignment.start,
                          //                         children: [
                          //                           InkWell(
                          //                             onTap: () {
                          //                               setState(() {});
                          //                             },
                          //                             child: Container(
                          //                               width: width,
                          //                               // height: height*0.05,
                          //                               decoration:
                          //                                   BoxDecoration(
                          //                                 color: primaryColor
                          //                                     .withOpacity(1.0),
                          //                                 borderRadius:
                          //                                     BorderRadius
                          //                                         .circular(
                          //                                             10.0),
                          //                               ),
                          //                               child: Padding(
                          //                                 padding:
                          //                                     const EdgeInsets
                          //                                         .all(8.0),
                          //                                 child: Row(
                          //                                   mainAxisAlignment:
                          //                                       MainAxisAlignment
                          //                                           .spaceBetween,
                          //                                   children: [
                          //                                     Text(
                          //                                       storeRoomController
                          //                                               .ingredientsPowedersList[i]
                          //                                           [
                          //                                           "ingredient"],
                          //                                       style:
                          //                                           TextStyle(
                          //                                         fontFamily:
                          //                                             "Lexand",
                          //                                         fontSize:
                          //                                             height *
                          //                                                 0.013,
                          //                                         fontWeight:
                          //                                             FontWeight
                          //                                                 .w700,
                          //                                       ),
                          //                                     ),
                          //                                     InkWell(
                          //                                       onTap: () {
                          //                                         showDialog(
                          //                                           context:
                          //                                               context,
                          //                                           builder:
                          //                                               (context) {
                          //                                             return AlertDialog(
                          //                                               // insetPadding: EdgeInsets.all(0.0),
                          //                                               content:
                          //                                                   SizedBox(
                          //                                                 // width: double.maxFinite,
                          //                                                 height:
                          //                                                     height * 0.3, // Ensure the AlertDialog content has a fixed width
                          //                                                 child:
                          //                                                     Column(
                          //                                                   children: [
                          //                                                     Row(
                          //                                                       children: [
                          //                                                         InkWell(
                          //                                                           onTap: () {
                          //                                                             Navigator.pop(context);
                          //                                                             // scaffoldkey.currentState!.openDrawer();
                          //                                                           },
                          //                                                           child: Icon(
                          //                                                             Icons.arrow_back_ios_rounded,
                          //                                                             size: height * 0.039,
                          //                                                           ),
                          //                                                         ),
                          //                                                         Expanded(
                          //                                                           child: Text(
                          //                                                             "Pick your ingredients from the table.",
                          //                                                             style: TextStyle(fontFamily: "Lexand", fontSize: height * 0.018, fontWeight: FontWeight.w500),
                          //                                                           ),
                          //                                                         ),
                          //                                                       ],
                          //                                                     ),
                          //                                                     SizedBox(height: height * 0.02),
                          //                                                     SizedBox(
                          //                                                       height: height * 0.05,
                          //                                                       child: TextFormField(
                          //                                                         style: TextStyle(
                          //                                                           fontFamily: "Lexand",
                          //                                                           fontSize: height * 0.018,
                          //                                                           fontWeight: FontWeight.w500,
                          //                                                         ),
                          //                                                         controller: ingredientsEditController = TextEditingController(text: storeRoomController.ingredientsPowedersList[i]["ingredient"]),
                          //                                                         decoration: InputDecoration(
                          //                                                           // suffixIcon: Padding(
                          //                                                           //   padding: const EdgeInsets.all(8.0),
                          //                                                           //   child: Image.asset(
                          //                                                           //     "assets/user_icon.png",
                          //                                                           //     height: height * 0.02,
                          //                                                           //   ),
                          //                                                           // ),
                          //                                                           contentPadding: const EdgeInsets.only(left: 16.0),
                          //                                                           label: Text(
                          //                                                             "Ingredients",
                          //                                                             style: TextStyle(
                          //                                                               fontFamily: "Lexand",
                          //                                                               fontSize: height * 0.018,
                          //                                                               fontWeight: FontWeight.w300,
                          //                                                             ),
                          //                                                           ),
                          //                                                           floatingLabelStyle: const TextStyle(
                          //                                                             fontFamily: "Lexand",
                          //                                                             fontWeight: FontWeight.w300,
                          //                                                           ),
                          //                                                           border: OutlineInputBorder(
                          //                                                             borderRadius: BorderRadius.circular(15.0),
                          //                                                             borderSide: const BorderSide(width: 1.5),
                          //                                                           ),
                          //                                                           disabledBorder: OutlineInputBorder(
                          //                                                             borderRadius: BorderRadius.circular(30.0),
                          //                                                             borderSide: const BorderSide(width: 1.5),
                          //                                                           ),
                          //                                                           enabledBorder: OutlineInputBorder(
                          //                                                             borderRadius: BorderRadius.circular(30.0),
                          //                                                             borderSide: BorderSide(
                          //                                                               color: borderColor.withOpacity(1.0),
                          //                                                               width: 1.5,
                          //                                                             ),
                          //                                                           ),
                          //                                                           focusedBorder: OutlineInputBorder(
                          //                                                             borderRadius: BorderRadius.circular(30.0),
                          //                                                             borderSide: const BorderSide(width: 1.5),
                          //                                                           ),
                          //                                                         ),
                          //                                                         onChanged: (value) {
                          //                                                           setState(() {});
                          //                                                         },
                          //                                                       ),
                          //                                                     ),
                          //                                                     SizedBox(height: height * 0.02),
                          //                                                     Container(
                          //                                                       height: height * 0.05,
                          //                                                       decoration: BoxDecoration(
                          //                                                         borderRadius: BorderRadius.circular(30.0),
                          //                                                         border: Border.all(
                          //                                                           color: borderColor.withOpacity(1.0),
                          //                                                           width: 1.5,
                          //                                                         ),
                          //                                                       ),
                          //                                                       child: DropdownButtonFormField<String>(
                          //                                                         hint: Text(
                          //                                                           "Select measurement",
                          //                                                           style: TextStyle(
                          //                                                             fontFamily: "Lexand",
                          //                                                             fontSize: height * 0.018,
                          //                                                             fontWeight: FontWeight.w300,
                          //                                                           ),
                          //                                                         ),
                          //                                                         padding: const EdgeInsets.only(left: 10, bottom: 5),
                          //                                                         value: selectedUnit,
                          //                                                         borderRadius: BorderRadius.circular(30.0),
                          //                                                         onChanged: (String? newValue) {
                          //                                                           setState(() {
                          //                                                             selectedUnit = newValue!;
                          //                                                           });
                          //                                                         },
                          //                                                         items: <String>[
                          //                                                           'kg',
                          //                                                           'litre',
                          //                                                           'unit'
                          //                                                         ].map<DropdownMenuItem<String>>(
                          //                                                           (String value) {
                          //                                                             return DropdownMenuItem<String>(
                          //                                                               value: value,
                          //                                                               child: Padding(
                          //                                                                 padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                          //                                                                 child: Text(
                          //                                                                   value,
                          //                                                                   style: TextStyle(
                          //                                                                     fontFamily: "Lexand",
                          //                                                                     fontSize: height * 0.018,
                          //                                                                     fontWeight: FontWeight.w300,
                          //                                                                   ),
                          //                                                                 ),
                          //                                                               ),
                          //                                                             );
                          //                                                           },
                          //                                                         ).toList(),
                          //                                                         decoration: InputDecoration(
                          //                                                           border: InputBorder.none,
                          //                                                           contentPadding: EdgeInsets.zero,
                          //                                                           floatingLabelStyle: TextStyle(
                          //                                                             fontFamily: "Lexand",
                          //                                                             fontSize: height * 0.013,
                          //                                                             fontWeight: FontWeight.w300,
                          //                                                           ),
                          //                                                         ),
                          //                                                         // Aligns the dropdown value vertically centered within the container
                          //                                                         alignment: Alignment.topCenter,
                          //                                                       ),
                          //                                                     ),
                          //                                                     SizedBox(
                          //                                                       height: height * 0.02,
                          //                                                     ),
                          //                                                     Row(
                          //                                                       children: [
                          //                                                         Expanded(
                          //                                                           child: InkWell(
                          //                                                             onTap: () {
                          //                                                               Navigator.pop(context);
                          //                                                             },
                          //                                                             child: Padding(
                          //                                                               padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                          //                                                               child: Container(
                          //                                                                 height: height * 0.04,
                          //                                                                 width: width,
                          //                                                                 decoration: BoxDecoration(
                          //                                                                   color: buttonColor.withOpacity(1.0),
                          //                                                                   borderRadius: BorderRadius.circular(15.0),
                          //                                                                 ),
                          //                                                                 child: Padding(
                          //                                                                   padding: const EdgeInsets.all(8.0),
                          //                                                                   child: Center(
                          //                                                                     child: Text(
                          //                                                                       "Cancel",
                          //                                                                       style: TextStyle(color: Colors.white, fontFamily: "Lexand", fontSize: height * 0.011, fontWeight: FontWeight.w700),
                          //                                                                     ),
                          //                                                                   ),
                          //                                                                 ),
                          //                                                               ),
                          //                                                             ),
                          //                                                           ),
                          //                                                         ),
                          //                                                         Expanded(
                          //                                                           child: InkWell(
                          //                                                             onTap: () async {
                          //                                                               await storeRoomController.storRoomingrediantEdit(
                          //                                                                 ingredientsEditController.text,
                          //                                                                 storeRoomController.ingredientsPowedersList[i]["ingredientId"],
                          //                                                                 storeRoomController.ingredientsPowedersList[i]["isChecked"],
                          //                                                                 selectedUnit,
                          //                                                               );
                          //                                                               setState(() {});
                          //                                                               Navigator.pop(context);
                          //                                                               await storeRoomController.stroreRoomingredientsList(nameOfIngeridiant);
                          //                                                             },
                          //                                                             child: Padding(
                          //                                                               padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                          //                                                               child: Container(
                          //                                                                 height: height * 0.04,
                          //                                                                 width: width,
                          //                                                                 decoration: BoxDecoration(
                          //                                                                   color: buttonColor.withOpacity(1.0),
                          //                                                                   borderRadius: BorderRadius.circular(15.0),
                          //                                                                 ),
                          //                                                                 child: Padding(
                          //                                                                   padding: const EdgeInsets.all(8.0),
                          //                                                                   child: Center(
                          //                                                                     child: Text(
                          //                                                                       "Save",
                          //                                                                       style: TextStyle(color: Colors.white, fontFamily: "Lexand", fontSize: height * 0.011, fontWeight: FontWeight.w700),
                          //                                                                     ),
                          //                                                                   ),
                          //                                                                 ),
                          //                                                               ),
                          //                                                             ),
                          //                                                           ),
                          //                                                         )
                          //                                                       ],
                          //                                                     )
                          //                                                   ],
                          //                                                 ),
                          //                                               ),
                          //                                             );
                          //                                           },
                          //                                         );
                          //                                       },
                          //                                       child:
                          //                                           const Icon(
                          //                                         Icons.edit,
                          //                                         size: 20,
                          //                                         color: Colors
                          //                                             .black,
                          //                                       ),
                          //                                     )
                          //                                   ],
                          //                                 ),
                          //                               ),
                          //                             ),
                          //                           ),
                          //                           SizedBox(
                          //                               height: height * 0.01),
                          //                         ],
                          //                       ),
                          //                     );
                          //                   },
                          //                 ),
                          //               ),
                          //             ),
                          //           )
                          //         : isSpices
                          //             ? Expanded(
                          //                 flex: 3,
                          //                 child: SingleChildScrollView(
                          //                   child: SizedBox(
                          //                     height: height * 0.7,
                          //                     child: ListView.builder(
                          //                       // shrinkWrap: true,
                          //                       itemCount: storeRoomController
                          //                           .ingredientsSpicesList
                          //                           .length,
                          //                       itemBuilder: (
                          //                         context,
                          //                         i,
                          //                       ) {
                          //                         return Padding(
                          //                           padding:
                          //                               const EdgeInsets.all(
                          //                                   8.0),
                          //                           child: Column(
                          //                             crossAxisAlignment:
                          //                                 CrossAxisAlignment
                          //                                     .start,
                          //                             children: [
                          //                               InkWell(
                          //                                 onTap: () {
                          //                                   setState(() {});
                          //                                 },
                          //                                 child: Container(
                          //                                   width: width,
                          //                                   // height: height*0.05,
                          //                                   decoration:
                          //                                       BoxDecoration(
                          //                                     color: primaryColor
                          //                                         .withOpacity(
                          //                                             1.0),
                          //                                     borderRadius:
                          //                                         BorderRadius
                          //                                             .circular(
                          //                                                 10.0),
                          //                                   ),
                          //                                   child: Padding(
                          //                                     padding:
                          //                                         const EdgeInsets
                          //                                             .all(8.0),
                          //                                     child: Row(
                          //                                       mainAxisAlignment:
                          //                                           MainAxisAlignment
                          //                                               .spaceBetween,
                          //                                       children: [
                          //                                         Text(
                          //                                           storeRoomController
                          //                                                   .ingredientsSpicesList[i]
                          //                                               [
                          //                                               "ingredient"],
                          //                                           style:
                          //                                               TextStyle(
                          //                                             fontFamily:
                          //                                                 "Lexand",
                          //                                             fontSize:
                          //                                                 height *
                          //                                                     0.013,
                          //                                             fontWeight:
                          //                                                 FontWeight
                          //                                                     .w700,
                          //                                           ),
                          //                                         ),
                          //                                         InkWell(
                          //                                           onTap: () {
                          //                                             showDialog(
                          //                                               context:
                          //                                                   context,
                          //                                               builder:
                          //                                                   (context) {
                          //                                                 return AlertDialog(
                          //                                                   // insetPadding: EdgeInsets.all(0.0),
                          //                                                   content:
                          //                                                       SizedBox(
                          //                                                     // width: double.maxFinite,
                          //                                                     height: height * 0.3, // Ensure the AlertDialog content has a fixed width
                          //                                                     child: Column(
                          //                                                       children: [
                          //                                                         Row(
                          //                                                           children: [
                          //                                                             InkWell(
                          //                                                               onTap: () {
                          //                                                                 Navigator.pop(context);
                          //                                                                 // scaffoldkey.currentState!.openDrawer();
                          //                                                               },
                          //                                                               child: Icon(
                          //                                                                 Icons.arrow_back_ios_rounded,
                          //                                                                 size: height * 0.039,
                          //                                                               ),
                          //                                                             ),
                          //                                                             Expanded(
                          //                                                               child: Text(
                          //                                                                 "Pick your ingredients from the table.",
                          //                                                                 style: TextStyle(fontFamily: "Lexand", fontSize: height * 0.018, fontWeight: FontWeight.w500),
                          //                                                               ),
                          //                                                             ),
                          //                                                           ],
                          //                                                         ),
                          //                                                         SizedBox(height: height * 0.02),
                          //                                                         SizedBox(
                          //                                                           height: height * 0.05,
                          //                                                           child: TextFormField(
                          //                                                             style: TextStyle(
                          //                                                               fontFamily: "Lexand",
                          //                                                               fontSize: height * 0.018,
                          //                                                               fontWeight: FontWeight.w500,
                          //                                                             ),
                          //                                                             controller: ingredientsEditController = TextEditingController(text: storeRoomController.ingredientsSpicesList[i]["ingredient"]),
                          //                                                             decoration: InputDecoration(
                          //                                                               // suffixIcon: Padding(
                          //                                                               //   padding: const EdgeInsets.all(8.0),
                          //                                                               //   child: Image.asset(
                          //                                                               //     "assets/user_icon.png",
                          //                                                               //     height: height * 0.02,
                          //                                                               //   ),
                          //                                                               // ),
                          //                                                               contentPadding: const EdgeInsets.only(left: 16.0),
                          //                                                               label: Text(
                          //                                                                 "Ingredients",
                          //                                                                 style: TextStyle(
                          //                                                                   fontFamily: "Lexand",
                          //                                                                   fontSize: height * 0.018,
                          //                                                                   fontWeight: FontWeight.w300,
                          //                                                                 ),
                          //                                                               ),
                          //                                                               floatingLabelStyle: const TextStyle(
                          //                                                                 fontFamily: "Lexand",
                          //                                                                 fontWeight: FontWeight.w300,
                          //                                                               ),
                          //                                                               border: OutlineInputBorder(
                          //                                                                 borderRadius: BorderRadius.circular(15.0),
                          //                                                                 borderSide: const BorderSide(width: 1.5),
                          //                                                               ),
                          //                                                               disabledBorder: OutlineInputBorder(
                          //                                                                 borderRadius: BorderRadius.circular(30.0),
                          //                                                                 borderSide: const BorderSide(width: 1.5),
                          //                                                               ),
                          //                                                               enabledBorder: OutlineInputBorder(
                          //                                                                 borderRadius: BorderRadius.circular(30.0),
                          //                                                                 borderSide: BorderSide(
                          //                                                                   color: borderColor.withOpacity(1.0),
                          //                                                                   width: 1.5,
                          //                                                                 ),
                          //                                                               ),
                          //                                                               focusedBorder: OutlineInputBorder(
                          //                                                                 borderRadius: BorderRadius.circular(30.0),
                          //                                                                 borderSide: const BorderSide(width: 1.5),
                          //                                                               ),
                          //                                                             ),
                          //                                                             onChanged: (value) {
                          //                                                               setState(() {});
                          //                                                             },
                          //                                                           ),
                          //                                                         ),
                          //                                                         SizedBox(height: height * 0.02),
                          //                                                         Container(
                          //                                                           height: height * 0.05,
                          //                                                           decoration: BoxDecoration(
                          //                                                             borderRadius: BorderRadius.circular(30.0),
                          //                                                             border: Border.all(
                          //                                                               color: borderColor.withOpacity(1.0),
                          //                                                               width: 1.5,
                          //                                                             ),
                          //                                                           ),
                          //                                                           child: DropdownButtonFormField<String>(
                          //                                                             hint: Text(
                          //                                                               "Select measurement",
                          //                                                               style: TextStyle(
                          //                                                                 fontFamily: "Lexand",
                          //                                                                 fontSize: height * 0.018,
                          //                                                                 fontWeight: FontWeight.w300,
                          //                                                               ),
                          //                                                             ),
                          //                                                             padding: const EdgeInsets.only(left: 10, bottom: 5),
                          //                                                             value: selectedUnit,
                          //                                                             borderRadius: BorderRadius.circular(30.0),
                          //                                                             onChanged: (String? newValue) {
                          //                                                               setState(() {
                          //                                                                 selectedUnit = newValue!;
                          //                                                               });
                          //                                                             },
                          //                                                             items: <String>[
                          //                                                               'kg',
                          //                                                               'litre',
                          //                                                               'unit'
                          //                                                             ].map<DropdownMenuItem<String>>(
                          //                                                               (String value) {
                          //                                                                 return DropdownMenuItem<String>(
                          //                                                                   value: value,
                          //                                                                   child: Padding(
                          //                                                                     padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                          //                                                                     child: Text(
                          //                                                                       value,
                          //                                                                       style: TextStyle(
                          //                                                                         fontFamily: "Lexand",
                          //                                                                         fontSize: height * 0.018,
                          //                                                                         fontWeight: FontWeight.w300,
                          //                                                                       ),
                          //                                                                     ),
                          //                                                                   ),
                          //                                                                 );
                          //                                                               },
                          //                                                             ).toList(),
                          //                                                             decoration: InputDecoration(
                          //                                                               border: InputBorder.none,
                          //                                                               contentPadding: EdgeInsets.zero,
                          //                                                               floatingLabelStyle: TextStyle(
                          //                                                                 fontFamily: "Lexand",
                          //                                                                 fontSize: height * 0.013,
                          //                                                                 fontWeight: FontWeight.w300,
                          //                                                               ),
                          //                                                             ),
                          //                                                             // Aligns the dropdown value vertically centered within the container
                          //                                                             alignment: Alignment.topCenter,
                          //                                                           ),
                          //                                                         ),
                          //                                                         SizedBox(
                          //                                                           height: height * 0.02,
                          //                                                         ),
                          //                                                         Row(
                          //                                                           children: [
                          //                                                             Expanded(
                          //                                                               child: InkWell(
                          //                                                                 onTap: () {
                          //                                                                   Navigator.pop(context);
                          //                                                                 },
                          //                                                                 child: Padding(
                          //                                                                   padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                          //                                                                   child: Container(
                          //                                                                     height: height * 0.04,
                          //                                                                     width: width,
                          //                                                                     decoration: BoxDecoration(
                          //                                                                       color: buttonColor.withOpacity(1.0),
                          //                                                                       borderRadius: BorderRadius.circular(15.0),
                          //                                                                     ),
                          //                                                                     child: Padding(
                          //                                                                       padding: const EdgeInsets.all(8.0),
                          //                                                                       child: Center(
                          //                                                                         child: Text(
                          //                                                                           "Cancel",
                          //                                                                           style: TextStyle(color: Colors.white, fontFamily: "Lexand", fontSize: height * 0.011, fontWeight: FontWeight.w700),
                          //                                                                         ),
                          //                                                                       ),
                          //                                                                     ),
                          //                                                                   ),
                          //                                                                 ),
                          //                                                               ),
                          //                                                             ),
                          //                                                             Expanded(
                          //                                                               child: InkWell(
                          //                                                                 onTap: () async {
                          //                                                                   var ingredientId = storeRoomController.ingredientsSpicesList[i]["ingredientId"];
                          //                                                                   await storeRoomController.storRoomingrediantEdit(
                          //                                                                     ingredientsEditController.text,
                          //                                                                     ingredientId,
                          //                                                                     storeRoomController.ingredientsSpicesList[i]["isChecked"],
                          //                                                                     selectedUnit,
                          //                                                                   );
                          //                                                                   setState(() {});
                          //                                                                   Navigator.pop(context);
                          //                                                                   await storeRoomController.stroreRoomingredientsList(nameOfIngeridiant);
                          //                                                                 },
                          //                                                                 child: Padding(
                          //                                                                   padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                          //                                                                   child: Container(
                          //                                                                     height: height * 0.04,
                          //                                                                     width: width,
                          //                                                                     decoration: BoxDecoration(
                          //                                                                       color: buttonColor.withOpacity(1.0),
                          //                                                                       borderRadius: BorderRadius.circular(15.0),
                          //                                                                     ),
                          //                                                                     child: Padding(
                          //                                                                       padding: const EdgeInsets.all(8.0),
                          //                                                                       child: Center(
                          //                                                                         child: Text(
                          //                                                                           "Save",
                          //                                                                           style: TextStyle(color: Colors.white, fontFamily: "Lexand", fontSize: height * 0.011, fontWeight: FontWeight.w700),
                          //                                                                         ),
                          //                                                                       ),
                          //                                                                     ),
                          //                                                                   ),
                          //                                                                 ),
                          //                                                               ),
                          //                                                             )
                          //                                                           ],
                          //                                                         )
                          //                                                       ],
                          //                                                     ),
                          //                                                   ),
                          //                                                 );
                          //                                               },
                          //                                             );
                          //                                           },
                          //                                           child:
                          //                                               const Icon(
                          //                                             Icons
                          //                                                 .edit,
                          //                                             size: 20,
                          //                                             color: Colors
                          //                                                 .black,
                          //                                           ),
                          //                                         )
                          //                                       ],
                          //                                     ),
                          //                                   ),
                          //                                 ),
                          //                               ),
                          //                               SizedBox(
                          //                                   height:
                          //                                       height * 0.01),
                          //                             ],
                          //                           ),
                          //                         );
                          //                       },
                          //                     ),
                          //                   ),
                          //                 ),
                          //               )
                          //             : isLentils
                          //                 ? Expanded(
                          //                     flex: 3,
                          //                     child: SingleChildScrollView(
                          //                       child: SizedBox(
                          //                         height: height * 0.7,
                          //                         child: ListView.builder(
                          //                           // shrinkWrap: true,
                          //                           itemCount: storeRoomController
                          //                               .ingredientsLentilList
                          //                               .length,
                          //                           itemBuilder: (
                          //                             context,
                          //                             i,
                          //                           ) {
                          //                             return Padding(
                          //                               padding:
                          //                                   const EdgeInsets
                          //                                       .all(8.0),
                          //                               child: Column(
                          //                                 crossAxisAlignment:
                          //                                     CrossAxisAlignment
                          //                                         .start,
                          //                                 children: [
                          //                                   InkWell(
                          //                                     onTap: () {
                          //                                       setState(() {});
                          //                                     },
                          //                                     child: Container(
                          //                                       width: width,
                          //                                       // height: height*0.05,
                          //                                       decoration:
                          //                                           BoxDecoration(
                          //                                         color: primaryColor
                          //                                             .withOpacity(
                          //                                                 1.0),
                          //                                         borderRadius:
                          //                                             BorderRadius
                          //                                                 .circular(
                          //                                                     10.0),
                          //                                       ),
                          //                                       child: Padding(
                          //                                         padding:
                          //                                             const EdgeInsets
                          //                                                 .all(
                          //                                                 8.0),
                          //                                         child: Row(
                          //                                           mainAxisAlignment:
                          //                                               MainAxisAlignment
                          //                                                   .spaceBetween,
                          //                                           children: [
                          //                                             Text(
                          //                                               storeRoomController.ingredientsLentilList[i]
                          //                                                   [
                          //                                                   "ingredient"],
                          //                                               style:
                          //                                                   TextStyle(
                          //                                                 fontFamily:
                          //                                                     "Lexand",
                          //                                                 fontSize:
                          //                                                     height * 0.013,
                          //                                                 fontWeight:
                          //                                                     FontWeight.w700,
                          //                                               ),
                          //                                             ),
                          //                                             InkWell(
                          //                                               onTap:
                          //                                                   () {
                          //                                                 showDialog(
                          //                                                   context:
                          //                                                       context,
                          //                                                   builder:
                          //                                                       (context) {
                          //                                                     return AlertDialog(
                          //                                                       // insetPadding: EdgeInsets.all(0.0),
                          //                                                       content: SizedBox(
                          //                                                         // width: double.maxFinite,
                          //                                                         height: height * 0.3, // Ensure the AlertDialog content has a fixed width
                          //                                                         child: Column(
                          //                                                           children: [
                          //                                                             Row(
                          //                                                               children: [
                          //                                                                 InkWell(
                          //                                                                   onTap: () {
                          //                                                                     Navigator.pop(context);
                          //                                                                     // scaffoldkey.currentState!.openDrawer();
                          //                                                                   },
                          //                                                                   child: Icon(
                          //                                                                     Icons.arrow_back_ios_rounded,
                          //                                                                     size: height * 0.039,
                          //                                                                   ),
                          //                                                                 ),
                          //                                                                 Expanded(
                          //                                                                   child: Text(
                          //                                                                     "Pick your ingredients from the table.",
                          //                                                                     style: TextStyle(fontFamily: "Lexand", fontSize: height * 0.018, fontWeight: FontWeight.w500),
                          //                                                                   ),
                          //                                                                 ),
                          //                                                               ],
                          //                                                             ),
                          //                                                             SizedBox(height: height * 0.02),
                          //                                                             SizedBox(
                          //                                                               height: height * 0.05,
                          //                                                               child: TextFormField(
                          //                                                                 style: TextStyle(
                          //                                                                   fontFamily: "Lexand",
                          //                                                                   fontSize: height * 0.018,
                          //                                                                   fontWeight: FontWeight.w500,
                          //                                                                 ),
                          //                                                                 controller: ingredientsEditController = TextEditingController(text: storeRoomController.ingredientsLentilList[i]["ingredient"]),
                          //                                                                 decoration: InputDecoration(
                          //                                                                   // suffixIcon: Padding(
                          //                                                                   //   padding: const EdgeInsets.all(8.0),
                          //                                                                   //   child: Image.asset(
                          //                                                                   //     "assets/user_icon.png",
                          //                                                                   //     height: height * 0.02,
                          //                                                                   //   ),
                          //                                                                   // ),
                          //                                                                   contentPadding: const EdgeInsets.only(left: 16.0),
                          //                                                                   label: Text(
                          //                                                                     "Ingredients",
                          //                                                                     style: TextStyle(
                          //                                                                       fontFamily: "Lexand",
                          //                                                                       fontSize: height * 0.018,
                          //                                                                       fontWeight: FontWeight.w300,
                          //                                                                     ),
                          //                                                                   ),
                          //                                                                   floatingLabelStyle: const TextStyle(
                          //                                                                     fontFamily: "Lexand",
                          //                                                                     fontWeight: FontWeight.w300,
                          //                                                                   ),
                          //                                                                   border: OutlineInputBorder(
                          //                                                                     borderRadius: BorderRadius.circular(15.0),
                          //                                                                     borderSide: const BorderSide(width: 1.5),
                          //                                                                   ),
                          //                                                                   disabledBorder: OutlineInputBorder(
                          //                                                                     borderRadius: BorderRadius.circular(30.0),
                          //                                                                     borderSide: const BorderSide(width: 1.5),
                          //                                                                   ),
                          //                                                                   enabledBorder: OutlineInputBorder(
                          //                                                                     borderRadius: BorderRadius.circular(30.0),
                          //                                                                     borderSide: BorderSide(
                          //                                                                       color: borderColor.withOpacity(1.0),
                          //                                                                       width: 1.5,
                          //                                                                     ),
                          //                                                                   ),
                          //                                                                   focusedBorder: OutlineInputBorder(
                          //                                                                     borderRadius: BorderRadius.circular(30.0),
                          //                                                                     borderSide: const BorderSide(width: 1.5),
                          //                                                                   ),
                          //                                                                 ),
                          //                                                                 onChanged: (value) {
                          //                                                                   setState(() {});
                          //                                                                 },
                          //                                                               ),
                          //                                                             ),
                          //                                                             SizedBox(height: height * 0.02),
                          //                                                             Container(
                          //                                                               height: height * 0.05,
                          //                                                               decoration: BoxDecoration(
                          //                                                                 borderRadius: BorderRadius.circular(30.0),
                          //                                                                 border: Border.all(
                          //                                                                   color: borderColor.withOpacity(1.0),
                          //                                                                   width: 1.5,
                          //                                                                 ),
                          //                                                               ),
                          //                                                               child: DropdownButtonFormField<String>(
                          //                                                                 hint: Text(
                          //                                                                   "Select measurement",
                          //                                                                   style: TextStyle(
                          //                                                                     fontFamily: "Lexand",
                          //                                                                     fontSize: height * 0.018,
                          //                                                                     fontWeight: FontWeight.w300,
                          //                                                                   ),
                          //                                                                 ),
                          //                                                                 padding: const EdgeInsets.only(left: 10, bottom: 5),
                          //                                                                 value: selectedUnit,
                          //                                                                 borderRadius: BorderRadius.circular(30.0),
                          //                                                                 onChanged: (String? newValue) {
                          //                                                                   setState(() {
                          //                                                                     selectedUnit = newValue!;
                          //                                                                   });
                          //                                                                 },
                          //                                                                 items: <String>[
                          //                                                                   'kg',
                          //                                                                   'litre',
                          //                                                                   'unit'
                          //                                                                 ].map<DropdownMenuItem<String>>(
                          //                                                                   (String value) {
                          //                                                                     return DropdownMenuItem<String>(
                          //                                                                       value: value,
                          //                                                                       child: Padding(
                          //                                                                         padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                          //                                                                         child: Text(
                          //                                                                           value,
                          //                                                                           style: TextStyle(
                          //                                                                             fontFamily: "Lexand",
                          //                                                                             fontSize: height * 0.018,
                          //                                                                             fontWeight: FontWeight.w300,
                          //                                                                           ),
                          //                                                                         ),
                          //                                                                       ),
                          //                                                                     );
                          //                                                                   },
                          //                                                                 ).toList(),
                          //                                                                 decoration: InputDecoration(
                          //                                                                   border: InputBorder.none,
                          //                                                                   contentPadding: EdgeInsets.zero,
                          //                                                                   floatingLabelStyle: TextStyle(
                          //                                                                     fontFamily: "Lexand",
                          //                                                                     fontSize: height * 0.013,
                          //                                                                     fontWeight: FontWeight.w300,
                          //                                                                   ),
                          //                                                                 ),
                          //                                                                 // Aligns the dropdown value vertically centered within the container
                          //                                                                 alignment: Alignment.topCenter,
                          //                                                               ),
                          //                                                             ),
                          //                                                             SizedBox(
                          //                                                               height: height * 0.02,
                          //                                                             ),
                          //                                                             Row(
                          //                                                               children: [
                          //                                                                 Expanded(
                          //                                                                   child: InkWell(
                          //                                                                     onTap: () {
                          //                                                                       Navigator.pop(context);
                          //                                                                     },
                          //                                                                     child: Padding(
                          //                                                                       padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                          //                                                                       child: Container(
                          //                                                                         height: height * 0.04,
                          //                                                                         width: width,
                          //                                                                         decoration: BoxDecoration(
                          //                                                                           color: buttonColor.withOpacity(1.0),
                          //                                                                           borderRadius: BorderRadius.circular(15.0),
                          //                                                                         ),
                          //                                                                         child: Padding(
                          //                                                                           padding: const EdgeInsets.all(8.0),
                          //                                                                           child: Center(
                          //                                                                             child: Text(
                          //                                                                               "Cancel",
                          //                                                                               style: TextStyle(color: Colors.white, fontFamily: "Lexand", fontSize: height * 0.011, fontWeight: FontWeight.w700),
                          //                                                                             ),
                          //                                                                           ),
                          //                                                                         ),
                          //                                                                       ),
                          //                                                                     ),
                          //                                                                   ),
                          //                                                                 ),
                          //                                                                 Expanded(
                          //                                                                   child: InkWell(
                          //                                                                     onTap: () async {
                          //                                                                       await storeRoomController.storRoomingrediantEdit(
                          //                                                                         ingredientsEditController.text,
                          //                                                                         storeRoomController.ingredientsLentilList[i]["ingredientId"],
                          //                                                                         storeRoomController.ingredientsLentilList[i]["isChecked"],
                          //                                                                         selectedUnit,
                          //                                                                       );
                          //                                                                       setState(() {});
                          //                                                                       Navigator.pop(context);
                          //                                                                       await storeRoomController.stroreRoomingredientsList(nameOfIngeridiant);
                          //                                                                     },
                          //                                                                     child: Padding(
                          //                                                                       padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                          //                                                                       child: Container(
                          //                                                                         height: height * 0.04,
                          //                                                                         width: width,
                          //                                                                         decoration: BoxDecoration(
                          //                                                                           color: buttonColor.withOpacity(1.0),
                          //                                                                           borderRadius: BorderRadius.circular(15.0),
                          //                                                                         ),
                          //                                                                         child: Padding(
                          //                                                                           padding: const EdgeInsets.all(8.0),
                          //                                                                           child: Center(
                          //                                                                             child: Text(
                          //                                                                               "Save",
                          //                                                                               style: TextStyle(color: Colors.white, fontFamily: "Lexand", fontSize: height * 0.011, fontWeight: FontWeight.w700),
                          //                                                                             ),
                          //                                                                           ),
                          //                                                                         ),
                          //                                                                       ),
                          //                                                                     ),
                          //                                                                   ),
                          //                                                                 )
                          //                                                               ],
                          //                                                             )
                          //                                                           ],
                          //                                                         ),
                          //                                                       ),
                          //                                                     );
                          //                                                   },
                          //                                                 );
                          //                                               },
                          //                                               child:
                          //                                                   const Icon(
                          //                                                 Icons
                          //                                                     .edit,
                          //                                                 size:
                          //                                                     20,
                          //                                                 color:
                          //                                                     Colors.black,
                          //                                               ),
                          //                                             )
                          //                                           ],
                          //                                         ),
                          //                                       ),
                          //                                     ),
                          //                                   ),
                          //                                   SizedBox(
                          //                                       height: height *
                          //                                           0.01),
                          //                                 ],
                          //                               ),
                          //                             );
                          //                           },
                          //                         ),
                          //                       ),
                          //                     ),
                          //                   )
                          //                 : isSeafoods
                          //                     ? Expanded(
                          //                         flex: 3,
                          //                         child: SingleChildScrollView(
                          //                           child: SizedBox(
                          //                             height: height * 0.7,
                          //                             child: ListView.builder(
                          //                               // shrinkWrap: true,
                          //                               itemCount:
                          //                                   storeRoomController
                          //                                       .ingredientsSeaFoodList
                          //                                       .length,
                          //                               itemBuilder: (
                          //                                 context,
                          //                                 i,
                          //                               ) {
                          //                                 return Padding(
                          //                                   padding:
                          //                                       const EdgeInsets
                          //                                           .all(8.0),
                          //                                   child: Column(
                          //                                     crossAxisAlignment:
                          //                                         CrossAxisAlignment
                          //                                             .start,
                          //                                     children: [
                          //                                       InkWell(
                          //                                         onTap: () {
                          //                                           setState(
                          //                                               () {});
                          //                                         },
                          //                                         child:
                          //                                             Container(
                          //                                           width:
                          //                                               width,
                          //                                           // height: height*0.05,
                          //                                           decoration:
                          //                                               BoxDecoration(
                          //                                             color: primaryColor
                          //                                                 .withOpacity(
                          //                                                     1.0),
                          //                                             borderRadius:
                          //                                                 BorderRadius.circular(
                          //                                                     10.0),
                          //                                           ),
                          //                                           child:
                          //                                               Padding(
                          //                                             padding: const EdgeInsets
                          //                                                 .all(
                          //                                                 8.0),
                          //                                             child:
                          //                                                 Row(
                          //                                               mainAxisAlignment:
                          //                                                   MainAxisAlignment.spaceBetween,
                          //                                               children: [
                          //                                                 Text(
                          //                                                   storeRoomController.ingredientsSeaFoodList[i]["ingredient"],
                          //                                                   style:
                          //                                                       TextStyle(
                          //                                                     fontFamily: "Lexand",
                          //                                                     fontSize: height * 0.013,
                          //                                                     fontWeight: FontWeight.w700,
                          //                                                   ),
                          //                                                 ),
                          //                                                 InkWell(
                          //                                                   onTap:
                          //                                                       () {
                          //                                                     showDialog(
                          //                                                       context: context,
                          //                                                       builder: (context) {
                          //                                                         return AlertDialog(
                          //                                                           // insetPadding: EdgeInsets.all(0.0),
                          //                                                           content: SizedBox(
                          //                                                             // width: double.maxFinite,
                          //                                                             height: height * 0.3, // Ensure the AlertDialog content has a fixed width
                          //                                                             child: Column(
                          //                                                               children: [
                          //                                                                 Row(
                          //                                                                   children: [
                          //                                                                     InkWell(
                          //                                                                       onTap: () {
                          //                                                                         Navigator.pop(context);
                          //                                                                         // scaffoldkey.currentState!.openDrawer();
                          //                                                                       },
                          //                                                                       child: Icon(
                          //                                                                         Icons.arrow_back_ios_rounded,
                          //                                                                         size: height * 0.039,
                          //                                                                       ),
                          //                                                                     ),
                          //                                                                     Expanded(
                          //                                                                       child: Text(
                          //                                                                         "Pick your ingredients from the table.",
                          //                                                                         style: TextStyle(fontFamily: "Lexand", fontSize: height * 0.018, fontWeight: FontWeight.w500),
                          //                                                                       ),
                          //                                                                     ),
                          //                                                                   ],
                          //                                                                 ),
                          //                                                                 SizedBox(height: height * 0.02),
                          //                                                                 SizedBox(
                          //                                                                   height: height * 0.05,
                          //                                                                   child: TextFormField(
                          //                                                                     style: TextStyle(
                          //                                                                       fontFamily: "Lexand",
                          //                                                                       fontSize: height * 0.018,
                          //                                                                       fontWeight: FontWeight.w500,
                          //                                                                     ),
                          //                                                                     controller: ingredientsEditController = TextEditingController(text: storeRoomController.ingredientsSeaFoodList[i]["ingredient"]),
                          //                                                                     decoration: InputDecoration(
                          //                                                                       // suffixIcon: Padding(
                          //                                                                       //   padding: const EdgeInsets.all(8.0),
                          //                                                                       //   child: Image.asset(
                          //                                                                       //     "assets/user_icon.png",
                          //                                                                       //     height: height * 0.02,
                          //                                                                       //   ),
                          //                                                                       // ),
                          //                                                                       contentPadding: const EdgeInsets.only(left: 16.0),
                          //                                                                       label: Text(
                          //                                                                         "Ingredients",
                          //                                                                         style: TextStyle(
                          //                                                                           fontFamily: "Lexand",
                          //                                                                           fontSize: height * 0.018,
                          //                                                                           fontWeight: FontWeight.w300,
                          //                                                                         ),
                          //                                                                       ),
                          //                                                                       floatingLabelStyle: const TextStyle(
                          //                                                                         fontFamily: "Lexand",
                          //                                                                         fontWeight: FontWeight.w300,
                          //                                                                       ),
                          //                                                                       border: OutlineInputBorder(
                          //                                                                         borderRadius: BorderRadius.circular(15.0),
                          //                                                                         borderSide: const BorderSide(width: 1.5),
                          //                                                                       ),
                          //                                                                       disabledBorder: OutlineInputBorder(
                          //                                                                         borderRadius: BorderRadius.circular(30.0),
                          //                                                                         borderSide: const BorderSide(width: 1.5),
                          //                                                                       ),
                          //                                                                       enabledBorder: OutlineInputBorder(
                          //                                                                         borderRadius: BorderRadius.circular(30.0),
                          //                                                                         borderSide: BorderSide(
                          //                                                                           color: borderColor.withOpacity(1.0),
                          //                                                                           width: 1.5,
                          //                                                                         ),
                          //                                                                       ),
                          //                                                                       focusedBorder: OutlineInputBorder(
                          //                                                                         borderRadius: BorderRadius.circular(30.0),
                          //                                                                         borderSide: const BorderSide(width: 1.5),
                          //                                                                       ),
                          //                                                                     ),
                          //                                                                     onChanged: (value) {
                          //                                                                       setState(() {});
                          //                                                                     },
                          //                                                                   ),
                          //                                                                 ),
                          //                                                                 SizedBox(height: height * 0.02),
                          //                                                                 Container(
                          //                                                                   height: height * 0.05,
                          //                                                                   decoration: BoxDecoration(
                          //                                                                     borderRadius: BorderRadius.circular(30.0),
                          //                                                                     border: Border.all(
                          //                                                                       color: borderColor.withOpacity(1.0),
                          //                                                                       width: 1.5,
                          //                                                                     ),
                          //                                                                   ),
                          //                                                                   child: DropdownButtonFormField<String>(
                          //                                                                     hint: Text(
                          //                                                                       "Select measurement",
                          //                                                                       style: TextStyle(
                          //                                                                         fontFamily: "Lexand",
                          //                                                                         fontSize: height * 0.018,
                          //                                                                         fontWeight: FontWeight.w300,
                          //                                                                       ),
                          //                                                                     ),
                          //                                                                     padding: const EdgeInsets.only(left: 10, bottom: 5),
                          //                                                                     value: selectedUnit,
                          //                                                                     borderRadius: BorderRadius.circular(30.0),
                          //                                                                     onChanged: (String? newValue) {
                          //                                                                       setState(() {
                          //                                                                         selectedUnit = newValue!;
                          //                                                                       });
                          //                                                                     },
                          //                                                                     items: <String>[
                          //                                                                       'kg',
                          //                                                                       'litre',
                          //                                                                       'unit'
                          //                                                                     ].map<DropdownMenuItem<String>>(
                          //                                                                       (String value) {
                          //                                                                         return DropdownMenuItem<String>(
                          //                                                                           value: value,
                          //                                                                           child: Padding(
                          //                                                                             padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                          //                                                                             child: Text(
                          //                                                                               value,
                          //                                                                               style: TextStyle(
                          //                                                                                 fontFamily: "Lexand",
                          //                                                                                 fontSize: height * 0.018,
                          //                                                                                 fontWeight: FontWeight.w300,
                          //                                                                               ),
                          //                                                                             ),
                          //                                                                           ),
                          //                                                                         );
                          //                                                                       },
                          //                                                                     ).toList(),
                          //                                                                     decoration: InputDecoration(
                          //                                                                       border: InputBorder.none,
                          //                                                                       contentPadding: EdgeInsets.zero,
                          //                                                                       floatingLabelStyle: TextStyle(
                          //                                                                         fontFamily: "Lexand",
                          //                                                                         fontSize: height * 0.013,
                          //                                                                         fontWeight: FontWeight.w300,
                          //                                                                       ),
                          //                                                                     ),
                          //                                                                     // Aligns the dropdown value vertically centered within the container
                          //                                                                     alignment: Alignment.topCenter,
                          //                                                                   ),
                          //                                                                 ),
                          //                                                                 SizedBox(
                          //                                                                   height: height * 0.02,
                          //                                                                 ),
                          //                                                                 Row(
                          //                                                                   children: [
                          //                                                                     Expanded(
                          //                                                                       child: InkWell(
                          //                                                                         onTap: () {
                          //                                                                           Navigator.pop(context);
                          //                                                                         },
                          //                                                                         child: Padding(
                          //                                                                           padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                          //                                                                           child: Container(
                          //                                                                             height: height * 0.04,
                          //                                                                             width: width,
                          //                                                                             decoration: BoxDecoration(
                          //                                                                               color: buttonColor.withOpacity(1.0),
                          //                                                                               borderRadius: BorderRadius.circular(15.0),
                          //                                                                             ),
                          //                                                                             child: Padding(
                          //                                                                               padding: const EdgeInsets.all(8.0),
                          //                                                                               child: Center(
                          //                                                                                 child: Text(
                          //                                                                                   "Cancel",
                          //                                                                                   style: TextStyle(color: Colors.white, fontFamily: "Lexand", fontSize: height * 0.011, fontWeight: FontWeight.w700),
                          //                                                                                 ),
                          //                                                                               ),
                          //                                                                             ),
                          //                                                                           ),
                          //                                                                         ),
                          //                                                                       ),
                          //                                                                     ),
                          //                                                                     Expanded(
                          //                                                                       child: InkWell(
                          //                                                                         onTap: () async {
                          //                                                                           await storeRoomController.storRoomingrediantEdit(
                          //                                                                             ingredientsEditController.text,
                          //                                                                             storeRoomController.ingredientsSeaFoodList[i]["ingredientId"],
                          //                                                                             storeRoomController.ingredientsSeaFoodList[i]["isChecked"],
                          //                                                                             selectedUnit,
                          //                                                                           );
                          //                                                                           setState(() {});
                          //                                                                           Navigator.pop(context);
                          //                                                                           await storeRoomController.stroreRoomingredientsList(nameOfIngeridiant);
                          //                                                                         },
                          //                                                                         child: Padding(
                          //                                                                           padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                          //                                                                           child: Container(
                          //                                                                             height: height * 0.04,
                          //                                                                             width: width,
                          //                                                                             decoration: BoxDecoration(
                          //                                                                               color: buttonColor.withOpacity(1.0),
                          //                                                                               borderRadius: BorderRadius.circular(15.0),
                          //                                                                             ),
                          //                                                                             child: Padding(
                          //                                                                               padding: const EdgeInsets.all(8.0),
                          //                                                                               child: Center(
                          //                                                                                 child: Text(
                          //                                                                                   "Save",
                          //                                                                                   style: TextStyle(color: Colors.white, fontFamily: "Lexand", fontSize: height * 0.011, fontWeight: FontWeight.w700),
                          //                                                                                 ),
                          //                                                                               ),
                          //                                                                             ),
                          //                                                                           ),
                          //                                                                         ),
                          //                                                                       ),
                          //                                                                     )
                          //                                                                   ],
                          //                                                                 )
                          //                                                               ],
                          //                                                             ),
                          //                                                           ),
                          //                                                         );
                          //                                                       },
                          //                                                     );
                          //                                                   },
                          //                                                   child:
                          //                                                       const Icon(
                          //                                                     Icons.edit,
                          //                                                     size: 20,
                          //                                                     color: Colors.black,
                          //                                                   ),
                          //                                                 )
                          //                                               ],
                          //                                             ),
                          //                                           ),
                          //                                         ),
                          //                                       ),
                          //                                       SizedBox(
                          //                                           height:
                          //                                               height *
                          //                                                   0.01),
                          //                                     ],
                          //                                   ),
                          //                                 );
                          //                               },
                          //                             ),
                          //                           ),
                          //                         ),
                          //                       )
                          //                     : isRice
                          //                         ? Expanded(
                          //                             flex: 3,
                          //                             child:
                          //                                 SingleChildScrollView(
                          //                               child: SizedBox(
                          //                                 height: height * 0.7,
                          //                                 child:
                          //                                     ListView.builder(
                          //                                   // shrinkWrap: true,
                          //                                   itemCount:
                          //                                       storeRoomController
                          //                                           .ingredientsRicesList
                          //                                           .length,
                          //                                   itemBuilder: (
                          //                                     context,
                          //                                     i,
                          //                                   ) {
                          //                                     return Padding(
                          //                                       padding:
                          //                                           const EdgeInsets
                          //                                               .all(
                          //                                               8.0),
                          //                                       child: Column(
                          //                                         crossAxisAlignment:
                          //                                             CrossAxisAlignment
                          //                                                 .start,
                          //                                         children: [
                          //                                           InkWell(
                          //                                             onTap:
                          //                                                 () {
                          //                                               setState(
                          //                                                   () {});
                          //                                             },
                          //                                             child:
                          //                                                 Container(
                          //                                               width:
                          //                                                   width,
                          //                                               // height: height*0.05,
                          //                                               decoration:
                          //                                                   BoxDecoration(
                          //                                                 color:
                          //                                                     primaryColor.withOpacity(1.0),
                          //                                                 borderRadius:
                          //                                                     BorderRadius.circular(10.0),
                          //                                               ),
                          //                                               child:
                          //                                                   Padding(
                          //                                                 padding: const EdgeInsets
                          //                                                     .all(
                          //                                                     8.0),
                          //                                                 child:
                          //                                                     Row(
                          //                                                   mainAxisAlignment:
                          //                                                       MainAxisAlignment.spaceBetween,
                          //                                                   children: [
                          //                                                     Text(
                          //                                                       storeRoomController.ingredientsRicesList[i]["ingredient"],
                          //                                                       style: TextStyle(
                          //                                                         fontFamily: "Lexand",
                          //                                                         fontSize: height * 0.013,
                          //                                                         fontWeight: FontWeight.w700,
                          //                                                       ),
                          //                                                     ),
                          //                                                     InkWell(
                          //                                                       onTap: () {
                          //                                                         showDialog(
                          //                                                           context: context,
                          //                                                           builder: (context) {
                          //                                                             return AlertDialog(
                          //                                                               // insetPadding: EdgeInsets.all(0.0),
                          //                                                               content: SizedBox(
                          //                                                                 // width: double.maxFinite,
                          //                                                                 height: height * 0.3, // Ensure the AlertDialog content has a fixed width
                          //                                                                 child: Column(
                          //                                                                   children: [
                          //                                                                     Row(
                          //                                                                       children: [
                          //                                                                         InkWell(
                          //                                                                           onTap: () {
                          //                                                                             Navigator.pop(context);
                          //                                                                             // scaffoldkey.currentState!.openDrawer();
                          //                                                                           },
                          //                                                                           child: Icon(
                          //                                                                             Icons.arrow_back_ios_rounded,
                          //                                                                             size: height * 0.039,
                          //                                                                           ),
                          //                                                                         ),
                          //                                                                         Expanded(
                          //                                                                           child: Text(
                          //                                                                             "Pick your ingredients from the table.",
                          //                                                                             style: TextStyle(fontFamily: "Lexand", fontSize: height * 0.018, fontWeight: FontWeight.w500),
                          //                                                                           ),
                          //                                                                         ),
                          //                                                                       ],
                          //                                                                     ),
                          //                                                                     SizedBox(height: height * 0.02),
                          //                                                                     SizedBox(
                          //                                                                       height: height * 0.05,
                          //                                                                       child: TextFormField(
                          //                                                                         style: TextStyle(
                          //                                                                           fontFamily: "Lexand",
                          //                                                                           fontSize: height * 0.018,
                          //                                                                           fontWeight: FontWeight.w500,
                          //                                                                         ),
                          //                                                                         controller: ingredientsEditController = TextEditingController(text: storeRoomController.ingredientsRicesList[i]["ingredient"]),
                          //                                                                         decoration: InputDecoration(
                          //                                                                           // suffixIcon: Padding(
                          //                                                                           //   padding: const EdgeInsets.all(8.0),
                          //                                                                           //   child: Image.asset(
                          //                                                                           //     "assets/user_icon.png",
                          //                                                                           //     height: height * 0.02,
                          //                                                                           //   ),
                          //                                                                           // ),
                          //                                                                           contentPadding: const EdgeInsets.only(left: 16.0),
                          //                                                                           label: Text(
                          //                                                                             "Ingredients",
                          //                                                                             style: TextStyle(
                          //                                                                               fontFamily: "Lexand",
                          //                                                                               fontSize: height * 0.018,
                          //                                                                               fontWeight: FontWeight.w300,
                          //                                                                             ),
                          //                                                                           ),
                          //                                                                           floatingLabelStyle: const TextStyle(
                          //                                                                             fontFamily: "Lexand",
                          //                                                                             fontWeight: FontWeight.w300,
                          //                                                                           ),
                          //                                                                           border: OutlineInputBorder(
                          //                                                                             borderRadius: BorderRadius.circular(15.0),
                          //                                                                             borderSide: const BorderSide(width: 1.5),
                          //                                                                           ),
                          //                                                                           disabledBorder: OutlineInputBorder(
                          //                                                                             borderRadius: BorderRadius.circular(30.0),
                          //                                                                             borderSide: const BorderSide(width: 1.5),
                          //                                                                           ),
                          //                                                                           enabledBorder: OutlineInputBorder(
                          //                                                                             borderRadius: BorderRadius.circular(30.0),
                          //                                                                             borderSide: BorderSide(
                          //                                                                               color: borderColor.withOpacity(1.0),
                          //                                                                               width: 1.5,
                          //                                                                             ),
                          //                                                                           ),
                          //                                                                           focusedBorder: OutlineInputBorder(
                          //                                                                             borderRadius: BorderRadius.circular(30.0),
                          //                                                                             borderSide: const BorderSide(width: 1.5),
                          //                                                                           ),
                          //                                                                         ),
                          //                                                                         onChanged: (value) {
                          //                                                                           setState(() {});
                          //                                                                         },
                          //                                                                       ),
                          //                                                                     ),
                          //                                                                     SizedBox(height: height * 0.02),
                          //                                                                     Container(
                          //                                                                       height: height * 0.05,
                          //                                                                       decoration: BoxDecoration(
                          //                                                                         borderRadius: BorderRadius.circular(30.0),
                          //                                                                         border: Border.all(
                          //                                                                           color: borderColor.withOpacity(1.0),
                          //                                                                           width: 1.5,
                          //                                                                         ),
                          //                                                                       ),
                          //                                                                       child: DropdownButtonFormField<String>(
                          //                                                                         hint: Text(
                          //                                                                           "Select measurement",
                          //                                                                           style: TextStyle(
                          //                                                                             fontFamily: "Lexand",
                          //                                                                             fontSize: height * 0.018,
                          //                                                                             fontWeight: FontWeight.w300,
                          //                                                                           ),
                          //                                                                         ),
                          //                                                                         padding: const EdgeInsets.only(left: 10, bottom: 5),
                          //                                                                         value: selectedUnit,
                          //                                                                         borderRadius: BorderRadius.circular(30.0),
                          //                                                                         onChanged: (String? newValue) {
                          //                                                                           setState(() {
                          //                                                                             selectedUnit = newValue!;
                          //                                                                           });
                          //                                                                         },
                          //                                                                         items: <String>[
                          //                                                                           'kg',
                          //                                                                           'litre',
                          //                                                                           'unit'
                          //                                                                         ].map<DropdownMenuItem<String>>(
                          //                                                                           (String value) {
                          //                                                                             return DropdownMenuItem<String>(
                          //                                                                               value: value,
                          //                                                                               child: Padding(
                          //                                                                                 padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                          //                                                                                 child: Text(
                          //                                                                                   value,
                          //                                                                                   style: TextStyle(
                          //                                                                                     fontFamily: "Lexand",
                          //                                                                                     fontSize: height * 0.018,
                          //                                                                                     fontWeight: FontWeight.w300,
                          //                                                                                   ),
                          //                                                                                 ),
                          //                                                                               ),
                          //                                                                             );
                          //                                                                           },
                          //                                                                         ).toList(),
                          //                                                                         decoration: InputDecoration(
                          //                                                                           border: InputBorder.none,
                          //                                                                           contentPadding: EdgeInsets.zero,
                          //                                                                           floatingLabelStyle: TextStyle(
                          //                                                                             fontFamily: "Lexand",
                          //                                                                             fontSize: height * 0.013,
                          //                                                                             fontWeight: FontWeight.w300,
                          //                                                                           ),
                          //                                                                         ),
                          //                                                                         // Aligns the dropdown value vertically centered within the container
                          //                                                                         alignment: Alignment.topCenter,
                          //                                                                       ),
                          //                                                                     ),
                          //                                                                     SizedBox(
                          //                                                                       height: height * 0.02,
                          //                                                                     ),
                          //                                                                     Row(
                          //                                                                       children: [
                          //                                                                         Expanded(
                          //                                                                           child: InkWell(
                          //                                                                             onTap: () {
                          //                                                                               Navigator.pop(context);
                          //                                                                             },
                          //                                                                             child: Padding(
                          //                                                                               padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                          //                                                                               child: Container(
                          //                                                                                 height: height * 0.04,
                          //                                                                                 width: width,
                          //                                                                                 decoration: BoxDecoration(
                          //                                                                                   color: buttonColor.withOpacity(1.0),
                          //                                                                                   borderRadius: BorderRadius.circular(15.0),
                          //                                                                                 ),
                          //                                                                                 child: Padding(
                          //                                                                                   padding: const EdgeInsets.all(8.0),
                          //                                                                                   child: Center(
                          //                                                                                     child: Text(
                          //                                                                                       "Cancel",
                          //                                                                                       style: TextStyle(color: Colors.white, fontFamily: "Lexand", fontSize: height * 0.011, fontWeight: FontWeight.w700),
                          //                                                                                     ),
                          //                                                                                   ),
                          //                                                                                 ),
                          //                                                                               ),
                          //                                                                             ),
                          //                                                                           ),
                          //                                                                         ),
                          //                                                                         Expanded(
                          //                                                                           child: InkWell(
                          //                                                                             onTap: () async {
                          //                                                                               await storeRoomController.storRoomingrediantEdit(
                          //                                                                                 ingredientsEditController.text,
                          //                                                                                 storeRoomController.ingredientsRicesList[i]["ingredientId"],
                          //                                                                                 storeRoomController.ingredientsRicesList[i]["isChecked"],
                          //                                                                                 selectedUnit,
                          //                                                                               );
                          //                                                                               setState(() {});
                          //                                                                               Navigator.pop(context);
                          //                                                                               await storeRoomController.stroreRoomingredientsList(nameOfIngeridiant);
                          //                                                                             },
                          //                                                                             child: Padding(
                          //                                                                               padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                          //                                                                               child: Container(
                          //                                                                                 height: height * 0.04,
                          //                                                                                 width: width,
                          //                                                                                 decoration: BoxDecoration(
                          //                                                                                   color: buttonColor.withOpacity(1.0),
                          //                                                                                   borderRadius: BorderRadius.circular(15.0),
                          //                                                                                 ),
                          //                                                                                 child: Padding(
                          //                                                                                   padding: const EdgeInsets.all(8.0),
                          //                                                                                   child: Center(
                          //                                                                                     child: Text(
                          //                                                                                       "Save",
                          //                                                                                       style: TextStyle(color: Colors.white, fontFamily: "Lexand", fontSize: height * 0.011, fontWeight: FontWeight.w700),
                          //                                                                                     ),
                          //                                                                                   ),
                          //                                                                                 ),
                          //                                                                               ),
                          //                                                                             ),
                          //                                                                           ),
                          //                                                                         )
                          //                                                                       ],
                          //                                                                     )
                          //                                                                   ],
                          //                                                                 ),
                          //                                                               ),
                          //                                                             );
                          //                                                           },
                          //                                                         );
                          //                                                       },
                          //                                                       child: const Icon(
                          //                                                         Icons.edit,
                          //                                                         size: 20,
                          //                                                         color: Colors.black,
                          //                                                       ),
                          //                                                     )
                          //                                                   ],
                          //                                                 ),
                          //                                               ),
                          //                                             ),
                          //                                           ),
                          //                                           SizedBox(
                          //                                               height: height *
                          //                                                   0.01),
                          //                                         ],
                          //                                       ),
                          //                                     );
                          //                                   },
                          //                                 ),
                          //                               ),
                          //                             ),
                          //                           )
                          //                         : isOils
                          //                             ? Expanded(
                          //                                 flex: 3,
                          //                                 child:
                          //                                     SingleChildScrollView(
                          //                                   child: SizedBox(
                          //                                     height:
                          //                                         height * 0.7,
                          //                                     child: ListView
                          //                                         .builder(
                          //                                       // shrinkWrap: true,
                          //                                       itemCount:
                          //                                           storeRoomController
                          //                                               .ingredientsOilsList
                          //                                               .length,
                          //                                       itemBuilder: (
                          //                                         context,
                          //                                         i,
                          //                                       ) {
                          //                                         return Padding(
                          //                                           padding:
                          //                                               const EdgeInsets
                          //                                                   .all(
                          //                                                   8.0),
                          //                                           child:
                          //                                               Column(
                          //                                             crossAxisAlignment:
                          //                                                 CrossAxisAlignment
                          //                                                     .start,
                          //                                             children: [
                          //                                               InkWell(
                          //                                                 onTap:
                          //                                                     () {
                          //                                                   setState(() {});
                          //                                                 },
                          //                                                 child:
                          //                                                     Container(
                          //                                                   width:
                          //                                                       width,
                          //                                                   // height: height*0.05,
                          //                                                   decoration:
                          //                                                       BoxDecoration(
                          //                                                     color: primaryColor.withOpacity(1.0),
                          //                                                     borderRadius: BorderRadius.circular(10.0),
                          //                                                   ),
                          //                                                   child:
                          //                                                       Padding(
                          //                                                     padding: const EdgeInsets.all(8.0),
                          //                                                     child: Row(
                          //                                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //                                                       children: [
                          //                                                         Text(
                          //                                                           storeRoomController.ingredientsOilsList[i]["ingredient"],
                          //                                                           style: TextStyle(
                          //                                                             fontFamily: "Lexand",
                          //                                                             fontSize: height * 0.013,
                          //                                                             fontWeight: FontWeight.w700,
                          //                                                           ),
                          //                                                         ),
                          //                                                         InkWell(
                          //                                                           onTap: () {
                          //                                                             showDialog(
                          //                                                               context: context,
                          //                                                               builder: (context) {
                          //                                                                 return AlertDialog(
                          //                                                                   // insetPadding: EdgeInsets.all(0.0),
                          //                                                                   content: SizedBox(
                          //                                                                     // width: double.maxFinite,
                          //                                                                     height: height * 0.3, // Ensure the AlertDialog content has a fixed width
                          //                                                                     child: Column(
                          //                                                                       children: [
                          //                                                                         Row(
                          //                                                                           children: [
                          //                                                                             InkWell(
                          //                                                                               onTap: () {
                          //                                                                                 Navigator.pop(context);
                          //                                                                                 // scaffoldkey.currentState!.openDrawer();
                          //                                                                               },
                          //                                                                               child: Icon(
                          //                                                                                 Icons.arrow_back_ios_rounded,
                          //                                                                                 size: height * 0.039,
                          //                                                                               ),
                          //                                                                             ),
                          //                                                                             Expanded(
                          //                                                                               child: Text(
                          //                                                                                 "Pick your ingredients from the table.",
                          //                                                                                 style: TextStyle(fontFamily: "Lexand", fontSize: height * 0.018, fontWeight: FontWeight.w500),
                          //                                                                               ),
                          //                                                                             ),
                          //                                                                           ],
                          //                                                                         ),
                          //                                                                         SizedBox(height: height * 0.02),
                          //                                                                         SizedBox(
                          //                                                                           height: height * 0.05,
                          //                                                                           child: TextFormField(
                          //                                                                             style: TextStyle(
                          //                                                                               fontFamily: "Lexand",
                          //                                                                               fontSize: height * 0.018,
                          //                                                                               fontWeight: FontWeight.w500,
                          //                                                                             ),
                          //                                                                             controller: ingredientsEditController = TextEditingController(text: storeRoomController.ingredientsOilsList[i]["ingredient"]),
                          //                                                                             decoration: InputDecoration(
                          //                                                                               // suffixIcon: Padding(
                          //                                                                               //   padding: const EdgeInsets.all(8.0),
                          //                                                                               //   child: Image.asset(
                          //                                                                               //     "assets/user_icon.png",
                          //                                                                               //     height: height * 0.02,
                          //                                                                               //   ),
                          //                                                                               // ),
                          //                                                                               contentPadding: const EdgeInsets.only(left: 16.0),
                          //                                                                               label: Text(
                          //                                                                                 "Ingredients",
                          //                                                                                 style: TextStyle(
                          //                                                                                   fontFamily: "Lexand",
                          //                                                                                   fontSize: height * 0.018,
                          //                                                                                   fontWeight: FontWeight.w300,
                          //                                                                                 ),
                          //                                                                               ),
                          //                                                                               floatingLabelStyle: const TextStyle(
                          //                                                                                 fontFamily: "Lexand",
                          //                                                                                 fontWeight: FontWeight.w300,
                          //                                                                               ),
                          //                                                                               border: OutlineInputBorder(
                          //                                                                                 borderRadius: BorderRadius.circular(15.0),
                          //                                                                                 borderSide: const BorderSide(width: 1.5),
                          //                                                                               ),
                          //                                                                               disabledBorder: OutlineInputBorder(
                          //                                                                                 borderRadius: BorderRadius.circular(30.0),
                          //                                                                                 borderSide: const BorderSide(width: 1.5),
                          //                                                                               ),
                          //                                                                               enabledBorder: OutlineInputBorder(
                          //                                                                                 borderRadius: BorderRadius.circular(30.0),
                          //                                                                                 borderSide: BorderSide(
                          //                                                                                   color: borderColor.withOpacity(1.0),
                          //                                                                                   width: 1.5,
                          //                                                                                 ),
                          //                                                                               ),
                          //                                                                               focusedBorder: OutlineInputBorder(
                          //                                                                                 borderRadius: BorderRadius.circular(30.0),
                          //                                                                                 borderSide: const BorderSide(width: 1.5),
                          //                                                                               ),
                          //                                                                             ),
                          //                                                                             onChanged: (value) {
                          //                                                                               setState(() {});
                          //                                                                             },
                          //                                                                           ),
                          //                                                                         ),
                          //                                                                         SizedBox(height: height * 0.02),
                          //                                                                         Container(
                          //                                                                           height: height * 0.05,
                          //                                                                           decoration: BoxDecoration(
                          //                                                                             borderRadius: BorderRadius.circular(30.0),
                          //                                                                             border: Border.all(
                          //                                                                               color: borderColor.withOpacity(1.0),
                          //                                                                               width: 1.5,
                          //                                                                             ),
                          //                                                                           ),
                          //                                                                           child: DropdownButtonFormField<String>(
                          //                                                                             hint: Text(
                          //                                                                               "Select measurement",
                          //                                                                               style: TextStyle(
                          //                                                                                 fontFamily: "Lexand",
                          //                                                                                 fontSize: height * 0.018,
                          //                                                                                 fontWeight: FontWeight.w300,
                          //                                                                               ),
                          //                                                                             ),
                          //                                                                             padding: const EdgeInsets.only(left: 10, bottom: 5),
                          //                                                                             value: selectedUnit,
                          //                                                                             borderRadius: BorderRadius.circular(30.0),
                          //                                                                             onChanged: (String? newValue) {
                          //                                                                               setState(() {
                          //                                                                                 selectedUnit = newValue!;
                          //                                                                               });
                          //                                                                             },
                          //                                                                             items: <String>['kg', 'litre', 'unit'].map<DropdownMenuItem<String>>(
                          //                                                                               (String value) {
                          //                                                                                 return DropdownMenuItem<String>(
                          //                                                                                   value: value,
                          //                                                                                   child: Padding(
                          //                                                                                     padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                          //                                                                                     child: Text(
                          //                                                                                       value,
                          //                                                                                       style: TextStyle(
                          //                                                                                         fontFamily: "Lexand",
                          //                                                                                         fontSize: height * 0.018,
                          //                                                                                         fontWeight: FontWeight.w300,
                          //                                                                                       ),
                          //                                                                                     ),
                          //                                                                                   ),
                          //                                                                                 );
                          //                                                                               },
                          //                                                                             ).toList(),
                          //                                                                             decoration: InputDecoration(
                          //                                                                               border: InputBorder.none,
                          //                                                                               contentPadding: EdgeInsets.zero,
                          //                                                                               floatingLabelStyle: TextStyle(
                          //                                                                                 fontFamily: "Lexand",
                          //                                                                                 fontSize: height * 0.013,
                          //                                                                                 fontWeight: FontWeight.w300,
                          //                                                                               ),
                          //                                                                             ),
                          //                                                                             // Aligns the dropdown value vertically centered within the container
                          //                                                                             alignment: Alignment.topCenter,
                          //                                                                           ),
                          //                                                                         ),
                          //                                                                         SizedBox(
                          //                                                                           height: height * 0.02,
                          //                                                                         ),
                          //                                                                         Row(
                          //                                                                           children: [
                          //                                                                             Expanded(
                          //                                                                               child: InkWell(
                          //                                                                                 onTap: () {
                          //                                                                                   Navigator.pop(context);
                          //                                                                                 },
                          //                                                                                 child: Padding(
                          //                                                                                   padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                          //                                                                                   child: Container(
                          //                                                                                     height: height * 0.04,
                          //                                                                                     width: width,
                          //                                                                                     decoration: BoxDecoration(
                          //                                                                                       color: buttonColor.withOpacity(1.0),
                          //                                                                                       borderRadius: BorderRadius.circular(15.0),
                          //                                                                                     ),
                          //                                                                                     child: Padding(
                          //                                                                                       padding: const EdgeInsets.all(8.0),
                          //                                                                                       child: Center(
                          //                                                                                         child: Text(
                          //                                                                                           "Cancel",
                          //                                                                                           style: TextStyle(color: Colors.white, fontFamily: "Lexand", fontSize: height * 0.011, fontWeight: FontWeight.w700),
                          //                                                                                         ),
                          //                                                                                       ),
                          //                                                                                     ),
                          //                                                                                   ),
                          //                                                                                 ),
                          //                                                                               ),
                          //                                                                             ),
                          //                                                                             Expanded(
                          //                                                                               child: InkWell(
                          //                                                                                 onTap: () async {
                          //                                                                                   await storeRoomController.storRoomingrediantEdit(
                          //                                                                                     ingredientsEditController.text,
                          //                                                                                     storeRoomController.ingredientsOilsList[i]["ingredientId"],
                          //                                                                                     storeRoomController.ingredientsOilsList[i]["isChecked"],
                          //                                                                                     selectedUnit,
                          //                                                                                   );
                          //                                                                                   setState(() {});
                          //                                                                                   Navigator.pop(context);
                          //                                                                                   await storeRoomController.stroreRoomingredientsList(nameOfIngeridiant);
                          //                                                                                 },
                          //                                                                                 child: Padding(
                          //                                                                                   padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                          //                                                                                   child: Container(
                          //                                                                                     height: height * 0.04,
                          //                                                                                     width: width,
                          //                                                                                     decoration: BoxDecoration(
                          //                                                                                       color: buttonColor.withOpacity(1.0),
                          //                                                                                       borderRadius: BorderRadius.circular(15.0),
                          //                                                                                     ),
                          //                                                                                     child: Padding(
                          //                                                                                       padding: const EdgeInsets.all(8.0),
                          //                                                                                       child: Center(
                          //                                                                                         child: Text(
                          //                                                                                           "Save",
                          //                                                                                           style: TextStyle(color: Colors.white, fontFamily: "Lexand", fontSize: height * 0.011, fontWeight: FontWeight.w700),
                          //                                                                                         ),
                          //                                                                                       ),
                          //                                                                                     ),
                          //                                                                                   ),
                          //                                                                                 ),
                          //                                                                               ),
                          //                                                                             )
                          //                                                                           ],
                          //                                                                         )
                          //                                                                       ],
                          //                                                                     ),
                          //                                                                   ),
                          //                                                                 );
                          //                                                               },
                          //                                                             );
                          //                                                           },
                          //                                                           child: const Icon(
                          //                                                             Icons.edit,
                          //                                                             size: 20,
                          //                                                             color: Colors.black,
                          //                                                           ),
                          //                                                         )
                          //                                                       ],
                          //                                                     ),
                          //                                                   ),
                          //                                                 ),
                          //                                               ),
                          //                                               SizedBox(
                          //                                                   height:
                          //                                                       height * 0.01),
                          //                                             ],
                          //                                           ),
                          //                                         );
                          //                                       },
                          //                                     ),
                          //                                   ),
                          //                                 ),
                          //                               )
                          //                             : isFruits
                          //                                 ? Expanded(
                          //                                     flex: 3,
                          //                                     child: SizedBox(
                          //                                       height: height *
                          //                                           0.7,
                          //                                       child: ListView
                          //                                           .builder(
                          //                                         // shrinkWrap: true,
                          //                                         itemCount:
                          //                                             storeRoomController
                          //                                                 .ingredientsFruitesList
                          //                                                 .length,
                          //                                         itemBuilder: (
                          //                                           context,
                          //                                           i,
                          //                                         ) {
                          //                                           return Padding(
                          //                                             padding: const EdgeInsets
                          //                                                 .all(
                          //                                                 8.0),
                          //                                             child:
                          //                                                 Column(
                          //                                               crossAxisAlignment:
                          //                                                   CrossAxisAlignment.start,
                          //                                               children: [
                          //                                                 InkWell(
                          //                                                   onTap:
                          //                                                       () {
                          //                                                     setState(() {});
                          //                                                   },
                          //                                                   child:
                          //                                                       Container(
                          //                                                     width: width,
                          //                                                     // height: height*0.05,
                          //                                                     decoration: BoxDecoration(
                          //                                                       color: primaryColor.withOpacity(1.0),
                          //                                                       borderRadius: BorderRadius.circular(10.0),
                          //                                                     ),
                          //                                                     child: Padding(
                          //                                                       padding: const EdgeInsets.all(8.0),
                          //                                                       child: Row(
                          //                                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //                                                         children: [
                          //                                                           Text(
                          //                                                             storeRoomController.ingredientsFruitesList[i]["ingredient"],
                          //                                                             style: TextStyle(
                          //                                                               fontFamily: "Lexand",
                          //                                                               fontSize: height * 0.013,
                          //                                                               fontWeight: FontWeight.w700,
                          //                                                             ),
                          //                                                           ),
                          //                                                           InkWell(
                          //                                                             onTap: () {
                          //                                                               showDialog(
                          //                                                                 context: context,
                          //                                                                 builder: (context) {
                          //                                                                   return AlertDialog(
                          //                                                                     // insetPadding: EdgeInsets.all(0.0),
                          //                                                                     content: SizedBox(
                          //                                                                       // width: double.maxFinite,
                          //                                                                       height: height * 0.3, // Ensure the AlertDialog content has a fixed width
                          //                                                                       child: Column(
                          //                                                                         children: [
                          //                                                                           Row(
                          //                                                                             children: [
                          //                                                                               InkWell(
                          //                                                                                 onTap: () {
                          //                                                                                   Navigator.pop(context);
                          //                                                                                   // scaffoldkey.currentState!.openDrawer();
                          //                                                                                 },
                          //                                                                                 child: Icon(
                          //                                                                                   Icons.arrow_back_ios_rounded,
                          //                                                                                   size: height * 0.039,
                          //                                                                                 ),
                          //                                                                               ),
                          //                                                                               Expanded(
                          //                                                                                 child: Text(
                          //                                                                                   "Pick your ingredients from the table.",
                          //                                                                                   style: TextStyle(fontFamily: "Lexand", fontSize: height * 0.018, fontWeight: FontWeight.w500),
                          //                                                                                 ),
                          //                                                                               ),
                          //                                                                             ],
                          //                                                                           ),
                          //                                                                           SizedBox(height: height * 0.02),
                          //                                                                           SizedBox(
                          //                                                                             height: height * 0.05,
                          //                                                                             child: TextFormField(
                          //                                                                               style: TextStyle(
                          //                                                                                 fontFamily: "Lexand",
                          //                                                                                 fontSize: height * 0.018,
                          //                                                                                 fontWeight: FontWeight.w500,
                          //                                                                               ),
                          //                                                                               controller: ingredientsEditController = TextEditingController(text: storeRoomController.ingredientsFruitesList[i]["ingredient"]),
                          //                                                                               decoration: InputDecoration(
                          //                                                                                 // suffixIcon: Padding(
                          //                                                                                 //   padding: const EdgeInsets.all(8.0),
                          //                                                                                 //   child: Image.asset(
                          //                                                                                 //     "assets/user_icon.png",
                          //                                                                                 //     height: height * 0.02,
                          //                                                                                 //   ),
                          //                                                                                 // ),
                          //                                                                                 contentPadding: const EdgeInsets.only(left: 16.0),
                          //                                                                                 label: Text(
                          //                                                                                   "Ingredients",
                          //                                                                                   style: TextStyle(
                          //                                                                                     fontFamily: "Lexand",
                          //                                                                                     fontSize: height * 0.018,
                          //                                                                                     fontWeight: FontWeight.w300,
                          //                                                                                   ),
                          //                                                                                 ),
                          //                                                                                 floatingLabelStyle: const TextStyle(
                          //                                                                                   fontFamily: "Lexand",
                          //                                                                                   fontWeight: FontWeight.w300,
                          //                                                                                 ),
                          //                                                                                 border: OutlineInputBorder(
                          //                                                                                   borderRadius: BorderRadius.circular(15.0),
                          //                                                                                   borderSide: const BorderSide(width: 1.5),
                          //                                                                                 ),
                          //                                                                                 disabledBorder: OutlineInputBorder(
                          //                                                                                   borderRadius: BorderRadius.circular(30.0),
                          //                                                                                   borderSide: const BorderSide(width: 1.5),
                          //                                                                                 ),
                          //                                                                                 enabledBorder: OutlineInputBorder(
                          //                                                                                   borderRadius: BorderRadius.circular(30.0),
                          //                                                                                   borderSide: BorderSide(
                          //                                                                                     color: borderColor.withOpacity(1.0),
                          //                                                                                     width: 1.5,
                          //                                                                                   ),
                          //                                                                                 ),
                          //                                                                                 focusedBorder: OutlineInputBorder(
                          //                                                                                   borderRadius: BorderRadius.circular(30.0),
                          //                                                                                   borderSide: const BorderSide(width: 1.5),
                          //                                                                                 ),
                          //                                                                               ),
                          //                                                                               onChanged: (value) {
                          //                                                                                 setState(() {});
                          //                                                                               },
                          //                                                                             ),
                          //                                                                           ),
                          //                                                                           SizedBox(height: height * 0.02),
                          //                                                                           Container(
                          //                                                                             height: height * 0.05,
                          //                                                                             decoration: BoxDecoration(
                          //                                                                               borderRadius: BorderRadius.circular(30.0),
                          //                                                                               border: Border.all(
                          //                                                                                 color: borderColor.withOpacity(1.0),
                          //                                                                                 width: 1.5,
                          //                                                                               ),
                          //                                                                             ),
                          //                                                                             child: DropdownButtonFormField<String>(
                          //                                                                               hint: Text(
                          //                                                                                 "Select measurement",
                          //                                                                                 style: TextStyle(
                          //                                                                                   fontFamily: "Lexand",
                          //                                                                                   fontSize: height * 0.018,
                          //                                                                                   fontWeight: FontWeight.w300,
                          //                                                                                 ),
                          //                                                                               ),
                          //                                                                               padding: const EdgeInsets.only(left: 10, bottom: 5),
                          //                                                                               value: selectedUnit,
                          //                                                                               borderRadius: BorderRadius.circular(30.0),
                          //                                                                               onChanged: (String? newValue) {
                          //                                                                                 setState(() {
                          //                                                                                   selectedUnit = newValue!;
                          //                                                                                 });
                          //                                                                               },
                          //                                                                               items: <String>['kg', 'litre', 'unit'].map<DropdownMenuItem<String>>(
                          //                                                                                 (String value) {
                          //                                                                                   return DropdownMenuItem<String>(
                          //                                                                                     value: value,
                          //                                                                                     child: Padding(
                          //                                                                                       padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                          //                                                                                       child: Text(
                          //                                                                                         value,
                          //                                                                                         style: TextStyle(
                          //                                                                                           fontFamily: "Lexand",
                          //                                                                                           fontSize: height * 0.018,
                          //                                                                                           fontWeight: FontWeight.w300,
                          //                                                                                         ),
                          //                                                                                       ),
                          //                                                                                     ),
                          //                                                                                   );
                          //                                                                                 },
                          //                                                                               ).toList(),
                          //                                                                               decoration: InputDecoration(
                          //                                                                                 border: InputBorder.none,
                          //                                                                                 contentPadding: EdgeInsets.zero,
                          //                                                                                 floatingLabelStyle: TextStyle(
                          //                                                                                   fontFamily: "Lexand",
                          //                                                                                   fontSize: height * 0.013,
                          //                                                                                   fontWeight: FontWeight.w300,
                          //                                                                                 ),
                          //                                                                               ),
                          //                                                                               // Aligns the dropdown value vertically centered within the container
                          //                                                                               alignment: Alignment.topCenter,
                          //                                                                             ),
                          //                                                                           ),
                          //                                                                           SizedBox(
                          //                                                                             height: height * 0.02,
                          //                                                                           ),
                          //                                                                           Row(
                          //                                                                             children: [
                          //                                                                               Expanded(
                          //                                                                                 child: InkWell(
                          //                                                                                   onTap: () {
                          //                                                                                     Navigator.pop(context);
                          //                                                                                   },
                          //                                                                                   child: Padding(
                          //                                                                                     padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                          //                                                                                     child: Container(
                          //                                                                                       height: height * 0.04,
                          //                                                                                       width: width,
                          //                                                                                       decoration: BoxDecoration(
                          //                                                                                         color: buttonColor.withOpacity(1.0),
                          //                                                                                         borderRadius: BorderRadius.circular(15.0),
                          //                                                                                       ),
                          //                                                                                       child: Padding(
                          //                                                                                         padding: const EdgeInsets.all(8.0),
                          //                                                                                         child: Center(
                          //                                                                                           child: Text(
                          //                                                                                             "Cancel",
                          //                                                                                             style: TextStyle(color: Colors.white, fontFamily: "Lexand", fontSize: height * 0.011, fontWeight: FontWeight.w700),
                          //                                                                                           ),
                          //                                                                                         ),
                          //                                                                                       ),
                          //                                                                                     ),
                          //                                                                                   ),
                          //                                                                                 ),
                          //                                                                               ),
                          //                                                                               Expanded(
                          //                                                                                 child: InkWell(
                          //                                                                                   onTap: () async {
                          //                                                                                     await storeRoomController.storRoomingrediantEdit(
                          //                                                                                       ingredientsEditController.text,
                          //                                                                                       storeRoomController.ingredientsFruitesList[i]["ingredientId"],
                          //                                                                                       storeRoomController.ingredientsFruitesList[i]["isChecked"],
                          //                                                                                       selectedUnit,
                          //                                                                                     );
                          //                                                                                     setState(() {});
                          //                                                                                     Navigator.pop(context);
                          //                                                                                     await storeRoomController.stroreRoomingredientsList(nameOfIngeridiant);
                          //                                                                                   },
                          //                                                                                   child: Padding(
                          //                                                                                     padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                          //                                                                                     child: Container(
                          //                                                                                       height: height * 0.04,
                          //                                                                                       width: width,
                          //                                                                                       decoration: BoxDecoration(
                          //                                                                                         color: buttonColor.withOpacity(1.0),
                          //                                                                                         borderRadius: BorderRadius.circular(15.0),
                          //                                                                                       ),
                          //                                                                                       child: Padding(
                          //                                                                                         padding: const EdgeInsets.all(8.0),
                          //                                                                                         child: Center(
                          //                                                                                           child: Text(
                          //                                                                                             "Save",
                          //                                                                                             style: TextStyle(color: Colors.white, fontFamily: "Lexand", fontSize: height * 0.011, fontWeight: FontWeight.w700),
                          //                                                                                           ),
                          //                                                                                         ),
                          //                                                                                       ),
                          //                                                                                     ),
                          //                                                                                   ),
                          //                                                                                 ),
                          //                                                                               )
                          //                                                                             ],
                          //                                                                           )
                          //                                                                         ],
                          //                                                                       ),
                          //                                                                     ),
                          //                                                                   );
                          //                                                                 },
                          //                                                               );
                          //                                                             },
                          //                                                             child: const Icon(
                          //                                                               Icons.edit,
                          //                                                               size: 20,
                          //                                                               color: Colors.black,
                          //                                                             ),
                          //                                                           )
                          //                                                         ],
                          //                                                       ),
                          //                                                     ),
                          //                                                   ),
                          //                                                 ),
                          //                                                 SizedBox(
                          //                                                     height: height * 0.01),
                          //                                               ],
                          //                                             ),
                          //                                           );
                          //                                         },
                          //                                       ),
                          //                                     ),
                          //                                   )
                          //                                 : isMeats
                          //                                     ? Expanded(
                          //                                         flex: 3,
                          //                                         child:
                          //                                             SingleChildScrollView(
                          //                                           child:
                          //                                               SizedBox(
                          //                                             height:
                          //                                                 height *
                          //                                                     0.7,
                          //                                             child: ListView
                          //                                                 .builder(
                          //                                               // shrinkWrap: true,
                          //                                               itemCount: storeRoomController
                          //                                                   .ingredientsMeatsList
                          //                                                   .length,
                          //                                               itemBuilder:
                          //                                                   (
                          //                                                 context,
                          //                                                 i,
                          //                                               ) {
                          //                                                 return Padding(
                          //                                                   padding:
                          //                                                       const EdgeInsets.all(8.0),
                          //                                                   child:
                          //                                                       Column(
                          //                                                     crossAxisAlignment: CrossAxisAlignment.start,
                          //                                                     children: [
                          //                                                       InkWell(
                          //                                                         onTap: () {
                          //                                                           setState(() {});
                          //                                                         },
                          //                                                         child: Container(
                          //                                                           width: width,
                          //                                                           // height: height*0.05,
                          //                                                           decoration: BoxDecoration(
                          //                                                             color: primaryColor.withOpacity(1.0),
                          //                                                             borderRadius: BorderRadius.circular(10.0),
                          //                                                           ),
                          //                                                           child: Padding(
                          //                                                             padding: const EdgeInsets.all(8.0),
                          //                                                             child: Row(
                          //                                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //                                                               children: [
                          //                                                                 Text(
                          //                                                                   storeRoomController.ingredientsMeatsList[i]["ingredient"],
                          //                                                                   style: TextStyle(
                          //                                                                     fontFamily: "Lexand",
                          //                                                                     fontSize: height * 0.013,
                          //                                                                     fontWeight: FontWeight.w700,
                          //                                                                   ),
                          //                                                                 ),
                          //                                                                 InkWell(
                          //                                                                   onTap: () {
                          //                                                                     showDialog(
                          //                                                                       context: context,
                          //                                                                       builder: (context) {
                          //                                                                         return AlertDialog(
                          //                                                                           // insetPadding: EdgeInsets.all(0.0),
                          //                                                                           content: SizedBox(
                          //                                                                             // width: double.maxFinite,
                          //                                                                             height: height * 0.3, // Ensure the AlertDialog content has a fixed width
                          //                                                                             child: Column(
                          //                                                                               children: [
                          //                                                                                 Row(
                          //                                                                                   children: [
                          //                                                                                     InkWell(
                          //                                                                                       onTap: () {
                          //                                                                                         Navigator.pop(context);
                          //                                                                                         // scaffoldkey.currentState!.openDrawer();
                          //                                                                                       },
                          //                                                                                       child: Icon(
                          //                                                                                         Icons.arrow_back_ios_rounded,
                          //                                                                                         size: height * 0.039,
                          //                                                                                       ),
                          //                                                                                     ),
                          //                                                                                     Expanded(
                          //                                                                                       child: Text(
                          //                                                                                         "Pick your ingredients from the table.",
                          //                                                                                         style: TextStyle(fontFamily: "Lexand", fontSize: height * 0.018, fontWeight: FontWeight.w500),
                          //                                                                                       ),
                          //                                                                                     ),
                          //                                                                                   ],
                          //                                                                                 ),
                          //                                                                                 SizedBox(height: height * 0.02),
                          //                                                                                 SizedBox(
                          //                                                                                   height: height * 0.05,
                          //                                                                                   child: TextFormField(
                          //                                                                                     style: TextStyle(
                          //                                                                                       fontFamily: "Lexand",
                          //                                                                                       fontSize: height * 0.018,
                          //                                                                                       fontWeight: FontWeight.w500,
                          //                                                                                     ),
                          //                                                                                     controller: ingredientsEditController = TextEditingController(text: storeRoomController.ingredientsMeatsList[i]["ingredient"]),
                          //                                                                                     decoration: InputDecoration(
                          //                                                                                       // suffixIcon: Padding(
                          //                                                                                       //   padding: const EdgeInsets.all(8.0),
                          //                                                                                       //   child: Image.asset(
                          //                                                                                       //     "assets/user_icon.png",
                          //                                                                                       //     height: height * 0.02,
                          //                                                                                       //   ),
                          //                                                                                       // ),

                          //                                                                                       contentPadding: const EdgeInsets.only(left: 16.0),
                          //                                                                                       label: Text(
                          //                                                                                         "Ingredients",
                          //                                                                                         style: TextStyle(
                          //                                                                                           fontFamily: "Lexand",
                          //                                                                                           fontSize: height * 0.018,
                          //                                                                                           fontWeight: FontWeight.w300,
                          //                                                                                         ),
                          //                                                                                       ),
                          //                                                                                       floatingLabelStyle: const TextStyle(
                          //                                                                                         fontFamily: "Lexand",
                          //                                                                                         fontWeight: FontWeight.w300,
                          //                                                                                       ),
                          //                                                                                       border: OutlineInputBorder(
                          //                                                                                         borderRadius: BorderRadius.circular(15.0),
                          //                                                                                         borderSide: const BorderSide(width: 1.5),
                          //                                                                                       ),
                          //                                                                                       disabledBorder: OutlineInputBorder(
                          //                                                                                         borderRadius: BorderRadius.circular(30.0),
                          //                                                                                         borderSide: const BorderSide(width: 1.5),
                          //                                                                                       ),
                          //                                                                                       enabledBorder: OutlineInputBorder(
                          //                                                                                         borderRadius: BorderRadius.circular(30.0),
                          //                                                                                         borderSide: BorderSide(
                          //                                                                                           color: borderColor.withOpacity(1.0),
                          //                                                                                           width: 1.5,
                          //                                                                                         ),
                          //                                                                                       ),
                          //                                                                                       focusedBorder: OutlineInputBorder(
                          //                                                                                         borderRadius: BorderRadius.circular(30.0),
                          //                                                                                         borderSide: const BorderSide(width: 1.5),
                          //                                                                                       ),
                          //                                                                                     ),
                          //                                                                                     onChanged: (value) {
                          //                                                                                       setState(() {});
                          //                                                                                     },
                          //                                                                                   ),
                          //                                                                                 ),
                          //                                                                                 SizedBox(height: height * 0.02),
                          //                                                                                 Container(
                          //                                                                                   height: height * 0.05,
                          //                                                                                   decoration: BoxDecoration(
                          //                                                                                     borderRadius: BorderRadius.circular(30.0),
                          //                                                                                     border: Border.all(
                          //                                                                                       color: borderColor.withOpacity(1.0),
                          //                                                                                       width: 1.5,
                          //                                                                                     ),
                          //                                                                                   ),
                          //                                                                                   child: DropdownButtonFormField<String>(
                          //                                                                                     hint: Text(
                          //                                                                                       "Select measurement",
                          //                                                                                       style: TextStyle(
                          //                                                                                         fontFamily: "Lexand",
                          //                                                                                         fontSize: height * 0.018,
                          //                                                                                         fontWeight: FontWeight.w300,
                          //                                                                                       ),
                          //                                                                                     ),
                          //                                                                                     padding: const EdgeInsets.only(left: 10, bottom: 5),
                          //                                                                                     value: selectedUnit,
                          //                                                                                     borderRadius: BorderRadius.circular(30.0),
                          //                                                                                     onChanged: (String? newValue) {
                          //                                                                                       setState(() {
                          //                                                                                         selectedUnit = newValue!;
                          //                                                                                       });
                          //                                                                                     },
                          //                                                                                     items: <String>['kg', 'litre', 'unit'].map<DropdownMenuItem<String>>(
                          //                                                                                       (String value) {
                          //                                                                                         return DropdownMenuItem<String>(
                          //                                                                                           value: value,
                          //                                                                                           child: Padding(
                          //                                                                                             padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                          //                                                                                             child: Text(
                          //                                                                                               value,
                          //                                                                                               style: TextStyle(
                          //                                                                                                 fontFamily: "Lexand",
                          //                                                                                                 fontSize: height * 0.018,
                          //                                                                                                 fontWeight: FontWeight.w300,
                          //                                                                                               ),
                          //                                                                                             ),
                          //                                                                                           ),
                          //                                                                                         );
                          //                                                                                       },
                          //                                                                                     ).toList(),
                          //                                                                                     decoration: InputDecoration(
                          //                                                                                       border: InputBorder.none,
                          //                                                                                       contentPadding: EdgeInsets.zero,
                          //                                                                                       floatingLabelStyle: TextStyle(
                          //                                                                                         fontFamily: "Lexand",
                          //                                                                                         fontSize: height * 0.013,
                          //                                                                                         fontWeight: FontWeight.w300,
                          //                                                                                       ),
                          //                                                                                     ),
                          //                                                                                     // Aligns the dropdown value vertically centered within the container
                          //                                                                                     alignment: Alignment.topCenter,
                          //                                                                                   ),
                          //                                                                                 ),
                          //                                                                                 SizedBox(
                          //                                                                                   height: height * 0.02,
                          //                                                                                 ),
                          //                                                                                 Row(
                          //                                                                                   children: [
                          //                                                                                     Expanded(
                          //                                                                                       child: InkWell(
                          //                                                                                         onTap: () {
                          //                                                                                           Navigator.pop(context);
                          //                                                                                         },
                          //                                                                                         child: Padding(
                          //                                                                                           padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                          //                                                                                           child: Container(
                          //                                                                                             height: height * 0.04,
                          //                                                                                             width: width,
                          //                                                                                             decoration: BoxDecoration(
                          //                                                                                               color: buttonColor.withOpacity(1.0),
                          //                                                                                               borderRadius: BorderRadius.circular(15.0),
                          //                                                                                             ),
                          //                                                                                             child: Padding(
                          //                                                                                               padding: const EdgeInsets.all(8.0),
                          //                                                                                               child: Center(
                          //                                                                                                 child: Text(
                          //                                                                                                   "Cancel",
                          //                                                                                                   style: TextStyle(color: Colors.white, fontFamily: "Lexand", fontSize: height * 0.011, fontWeight: FontWeight.w700),
                          //                                                                                                 ),
                          //                                                                                               ),
                          //                                                                                             ),
                          //                                                                                           ),
                          //                                                                                         ),
                          //                                                                                       ),
                          //                                                                                     ),
                          //                                                                                     Expanded(
                          //                                                                                       child: InkWell(
                          //                                                                                         onTap: () async {
                          //                                                                                           await storeRoomController.storRoomingrediantEdit(
                          //                                                                                             ingredientsEditController.text,
                          //                                                                                             storeRoomController.ingredientsMeatsList[i]["ingredientId"],
                          //                                                                                             storeRoomController.ingredientsMeatsList[i]["isChecked"],
                          //                                                                                             selectedUnit,
                          //                                                                                           );
                          //                                                                                           setState(() {});
                          //                                                                                           Navigator.pop(context);
                          //                                                                                           await storeRoomController.stroreRoomingredientsList(nameOfIngeridiant);
                          //                                                                                         },
                          //                                                                                         child: Padding(
                          //                                                                                           padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                          //                                                                                           child: Container(
                          //                                                                                             height: height * 0.04,
                          //                                                                                             width: width,
                          //                                                                                             decoration: BoxDecoration(
                          //                                                                                               color: buttonColor.withOpacity(1.0),
                          //                                                                                               borderRadius: BorderRadius.circular(15.0),
                          //                                                                                             ),
                          //                                                                                             child: Padding(
                          //                                                                                               padding: const EdgeInsets.all(8.0),
                          //                                                                                               child: Center(
                          //                                                                                                 child: Text(
                          //                                                                                                   "Save",
                          //                                                                                                   style: TextStyle(color: Colors.white, fontFamily: "Lexand", fontSize: height * 0.011, fontWeight: FontWeight.w700),
                          //                                                                                                 ),
                          //                                                                                               ),
                          //                                                                                             ),
                          //                                                                                           ),
                          //                                                                                         ),
                          //                                                                                       ),
                          //                                                                                     )
                          //                                                                                   ],
                          //                                                                                 )
                          //                                                                               ],
                          //                                                                             ),
                          //                                                                           ),
                          //                                                                         );
                          //                                                                       },
                          //                                                                     );
                          //                                                                   },
                          //                                                                   child: const Icon(
                          //                                                                     Icons.edit,
                          //                                                                     size: 20,
                          //                                                                     color: Colors.black,
                          //                                                                   ),
                          //                                                                 )
                          //                                                               ],
                          //                                                             ),
                          //                                                           ),
                          //                                                         ),
                          //                                                       ),
                          //                                                       SizedBox(height: height * 0.01),
                          //                                                     ],
                          //                                                   ),
                          //                                                 );
                          //                                               },
                          //                                             ),
                          //                                           ),
                          //                                         ),
                          //                                       )
                          //                                     : isFlour
                          //                                         ? Expanded(
                          //                                             flex: 3,
                          //                                             child:
                          //                                                 SingleChildScrollView(
                          //                                               child:
                          //                                                   SizedBox(
                          //                                                 height:
                          //                                                     height * 0.7,
                          //                                                 child:
                          //                                                     ListView.builder(
                          //                                                   // shrinkWrap: true,
                          //                                                   itemCount:
                          //                                                       storeRoomController.ingredientsFloursList.length,
                          //                                                   itemBuilder:
                          //                                                       (
                          //                                                     context,
                          //                                                     i,
                          //                                                   ) {
                          //                                                     return Padding(
                          //                                                       padding: const EdgeInsets.all(8.0),
                          //                                                       child: Column(
                          //                                                         crossAxisAlignment: CrossAxisAlignment.start,
                          //                                                         children: [
                          //                                                           InkWell(
                          //                                                             onTap: () {
                          //                                                               setState(() {});
                          //                                                             },
                          //                                                             child: Container(
                          //                                                               width: width,
                          //                                                               // height: height*0.05,
                          //                                                               decoration: BoxDecoration(
                          //                                                                 color: primaryColor.withOpacity(1.0),
                          //                                                                 borderRadius: BorderRadius.circular(10.0),
                          //                                                               ),
                          //                                                               child: Padding(
                          //                                                                 padding: const EdgeInsets.all(8.0),
                          //                                                                 child: Row(
                          //                                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //                                                                   children: [
                          //                                                                     Text(
                          //                                                                       storeRoomController.ingredientsFloursList[i]["ingredient"],
                          //                                                                       style: TextStyle(
                          //                                                                         fontFamily: "Lexand",
                          //                                                                         fontSize: height * 0.013,
                          //                                                                         fontWeight: FontWeight.w700,
                          //                                                                       ),
                          //                                                                     ),
                          //                                                                     InkWell(
                          //                                                                       onTap: () {
                          //                                                                         showDialog(
                          //                                                                           context: context,
                          //                                                                           builder: (context) {
                          //                                                                             return AlertDialog(
                          //                                                                               // insetPadding: EdgeInsets.all(0.0),
                          //                                                                               content: SizedBox(
                          //                                                                                 // width: double.maxFinite,
                          //                                                                                 height: height * 0.3, // Ensure the AlertDialog content has a fixed width
                          //                                                                                 child: Column(
                          //                                                                                   children: [
                          //                                                                                     Row(
                          //                                                                                       children: [
                          //                                                                                         InkWell(
                          //                                                                                           onTap: () {
                          //                                                                                             Navigator.pop(context);
                          //                                                                                             // scaffoldkey.currentState!.openDrawer();
                          //                                                                                           },
                          //                                                                                           child: Icon(
                          //                                                                                             Icons.arrow_back_ios_rounded,
                          //                                                                                             size: height * 0.039,
                          //                                                                                           ),
                          //                                                                                         ),
                          //                                                                                         Expanded(
                          //                                                                                           child: Text(
                          //                                                                                             "Pick your ingredients from the table.",
                          //                                                                                             style: TextStyle(fontFamily: "Lexand", fontSize: height * 0.018, fontWeight: FontWeight.w500),
                          //                                                                                           ),
                          //                                                                                         ),
                          //                                                                                       ],
                          //                                                                                     ),
                          //                                                                                     SizedBox(height: height * 0.02),
                          //                                                                                     SizedBox(
                          //                                                                                       height: height * 0.05,
                          //                                                                                       child: TextFormField(
                          //                                                                                         style: TextStyle(
                          //                                                                                           fontFamily: "Lexand",
                          //                                                                                           fontSize: height * 0.018,
                          //                                                                                           fontWeight: FontWeight.w500,
                          //                                                                                         ),
                          //                                                                                         controller: ingredientsEditController = TextEditingController(text: storeRoomController.ingredientsFloursList[i]["ingredient"]),
                          //                                                                                         decoration: InputDecoration(
                          //                                                                                           // suffixIcon: Padding(
                          //                                                                                           //   padding: const EdgeInsets.all(8.0),
                          //                                                                                           //   child: Image.asset(
                          //                                                                                           //     "assets/user_icon.png",
                          //                                                                                           //     height: height * 0.02,
                          //                                                                                           //   ),
                          //                                                                                           // ),
                          //                                                                                           contentPadding: const EdgeInsets.only(left: 16.0),
                          //                                                                                           label: Text(
                          //                                                                                             "Ingredients",
                          //                                                                                             style: TextStyle(
                          //                                                                                               fontFamily: "Lexand",
                          //                                                                                               fontSize: height * 0.018,
                          //                                                                                               fontWeight: FontWeight.w300,
                          //                                                                                             ),
                          //                                                                                           ),
                          //                                                                                           floatingLabelStyle: const TextStyle(
                          //                                                                                             fontFamily: "Lexand",
                          //                                                                                             fontWeight: FontWeight.w300,
                          //                                                                                           ),
                          //                                                                                           border: OutlineInputBorder(
                          //                                                                                             borderRadius: BorderRadius.circular(15.0),
                          //                                                                                             borderSide: const BorderSide(width: 1.5),
                          //                                                                                           ),
                          //                                                                                           disabledBorder: OutlineInputBorder(
                          //                                                                                             borderRadius: BorderRadius.circular(30.0),
                          //                                                                                             borderSide: const BorderSide(width: 1.5),
                          //                                                                                           ),
                          //                                                                                           enabledBorder: OutlineInputBorder(
                          //                                                                                             borderRadius: BorderRadius.circular(30.0),
                          //                                                                                             borderSide: BorderSide(
                          //                                                                                               color: borderColor.withOpacity(1.0),
                          //                                                                                               width: 1.5,
                          //                                                                                             ),
                          //                                                                                           ),
                          //                                                                                           focusedBorder: OutlineInputBorder(
                          //                                                                                             borderRadius: BorderRadius.circular(30.0),
                          //                                                                                             borderSide: const BorderSide(width: 1.5),
                          //                                                                                           ),
                          //                                                                                         ),
                          //                                                                                         onChanged: (value) {
                          //                                                                                           setState(() {});
                          //                                                                                         },
                          //                                                                                       ),
                          //                                                                                     ),
                          //                                                                                     SizedBox(height: height * 0.02),
                          //                                                                                     Container(
                          //                                                                                       height: height * 0.05,
                          //                                                                                       decoration: BoxDecoration(
                          //                                                                                         borderRadius: BorderRadius.circular(30.0),
                          //                                                                                         border: Border.all(
                          //                                                                                           color: borderColor.withOpacity(1.0),
                          //                                                                                           width: 1.5,
                          //                                                                                         ),
                          //                                                                                       ),
                          //                                                                                       child: DropdownButtonFormField<String>(
                          //                                                                                         hint: Text(
                          //                                                                                           "Select measurement",
                          //                                                                                           style: TextStyle(
                          //                                                                                             fontFamily: "Lexand",
                          //                                                                                             fontSize: height * 0.018,
                          //                                                                                             fontWeight: FontWeight.w300,
                          //                                                                                           ),
                          //                                                                                         ),
                          //                                                                                         padding: const EdgeInsets.only(left: 10, bottom: 5),
                          //                                                                                         value: selectedUnit,
                          //                                                                                         borderRadius: BorderRadius.circular(30.0),
                          //                                                                                         onChanged: (String? newValue) {
                          //                                                                                           setState(() {
                          //                                                                                             selectedUnit = newValue!;
                          //                                                                                           });
                          //                                                                                         },
                          //                                                                                         items: <String>['kg', 'litre', 'unit'].map<DropdownMenuItem<String>>(
                          //                                                                                           (String value) {
                          //                                                                                             return DropdownMenuItem<String>(
                          //                                                                                               value: value,
                          //                                                                                               child: Padding(
                          //                                                                                                 padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                          //                                                                                                 child: Text(
                          //                                                                                                   value,
                          //                                                                                                   style: TextStyle(
                          //                                                                                                     fontFamily: "Lexand",
                          //                                                                                                     fontSize: height * 0.018,
                          //                                                                                                     fontWeight: FontWeight.w300,
                          //                                                                                                   ),
                          //                                                                                                 ),
                          //                                                                                               ),
                          //                                                                                             );
                          //                                                                                           },
                          //                                                                                         ).toList(),
                          //                                                                                         decoration: InputDecoration(
                          //                                                                                           border: InputBorder.none,
                          //                                                                                           contentPadding: EdgeInsets.zero,
                          //                                                                                           floatingLabelStyle: TextStyle(
                          //                                                                                             fontFamily: "Lexand",
                          //                                                                                             fontSize: height * 0.013,
                          //                                                                                             fontWeight: FontWeight.w300,
                          //                                                                                           ),
                          //                                                                                         ),
                          //                                                                                         // Aligns the dropdown value vertically centered within the container
                          //                                                                                         alignment: Alignment.topCenter,
                          //                                                                                       ),
                          //                                                                                     ),
                          //                                                                                     SizedBox(
                          //                                                                                       height: height * 0.02,
                          //                                                                                     ),
                          //                                                                                     Row(
                          //                                                                                       children: [
                          //                                                                                         Expanded(
                          //                                                                                           child: InkWell(
                          //                                                                                             onTap: () {
                          //                                                                                               Navigator.pop(context);
                          //                                                                                             },
                          //                                                                                             child: Padding(
                          //                                                                                               padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                          //                                                                                               child: Container(
                          //                                                                                                 height: height * 0.04,
                          //                                                                                                 width: width,
                          //                                                                                                 decoration: BoxDecoration(
                          //                                                                                                   color: buttonColor.withOpacity(1.0),
                          //                                                                                                   borderRadius: BorderRadius.circular(15.0),
                          //                                                                                                 ),
                          //                                                                                                 child: Padding(
                          //                                                                                                   padding: const EdgeInsets.all(8.0),
                          //                                                                                                   child: Center(
                          //                                                                                                     child: Text(
                          //                                                                                                       "Cancel",
                          //                                                                                                       style: TextStyle(color: Colors.white, fontFamily: "Lexand", fontSize: height * 0.011, fontWeight: FontWeight.w700),
                          //                                                                                                     ),
                          //                                                                                                   ),
                          //                                                                                                 ),
                          //                                                                                               ),
                          //                                                                                             ),
                          //                                                                                           ),
                          //                                                                                         ),
                          //                                                                                         Expanded(
                          //                                                                                           child: InkWell(
                          //                                                                                             onTap: () async {
                          //                                                                                               await storeRoomController.storRoomingrediantEdit(
                          //                                                                                                 ingredientsEditController.text,
                          //                                                                                                 storeRoomController.ingredientsFloursList[i]["ingredientId"],
                          //                                                                                                 storeRoomController.ingredientsFloursList[i]["isChecked"],
                          //                                                                                                 selectedUnit,
                          //                                                                                               );
                          //                                                                                               setState(() {});
                          //                                                                                               Navigator.pop(context);
                          //                                                                                               await storeRoomController.stroreRoomingredientsList(nameOfIngeridiant);
                          //                                                                                             },
                          //                                                                                             child: Padding(
                          //                                                                                               padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                          //                                                                                               child: Container(
                          //                                                                                                 height: height * 0.04,
                          //                                                                                                 width: width,
                          //                                                                                                 decoration: BoxDecoration(
                          //                                                                                                   color: buttonColor.withOpacity(1.0),
                          //                                                                                                   borderRadius: BorderRadius.circular(15.0),
                          //                                                                                                 ),
                          //                                                                                                 child: Padding(
                          //                                                                                                   padding: const EdgeInsets.all(8.0),
                          //                                                                                                   child: Center(
                          //                                                                                                     child: Text(
                          //                                                                                                       "Save",
                          //                                                                                                       style: TextStyle(color: Colors.white, fontFamily: "Lexand", fontSize: height * 0.011, fontWeight: FontWeight.w700),
                          //                                                                                                     ),
                          //                                                                                                   ),
                          //                                                                                                 ),
                          //                                                                                               ),
                          //                                                                                             ),
                          //                                                                                           ),
                          //                                                                                         )
                          //                                                                                       ],
                          //                                                                                     )
                          //                                                                                   ],
                          //                                                                                 ),
                          //                                                                               ),
                          //                                                                             );
                          //                                                                           },
                          //                                                                         );
                          //                                                                       },
                          //                                                                       child: const Icon(
                          //                                                                         Icons.edit,
                          //                                                                         size: 20,
                          //                                                                         color: Colors.black,
                          //                                                                       ),
                          //                                                                     )
                          //                                                                   ],
                          //                                                                 ),
                          //                                                               ),
                          //                                                             ),
                          //                                                           ),
                          //                                                           SizedBox(height: height * 0.01),
                          //                                                         ],
                          //                                                       ),
                          //                                                     );
                          //                                                   },
                          //                                                 ),
                          //                                               ),
                          //                                             ),
                          //                                           )
                          //                                         : isSauces
                          //                                             ? Expanded(
                          //                                                 flex:
                          //                                                     3,
                          //                                                 child:
                          //                                                     SingleChildScrollView(
                          //                                                   child:
                          //                                                       SizedBox(
                          //                                                     height: height * 0.7,
                          //                                                     child: ListView.builder(
                          //                                                       // shrinkWrap: true,
                          //                                                       itemCount: storeRoomController.ingredientsSaucesList.length,
                          //                                                       itemBuilder: (
                          //                                                         context,
                          //                                                         i,
                          //                                                       ) {
                          //                                                         return Padding(
                          //                                                           padding: const EdgeInsets.all(8.0),
                          //                                                           child: Column(
                          //                                                             crossAxisAlignment: CrossAxisAlignment.start,
                          //                                                             children: [
                          //                                                               InkWell(
                          //                                                                 onTap: () {
                          //                                                                   setState(() {});
                          //                                                                 },
                          //                                                                 child: Container(
                          //                                                                   width: width,
                          //                                                                   // height: height*0.05,
                          //                                                                   decoration: BoxDecoration(
                          //                                                                     color: primaryColor.withOpacity(1.0),
                          //                                                                     borderRadius: BorderRadius.circular(10.0),
                          //                                                                   ),
                          //                                                                   child: Padding(
                          //                                                                     padding: const EdgeInsets.all(8.0),
                          //                                                                     child: Row(
                          //                                                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //                                                                       children: [
                          //                                                                         Text(
                          //                                                                           storeRoomController.ingredientsSaucesList[i]["ingredient"],
                          //                                                                           style: TextStyle(
                          //                                                                             fontFamily: "Lexand",
                          //                                                                             fontSize: height * 0.013,
                          //                                                                             fontWeight: FontWeight.w700,
                          //                                                                           ),
                          //                                                                         ),
                          //                                                                         InkWell(
                          //                                                                           onTap: () {
                          //                                                                             showDialog(
                          //                                                                               context: context,
                          //                                                                               builder: (context) {
                          //                                                                                 return AlertDialog(
                          //                                                                                   // insetPadding: EdgeInsets.all(0.0),
                          //                                                                                   content: SizedBox(
                          //                                                                                     // width: double.maxFinite,
                          //                                                                                     height: height * 0.3, // Ensure the AlertDialog content has a fixed width
                          //                                                                                     child: Column(
                          //                                                                                       children: [
                          //                                                                                         Row(
                          //                                                                                           children: [
                          //                                                                                             InkWell(
                          //                                                                                               onTap: () {
                          //                                                                                                 Navigator.pop(context);
                          //                                                                                                 // scaffoldkey.currentState!.openDrawer();
                          //                                                                                               },
                          //                                                                                               child: Icon(
                          //                                                                                                 Icons.arrow_back_ios_rounded,
                          //                                                                                                 size: height * 0.039,
                          //                                                                                               ),
                          //                                                                                             ),
                          //                                                                                             Expanded(
                          //                                                                                               child: Text(
                          //                                                                                                 "Pick your ingredients from the table.",
                          //                                                                                                 style: TextStyle(fontFamily: "Lexand", fontSize: height * 0.018, fontWeight: FontWeight.w500),
                          //                                                                                               ),
                          //                                                                                             ),
                          //                                                                                           ],
                          //                                                                                         ),
                          //                                                                                         SizedBox(height: height * 0.02),
                          //                                                                                         SizedBox(
                          //                                                                                           height: height * 0.05,
                          //                                                                                           child: TextFormField(
                          //                                                                                             style: TextStyle(
                          //                                                                                               fontFamily: "Lexand",
                          //                                                                                               fontSize: height * 0.018,
                          //                                                                                               fontWeight: FontWeight.w500,
                          //                                                                                             ),
                          //                                                                                             controller: ingredientsEditController = TextEditingController(text: storeRoomController.ingredientsSaucesList[i]["ingredient"]),
                          //                                                                                             decoration: InputDecoration(
                          //                                                                                               // suffixIcon: Padding(
                          //                                                                                               //   padding: const EdgeInsets.all(8.0),
                          //                                                                                               //   child: Image.asset(
                          //                                                                                               //     "assets/user_icon.png",
                          //                                                                                               //     height: height * 0.02,
                          //                                                                                               //   ),
                          //                                                                                               // ),
                          //                                                                                               contentPadding: const EdgeInsets.only(left: 16.0),
                          //                                                                                               label: Text(
                          //                                                                                                 "Ingredients",
                          //                                                                                                 style: TextStyle(
                          //                                                                                                   fontFamily: "Lexand",
                          //                                                                                                   fontSize: height * 0.018,
                          //                                                                                                   fontWeight: FontWeight.w300,
                          //                                                                                                 ),
                          //                                                                                               ),
                          //                                                                                               floatingLabelStyle: const TextStyle(
                          //                                                                                                 fontFamily: "Lexand",
                          //                                                                                                 fontWeight: FontWeight.w300,
                          //                                                                                               ),
                          //                                                                                               border: OutlineInputBorder(
                          //                                                                                                 borderRadius: BorderRadius.circular(15.0),
                          //                                                                                                 borderSide: const BorderSide(width: 1.5),
                          //                                                                                               ),
                          //                                                                                               disabledBorder: OutlineInputBorder(
                          //                                                                                                 borderRadius: BorderRadius.circular(30.0),
                          //                                                                                                 borderSide: const BorderSide(width: 1.5),
                          //                                                                                               ),
                          //                                                                                               enabledBorder: OutlineInputBorder(
                          //                                                                                                 borderRadius: BorderRadius.circular(30.0),
                          //                                                                                                 borderSide: BorderSide(
                          //                                                                                                   color: borderColor.withOpacity(1.0),
                          //                                                                                                   width: 1.5,
                          //                                                                                                 ),
                          //                                                                                               ),
                          //                                                                                               focusedBorder: OutlineInputBorder(
                          //                                                                                                 borderRadius: BorderRadius.circular(30.0),
                          //                                                                                                 borderSide: const BorderSide(width: 1.5),
                          //                                                                                               ),
                          //                                                                                             ),
                          //                                                                                             onChanged: (value) {
                          //                                                                                               setState(() {});
                          //                                                                                             },
                          //                                                                                           ),
                          //                                                                                         ),
                          //                                                                                         SizedBox(height: height * 0.02),
                          //                                                                                         Container(
                          //                                                                                           height: height * 0.05,
                          //                                                                                           decoration: BoxDecoration(
                          //                                                                                             borderRadius: BorderRadius.circular(30.0),
                          //                                                                                             border: Border.all(
                          //                                                                                               color: borderColor.withOpacity(1.0),
                          //                                                                                               width: 1.5,
                          //                                                                                             ),
                          //                                                                                           ),
                          //                                                                                           child: DropdownButtonFormField<String>(
                          //                                                                                             hint: Text(
                          //                                                                                               "Select measurement",
                          //                                                                                               style: TextStyle(
                          //                                                                                                 fontFamily: "Lexand",
                          //                                                                                                 fontSize: height * 0.018,
                          //                                                                                                 fontWeight: FontWeight.w300,
                          //                                                                                               ),
                          //                                                                                             ),
                          //                                                                                             padding: const EdgeInsets.only(left: 10, bottom: 5),
                          //                                                                                             value: selectedUnit,
                          //                                                                                             borderRadius: BorderRadius.circular(30.0),
                          //                                                                                             onChanged: (String? newValue) {
                          //                                                                                               setState(() {
                          //                                                                                                 selectedUnit = newValue!;
                          //                                                                                               });
                          //                                                                                             },
                          //                                                                                             items: <String>['kg', 'litre', 'unit'].map<DropdownMenuItem<String>>(
                          //                                                                                               (String value) {
                          //                                                                                                 return DropdownMenuItem<String>(
                          //                                                                                                   value: value,
                          //                                                                                                   child: Padding(
                          //                                                                                                     padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                          //                                                                                                     child: Text(
                          //                                                                                                       value,
                          //                                                                                                       style: TextStyle(
                          //                                                                                                         fontFamily: "Lexand",
                          //                                                                                                         fontSize: height * 0.018,
                          //                                                                                                         fontWeight: FontWeight.w300,
                          //                                                                                                       ),
                          //                                                                                                     ),
                          //                                                                                                   ),
                          //                                                                                                 );
                          //                                                                                               },
                          //                                                                                             ).toList(),
                          //                                                                                             decoration: InputDecoration(
                          //                                                                                               border: InputBorder.none,
                          //                                                                                               contentPadding: EdgeInsets.zero,
                          //                                                                                               floatingLabelStyle: TextStyle(
                          //                                                                                                 fontFamily: "Lexand",
                          //                                                                                                 fontSize: height * 0.013,
                          //                                                                                                 fontWeight: FontWeight.w300,
                          //                                                                                               ),
                          //                                                                                             ),
                          //                                                                                             // Aligns the dropdown value vertically centered within the container
                          //                                                                                             alignment: Alignment.topCenter,
                          //                                                                                           ),
                          //                                                                                         ),
                          //                                                                                         SizedBox(
                          //                                                                                           height: height * 0.02,
                          //                                                                                         ),
                          //                                                                                         Row(
                          //                                                                                           children: [
                          //                                                                                             Expanded(
                          //                                                                                               child: InkWell(
                          //                                                                                                 onTap: () {
                          //                                                                                                   Navigator.pop(context);
                          //                                                                                                 },
                          //                                                                                                 child: Padding(
                          //                                                                                                   padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                          //                                                                                                   child: Container(
                          //                                                                                                     height: height * 0.04,
                          //                                                                                                     width: width,
                          //                                                                                                     decoration: BoxDecoration(
                          //                                                                                                       color: buttonColor.withOpacity(1.0),
                          //                                                                                                       borderRadius: BorderRadius.circular(15.0),
                          //                                                                                                     ),
                          //                                                                                                     child: Padding(
                          //                                                                                                       padding: const EdgeInsets.all(8.0),
                          //                                                                                                       child: Center(
                          //                                                                                                         child: Text(
                          //                                                                                                           "Cancel",
                          //                                                                                                           style: TextStyle(color: Colors.white, fontFamily: "Lexand", fontSize: height * 0.011, fontWeight: FontWeight.w700),
                          //                                                                                                         ),
                          //                                                                                                       ),
                          //                                                                                                     ),
                          //                                                                                                   ),
                          //                                                                                                 ),
                          //                                                                                               ),
                          //                                                                                             ),
                          //                                                                                             Expanded(
                          //                                                                                               child: InkWell(
                          //                                                                                                 onTap: () async {
                          //                                                                                                   await storeRoomController.storRoomingrediantEdit(
                          //                                                                                                     ingredientsEditController.text,
                          //                                                                                                     storeRoomController.ingredientsSaucesList[i]["ingredientId"],
                          //                                                                                                     storeRoomController.ingredientsSaucesList[i]["isChecked"],
                          //                                                                                                     selectedUnit,
                          //                                                                                                   );
                          //                                                                                                   setState(() {});
                          //                                                                                                   Navigator.pop(context);
                          //                                                                                                   await storeRoomController.stroreRoomingredientsList(nameOfIngeridiant);
                          //                                                                                                 },
                          //                                                                                                 child: Padding(
                          //                                                                                                   padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                          //                                                                                                   child: Container(
                          //                                                                                                     height: height * 0.04,
                          //                                                                                                     width: width,
                          //                                                                                                     decoration: BoxDecoration(
                          //                                                                                                       color: buttonColor.withOpacity(1.0),
                          //                                                                                                       borderRadius: BorderRadius.circular(15.0),
                          //                                                                                                     ),
                          //                                                                                                     child: Padding(
                          //                                                                                                       padding: const EdgeInsets.all(8.0),
                          //                                                                                                       child: Center(
                          //                                                                                                         child: Text(
                          //                                                                                                           "Save",
                          //                                                                                                           style: TextStyle(color: Colors.white, fontFamily: "Lexand", fontSize: height * 0.011, fontWeight: FontWeight.w700),
                          //                                                                                                         ),
                          //                                                                                                       ),
                          //                                                                                                     ),
                          //                                                                                                   ),
                          //                                                                                                 ),
                          //                                                                                               ),
                          //                                                                                             )
                          //                                                                                           ],
                          //                                                                                         )
                          //                                                                                       ],
                          //                                                                                     ),
                          //                                                                                   ),
                          //                                                                                 );
                          //                                                                               },
                          //                                                                             );
                          //                                                                           },
                          //                                                                           child: const Icon(
                          //                                                                             Icons.edit,
                          //                                                                             size: 20,
                          //                                                                             color: Colors.black,
                          //                                                                           ),
                          //                                                                         )
                          //                                                                       ],
                          //                                                                     ),
                          //                                                                   ),
                          //                                                                 ),
                          //                                                               ),
                          //                                                               SizedBox(height: height * 0.01),
                          //                                                             ],
                          //                                                           ),
                          //                                                         );
                          //                                                       },
                          //                                                     ),
                          //                                                   ),
                          //                                                 ),
                          //                                               )
                          //                                             : isBeverages
                          //                                                 ? Expanded(
                          //                                                     flex: 3,
                          //                                                     child: SingleChildScrollView(
                          //                                                       child: SizedBox(
                          //                                                         height: height * 0.7,
                          //                                                         child: ListView.builder(
                          //                                                           // shrinkWrap: true,
                          //                                                           itemCount: storeRoomController.ingredientsBeveragesList.length,
                          //                                                           itemBuilder: (
                          //                                                             context,
                          //                                                             i,
                          //                                                           ) {
                          //                                                             return Padding(
                          //                                                               padding: const EdgeInsets.all(8.0),
                          //                                                               child: Column(
                          //                                                                 crossAxisAlignment: CrossAxisAlignment.start,
                          //                                                                 children: [
                          //                                                                   InkWell(
                          //                                                                     onTap: () {
                          //                                                                       setState(() {});
                          //                                                                     },
                          //                                                                     child: Container(
                          //                                                                       width: width,
                          //                                                                       // height: height*0.05,
                          //                                                                       decoration: BoxDecoration(
                          //                                                                         color: primaryColor.withOpacity(1.0),
                          //                                                                         borderRadius: BorderRadius.circular(10.0),
                          //                                                                       ),
                          //                                                                       child: Padding(
                          //                                                                         padding: const EdgeInsets.all(8.0),
                          //                                                                         child: Row(
                          //                                                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //                                                                           children: [
                          //                                                                             Text(
                          //                                                                               storeRoomController.ingredientsBeveragesList[i]["ingredient"],
                          //                                                                               style: TextStyle(
                          //                                                                                 fontFamily: "Lexand",
                          //                                                                                 fontSize: height * 0.013,
                          //                                                                                 fontWeight: FontWeight.w700,
                          //                                                                               ),
                          //                                                                             ),
                          //                                                                             InkWell(
                          //                                                                               onTap: () {
                          //                                                                                 showDialog(
                          //                                                                                   context: context,
                          //                                                                                   builder: (context) {
                          //                                                                                     return AlertDialog(
                          //                                                                                       // insetPadding: EdgeInsets.all(0.0),
                          //                                                                                       content: SizedBox(
                          //                                                                                         // width: double.maxFinite,
                          //                                                                                         height: height * 0.3, // Ensure the AlertDialog content has a fixed width
                          //                                                                                         child: Column(
                          //                                                                                           children: [
                          //                                                                                             Row(
                          //                                                                                               children: [
                          //                                                                                                 InkWell(
                          //                                                                                                   onTap: () {
                          //                                                                                                     Navigator.pop(context);
                          //                                                                                                     // scaffoldkey.currentState!.openDrawer();
                          //                                                                                                   },
                          //                                                                                                   child: Icon(
                          //                                                                                                     Icons.arrow_back_ios_rounded,
                          //                                                                                                     size: height * 0.039,
                          //                                                                                                   ),
                          //                                                                                                 ),
                          //                                                                                                 Expanded(
                          //                                                                                                   child: Text(
                          //                                                                                                     "Pick your ingredients from the table.",
                          //                                                                                                     style: TextStyle(fontFamily: "Lexand", fontSize: height * 0.018, fontWeight: FontWeight.w500),
                          //                                                                                                   ),
                          //                                                                                                 ),
                          //                                                                                               ],
                          //                                                                                             ),
                          //                                                                                             SizedBox(height: height * 0.02),
                          //                                                                                             SizedBox(
                          //                                                                                               height: height * 0.05,
                          //                                                                                               child: TextFormField(
                          //                                                                                                 style: TextStyle(
                          //                                                                                                   fontFamily: "Lexand",
                          //                                                                                                   fontSize: height * 0.018,
                          //                                                                                                   fontWeight: FontWeight.w500,
                          //                                                                                                 ),
                          //                                                                                                 controller: ingredientsEditController = TextEditingController(text: storeRoomController.ingredientsBeveragesList[i]["ingredient"]),
                          //                                                                                                 decoration: InputDecoration(
                          //                                                                                                   // suffixIcon: Padding(
                          //                                                                                                   //   padding: const EdgeInsets.all(8.0),
                          //                                                                                                   //   child: Image.asset(
                          //                                                                                                   //     "assets/user_icon.png",
                          //                                                                                                   //     height: height * 0.02,
                          //                                                                                                   //   ),
                          //                                                                                                   // ),
                          //                                                                                                   contentPadding: const EdgeInsets.only(left: 16.0),
                          //                                                                                                   label: Text(
                          //                                                                                                     "Ingredients",
                          //                                                                                                     style: TextStyle(
                          //                                                                                                       fontFamily: "Lexand",
                          //                                                                                                       fontSize: height * 0.018,
                          //                                                                                                       fontWeight: FontWeight.w300,
                          //                                                                                                     ),
                          //                                                                                                   ),
                          //                                                                                                   floatingLabelStyle: const TextStyle(
                          //                                                                                                     fontFamily: "Lexand",
                          //                                                                                                     fontWeight: FontWeight.w300,
                          //                                                                                                   ),
                          //                                                                                                   border: OutlineInputBorder(
                          //                                                                                                     borderRadius: BorderRadius.circular(15.0),
                          //                                                                                                     borderSide: const BorderSide(width: 1.5),
                          //                                                                                                   ),
                          //                                                                                                   disabledBorder: OutlineInputBorder(
                          //                                                                                                     borderRadius: BorderRadius.circular(30.0),
                          //                                                                                                     borderSide: const BorderSide(width: 1.5),
                          //                                                                                                   ),
                          //                                                                                                   enabledBorder: OutlineInputBorder(
                          //                                                                                                     borderRadius: BorderRadius.circular(30.0),
                          //                                                                                                     borderSide: BorderSide(
                          //                                                                                                       color: borderColor.withOpacity(1.0),
                          //                                                                                                       width: 1.5,
                          //                                                                                                     ),
                          //                                                                                                   ),
                          //                                                                                                   focusedBorder: OutlineInputBorder(
                          //                                                                                                     borderRadius: BorderRadius.circular(30.0),
                          //                                                                                                     borderSide: const BorderSide(width: 1.5),
                          //                                                                                                   ),
                          //                                                                                                 ),
                          //                                                                                                 onChanged: (value) {
                          //                                                                                                   setState(() {});
                          //                                                                                                 },
                          //                                                                                               ),
                          //                                                                                             ),
                          //                                                                                             SizedBox(height: height * 0.02),
                          //                                                                                             Container(
                          //                                                                                               height: height * 0.05,
                          //                                                                                               decoration: BoxDecoration(
                          //                                                                                                 borderRadius: BorderRadius.circular(30.0),
                          //                                                                                                 border: Border.all(
                          //                                                                                                   color: borderColor.withOpacity(1.0),
                          //                                                                                                   width: 1.5,
                          //                                                                                                 ),
                          //                                                                                               ),
                          //                                                                                               child: DropdownButtonFormField<String>(
                          //                                                                                                 hint: Text(
                          //                                                                                                   "Select measurement",
                          //                                                                                                   style: TextStyle(
                          //                                                                                                     fontFamily: "Lexand",
                          //                                                                                                     fontSize: height * 0.018,
                          //                                                                                                     fontWeight: FontWeight.w300,
                          //                                                                                                   ),
                          //                                                                                                 ),
                          //                                                                                                 padding: const EdgeInsets.only(left: 10, bottom: 5),
                          //                                                                                                 value: selectedUnit,
                          //                                                                                                 borderRadius: BorderRadius.circular(30.0),
                          //                                                                                                 onChanged: (String? newValue) {
                          //                                                                                                   setState(() {
                          //                                                                                                     selectedUnit = newValue!;
                          //                                                                                                   });
                          //                                                                                                 },
                          //                                                                                                 items: <String>['kg', 'litre', 'unit'].map<DropdownMenuItem<String>>(
                          //                                                                                                   (String value) {
                          //                                                                                                     return DropdownMenuItem<String>(
                          //                                                                                                       value: value,
                          //                                                                                                       child: Padding(
                          //                                                                                                         padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                          //                                                                                                         child: Text(
                          //                                                                                                           value,
                          //                                                                                                           style: TextStyle(
                          //                                                                                                             fontFamily: "Lexand",
                          //                                                                                                             fontSize: height * 0.018,
                          //                                                                                                             fontWeight: FontWeight.w300,
                          //                                                                                                           ),
                          //                                                                                                         ),
                          //                                                                                                       ),
                          //                                                                                                     );
                          //                                                                                                   },
                          //                                                                                                 ).toList(),
                          //                                                                                                 decoration: InputDecoration(
                          //                                                                                                   border: InputBorder.none,
                          //                                                                                                   contentPadding: EdgeInsets.zero,
                          //                                                                                                   floatingLabelStyle: TextStyle(
                          //                                                                                                     fontFamily: "Lexand",
                          //                                                                                                     fontSize: height * 0.013,
                          //                                                                                                     fontWeight: FontWeight.w300,
                          //                                                                                                   ),
                          //                                                                                                 ),
                          //                                                                                                 // Aligns the dropdown value vertically centered within the container
                          //                                                                                                 alignment: Alignment.topCenter,
                          //                                                                                               ),
                          //                                                                                             ),
                          //                                                                                             SizedBox(
                          //                                                                                               height: height * 0.02,
                          //                                                                                             ),
                          //                                                                                             Row(
                          //                                                                                               children: [
                          //                                                                                                 Expanded(
                          //                                                                                                   child: InkWell(
                          //                                                                                                     onTap: () {
                          //                                                                                                       Navigator.pop(context);
                          //                                                                                                     },
                          //                                                                                                     child: Padding(
                          //                                                                                                       padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                          //                                                                                                       child: Container(
                          //                                                                                                         height: height * 0.04,
                          //                                                                                                         width: width,
                          //                                                                                                         decoration: BoxDecoration(
                          //                                                                                                           color: buttonColor.withOpacity(1.0),
                          //                                                                                                           borderRadius: BorderRadius.circular(15.0),
                          //                                                                                                         ),
                          //                                                                                                         child: Padding(
                          //                                                                                                           padding: const EdgeInsets.all(8.0),
                          //                                                                                                           child: Center(
                          //                                                                                                             child: Text(
                          //                                                                                                               "Cancel",
                          //                                                                                                               style: TextStyle(color: Colors.white, fontFamily: "Lexand", fontSize: height * 0.011, fontWeight: FontWeight.w700),
                          //                                                                                                             ),
                          //                                                                                                           ),
                          //                                                                                                         ),
                          //                                                                                                       ),
                          //                                                                                                     ),
                          //                                                                                                   ),
                          //                                                                                                 ),
                          //                                                                                                 Expanded(
                          //                                                                                                   child: InkWell(
                          //                                                                                                     onTap: () async {
                          //                                                                                                       await storeRoomController.storRoomingrediantEdit(
                          //                                                                                                         ingredientsEditController.text,
                          //                                                                                                         storeRoomController.ingredientsBeveragesList[i]["ingredientId"],
                          //                                                                                                         storeRoomController.ingredientsBeveragesList[i]["isChecked"],
                          //                                                                                                         selectedUnit,
                          //                                                                                                       );
                          //                                                                                                       setState(() {});
                          //                                                                                                       Navigator.pop(context);
                          //                                                                                                       await storeRoomController.stroreRoomingredientsList(nameOfIngeridiant);
                          //                                                                                                     },
                          //                                                                                                     child: Padding(
                          //                                                                                                       padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                          //                                                                                                       child: Container(
                          //                                                                                                         height: height * 0.04,
                          //                                                                                                         width: width,
                          //                                                                                                         decoration: BoxDecoration(
                          //                                                                                                           color: buttonColor.withOpacity(1.0),
                          //                                                                                                           borderRadius: BorderRadius.circular(15.0),
                          //                                                                                                         ),
                          //                                                                                                         child: Padding(
                          //                                                                                                           padding: const EdgeInsets.all(8.0),
                          //                                                                                                           child: Center(
                          //                                                                                                             child: Text(
                          //                                                                                                               "Save",
                          //                                                                                                               style: TextStyle(color: Colors.white, fontFamily: "Lexand", fontSize: height * 0.011, fontWeight: FontWeight.w700),
                          //                                                                                                             ),
                          //                                                                                                           ),
                          //                                                                                                         ),
                          //                                                                                                       ),
                          //                                                                                                     ),
                          //                                                                                                   ),
                          //                                                                                                 )
                          //                                                                                               ],
                          //                                                                                             )
                          //                                                                                           ],
                          //                                                                                         ),
                          //                                                                                       ),
                          //                                                                                     );
                          //                                                                                   },
                          //                                                                                 );
                          //                                                                               },
                          //                                                                               child: const Icon(
                          //                                                                                 Icons.edit,
                          //                                                                                 size: 20,
                          //                                                                                 color: Colors.black,
                          //                                                                               ),
                          //                                                                             )
                          //                                                                           ],
                          //                                                                         ),
                          //                                                                       ),
                          //                                                                     ),
                          //                                                                   ),
                          //                                                                   SizedBox(height: height * 0.01),
                          //                                                                 ],
                          //                                                               ),
                          //                                                             );
                          //                                                           },
                          //                                                         ),
                          //                                                       ),
                          //                                                     ),
                          //                                                   )
                          //                                                 : Expanded(
                          //                                                     flex: 3,
                          //                                                     child: SingleChildScrollView(
                          //                                                       child: SizedBox(
                          //                                                         height: height * 0.7,
                          //                                                         child: ListView.builder(
                          //                                                           // shrinkWrap: true,
                          //                                                           itemCount: storeRoomController.ingredientsDairyList.length,
                          //                                                           itemBuilder: (
                          //                                                             context,
                          //                                                             i,
                          //                                                           ) {
                          //                                                             return Padding(
                          //                                                               padding: const EdgeInsets.all(8.0),
                          //                                                               child: Column(
                          //                                                                 crossAxisAlignment: CrossAxisAlignment.start,
                          //                                                                 children: [
                          //                                                                   InkWell(
                          //                                                                     onTap: () {
                          //                                                                       setState(() {});
                          //                                                                     },
                          //                                                                     child: Container(
                          //                                                                       width: width,
                          //                                                                       // height: height*0.05,
                          //                                                                       decoration: BoxDecoration(
                          //                                                                         color: primaryColor.withOpacity(1.0),
                          //                                                                         borderRadius: BorderRadius.circular(10.0),
                          //                                                                       ),
                          //                                                                       child: Padding(
                          //                                                                         padding: const EdgeInsets.all(8.0),
                          //                                                                         child: Row(
                          //                                                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //                                                                           children: [
                          //                                                                             Text(
                          //                                                                               storeRoomController.ingredientsDairyList[i]["ingredient"],
                          //                                                                               style: TextStyle(
                          //                                                                                 fontFamily: "Lexand",
                          //                                                                                 fontSize: height * 0.013,
                          //                                                                                 fontWeight: FontWeight.w700,
                          //                                                                               ),
                          //                                                                             ),
                          //                                                                             InkWell(
                          //                                                                               onTap: () {
                          //                                                                                 showDialog(
                          //                                                                                   context: context,
                          //                                                                                   builder: (context) {
                          //                                                                                     return AlertDialog(
                          //                                                                                       // insetPadding: EdgeInsets.all(0.0),
                          //                                                                                       content: SizedBox(
                          //                                                                                         // width: double.maxFinite,
                          //                                                                                         height: height * 0.3, // Ensure the AlertDialog content has a fixed width
                          //                                                                                         child: Column(
                          //                                                                                           children: [
                          //                                                                                             Row(
                          //                                                                                               children: [
                          //                                                                                                 InkWell(
                          //                                                                                                   onTap: () {
                          //                                                                                                     Navigator.pop(context);
                          //                                                                                                     // scaffoldkey.currentState!.openDrawer();
                          //                                                                                                   },
                          //                                                                                                   child: Icon(
                          //                                                                                                     Icons.arrow_back_ios_rounded,
                          //                                                                                                     size: height * 0.039,
                          //                                                                                                   ),
                          //                                                                                                 ),
                          //                                                                                                 Expanded(
                          //                                                                                                   child: Text(
                          //                                                                                                     "Pick your ingredients from the table.",
                          //                                                                                                     style: TextStyle(fontFamily: "Lexand", fontSize: height * 0.018, fontWeight: FontWeight.w500),
                          //                                                                                                   ),
                          //                                                                                                 ),
                          //                                                                                               ],
                          //                                                                                             ),
                          //                                                                                             SizedBox(height: height * 0.02),
                          //                                                                                             SizedBox(
                          //                                                                                               height: height * 0.05,
                          //                                                                                               child: TextFormField(
                          //                                                                                                 style: TextStyle(
                          //                                                                                                   fontFamily: "Lexand",
                          //                                                                                                   fontSize: height * 0.018,
                          //                                                                                                   fontWeight: FontWeight.w500,
                          //                                                                                                 ),
                          //                                                                                                 controller: ingredientsEditController = TextEditingController(text: storeRoomController.ingredientsDairyList[i]["ingredient"]),
                          //                                                                                                 decoration: InputDecoration(
                          //                                                                                                   // suffixIcon: Padding(
                          //                                                                                                   //   padding: const EdgeInsets.all(8.0),
                          //                                                                                                   //   child: Image.asset(
                          //                                                                                                   //     "assets/user_icon.png",
                          //                                                                                                   //     height: height * 0.02,
                          //                                                                                                   //   ),
                          //                                                                                                   // ),
                          //                                                                                                   contentPadding: const EdgeInsets.only(left: 16.0),
                          //                                                                                                   label: Text(
                          //                                                                                                     "Ingredients",
                          //                                                                                                     style: TextStyle(
                          //                                                                                                       fontFamily: "Lexand",
                          //                                                                                                       fontSize: height * 0.018,
                          //                                                                                                       fontWeight: FontWeight.w300,
                          //                                                                                                     ),
                          //                                                                                                   ),
                          //                                                                                                   floatingLabelStyle: const TextStyle(
                          //                                                                                                     fontFamily: "Lexand",
                          //                                                                                                     fontWeight: FontWeight.w300,
                          //                                                                                                   ),
                          //                                                                                                   border: OutlineInputBorder(
                          //                                                                                                     borderRadius: BorderRadius.circular(15.0),
                          //                                                                                                     borderSide: const BorderSide(width: 1.5),
                          //                                                                                                   ),
                          //                                                                                                   disabledBorder: OutlineInputBorder(
                          //                                                                                                     borderRadius: BorderRadius.circular(30.0),
                          //                                                                                                     borderSide: const BorderSide(width: 1.5),
                          //                                                                                                   ),
                          //                                                                                                   enabledBorder: OutlineInputBorder(
                          //                                                                                                     borderRadius: BorderRadius.circular(30.0),
                          //                                                                                                     borderSide: BorderSide(
                          //                                                                                                       color: borderColor.withOpacity(1.0),
                          //                                                                                                       width: 1.5,
                          //                                                                                                     ),
                          //                                                                                                   ),
                          //                                                                                                   focusedBorder: OutlineInputBorder(
                          //                                                                                                     borderRadius: BorderRadius.circular(30.0),
                          //                                                                                                     borderSide: const BorderSide(width: 1.5),
                          //                                                                                                   ),
                          //                                                                                                 ),
                          //                                                                                                 onChanged: (value) {
                          //                                                                                                   setState(() {});
                          //                                                                                                 },
                          //                                                                                               ),
                          //                                                                                             ),
                          //                                                                                             SizedBox(height: height * 0.02),
                          //                                                                                             Container(
                          //                                                                                               height: height * 0.05,
                          //                                                                                               decoration: BoxDecoration(
                          //                                                                                                 borderRadius: BorderRadius.circular(30.0),
                          //                                                                                                 border: Border.all(
                          //                                                                                                   color: borderColor.withOpacity(1.0),
                          //                                                                                                   width: 1.5,
                          //                                                                                                 ),
                          //                                                                                               ),
                          //                                                                                               child: DropdownButtonFormField<String>(
                          //                                                                                                 hint: Text(
                          //                                                                                                   "Select measurement",
                          //                                                                                                   style: TextStyle(
                          //                                                                                                     fontFamily: "Lexand",
                          //                                                                                                     fontSize: height * 0.018,
                          //                                                                                                     fontWeight: FontWeight.w300,
                          //                                                                                                   ),
                          //                                                                                                 ),
                          //                                                                                                 padding: const EdgeInsets.only(left: 10, bottom: 5),
                          //                                                                                                 value: selectedUnit,
                          //                                                                                                 borderRadius: BorderRadius.circular(30.0),
                          //                                                                                                 onChanged: (String? newValue) {
                          //                                                                                                   setState(() {
                          //                                                                                                     selectedUnit = newValue!;
                          //                                                                                                   });
                          //                                                                                                 },
                          //                                                                                                 items: <String>['kg', 'litre', 'unit'].map<DropdownMenuItem<String>>(
                          //                                                                                                   (String value) {
                          //                                                                                                     return DropdownMenuItem<String>(
                          //                                                                                                       value: value,
                          //                                                                                                       child: Padding(
                          //                                                                                                         padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                          //                                                                                                         child: Text(
                          //                                                                                                           value,
                          //                                                                                                           style: TextStyle(
                          //                                                                                                             fontFamily: "Lexand",
                          //                                                                                                             fontSize: height * 0.018,
                          //                                                                                                             fontWeight: FontWeight.w300,
                          //                                                                                                           ),
                          //                                                                                                         ),
                          //                                                                                                       ),
                          //                                                                                                     );
                          //                                                                                                   },
                          //                                                                                                 ).toList(),
                          //                                                                                                 decoration: InputDecoration(
                          //                                                                                                   border: InputBorder.none,
                          //                                                                                                   contentPadding: EdgeInsets.zero,
                          //                                                                                                   floatingLabelStyle: TextStyle(
                          //                                                                                                     fontFamily: "Lexand",
                          //                                                                                                     fontSize: height * 0.013,
                          //                                                                                                     fontWeight: FontWeight.w300,
                          //                                                                                                   ),
                          //                                                                                                 ),
                          //                                                                                                 // Aligns the dropdown value vertically centered within the container
                          //                                                                                                 alignment: Alignment.topCenter,
                          //                                                                                               ),
                          //                                                                                             ),
                          //                                                                                             SizedBox(
                          //                                                                                               height: height * 0.02,
                          //                                                                                             ),
                          //                                                                                             Row(
                          //                                                                                               children: [
                          //                                                                                                 Expanded(
                          //                                                                                                   child: InkWell(
                          //                                                                                                     onTap: () {
                          //                                                                                                       Navigator.pop(context);
                          //                                                                                                     },
                          //                                                                                                     child: Padding(
                          //                                                                                                       padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                          //                                                                                                       child: Container(
                          //                                                                                                         height: height * 0.04,
                          //                                                                                                         width: width,
                          //                                                                                                         decoration: BoxDecoration(
                          //                                                                                                           color: buttonColor.withOpacity(1.0),
                          //                                                                                                           borderRadius: BorderRadius.circular(15.0),
                          //                                                                                                         ),
                          //                                                                                                         child: Padding(
                          //                                                                                                           padding: const EdgeInsets.all(8.0),
                          //                                                                                                           child: Center(
                          //                                                                                                             child: Text(
                          //                                                                                                               "Cancel",
                          //                                                                                                               style: TextStyle(color: Colors.white, fontFamily: "Lexand", fontSize: height * 0.011, fontWeight: FontWeight.w700),
                          //                                                                                                             ),
                          //                                                                                                           ),
                          //                                                                                                         ),
                          //                                                                                                       ),
                          //                                                                                                     ),
                          //                                                                                                   ),
                          //                                                                                                 ),
                          //                                                                                                 Expanded(
                          //                                                                                                   child: InkWell(
                          //                                                                                                     onTap: () async {
                          //                                                                                                       await storeRoomController.storRoomingrediantEdit(
                          //                                                                                                         ingredientsEditController.text,
                          //                                                                                                         storeRoomController.ingredientsDairyList[i]["ingredientId"],
                          //                                                                                                         storeRoomController.ingredientsDairyList[i]["isChecked"],
                          //                                                                                                         selectedUnit,
                          //                                                                                                       );
                          //                                                                                                       setState(() {});
                          //                                                                                                       Navigator.pop(context);
                          //                                                                                                       await storeRoomController.stroreRoomingredientsList(nameOfIngeridiant);
                          //                                                                                                     },
                          //                                                                                                     child: Padding(
                          //                                                                                                       padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                          //                                                                                                       child: Container(
                          //                                                                                                         height: height * 0.04,
                          //                                                                                                         width: width,
                          //                                                                                                         decoration: BoxDecoration(
                          //                                                                                                           color: buttonColor.withOpacity(1.0),
                          //                                                                                                           borderRadius: BorderRadius.circular(15.0),
                          //                                                                                                         ),
                          //                                                                                                         child: Padding(
                          //                                                                                                           padding: const EdgeInsets.all(8.0),
                          //                                                                                                           child: Center(
                          //                                                                                                             child: Text(
                          //                                                                                                               "Save",
                          //                                                                                                               style: TextStyle(color: Colors.white, fontFamily: "Lexand", fontSize: height * 0.011, fontWeight: FontWeight.w700),
                          //                                                                                                             ),
                          //                                                                                                           ),
                          //                                                                                                         ),
                          //                                                                                                       ),
                          //                                                                                                     ),
                          //                                                                                                   ),
                          //                                                                                                 )
                          //                                                                                               ],
                          //                                                                                             )
                          //                                                                                           ],
                          //                                                                                         ),
                          //                                                                                       ),
                          //                                                                                     );
                          //                                                                                   },
                          //                                                                                 );
                          //                                                                               },
                          //                                                                               child: const Icon(
                          //                                                                                 Icons.edit,
                          //                                                                                 size: 20,
                          //                                                                                 color: Colors.black,
                          //                                                                               ),
                          //                                                                             )
                          //                                                                           ],
                          //                                                                         ),
                          //                                                                       ),
                          //                                                                     ),
                          //                                                                   ),
                          //                                                                   SizedBox(height: height * 0.01),
                          //                                                                 ],
                          //                                                               ),
                          //                                                             );
                          //                                                           },
                          //                                                         ),
                          //                                                       ),
                          //                                                     ),
                          //                                                   )
                        
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget drawerContent(
  //     {String? title, IconData? icon, GestureTapCallback? onTap}) {
  //   var height = MediaQuery.of(context).size.height;
  //   var width = MediaQuery.of(context).size.width;
  //   return Material(
  //     color: Colors.transparent,
  //     child: InkWell(
  //       onTap: onTap,
  //       child: Container(
  //         padding: const EdgeInsets.all(10),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text(
  //               title!,
  //               style: TextStyle(
  //                   fontFamily: "Lexand",
  //                   fontSize: height * 0.008,
  //                   fontWeight: FontWeight.w700),
  //             ),
  //             // assetImageHelper(image: image, width: 24, height: 24)
  //             Icon(
  //               icon,
  //               size: 24,
  //               color: primaryColor.withOpacity(1.0),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget buildIngredientListView(
  //     List<dynamic> ingredients, double height, double width) {
  //   return Container(
  //     height: height * 0.5,
  //     child: ListView.builder(
  //       // shrinkWrap: true,
  //       itemCount: ingredients.length,
  //       itemBuilder: (context, index) {
  //         return Padding(
  //           padding: EdgeInsets.symmetric(
  //               horizontal: width * 0.04, vertical: height * 0.005),
  //           child: Container(
  //             height: height * 0.05,
  //             decoration: BoxDecoration(
  //               color: primaryColor,
  //               borderRadius: BorderRadius.circular(3.0),
  //             ),
  //             child: Align(
  //               alignment: Alignment.centerLeft,
  //               child: Padding(
  //                 padding: EdgeInsets.symmetric(horizontal: width * 0.03),
  //                 child: Text(
  //                   ingredients[index].name,
  //                   style: TextStyle(
  //                     fontFamily: "Lexand",
  //                     fontSize: height * 0.013,
  //                     fontWeight: FontWeight.w700,
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

// Function to check if at least one ingredient is selected
  // bool isAtLeastOneIngredientSelected(List<bool> isCheckedList) {
  //   return isCheckedList.contains(true);
  // }
}
