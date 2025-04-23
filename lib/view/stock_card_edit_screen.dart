import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_custom_month_picker/flutter_custom_month_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:marie_erp/constants/groupes_list.dart';
import 'package:marie_erp/model/IngredientModels.dart';
import 'package:marie_erp/model/StockListModel.dart';

import '../constants/color.dart';
import 'dart:math' as math;

import '../controller/store_room_controller.dart';

class StockCardEditScreen extends StatefulWidget {
  final String? categoryName;
  const StockCardEditScreen({super.key, this.categoryName});

  @override
  State<StockCardEditScreen> createState() => _StockCardEditScreenState();
}

class _StockCardEditScreenState extends State<StockCardEditScreen> {
  StoreRoomController storeRoomController = Get.find();
  TextEditingController startDate = TextEditingController();
  TextEditingController stackAddingDate = TextEditingController();
  TextEditingController stockCountController = TextEditingController();
  TextEditingController stockCountUnit = TextEditingController();
  TextEditingController stockCountDate = TextEditingController();
  TextEditingController planToBuyAdd = TextEditingController();
  TextEditingController planToBuyEdit = TextEditingController();
  TextEditingController planToBuyPrice = TextEditingController();
  TextEditingController planToBought = TextEditingController();
  TextEditingController planToBoughtPrice = TextEditingController();

  TextEditingController alertStackCount = TextEditingController();
  TextEditingController alertPlanToBuy = TextEditingController();
  TextEditingController alertBoughtCount = TextEditingController();
  TextEditingController alertUnitPrice = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
  // bool isNavBarHide = false;
  List<int> selectedIndices = [];
  List<String> stockCardName = [
    "Eggs",
    "Chicken",
    "Chicken-Broiler",
    "Chicken-Wings"
  ];

