import 'dart:io';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:marie_erp/view/save_file_mobile.dart';
import 'package:marie_erp/view/stock_card_edit_screen.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../constants/color.dart';
import '../constants/groupes_list.dart';
import '../controller/groups_controller.dart';
// import 'package:share_plus/share_plus.dart';

import 'package:intl/intl.dart';

class StockCardScreen extends StatefulWidget {
  const StockCardScreen({super.key});

  @override
  State<StockCardScreen> createState() => _StockCardScreenState();
}

class _StockCardScreenState extends State<StockCardScreen> {
  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();
  int selectedIndex = 0;
  DateTime? startDateset;

  final storage = const FlutterSecureStorage();
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  String? categoryName = "";
  int? selectedItem = 0;

  // Future<void> sharePDF(BuildContext context) async {
  //   try {
  //     final ByteData data = await rootBundle.load('assets/sample.pdf');
  //     final String pdfPath =
  //         '${(await getTemporaryDirectory()).path}/sample.pdf';
  //     final XFile pdfFile = XFile(pdfPath);
  //     // pdfFile.writeAsBytesSync(data.buffer.asUint8List());

  //     await Share.shareXFiles([XFile(pdfPath)], text: 'Sharing PDF');
  //   } catch (e) {
  //     print('Error sharing PDF: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Error sharing PDF'),
  //       ),
  //     );
  //   }
  // }

  // share() async {
  //   final ByteData data = await rootBundle.load('assets/sample.pdf');
  //   final String pdfPath = '${(await getTemporaryDirectory()).path}/sample.pdf';
  //   final File pdfFile = File(pdfPath);
  //   final result = await Share.shareXFiles([XFile('$pdfPath/sample.pdf')],
  //       text: 'Great picture');

  //   if (result.status == ShareResultStatus.success) {
  //     print('Thank you for sharing the picture!');
  //   }
  // }

