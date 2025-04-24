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
import 'package:pie_chart/pie_chart.dart';
import '../constants/color.dart';
import 'dart:math' as math;

import '../controller/store_room_controller.dart';

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final double percent;
  final Color color;
  final IconData icon;

  const _MetricCard({
    Key? key,
    required this.title,
    required this.value,
    required this.percent,
    required this.color,
    required this.icon, // <-- trailing comma is fine
  }) : super(key: key); // ← closing parenthesis here

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.15),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: Colors.grey.shade600)),
                  Text(
                    value,
                    style: const TextStyle(
                      fontFamily: "Lexand",
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text("${percent.toStringAsFixed(0)}%",
                      style: TextStyle(color: color)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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

  final TextEditingController alertProcessingPct = TextEditingController();
  final TextEditingController alertPackagingPct = TextEditingController();
  final TextEditingController alertEnvironmentPct = TextEditingController();

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
  String? stockRecordId = "";
  String? ingredientId = "";
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
    // clear any old data
    storeRoomController.ingredientList.clear();
    storeRoomController.stockList.clear();

    // re-fetch all ingredients in this category
    await storeRoomController.stroreRoomingredientsList(widget.categoryName!);

    if (storeRoomController.ingredientList.isNotEmpty) {
      selectedIndex = 0;
      final first = storeRoomController.ingredientList[0];
      ingredientId = first.ingredientId;
      selectedIngredient = first.ingredient!;

      if (ingredientId != null) {
        await storeRoomController.stockListApi(
          category: widget.categoryName!,
          item: ingredientId!,
        );
        // now grab the actual Stock record’s PK
        if (storeRoomController.stockList.isNotEmpty) {
          stockRecordId = storeRoomController.stockList.last.id.toString();
        }
      }

      setState(() {});
    }
  }

  Widget _buildMonthlySummaryCard() {
    // 1. filter and sort this month’s records
    final list = storeRoomController.stockList.where((s) {
      final d = DateTime.parse(s.datecreated!);
      return d.month == currentMonth && d.year == currentYear;
    }).toList()
      ..sort((a, b) => DateTime.parse(a.datecreated!)
          .compareTo(DateTime.parse(b.datecreated!)));

    if (list.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          "No stock data for this month",
          style: TextStyle(fontFamily: "Lexand", color: borderColor),
        ),
      );
    }

    // 2. compute opening, totalIn, totalOut, closing
    final opening = int.tryParse(list.first.stockCount ?? '0') ?? 0;
    final totalIn = list.fold<int>(
      0,
      (sum, s) => sum + (int.tryParse(s.stockCount ?? '0') ?? 0),
    );
    final totalOut = list.fold<int>(
      0,
      (sum, s) => sum + (int.tryParse(s.consumption ?? '0') ?? 0),
    );
    final closing = opening + totalIn - totalOut;

    // 3. average price = sum of all prices ÷ totalIn
    final priceSum = list.fold<double>(
      0.0,
      (sum, s) => sum + (double.tryParse(s.pricePerUnit ?? '0') ?? 0.0),
    );
    final avgPrice = totalIn > 0 ? priceSum / totalIn : 0.0;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ─── summary row ──────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStat("Opening", "$opening kg"),
                  _buildStat("In", "$totalIn kg"),
                  _buildStat("Out", "$totalOut kg"),
                  _buildStat("Closing", "$closing kg"),
                ],
              ),

              const SizedBox(height: 24),

              // ─── daily table ───────────────────────────────────────
              Table(
                border: TableBorder(
                  horizontalInside:
                      BorderSide(color: borderColor.withOpacity(0.3)),
                  bottom: BorderSide(color: borderColor.withOpacity(0.3)),
                ),
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(),
                  2: FlexColumnWidth(),
                  3: FlexColumnWidth(),
                },
                children: [
                  // header
                  TableRow(
                    decoration:
                        BoxDecoration(color: borderColor.withOpacity(0.1)),
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text("Date",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "Lexand",
                              fontWeight: FontWeight.w600,
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text("Stock In",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "Lexand",
                              fontWeight: FontWeight.w600,
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text("Stock Out",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "Lexand",
                              fontWeight: FontWeight.w600,
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text("Price/kg",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "Lexand",
                              fontWeight: FontWeight.w600,
                            )),
                      ),
                    ],
                  ),
                  // data rows
                  for (var s in list)
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            DateFormat("d/M/yyyy")
                                .format(DateTime.parse(s.datecreated!)),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontFamily: "Lexand"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            s.stockCount ?? "0",
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontFamily: "Lexand"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            s.consumption ?? "0",
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontFamily: "Lexand"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            s.pricePerUnit ?? "0",
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontFamily: "Lexand"),
                          ),
                        ),
                      ],
                    ),
                ],
              ),

              const SizedBox(height: 24),

              // ─── footer with actual numbers ────────────────────────
              Text(
                "Opening + In − Out = Closing ⇒ "
                "$opening + $totalIn − $totalOut = $closing",
                style: const TextStyle(
                  fontFamily: "Lexand",
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Total Stock In : $totalIn kg",
                style: const TextStyle(
                  fontFamily: "Lexand",
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Total Stock Out : $totalOut kg",
                style: const TextStyle(
                  fontFamily: "Lexand",
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Average Price /RM per kg: ${avgPrice.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontFamily: "Lexand",
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// small helper to keep the stats row DRY
  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: "Lexand",
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontFamily: "Lexand",
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildUsageWastageDashboard(
    List<Stocks> list,
    int totalOut,
    double avgPrice,
    double width,
  ) {
    // 1. compute actual usage & wastage
    final actualUsage = list.fold<double>(
      0.0,
      (sum, s) => sum + (double.tryParse(s.consumption ?? '0') ?? 0.0),
    );

    final totalIn = list.fold<double>(
      0.0,
      (sum, s) => sum + (double.tryParse(s.stockCount ?? '0') ?? 0.0),
    );

    final wastage = (totalOut - actualUsage).clamp(0.0, totalOut.toDouble());

    // 2. cost metrics
    final totalCost = avgPrice * totalOut;
    final actualUsagePrice = avgPrice * actualUsage;
    final wastageCost = totalCost - actualUsagePrice;
    final totalPrice = list.fold<double>(
      0.0,
      (sum, s) =>
          sum +
          (double.tryParse(s.pricePerUnit ?? '0') ?? 0.0) *
              (double.tryParse(s.stockCount ?? '0') ?? 0.0),
    );

    // 3. breakdown percentages (you can replace these with your real fields)
    final latest = list.last;
    final processingPct = latest.processingPct;
    final packagingPct = latest.packagingPct;
    final environmentPct = latest.environmentPct;

    // 3. compute wastage in kg = usage * (sum of breakdown %) / 100
    final sumPct = processingPct + packagingPct + environmentPct;
    final wastageKg = actualUsage * sumPct / 100.0;

    // 4. compute “good” usage (what remains after wastage)
    final usageKg = actualUsage - wastageKg;

    // 5. percentages for your metric cards
    final usagePct = totalOut > 0 ? (usageKg / totalOut) * 100.0 : 0.0;
    final wastePct = totalOut > 0 ? (wastageKg / totalOut) * 100.0 : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ─── Top metric cards ────────────────────────────
        Row(
          children: [
            _MetricCard(
              title: "Usage",
              value: "${usageKg.toStringAsFixed(1)} kg",
              percent: usagePct,
              color: Colors.teal,
              icon: Icons.trending_up,
            ),
            const SizedBox(width: 12),
            _MetricCard(
              title: "Wastage",
              value: "${wastageKg.toStringAsFixed(1)} kg",
              percent: wastePct,
              color: Colors.deepOrange,
              icon: Icons.delete_outline,
            ),
          ],
        ),
        const SizedBox(height: 24),

        // ─── Pie chart ───────────────────────────────────
        Card(
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: PieChart(
              dataMap: {
                "Usage": usageKg,
                "Wastage": wastageKg,
              },
              chartRadius: width * 0.35,
              initialAngleInDegree: 0,
              chartType: ChartType.disc,
              centerText: "${usagePct.toStringAsFixed(0)}%",
              chartValuesOptions:
                  const ChartValuesOptions(showChartValues: false),
              legendOptions: LegendOptions(
                showLegends: true,
                legendPosition: LegendPosition.bottom,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // ─── Breakdown header + edit button ────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Wastage: ${wastageKg.toStringAsFixed(1)} kg",
                style: const TextStyle(
                  fontFamily: "Lexand",
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.deepOrange),
                onPressed: () {
                  if (stockRecordId != null && stockRecordId!.isNotEmpty) {
                    _showEditItemModal(
                      context,
                      stockRecordId!,
                      processingPct,
                      packagingPct,
                      environmentPct,
                    );
                  }
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // ─── Breakdown table ────────────────────────────
        Card(
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Table(
            border: TableBorder.all(color: Colors.grey.shade300),
            columnWidths: const {
              0: FlexColumnWidth(),
              1: FlexColumnWidth(),
              2: FlexColumnWidth(),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(color: Colors.grey.shade100),
                children: const [
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Text("Processing / %",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "Lexand", fontWeight: FontWeight.w600)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Text("Packaging / %",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "Lexand", fontWeight: FontWeight.w600)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Text("Environment / %",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "Lexand", fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text("$processingPct",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontFamily: "Lexand")),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text("$packagingPct",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontFamily: "Lexand")),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text("$environmentPct",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontFamily: "Lexand")),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // ─── Detailed breakdown table ─────────────────────
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          child: DataTable(
            headingRowColor:
                MaterialStateColor.resolveWith((_) => Colors.grey.shade100),
            columns: const [
              DataColumn(label: Text("Metric")),
              DataColumn(label: Text("Value")),
            ],
            rows: [
              DataRow(cells: [
                const DataCell(Text("Total Stock Out")),
                DataCell(Text("${totalOut.toStringAsFixed(1)} kg")),
              ]),
              DataRow(cells: [
                const DataCell(Text("Actual Usage")),
                DataCell(Text("${usageKg.toStringAsFixed(1)} kg")),
              ]),
              DataRow(cells: [
                const DataCell(Text("Wastage")),
                DataCell(Text("${wastageKg.toStringAsFixed(1)} kg")),
              ]),
              DataRow(cells: [
                const DataCell(Text("Avg. Price")),
                DataCell(Text("RM ${avgPrice.toStringAsFixed(2)}")),
              ]),
              DataRow(cells: [
                const DataCell(Text("Total Cost")),
                DataCell(Text("RM ${totalCost.toStringAsFixed(2)}")),
              ]),
              DataRow(cells: [
                const DataCell(Text("Usage Cost")),
                DataCell(Text("RM ${actualUsagePrice.toStringAsFixed(2)}")),
              ]),
              DataRow(cells: [
                const DataCell(Text("Wastage Cost")),
                DataCell(Text("RM ${wastageCost.toStringAsFixed(2)}")),
              ]),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // ─── Formulas ──────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Formulas:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                "Actual Usage Price = Usage × Avg. Price = "
                "${usageKg.toStringAsFixed(1)} kg × RM ${avgPrice.toStringAsFixed(2)} "
                "= RM ${actualUsagePrice.toStringAsFixed(2)}",
              ),
              Text(
                "Total Cost = Avg. Price × Stock Out = "
                "RM ${avgPrice.toStringAsFixed(2)} × ${totalOut.toStringAsFixed(1)} kg "
                "= RM ${totalCost.toStringAsFixed(2)}",
              ),
              Text(
                "Wastage Cost = Total Cost − Usage Cost = "
                "RM ${totalCost.toStringAsFixed(2)} − RM ${actualUsagePrice.toStringAsFixed(2)} "
                "= RM ${wastageCost.toStringAsFixed(2)}",
              ),
            ],
          ),
        ),
      ],
    );
  }

  int selectedIndex = -1;
  bool isSelected = false;
  String selectedIngredient = '';
  String selectedStockId = '';
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    final filteredList = storeRoomController.stockList.where((s) {
      final d = DateTime.parse(s.datecreated!);
      return d.month == currentMonth && d.year == currentYear;
    }).toList()
      ..sort((a, b) => DateTime.parse(a.datecreated!)
          .compareTo(DateTime.parse(b.datecreated!)));

    // ── 1. recompute this month’s list & metrics ────────────────────────
    final monthlyList = storeRoomController.stockList.where((s) {
      final d = DateTime.parse(s.datecreated!);
      return d.month == currentMonth && d.year == currentYear;
    }).toList()
      ..sort((a, b) => DateTime.parse(a.datecreated!)
          .compareTo(DateTime.parse(b.datecreated!)));

    final totalOut = monthlyList.fold<int>(
      0,
      (sum, s) => sum + (int.tryParse(s.consumption ?? '0') ?? 0),
    );
    final totalIn = monthlyList.fold<int>(
      0,
      (sum, s) => sum + (int.tryParse(s.bought ?? '0') ?? 0),
    );
    final priceSum = monthlyList.fold<double>(
      0.0,
      (sum, s) => sum + (double.tryParse(s.pricePerUnit ?? '0') ?? 0.0),
    );
    final avgPrice = totalIn > 0 ? priceSum / totalIn : 0.0;

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
                            onTap: () async {
                              selectedIndex = index;
                              final data =
                                  storeRoomController.ingredientList[index];
                              ingredientId = data.ingredientId;
                              selectedIngredient = data.ingredient!;
                              scaffoldkey.currentState!.closeDrawer();

                              if (ingredientId != null) {
                                await storeRoomController.stockListApi(
                                  category: widget.categoryName!,
                                  item: ingredientId!,
                                );
                                if (storeRoomController.stockList.isNotEmpty) {
                                  stockRecordId = storeRoomController
                                      .stockList.last.id
                                      .toString();
                                }
                              }

                              setState(() {});
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
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, anim) => SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -1), // ↑ off-screen above
                    end: Offset.zero,
                  ).animate(anim),
                  child: child,
                ),
                child: isAddButtonClicked
                    ? _buildUsageWastageDashboard(
                        monthlyList, totalOut, avgPrice, width)
                    : const SizedBox.shrink(),
              ),
            ),
            (ingredientId != null && ingredientId!.isNotEmpty)
                ? Obx(() => _buildMonthlySummaryCard())
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      "Select Ingredient",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: borderColor,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  void _showEditItemModal(
    BuildContext context,
    String stockId,
    int processingPct,
    int packagingPct,
    int environmentPct,
  ) {
    final h = MediaQuery.of(context).size.height;

    // Prefill the controllers:
    alertProcessingPct.text = processingPct.toString();
    alertPackagingPct.text = packagingPct.toString();
    alertEnvironmentPct.text = environmentPct.toString();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Edit Wastage Breakdown",
              style: TextStyle(
                fontFamily: "Lexand",
                fontSize: h * 0.02,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Processing %
            TextFormField(
              controller: alertProcessingPct,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Processing %",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Packaging %
            TextFormField(
              controller: alertPackagingPct,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Packaging %",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Environment %
            TextFormField(
              controller: alertEnvironmentPct,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Environment %",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final res = await storeRoomController.editStock(
                        stockId: stockId,
                        processingPct: int.parse(alertProcessingPct.text),
                        packagingPct: int.parse(alertPackagingPct.text),
                        environmentPct: int.parse(alertEnvironmentPct.text),
                      );
                      if (res != null) {
                        // show success
                        AnimatedSnackBar.material(
                          'Breakdown updated',
                          type: AnimatedSnackBarType.success,
                        ).show(context);

                        // re-fetch by ingredientId (NOT stockRecordId!)
                        await storeRoomController.stockListApi(
                          category: widget.categoryName!,
                          item: ingredientId!,
                        );
                        // grab the new latest
                        if (storeRoomController.stockList.isNotEmpty) {
                          stockRecordId =
                              storeRoomController.stockList.last.id.toString();
                        }

                        setState(() {});
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text("Save"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