  List<String> selectedNames = [];
  bool isAddselected = false;
  bool isAddButtonClicked = false;
  String? stockId = "";
  int currentMonth = DateTime.now().month;
  int currentYear = DateTime.now().year;
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) => getData());
    super.initState();
    // Get current month and year
    // Set initial value in the TextFormField
    final List<String> monthAbbreviations = [
      '', // Index 0 is unused as months start from index 1
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];
    startDate.text = "${monthAbbreviations[currentMonth]}, $currentYear";
    stackAddingDate.text = DateTime.now().toString().split(" ").first;
  }

  String formatDate(String? dateString) {
    if (dateString != null && dateString.isNotEmpty) {
      return DateFormat('dd-MMM-yyyy').format(DateTime.parse(dateString));
    } else {
      return '';
    }
  }

  List stockList = [];

  getData() async {
    storeRoomController.ingredientList.clear();
    storeRoomController.stockList.clear();
    await storeRoomController.stroreRoomingredientsList(widget.categoryName!);
    if (storeRoomController.ingredientList.isNotEmpty) {
      // stockId = storeRoomController.ingredientList[0].ingredientId;
      await storeRoomController.stockListApi(
          category: widget.categoryName!, item: stockId);
    }
    // print("${storeRoomController.ingredientList.toJson()} ==<<<<<<< stocklist");
  }

  int selectedIndex = -1;
  bool isSelected = false;
  String selectedIngredient = '';
  String selectedStockId = '';
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: scaffoldkey,
      drawer: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          // margin: EdgeInsets.only(top: height * 0.06, bottom: height * 0.005),
          height: height * 0.82,
          width: width * 0.45,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: height,
                  child: Obx(() => ListView.builder(
                        padding: const EdgeInsets.all(0.0),
                        itemCount: storeRoomController.ingredientList.length,
                        itemBuilder: (BuildContext context, int index) {
                          IngredientModels data =
                              storeRoomController.ingredientList[index];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                                stockId = data.ingredientId;
                                storeRoomController.stockListApi(
                                  category: widget.categoryName!,
                                  item: data.ingredientId,
                                );
                                scaffoldkey.currentState!.closeDrawer();
                                selectedIngredient = data.ingredient!;
                              });
                              // print("${selectedIndex} =========>>>>>>>>>");
                              // print("${data.toJson()} =========>>>>>>>>>");
                              print(data.ingredientId);
                              print(data.ingredient);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: width * 0.04,
                                vertical: height * 0.01,
                              ),
                              child: Container(
                                height: height * 0.05,
                                decoration: BoxDecoration(
                                  color: selectedIndex == index
                                      ? primaryColor
                                      : Colors.white,
                                  border: Border.all(
                                    color: selectedIndex == index
                                        ? Colors.white
                                        : Colors.black,
                                    width: width * 0.001,
                                  ),
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: Center(
                                  child: Text(
                                    data.ingredient!,
                                    style: TextStyle(
                                      color: selectedIndex == index
                                          ? Colors.white
                                          : Colors.black,
                                      fontFamily: "Lexand",
                                      fontSize: height * 0.012,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_rounded,
            size: height * 0.039,
          ),
        ),
        title: SizedBox(
          width: width * 0.65,
          child: Text(
            "${widget.categoryName}",
            style: TextStyle(
                fontFamily: "Lexand",
                fontSize: height * 0.018,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: height * 0.04,
                      child: TextFormField(
                        controller: startDate,
                        readOnly: true,
                        decoration: InputDecoration(
                          suffixIcon: InkWell(
                            onTap: () {
                              showMonthPicker(context,
                                  onSelected: (month, year) {
                                if (kDebugMode) {
                                  print('Selected month: $month, year: $year');
                                }
                                final List<String> monthAbbreviations = [
                                  '', // Index 0 is unused as months start from index 1
                                  'JAN',
                                  'FEB',
                                  'MAR',
                                  'APR',
                                  'MAY',
                                  'JUN',
                                  'JUL',
                                  'AUG',
                                  'SEP',
                                  'OCT',
                                  'NOV',
                                  'DEC',
                                ];
                                startDate.text =
                                    "${monthAbbreviations[month]}, $year";
                                currentMonth = month;
                                currentYear = year;
                                setState(() {});
                              },
                                  initialSelectedMonth: DateTime.now().month,
                                  initialSelectedYear: DateTime.now().year,
                                  firstEnabledMonth: 3,
                                  lastEnabledMonth: 10,
                                  firstYear: DateTime.now().year - 10,
                                  lastYear: DateTime.now().year + 100,
                                  selectButtonText: 'OK',
                                  cancelButtonText: 'Cancel',
                                  highlightColor: primaryColor,
                                  textColor: Colors.white,
                                  contentBackgroundColor: Colors.white,
                                  dialogBackgroundColor: Colors.grey[200]);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                "assets/calendar.png",
                                height: height * 0.02,
                              ),
                            ),
                          ),
                          contentPadding: const EdgeInsets.only(left: 16.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(width: 1.5),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(width: 1.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                              color: borderColor.withOpacity(1.0),
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(width: 1.5),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: width * 0.43),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          isAddButtonClicked = !isAddButtonClicked;
                          setState(() {});
                        },
                        child: Icon(
                          Icons.add_to_photos_sharp,
                          color:
                              isAddButtonClicked ? Colors.amber : Colors.black,
                          size: 30,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: height * 0.02),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.03),
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        print("object");
                        scaffoldkey.currentState!.openDrawer();
                      });
                      // Get.to(const StoreRoomScreen());
                    },
                    child: Image.asset(
                      "assets/right-icon.png",
                      // scale: ,
                      height: height * 0.06,
                      width: width * 0.08,
                    ),
                  ),
                  SizedBox(
                    width: width * 0.04,
                  ),
                  Text(
                    selectedIngredient,
                    style: const TextStyle(
                      fontFamily: "Lexand",
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // VerticalDivider(
                  //   thickness: height,
                  //   color: borderColor,
                  // ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: height * 0.04),
              child: Column(
                children: [
                  !isAddButtonClicked
                      ? Container()
                      : SizedBox(
                          width: width * 0.9,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: height * 0.01),
                              Row(
                                children: [
                                  SizedBox(height: height * 0.02),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      "Enter stockcount",
                                      style: TextStyle(
                                          color: Colors.grey[700],
                                          fontFamily: "Lexand",
                                          fontSize: height * 0.018,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: height * 0.01),
                              Row(
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: height * 0.02),
                                  Expanded(
                                    child: TextFormField(
                                      controller: stockCountController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.only(left: 16.0),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide:
                                              const BorderSide(width: 1.5),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide:
                                              const BorderSide(width: 1.5),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: BorderSide(
                                            color: borderColor.withOpacity(1.0),
                                            width: 1.5,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide:
                                              const BorderSide(width: 1.5),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: height * 0.01),
                              Text(
                                "Plan to buy",
                                style: TextStyle(
                                    color: Colors.grey[700],
                                    fontFamily: "Lexand",
                                    fontSize: height * 0.018,
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(height: height * 0.01),
                              SizedBox(
                                // height: height * 0.07,
                                child: TextFormField(
                                  controller: planToBuyAdd,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(left: 16.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(width: 1.5),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(width: 1.5),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(
                                        color: borderColor.withOpacity(1.0),
                                        width: 1.5,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(width: 1.5),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                ),
                              ),
                              SizedBox(height: height * 0.01),
                              Text(
                                "Date",
                                style: TextStyle(
                                    color: Colors.grey[700],
                                    fontFamily: "Lexand",
                                    fontSize: height * 0.018,
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(height: height * 0.01),
                              SizedBox(
                                height: height * 0.07,
                                child: TextFormField(
                                  controller: stackAddingDate,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    suffixIcon: InkWell(
                                      onTap: () {
                                        showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1910),
                                          lastDate: DateTime(2025),
                                          builder: (BuildContext context,
                                              Widget? child) {
                                            return Theme(
                                              data: Theme.of(context).copyWith(
                                                colorScheme: ColorScheme.light(
                                                  primary: primaryColor,
                                                  onPrimary: Colors.white,
                                                  onSurface: Colors.black,
                                                ),
                                              ),
                                              child: child!,
                                            );
                                          },
                                        ).then((value) {
                                          if (value != null) {
                                            stackAddingDate.text = value
                                                .toString()
                                                .split(" ")
                                                .first;
                                          }
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset(
                                          "assets/calendar.png",
                                          height: height * 0.02,
                                        ),
                                      ),
                                    ),
                                    contentPadding:
                                        const EdgeInsets.only(left: 16.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(width: 1.5),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(width: 1.5),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(
                                        color: borderColor.withOpacity(1.0),
                                        width: 1.5,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(width: 1.5),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                ),
                              ),
                              SizedBox(height: height * 0.02),
                              Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        isAddButtonClicked = false;
                                        setState(() {});
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: width * 0.02),
                                        child: Container(
                                          height: height * 0.04,
                                          width: width,
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(1.0),
                                            border: Border.all(
                                                width: width * 0.001,
                                                color: buttonColor),
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                              child: Text(
                                                "Cancel",
                                                style: TextStyle(
                                                    color: buttonColor,
                                                    fontFamily: "Lexand",
                                                    fontSize: height * 0.011,
                                                    fontWeight:
                                                        FontWeight.w700),
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
                                            await storeRoomController.addStock(
                                                planToBuy: planToBuyAdd.text,
                                                stockCount:
                                                    stockCountController.text,
                                                date: stackAddingDate.text,
                                                category: widget.categoryName,
                                                item: stockId);

                                        if (result != null) {
                                          planToBuyAdd.clear();
                                          stockCountController.clear();
                                          stackAddingDate.clear();
                                          isAddButtonClicked = false;
                                          await storeRoomController
                                              .stockListApi(
                                                  category:
                                                      widget.categoryName!,
                                                  item: stockId);
                                          setState(() {});
                                        }
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: width * 0.02),
                                        child: Container(
                                          height: height * 0.04,
                                          width: width,
                                          decoration: BoxDecoration(
                                            color: buttonColor.withOpacity(1.0),
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                              child: Text(
                                                "Save",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: "Lexand",
                                                    fontSize: height * 0.011,
                                                    fontWeight:
                                                        FontWeight.w700),
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
                ],
              ),
            ),
            (stockId!.isNotEmpty)
                ? SizedBox(
                    height: height * 0.7,
                    width: width,
                    child: Obx(() => ListView.builder(
                          // shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: storeRoomController.stockList.length,
                          itemBuilder: (context, i) {
                            Stocks data = storeRoomController.stockList[i];
                            DateTime tempDate = new DateFormat("yyyy-MM-dd")
                                .parse(data.datecreated!);
                            if (tempDate.month ==
                                    (currentMonth > 10
                                        ? int.parse("0$currentMonth")
                                        : currentMonth) &&
                                tempDate.year == currentYear) {
                              print(tempDate.month);
                              print((currentMonth > 10
                                  ? int.parse("0$currentMonth")
                                  : currentMonth));
                              print(currentYear);
                              print(tempDate.year);
                              print(selectedStockId);
                              print(stockId);
                              return
                                  // (selectedStockId != stockId || data == '')
                                  //     ? Container(
                                  //         width: width,
                                  //         // color: primaryColor,
                                  //         child: Column(
                                  //           mainAxisAlignment:
                                  //               MainAxisAlignment.center,
                                  //           children: [
                                  //             Row(
                                  //               mainAxisAlignment:
                                  //                   MainAxisAlignment.center,
                                  //               children: [
                                  //                 Center(
                                  //                   child: Text(
                                  //                     "Add Stock",
                                  //                     style: TextStyle(
                                  //                         fontSize: 18,
                                  //                         fontWeight:
                                  //                             FontWeight.bold,
                                  //                         color: borderColor),
                                  //                   ),
                                  //                 )
                                  //               ],
                                  //             )
                                  //           ],
                                  //         ),
                                  //       )
                                  //     :
                                  Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  // height: height * 0.1,
                                  width: width / 1.3,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: width * 0.001,
                                        color: primaryColor),
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: width * 0.04,
                                            vertical: height * 0.02),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    formatDate(
                                                        data.datecreated),
                                                    style: TextStyle(
                                                      fontFamily: "Lexand",
                                                      fontSize: height * 0.022,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: height * 0.04),
                                                  Text(
                                                    "Opening Stock",
                                                    style: TextStyle(
                                                        fontFamily: "Lexand",
                                                        fontSize:
                                                            height * 0.017,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        color:
                                                            Colors.grey[600]),
                                                  ),
                                                  Text(
                                                    "${data.stockCount} ${data.unit}",
                                                    style: TextStyle(
                                                      fontFamily: "Lexand",
                                                      fontSize: height * 0.022,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: height * 0.02),
                                                  Text(
                                                    "Plan to buy",
                                                    style: TextStyle(
                                                        fontFamily: "Lexand",
                                                        fontSize:
                                                            height * 0.017,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        color:
                                                            Colors.grey[600]),
                                                  ),
                                                  Text(
                                                    "${data.planToBuy} ${data.unit}",
                                                    style: TextStyle(
                                                      fontFamily: "Lexand",
                                                      fontSize: height * 0.022,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: height * 0.02),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Bought",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Lexand",
                                                            fontSize:
                                                                height * 0.017,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            color: Colors
                                                                .grey[600]),
                                                      ),
                                                      // Icon(
                                                      //   Icons.arrow_drop_up,
                                                      //   size: height * 0.03,
                                                      //   color: Colors.green,
                                                      // ),
                                                      // Text(
                                                      //   "20 %",
                                                      //   style: TextStyle(
                                                      //       fontFamily: "Lexand",
                                                      //       fontSize: height * 0.011,
                                                      //       fontWeight: FontWeight.w300,
                                                      //       color: Colors.green),
                                                      // ),
                                                    ],
                                                  ),
                                                  // SizedBox(height: height * 0.02),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        (data.bought != null)
                                                            ? "${data.bought} ${data.unit}"
                                                            : "Not yet entered",
                                                        style: TextStyle(
                                                          fontFamily: "Lexand",
                                                          fontSize:
                                                              height * 0.022,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      height: height * 0.02),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Paid per unit",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Lexand",
                                                            fontSize:
                                                                height * 0.017,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            color: Colors
                                                                .grey[600]),
                                                      ),
                                                      // Icon(
                                                      //   Icons.arrow_drop_down,
                                                      //   size: height * 0.03,
                                                      //   color: Colors.red,
                                                      // ),
                                                      // Text(
                                                      //   "20 %",
                                                      //   style: TextStyle(
                                                      //       fontFamily: "Lexand",
                                                      //       fontSize: height * 0.011,
                                                      //       fontWeight: FontWeight.w300,
                                                      //       color: Colors.red),
                                                      // ),
                                                    ],
                                                  ),
                                                  // SizedBox(height: height * 0.02),
                                                  Text(
                                                    (data.bought != null)
                                                        ? "${data.pricePerUnit} ${data.unit}"
                                                        : "Not yet entered",
                                                    style: TextStyle(
                                                      fontFamily: "Lexand",
                                                      fontSize: height * 0.022,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: height * 0.02),
                                                  Text(
                                                    "Consumption",
                                                    style: TextStyle(
                                                        fontFamily: "Lexand",
                                                        fontSize:
                                                            height * 0.017,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        color:
                                                            Colors.grey[600]),
                                                  ),
                                                  SizedBox(
                                                    width: width * 0.6,
                                                    child: Text(
                                                      (data.consumption != null)
                                                          ? "${data.consumption} ${data.unit}"
                                                          : "Calculated upon addition of the next stock card.",
                                                      // overflow: TextOverflow.ellipsis,
                                                      // maxLines: 1,
                                                      style: TextStyle(
                                                        fontFamily: "Lexand",
                                                        fontSize:
                                                            height * 0.022,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: height * 0.02),
                                                  Text(
                                                    "Closing stock",
                                                    style: TextStyle(
                                                        fontFamily: "Lexand",
                                                        fontSize:
                                                            height * 0.017,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        color:
                                                            Colors.grey[600]),
                                                  ),
                                                  SizedBox(
                                                    width: width * 0.6,
                                                    child: Text(
                                                      (data.closingStock !=
                                                              null)
                                                          ? "${data.closingStock} ${data.unit}"
                                                          : "Calculated upon addition of the next stock card.",
                                                      // overflow: TextOverflow.ellipsis,
                                                      // maxLines: 1,
                                                      style: TextStyle(
                                                        fontFamily: "Lexand",
                                                        fontSize:
                                                            height * 0.022,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                IconButton(
                                                  onPressed: () async {
                                                    // print(data.toJson());
                                                    _showEditItemModal(
                                                        context,
                                                        data!.id.toString(),
                                                        data.stockCount ?? "",
                                                        data.planToBuy ?? "",
                                                        data.bought ?? "",
                                                        data.pricePerUnit ?? "",
                                                        stockId.toString());
                                                  },
                                                  icon: const Icon(Icons.edit),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    Get.dialog(
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        40),
                                                            child: Container(
                                                              decoration:
                                                                  const BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          20),
                                                                ),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        20.0),
                                                                child: Material(
                                                                  child: Column(
                                                                    children: [
                                                                      const Text(
                                                                        "Delete Item",
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontSize:
                                                                              20,
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              height * 0.02),
                                                                      const Text(
                                                                        "Are You Sure,Delete This Item?",
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontSize:
                                                                              16,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              height * 0.04),
                                                                      Row(
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                InkWell(
                                                                              onTap: () {
                                                                                Get.back();
                                                                              },
                                                                              child: Padding(
                                                                                padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                                                                                child: Container(
                                                                                  height: height * 0.04,
                                                                                  width: width,
                                                                                  decoration: BoxDecoration(
                                                                                    color: Colors.white.withOpacity(1.0),
                                                                                    border: Border.all(width: width * 0.001, color: buttonColor),
                                                                                    borderRadius: BorderRadius.circular(15.0),
                                                                                  ),
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: Center(
                                                                                      child: Text(
                                                                                        "No",
                                                                                        style: TextStyle(color: buttonColor, fontFamily: "Lexand", fontSize: height * 0.015, fontWeight: FontWeight.w700),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                              width: 10),
                                                                          Expanded(
                                                                            child:
                                                                                InkWell(
                                                                              onTap: () async {
                                                                                var result = await storeRoomController.deleteStock(stockId: data.id);
                                                                                if (result == true) {
                                                                                  storeRoomController.stockListApi(category: widget.categoryName!, item: stockId);

                                                                                  Get.back();
                                                                                }
                                                                                print("${result}--->>>");
                                                                              },
                                                                              child: Padding(
                                                                                padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                                                                                child: Container(
                                                                                  height: height * 0.04,
                                                                                  width: width,
                                                                                  decoration: BoxDecoration(
                                                                                    color: Colors.black.withOpacity(1.0),
                                                                                    border: Border.all(width: width * 0.001, color: buttonColor),
                                                                                    borderRadius: BorderRadius.circular(15.0),
                                                                                  ),
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: Center(
                                                                                      child: Text(
                                                                                        "Yes",
                                                                                        style: TextStyle(color: Colors.white, fontFamily: "Lexand", fontSize: height * 0.015, fontWeight: FontWeight.w700),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  icon:
                                                      const Icon(Icons.delete),
                                                ),
                                                // InkWell(
                                                //   onTap: () {},
                                                //   child: Padding(
                                                //     padding: const EdgeInsets.all(8.0),
                                                //     child: Icon(
                                                //       Icons.edit,
                                                //       size: height * 0.02,
                                                //     ),
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        )),
                  )
                : Container(
                    child: Column(
                      children: [
                        Text(
                          "Select Ingredient",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: borderColor),
                        ),
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }

  void _showEditItemModal(BuildContext context, String id, String stockCount,
      String planToBuy, String bought, String pricePerUnit, String itemId) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    alertStackCount.text = stockCount;
    alertPlanToBuy.text = planToBuy;
    alertBoughtCount.text = bought;
    alertUnitPrice.text = pricePerUnit;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          elevation: 1,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: height * 0.02),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: height * 0.05,
                      child: TextFormField(
                        controller: alertStackCount,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 16.0),
                          floatingLabelStyle: const TextStyle(
                            fontFamily: "Lexand",
                            fontWeight: FontWeight.w400,
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
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: width * 0.02),
                  Expanded(
                    child: SizedBox(
                      height: height * 0.05,
                      child: TextFormField(
                        controller: alertPlanToBuy,
                        decoration: InputDecoration(
                          // suffixIcon: InkWell(
                          //   onTap: () {

                          //   },
                          //   child: Padding(
                          //     padding:
                          //         const EdgeInsets.all(8.0),
                          //     child: Image.asset(
                          //       "assets/calendar.png",
                          //       height: height * 0.02,
                          //     ),
                          //   ),
                          // ),
                          contentPadding: const EdgeInsets.only(left: 16.0),

                          floatingLabelStyle: const TextStyle(
                            fontFamily: "Lexand",
                            fontWeight: FontWeight.w400,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
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
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.02),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: height * 0.05,
                      child: TextFormField(
                        controller: alertBoughtCount,
                        decoration: InputDecoration(
                          // suffixIcon: InkWell(
                          //   onTap: () {

                          //   },
                          //   child: Padding(
                          //     padding:
                          //         const EdgeInsets.all(8.0),
                          //     child: Image.asset(
                          //       "assets/calendar.png",
                          //       height: height * 0.02,
                          //     ),
                          //   ),
                          // ),
                          contentPadding: const EdgeInsets.only(left: 16.0),
                          hintText: "Bought quantity?",
                          hintStyle: TextStyle(
                            fontFamily: "Lexand",
                            fontSize: height * 0.015,
                            fontWeight: FontWeight.w400,
                          ),
                          floatingLabelStyle: const TextStyle(
                            fontFamily: "Lexand",
                            fontWeight: FontWeight.w400,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
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
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: width * 0.02),
                  Expanded(
                    child: SizedBox(
                      height: height * 0.05,
                      child: TextFormField(
                        controller: alertUnitPrice,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 16.0),
                          hintText: "Unit price?",
                          hintStyle: TextStyle(
                            fontFamily: "Lexand",
                            fontSize: height * 0.015,
                            fontWeight: FontWeight.w400,
                          ),
                          floatingLabelStyle: const TextStyle(
                            fontFamily: "Lexand",
                            fontWeight: FontWeight.w400,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
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
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.02),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                        child: Container(
                          height: height * 0.04,
                          width: width,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(1.0),
                            border: Border.all(
                                width: width * 0.001, color: buttonColor),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                    color: buttonColor,
                                    fontFamily: "Lexand",
                                    fontSize: height * 0.015,
                                    fontWeight: FontWeight.w700),
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
                        var result = await storeRoomController.editStock(
                            bought: alertBoughtCount.text,
                            planToBuy: alertPlanToBuy.text,
                            pricePerUnit: alertUnitPrice.text,
                            stockCount: alertStackCount.text,
                            stockId: id);
                        print("${result} ======>");
                        if (result != null) {
                          AnimatedSnackBar.material(
                            'Successfully Changed',
                            type: AnimatedSnackBarType.success,
                            duration: const Duration(seconds: 2),
                            mobilePositionSettings:
                                const MobilePositionSettings(
                              topOnAppearance: 100,
                              topOnDissapear: 50,
                              // bottomOnAppearance: 100,
                              // bottomOnDissapear: 50,
                              // left: 20,
                              right: 10,
                            ),
                            mobileSnackBarPosition: MobileSnackBarPosition.top,
                            desktopSnackBarPosition:
                                DesktopSnackBarPosition.bottomLeft,
                          ).show(context);
                          // Refresh the page or update the state
                          storeRoomController.stockListApi(
                            category: widget.categoryName!,
                            item: itemId,
                          );
                          setState(() {});
                          Get.back();
                        }
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
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Lexand",
                                    fontSize: height * 0.015,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
