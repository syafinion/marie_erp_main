/*
 * File: stock_card_edit_screen.dart
 * Project: Marie ERP
 * Created Date: 2024
 * 
 * Copyright (c) 2024 Group 17
 * 
 * Authors:
 * - Syafiq
 * 
 * Description:
 * A Flutter widget that implements the stock card editing functionality.
 * Provides detailed stock tracking with monthly summaries, usage analytics,
 * and wastage breakdowns. Features interactive data visualization and
 * real-time updates.
 * 
 * Features:
 * - Monthly stock summary with in/out tracking
 * - Usage and wastage analytics with pie charts
 * - Detailed breakdown of processing/packaging/environmental waste
 * - Real-time stock level monitoring
 * - Interactive data editing capabilities
 * - Filtered ingredient selection
 * - Cost analysis and pricing calculations
 * 
 * Libraries Used:
 * - flutter/material.dart - Flutter's material design widgets
 * - get - State management (GetX)
 * - pie_chart - Data visualization
 * - intl - Date formatting
 * - animated_snack_bar - Toast notifications
 * - flutter_custom_month_picker - Month selection
 * 
 * External Dependencies:
 * - get: ^4.6.5
 *   Source: https://pub.dev/packages/get
 * - pie_chart: ^5.3.2
 *   Source: https://pub.dev/packages/pie_chart
 * - intl: ^0.18.0
 *   Source: https://pub.dev/packages/intl
 * - animated_snack_bar: ^0.3.1
 *   Source: https://pub.dev/packages/animated_snack_bar
 * - flutter_custom_month_picker: ^1.0.0
 *   Source: https://pub.dev/packages/flutter_custom_month_picker
 * 
 * Assets Required:
 * - right-icon.png - Navigation icon
 * - calendar.png - Date picker icon
 * 
 * State Management:
 * - Uses GetX for store room state (StoreRoomController)
 * - Local form state managed with setState
 * - Monthly data filtering and calculations
 * 
 * Modified/Adapted From:
 * - Flutter data table implementation guide
 *   Source: https://api.flutter.dev/flutter/material/DataTable-class.html
 * - GetX state management patterns
 *   Source: https://github.com/jonataslaw/getx/blob/master/documentation/en_US/state_management.md
 * - Pie Chart implementation guide
 *   Source: https://pub.dev/packages/pie_chart/example
 */

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
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
    final selectedIng = storeRoomController.ingredientList.firstWhere(
      (e) => e.ingredientId == ingredientId,
      orElse: () => storeRoomController.ingredientList.first,
    );