  bool isEnterStockCard = false;
  GroupsController groupsController = Get.put(GroupsController());
  late List<bool> isCheckedList =
      List.generate(groups.length, (index) => false);
  // bool showAllItems = false;
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

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) => setData());
    super.initState();
  }

  setData() {
    if (groups.isNotEmpty) {
      selectedItem = 0;
      categoryName = groups[0].name;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: isEnterStockCard
          ? AppBar(
              surfaceTintColor: Colors.white,
              leading: InkWell(
                onTap: () {
                  setState(() {
                    isEnterStockCard = !isEnterStockCard;
                  });
                  // scaffoldkey.currentState!.openDrawer();
                },
                child: Icon(
                  Icons.arrow_back_ios_rounded,
                  size: height * 0.039,
                ),
              ),
              title: SizedBox(
                // width: width * 0.6,
                // height: height*0.05,
                child: Text(
                  "Choose the groups and dates to PDF.",
                  style: TextStyle(
                      fontFamily: "Lexand",
                      fontSize: height * 0.018,
                      fontWeight: FontWeight.w500),
                ),
              ),
            )
          : AppBar(
              surfaceTintColor: Colors.white,
              // leading: InkWell(
              //   onTap: () {
              //     Navigator.pop(context);
              //     // scaffoldkey.currentState!.openDrawer();
              //   },
              //   child: Icon(
              //     Icons.arrow_back_ios_rounded,
              //     size: height * 0.039,
              //   ),
              // ),
              title: Text(
                "Select to enter stockcards.",
                style: TextStyle(
                    fontFamily: "Lexand",
                    fontSize: height * 0.018,
                    fontWeight: FontWeight.w500),
              ),
            ),
      body: isEnterStockCard
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "$categoryName",
                          style: TextStyle(
                              color: primaryColor.withOpacity(1.0),
                              fontFamily: "Lexand",
                              fontSize: height * 0.018,
                              fontWeight: FontWeight.w500),
                        ),
                        // InkWell(
                        //   onTap: () {
                        //     setState(() {
                        //       isEnterStockCard = true;
                        //     });
                        //   },
                        //   child: Icon(
                        //     Icons.download_sharp,
                        //     size: height * 0.03,
                        //   ),
                        // )
                      ],
                    ),
                  ),
                  Container(
                    height: height * 0.6,
                    child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: groups.length,
                      itemBuilder: ((context, index) {
                        return InkWell(
                          onTap: () {
                            selectedItem = index;
                            categoryName = groups[index].name;
                            // isCheckedList[index] = !isCheckedList[index];
                            setState(() {});
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              width: height *
                                  0.16, // Reduced size for the container
                              height: height *
                                  0.16, // Reduced size for the container
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: (index == selectedItem)
                                      ? borderColor.withOpacity(1.0)
                                      : Colors.transparent,
                                ),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                    50.0), // Adjusted to half the size
                              ),
                              child: Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      100.0), // Adjusted to half the size
                                  child: Image.asset(
                                    groups[index].imageName,
                                    fit: BoxFit
                                        .contain, // Fit the image within the container
                                    width: height *
                                        0.16, // Reduced size for the image
                                    height: height *
                                        0.16, // Reduced size for the image
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1.0,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            // insetPadding: EdgeInsets.all(0.0),
                            content: Container(
                              // width: double.maxFinite,
                              height: height *
                                  0.3, // Ensure the AlertDialog content has a fixed width
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Calendar",
                                    style: TextStyle(
                                        fontFamily: "Lexand",
                                        fontSize: height * 0.018,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  // SizedBox(height: height * 0.02),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Start Date",
                                          style: TextStyle(
                                            fontFamily: "Lexand",
                                            fontSize: height * 0.013,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * 0.05,
                                        child: TextFormField(
                                          controller: startDate,
                                          decoration: InputDecoration(
                                            suffixIcon: InkWell(
                                              onTap: () {
                                                showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime(1910),
                                                    lastDate: DateTime(2025),
                                                    builder:
                                                        (BuildContext context,
                                                            Widget? child) {
                                                      return Theme(
                                                        data: Theme.of(context)
                                                            .copyWith(
                                                          colorScheme:
                                                              ColorScheme.light(
                                                            primary:
                                                                primaryColor,
                                                            onPrimary:
                                                                Colors.white,
                                                            onSurface:
                                                                Colors.black,
                                                          ),
                                                        ),
                                                        child: child!,
                                                      );
                                                    }).then((value) {
                                                  if (value != null) {
                                                    startDate.text =
                                                        DateFormat('dd-MM-yyyy')
                                                            .format(value);
                                                    startDate.text = value
                                                        .toString()
                                                        .split(" ")
                                                        .first;
                                                    startDateset = value;
                                                    // startDate.text =
                                                    //     value.year.toString();
                                                  }
                                                });
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Image.asset(
                                                  "assets/calendar.png",
                                                  height: height * 0.02,
                                                ),
                                              ),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.only(
                                                    left: 16.0),
                                            label: Text(
                                              "DD-----YYYY",
                                              style: TextStyle(
                                                fontFamily: "Lexand",
                                                fontSize: height * 0.011,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                            floatingLabelStyle: const TextStyle(
                                              fontFamily: "Lexand",
                                              fontWeight: FontWeight.w400,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              borderSide:
                                                  const BorderSide(width: 1.5),
                                            ),
                                            disabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                              borderSide:
                                                  const BorderSide(width: 1.5),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                              borderSide: BorderSide(
                                                color: borderColor
                                                    .withOpacity(1.0),
                                                width: 1.5,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
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
                                  // SizedBox(height: height * 0.02),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "End Date",
                                          style: TextStyle(
                                            fontFamily: "Lexand",
                                            fontSize: height * 0.013,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * 0.05,
                                        child: TextFormField(
                                          controller: endDate,
                                          decoration: InputDecoration(
                                            suffixIcon: InkWell(
                                              onTap: () {
                                                showDatePicker(
                                                  context: context,
                                                  initialDate: startDateset,
                                                  firstDate: startDateset!,
                                                  lastDate: DateTime(2025),
                                                  builder:
                                                      (BuildContext context,
                                                          Widget? child) {
                                                    return Theme(
                                                      data: Theme.of(context)
                                                          .copyWith(
                                                        colorScheme:
                                                            ColorScheme.light(
                                                          primary: primaryColor,
                                                          onPrimary:
                                                              Colors.white,
                                                          onSurface:
                                                              Colors.black,
                                                        ),
                                                      ),
                                                      child: child!,
                                                    );
                                                  },
                                                ).then((value) {
                                                  if (value != null) {
                                                    endDate.text =
                                                        DateFormat('dd-MM-yyyy')
                                                            .format(value);
                                                    endDate.text = value
                                                        .toString()
                                                        .split(" ")
                                                        .first;
                                                    // startDate.text = value.year.toString();
                                                  }
                                                });
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Image.asset(
                                                  "assets/calendar.png",
                                                  height: height * 0.02,
                                                ),
                                              ),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.only(
                                                    left: 16.0),
                                            label: Text(
                                              "DD-----YYYY",
                                              style: TextStyle(
                                                fontFamily: "Lexand",
                                                fontSize: height * 0.011,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            floatingLabelStyle: const TextStyle(
                                              fontFamily: "Lexand",
                                              fontWeight: FontWeight.w400,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              borderSide:
                                                  const BorderSide(width: 1.5),
                                            ),
                                            disabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                              borderSide:
                                                  const BorderSide(width: 1.5),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                              borderSide: BorderSide(
                                                color: borderColor
                                                    .withOpacity(1.0),
                                                width: 1.5,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
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
                                  SizedBox(height: height * 0.02),
                                  InkWell(
                                    onTap: () async {
                                      if (startDate.text.isEmpty) {
                                        AnimatedSnackBar.material(
                                          'Select from date',
                                          type: AnimatedSnackBarType.error,
                                          duration: const Duration(seconds: 2),
                                          mobilePositionSettings:
                                              const MobilePositionSettings(
                                            topOnAppearance: 100,
                                            topOnDissapear: 50,
                                            right: 10,
                                          ),
                                          mobileSnackBarPosition:
                                              MobileSnackBarPosition.top,
                                          desktopSnackBarPosition:
                                              DesktopSnackBarPosition
                                                  .bottomLeft,
                                        ).show(context);
                                        return;
                                      }
                                      if (endDate.text.isEmpty) {
                                        AnimatedSnackBar.material(
                                          'Select end date',
                                          type: AnimatedSnackBarType.error,
                                          duration: const Duration(seconds: 2),
                                          mobilePositionSettings:
                                              const MobilePositionSettings(
                                            topOnAppearance: 100,
                                            topOnDissapear: 50,
                                            right: 10,
                                          ),
                                          mobileSnackBarPosition:
                                              MobileSnackBarPosition.top,
                                          desktopSnackBarPosition:
                                              DesktopSnackBarPosition
                                                  .bottomLeft,
                                        ).show(context);
                                        return;
                                      }
                                      var result = await groupsController
                                          .downloadStockCard(
                                              startDate.text, endDate.text);
                                      Navigator.pop(context);
                                      if (result != null) {
                                        if (result["data"]["category"]
                                                    [categoryName] !=
                                                null &&
                                            result["data"]["category"]
                                                        [categoryName]["stocks"]
                                                    .length >
                                                0) {
                                                await generateInvoice(result["data"]["category"]
                                                        [categoryName]["stocks"]);
                                        } else {
                                          AnimatedSnackBar.material(
                                            'No Data Found',
                                            type: AnimatedSnackBarType.error,
                                            duration:
                                                const Duration(seconds: 2),
                                            mobilePositionSettings:
                                                const MobilePositionSettings(
                                              topOnAppearance: 100,
                                              topOnDissapear: 50,
                                              right: 10,
                                            ),
                                            mobileSnackBarPosition:
                                                MobileSnackBarPosition.top,
                                            desktopSnackBarPosition:
                                                DesktopSnackBarPosition
                                                    .bottomLeft,
                                          ).show(context);
                                        }
                                      }
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: width * 0.02),
                                      child: Container(
                                        height: height * 0.05,
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
                                              "Download",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: "Lexand",
                                                  fontSize: height * 0.011,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: width * 0.08),
                      child: Image.asset(
                        "assets/calendar.png",
                        height: 80,
                        width: width * 0.13,
                      ),
                    ),
                  ),
                  // SizedBox(height: height * 0.02),
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => const StockCardEditScreen(),
                  //       ),
                  //     );
                  //     // share();
                  //     // sharePDF(context);
                  //   },
                  //   child: Padding(
                  //     padding: EdgeInsets.only(left: width * 0.08),
                  //     child: Icon(
                  //       Icons.share_rounded,
                  //       size: height * 0.044,
                  //     ),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: EdgeInsets.only(left: width * 0.08),
                  //   child: Icon(
                  //     Icons.calendar_month,
                  //     size: height*0.044,
                  //   ),
                  // )
                  // InkWell(
                  //   onTap: () {
                  //     setState(() {
                  //       isEnterStockCard = true;
                  //     });
                  //   },
                  //   child: Padding(
                  //     padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                  //     child: Container(
                  //       height: height * 0.05,
                  //       // width: width,
                  //       decoration: BoxDecoration(
                  //         color: primaryColor.withOpacity(1.0),
                  //         borderRadius: BorderRadius.circular(5.0),
                  //       ),
                  //       child: Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: Center(
                  //           child: Text(
                  //             "Enter Stockcards",
                  //             style: TextStyle(
                  //                 color: Colors.white,
                  //                 fontFamily: "Lexand",
                  //                 fontSize: height * 0.016,
                  //                 fontWeight: FontWeight.w600),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "$categoryName",
                          style: TextStyle(
                              color: primaryColor.withOpacity(1.0),
                              fontFamily: "Lexand",
                              fontSize: height * 0.018,
                              fontWeight: FontWeight.w500),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              isEnterStockCard = true;
                            });
                          },
                          child: Icon(
                            Icons.download_sharp,
                            size: height * 0.03,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: height * 0.6,
                    child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: groups.length,
                      itemBuilder: ((context, index) {
                        return InkWell(
                          onTap: () {
                            selectedItem = index;
                            categoryName = groups[index].name;
                            // isCheckedList[index] = !isCheckedList[index];
                            setState(() {});
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              width: height *
                                  0.16, // Reduced size for the container
                              height: height *
                                  0.16, // Reduced size for the container
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: (selectedItem == index)
                                      ? borderColor.withOpacity(1.0)
                                      : Colors.transparent,
                                ),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                    50.0), // Adjusted to half the size
                              ),
                              child: Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      100.0), // Adjusted to half the size
                                  child: Image.asset(
                                    groups[index].imageName,
                                    fit: BoxFit
                                        .contain, // Fit the image within the container
                                    width: height *
                                        0.16, // Reduced size for the image
                                    height: height *
                                        0.16, // Reduced size for the image
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StockCardEditScreen(
                            categoryName: categoryName,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                      child: Container(
                        height: height * 0.05,
                        // width: width,
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(1.0),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              "Enter Stockcards",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Lexand",
                                  fontSize: height * 0.016,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }



  Future<void> generateInvoice(List<dynamic>? data) async {
    //Create a PDF document.
    final PdfDocument document = PdfDocument();
    //Add page to the PDF
    final PdfPage page = document.pages.add();
    //Get page client size
    final Size pageSize = page.getClientSize();
    String? currency = await storage.read(key: "currency");

    final PdfGrid grid = getGrid(data,currency);
    //Draw the header section by creating text element
    // final PdfLayoutResult result = await drawHeader(page, pageSize, grid, data);
    //Draw grid
    await drawGrid(page, grid, data, pageSize);
    //Add invoice footer
    // await drawFooter(page, pageSize);
    //Save the PDF document
    final List<int> bytes = document.saveSync();
    //Dispose the document.
    document.dispose();
    //Save and launch the file.
    await saveAndLaunchFile(bytes, "${DateTime.now().microsecondsSinceEpoch}.pdf");
    // if (type == "share") {
    //   Share.shareXFiles([XFile(file.path)], text: '${data.name}');
    // }
  }

  //Draws the grid
  Future drawGrid(PdfPage page, PdfGrid grid,
      List<dynamic>? data, Size pageSize) async {
    // Rect? totalPriceCellBounds;
    // Rect? quantityCellBounds;
    // //Invoke the beginCellLayout event.
    // grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
    //   final PdfGrid grid = sender as PdfGrid;
    //   if (args.cellIndex == grid.columns.count - 1) {
    //     totalPriceCellBounds = args.bounds;
    //   } else if (args.cellIndex == grid.columns.count - 2) {
    //     quantityCellBounds = args.bounds;
    //   }
    // };
    grid.draw(
    page: page,
    bounds: Rect.fromLTWH(
        0, 0, page.getClientSize().width, page.getClientSize().height));
  }

  //Create PDF grid and return
  PdfGrid getGrid(List<dynamic>? data, String? currency) {
    //Create a PDF grid
    final PdfGrid grid = PdfGrid();
    //Secify the columns count to the grid.
    grid.columns.add(count: 10);
    //Create the header row of the grid.
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    //Set style
    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
    headerRow.style.font = PdfStandardFont(PdfFontFamily.helvetica, 7.5);
    headerRow.style.textBrush = PdfBrushes.white;
    headerRow.cells[0].value = 'No';
    headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[1].value = 'Category';
    headerRow.cells[2].value = 'Item';
    headerRow.cells[3].value = 'Stock';
    headerRow.cells[4].value = 'PlanToBuy';
    headerRow.cells[5].value = 'Bought';
    headerRow.cells[6].value = 'Price';
    headerRow.cells[7].value = 'Consumption';
    headerRow.cells[8].value = 'ClosingStock';
    headerRow.cells[9].value = 'Date';
    headerRow.cells[9].stringFormat.alignment = PdfTextAlignment.center;
    for (int i = 0; i < data!.length; i++) {
      addProducts('${i + 1}',data[i], grid,currency);
    }
    //Apply the table built-in style
    grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent5);
    //Set gird columns width
    grid.columns[1].width = 100;
    grid.columns[0].width = 20;
    // grid.columns[2].width = 40;
    // for (int i = 0; i < headerRow.cells.count; i++) {
    //   headerRow.cells[i].style.cellPadding =
    //       PdfPaddings(bottom: 5, left: 1, right: 1, top: 5);
    // }
    for (int i = 0; i < grid.rows.count; i++) {
      final PdfGridRow row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j];
        if (j == 0) {
          cell.stringFormat.alignment = PdfTextAlignment.center;
        }
        cell.style.cellPadding =
            PdfPaddings(bottom: 5, left: 1, right: 1, top: 5);
      }
    }
    return grid;
  }

  //Create and row for the grid.
  void addProducts(String productId,dynamic data, PdfGrid grid, String? currency) {
    final PdfGridRow row = grid.rows.add();
    row.style =
        PdfGridRowStyle(font: PdfStandardFont(PdfFontFamily.helvetica, 7.5));
    row.cells[0].value = productId;
    row.cells[1].value = data["datas"][0]["category"]??"";
    row.cells[2].value = data["datas"][0]["item"]??"";
    row.cells[3].value = "${data["datas"][0]["stockCount"]??"0"} Kg";
    row.cells[4].value = "${data["datas"][0]["planToBuy"]??"0"} kg";
    row.cells[5].value = "${data["datas"][0]["bought"]??"0"} kg";
    row.cells[6].value = "$currency ${data["datas"][0]["pricePerUnit"]??"0"}";
    row.cells[7].value = "${data["datas"][0]["consumption"]??"0"} kg";
    row.cells[8].value = "${data["datas"][0]["closingStock"]??"0"} kg";
    row.cells[9].value = data["datas"][0]["datecreated"]??"";
  }

}