// ── use the same date string you already have in stackAddingDate:
    final initialDate = DateTime.parse(stackAddingDate.text);
    final initialDateStr = DateFormat("d/M/yyyy").format(initialDate);

    // 1. filter and sort this month’s records
    final list = storeRoomController.stockList.where((s) {
      final d = DateTime.parse(s.datecreated!);
      return d.month == currentMonth && d.year == currentYear;
    }).toList()
      ..sort((a, b) => DateTime.parse(a.datecreated!)
          .compareTo(DateTime.parse(b.datecreated!)));

    // ─── include the initial packageWeight as stock-in ─────────────────
    final int initialWeight =
        int.tryParse(selectedIng.packageWeight ?? '0') ?? 0;
    final double unitPrice =
        double.tryParse(selectedIng.unitPrice ?? '0') ?? 0.0;

    // month’s transactions
    final int sumInTx = list.fold<int>(
        0, (sum, s) => sum + (int.tryParse(s.stockCount ?? '0') ?? 0));
    final int sumOutTx = list.fold<int>(
        0, (sum, s) => sum + (int.tryParse(s.consumption ?? '0') ?? 0));

    // now combine
    final String unit = selectedIng.measurement ?? '';
    final int opening = initialWeight; // initial stock
    final int totalIn = initialWeight + sumInTx; // include initial
    final int totalOut = sumOutTx;
    final int closing = opening + sumInTx - totalOut;

    // cost: transactions + initial
    final double txCostSum = list.fold<double>(
        0.0,
        (sum, s) =>
            sum +
            (int.tryParse(s.stockCount ?? '0') ?? 0) *
                (double.tryParse(s.pricePerUnit ?? '0') ?? 0.0));
    final double initialCost = initialWeight * unitPrice;
    final double avgPrice =
        totalIn > 0 ? (initialCost + txCostSum) / totalIn : 0.0;

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
                  _buildStat("Opening", "$opening $unit"),
                  _buildStat("In", "$totalIn $unit"),
                  _buildStat("Out", "$totalOut $unit"),
                  _buildStat("Closing", "$closing $unit"),
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
                        child: Text("Total Price",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "Lexand",
                              fontWeight: FontWeight.w600,
                            )),
                      ),
                    ],
                  ),

                  // 1) “Stock In” initial row comes from the ingredient’s packageWeight
                  TableRow(
                    children: [
                      // date
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          initialDateStr,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontFamily: "Lexand"),
                        ),
                      ),

                      // Stock In ← packageWeight from the selected ingredient
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          selectedIng.packageWeight ?? '–',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontFamily: "Lexand"),
                        ),
                      ),

                      // Stock Out
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          '–',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontFamily: "Lexand"),
                        ),
                      ),

                      // Total Price ← unitPrice from the selected ingredient
                      // Total Price ← initialCost
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          initialWeight > 0
                              ? (initialWeight * unitPrice).toStringAsFixed(2)
                              : '–',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontFamily: "Lexand"),
                        ),
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
                        // 3) Total Price = stockCount × pricePerUnit
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Builder(builder: (_) {
                            final int qty =
                                int.tryParse(s.stockCount ?? '0') ?? 0;
                            final double ppu =
                                double.tryParse(s.pricePerUnit ?? '0') ?? 0.0;
                            final double total = qty * ppu;
                            return Text(
                              qty > 0
                                  ? total.toStringAsFixed(2) // e.g. “15.00”
                                  : '–',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontFamily: "Lexand"),
                            );
                          }),
                        ),
                      ],
                    ),
                ],
              ),

              // optional “no transactions” note
              if (list.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    "No stock-in/-out records for this month",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: borderColor),
                  ),
                ),

              const SizedBox(height: 24),

              // ─── footer with actual numbers ────────────────────────
              Text(
                "Closing Balance: "
                "$opening + $totalIn − $totalOut = $closing",
                style: const TextStyle(
                  fontFamily: "Lexand",
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Total Stock In : $totalIn $unit",
                style: const TextStyle(
                  fontFamily: "Lexand",
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Total Stock Out : $totalOut $unit",
                style: const TextStyle(
                  fontFamily: "Lexand",
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Average Price /RM per $unit: ${avgPrice.toStringAsFixed(2)}",
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
    // ─── pull in the “initial” package weight ─────────────────────────
    final selectedIng = storeRoomController.ingredientList.firstWhere(
      (e) => e.ingredientId == ingredientId,
      orElse: () => storeRoomController.ingredientList.first,
    );
    final int initialWeight =
        int.tryParse(selectedIng.packageWeight ?? '0') ?? 0;
    final double unitPrice =
        double.tryParse(selectedIng.unitPrice ?? '0') ?? 0.0;

    final unit =
        list.isNotEmpty ? list.first.unit : selectedIng.measurement ?? '';

    // 1. compute actual usage & wastage (unchanged)
    final actualUsage = list.fold<double>(
      0.0,
      (sum, s) => sum + (double.tryParse(s.consumption ?? '0') ?? 0.0),
    );

    // 2. include initialWeight in total-in
    final double sumInTx = list.fold<double>(
      0.0,
      (sum, s) => sum + (double.tryParse(s.stockCount ?? '0') ?? 0.0),
    );
    final double totalIn = initialWeight + sumInTx;

    final wastage = (totalOut - actualUsage).clamp(0.0, totalOut.toDouble());

    // 3. include initialCost alongside transaction costs
    final double txCostSum = list.fold<double>(
      0.0,
      (sum, s) {
        final qty = double.tryParse(s.stockCount ?? '0') ?? 0.0;
        final ppu = double.tryParse(s.pricePerUnit ?? '0') ?? 0.0;
        return sum + qty * ppu;
      },
    );

    final double initialCost = initialWeight * unitPrice;
    final double avgPrice =
        totalIn > 0 ? (initialCost + txCostSum) / totalIn : 0.0;

    final double totalPrice = initialCost +
        list.fold<double>(
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

    // 2. cost metrics
    final double totalCost = avgPrice * totalOut;
    // final actualUsagePrice = avgPrice * actualUsage;
    // final wastageCost = totalCost - actualUsagePrice;
    final double usageCost = avgPrice * usageKg;
    final double wastageCost = avgPrice * wastageKg;

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
              value: "${usageKg.toStringAsFixed(1)} $unit",
              percent: usagePct,
              color: Colors.teal,
              icon: Icons.trending_up,
            ),
            const SizedBox(width: 12),
            _MetricCard(
              title: "Wastage",
              value: "${wastageKg.toStringAsFixed(1)} $unit",
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
                "Wastage: ${wastageKg.toStringAsFixed(1)} $unit",
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
                DataCell(Text("${totalOut.toStringAsFixed(1)} $unit")),
              ]),
              DataRow(cells: [
                const DataCell(Text("Actual Usage")),
                DataCell(Text("${usageKg.toStringAsFixed(1)} $unit")),
              ]),
              DataRow(cells: [
                const DataCell(Text("Wastage")),
                DataCell(Text("${wastageKg.toStringAsFixed(1)} $unit")),
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
                DataCell(Text("RM ${usageCost.toStringAsFixed(2)}")),
              ]),
              DataRow(cells: [
                const DataCell(Text("Wastage Cost")),
                DataCell(Text("RM ${wastageCost.toStringAsFixed(2)}")),
              ]),
            ],
          ),
        ),

        const SizedBox(height: 16),
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
      drawer: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        child: Drawer(
          elevation: 8,
          child: SafeArea(
            child: Column(
              children: [
                // ─── Header with Search ───────────────────────────
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                  width: double.infinity,
                  color: primaryColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.categoryName ?? '',
                        style: const TextStyle(
                          fontFamily: 'Lexand',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _searchController,
                        onChanged: (q) => setState(() => _searchQuery = q),
                        decoration: InputDecoration(
                          hintText: 'Search…',
                          hintStyle: const TextStyle(color: Colors.white70),
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.white70),
                          filled: true,
                          fillColor: Colors.white24,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),

                // ─── Filtered Ingredient List ────────────────────
                Expanded(
                  child: Obx(() {
                    final allItems = storeRoomController.ingredientList;
                    final filtered = _searchQuery.isEmpty
                        ? allItems
                        : allItems
                            .where((e) => e.ingredient!
                                .toLowerCase()
                                .contains(_searchQuery.toLowerCase()))
                            .toList();

                    return ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (ctx, idx) {
                        final data = filtered[idx];
                        final isSelected = data.ingredientId == ingredientId;

                        return Material(
                          color:
                              isSelected ? primaryColor.withOpacity(0.1) : null,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: isSelected
                                  ? primaryColor
                                  : Colors.grey.shade300,
                              child: Text(
                                data.ingredient![0].toUpperCase(),
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.grey.shade700,
                                ),
                              ),
                            ),
                            title: Text(
                              data.ingredient!,
                              style: TextStyle(
                                fontFamily: 'Lexand',
                                fontSize: 16,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color:
                                    isSelected ? primaryColor : Colors.black87,
                              ),
                            ),
                            trailing: isSelected
                                ? Icon(Icons.keyboard_arrow_right,
                                    color: primaryColor)
                                : null,
                            onTap: () async {
                              // preserve your original tap behavior:
                              setState(() {
                                ingredientId = data.ingredientId;
                                selectedIngredient = data.ingredient!;
                              });
                              Navigator.of(context).pop();
                              await storeRoomController.stockListApi(
                                category: widget.categoryName!,
                                item: ingredientId!,
                              );
                              if (storeRoomController.stockList.isNotEmpty) {
                                stockRecordId = storeRoomController
                                    .stockList.last.id
                                    .toString();
                              }
                              setState(() {});
                            },
                          ),
                        );
                      },
                    );
                  }),
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
                ? _buildMonthlySummaryCard()
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
    final _formKey = GlobalKey<FormState>();
    final h = MediaQuery.of(context).size.height;

    // Prefill the controllers:
    alertProcessingPct.text = processingPct.toString();
    alertPackagingPct.text = packagingPct.toString();
    alertEnvironmentPct.text = environmentPct.toString();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Form(
          key: _formKey,
          child: Column(
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
                validator: (value) {
                  final n = int.tryParse(value ?? '');
                  if (value == null || value.isEmpty) {
                    return 'Please enter a value';
                  } else if (n == null) {
                    return 'Must be a number';
                  } else if (n < 0 || n > 100) {
                    return 'Enter 0–100';
                  }
                  return null;
                },
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
                validator: (value) {
                  final n = int.tryParse(value ?? '');
                  if (value == null || value.isEmpty) {
                    return 'Please enter a value';
                  } else if (n == null) {
                    return 'Must be a number';
                  } else if (n < 0 || n > 100) {
                    return 'Enter 0–100';
                  }
                  return null;
                },
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
                validator: (value) {
                  final n = int.tryParse(value ?? '');
                  if (value == null || value.isEmpty) {
                    return 'Please enter a value';
                  } else if (n == null) {
                    return 'Must be a number';
                  } else if (n < 0 || n > 100) {
                    return 'Enter 0–100';
                  }
                  return null;
                },
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
                        // Validate all fields first
                        if (!_formKey.currentState!.validate()) return;
                        // 2) now check that the three add up to at most 100
                        final p = int.parse(alertProcessingPct.text);
                        final pack = int.parse(alertPackagingPct.text);
                        final e = int.parse(alertEnvironmentPct.text);
                        final total = p + pack + e;
                        if (total > 100) {
                          AnimatedSnackBar.material(
                            'Total breakdown cannot exceed 100%',
                            type: AnimatedSnackBarType.error,
                          ).show(context);
                          return;
                        }
                        try {
                          final res = await storeRoomController.editStock(
                            stockId: stockId,
                            processingPct: int.parse(alertProcessingPct.text),
                            packagingPct: int.parse(alertPackagingPct.text),
                            environmentPct: int.parse(alertEnvironmentPct.text),
                          );

                          if (res != null) {
                            AnimatedSnackBar.material(
                              'Breakdown updated',
                              type: AnimatedSnackBarType.success,
                            ).show(context);

                            // re-fetch by ingredientId
                            await storeRoomController.stockListApi(
                              category: widget.categoryName!,
                              item: ingredientId!,
                            );

                            if (storeRoomController.stockList.isNotEmpty) {
                              stockRecordId = storeRoomController
                                  .stockList.last.id
                                  .toString();
                            }

                            setState(() {});
                            Navigator.of(context).pop();
                          } else {
                            // API returned error
                            AnimatedSnackBar.material(
                              'Failed to update. Try again.',
                              type: AnimatedSnackBarType.error,
                            ).show(context);
                          }
                        } catch (e) {
                          AnimatedSnackBar.material(
                            'Invalid input or network error',
                            type: AnimatedSnackBarType.error,
                          ).show(context);
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
      ),
    );
  }
}
