import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart'; // Ensure this dependency is in your pubspec.yaml
import '../constants/color.dart';

class StockCardListScreen extends StatefulWidget {
  final String categoryName;

  const StockCardListScreen({Key? key, required this.categoryName})
      : super(key: key);

  @override
  State<StockCardListScreen> createState() => _StockCardListScreenState();
}

class _StockCardListScreenState extends State<StockCardListScreen> {
  // Sample data for demonstration
  final List<Map<String, String>> _sampleIngredients = [
    {
      'name': 'Orange',
      'image': 'assets/food8.png',
    },
    {
      'name': 'Ladies Finger',
      'image': 'assets/food1.png',
    },
    {
      'name': 'Snake Guard',
      'image': 'assets/food3.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios_rounded,
            size: height * 0.035,
            color: Colors.black,
          ),
        ),
        title: Text(
          widget.categoryName.isNotEmpty
              ? widget.categoryName
              : "Stock Card List",
          style: TextStyle(
            fontFamily: "Lexand",
            fontSize: height * 0.018,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _sampleIngredients.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              // Ingredient container
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: width * 0.05,
                  vertical: height * 0.01,
                ),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: InkWell(
                  onTap: () {
                    _showFirstPopup(context, index);
                  },
                  child: Row(
                    children: [
                      // Ingredient image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(
                          _sampleIngredients[index]['image'] ?? '',
                          fit: BoxFit.cover,
                          width: width * 0.15,
                          height: width * 0.15,
                        ),
                      ),
                      SizedBox(width: width * 0.04),
                      // Ingredient name
                      Text(
                        _sampleIngredients[index]['name'] ?? '',
                        style: TextStyle(
                          fontFamily: "Lexand",
                          fontSize: height * 0.016,
                          fontWeight: FontWeight.w500,
                          color: primaryColor.withOpacity(1.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Divider
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                child: Container(
                  height: 1,
                  color: Colors.grey.shade300,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// First pop-up
  void _showFirstPopup(BuildContext context, int index) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Closing balance : 3 KG",
                      style: TextStyle(
                        fontFamily: "Lexand",
                        fontSize: height * 0.016,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: height * 0.015),
                    // Ingredient image + name
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Image.asset(
                            _sampleIngredients[index]['image'] ?? '',
                            width: width * 0.15,
                            height: width * 0.15,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(width: width * 0.03),
                          Text(
                            "${_sampleIngredients[index]['name']} 10kg",
                            style: TextStyle(
                              fontFamily: "Lexand",
                              fontSize: height * 0.016,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    // Date fields
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Date From : ",
                          style: TextStyle(
                            fontFamily: "Lexand",
                            fontSize: height * 0.016,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Text(
                          "01/08/2024",
                          style: TextStyle(fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.015),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Date To : ",
                          style: TextStyle(
                            fontFamily: "Lexand",
                            fontSize: height * 0.016,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Text(
                          "14/08/2024",
                          style: TextStyle(fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.025),
                    // "Stockcard" button
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        _showSecondPopup(context, index);
                      },
                      child: Container(
                        width: double.infinity,
                        height: height * 0.05,
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(1.0),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Center(
                          child: Text(
                            "Stockcard",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Lexand",
                              fontSize: height * 0.016,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  /// Second pop-up
  void _showSecondPopup(BuildContext context, int index) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Balances + edit icon
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Closing Balance : 3kg",
                                style: TextStyle(
                                  fontFamily: "Lexand",
                                  fontSize: height * 0.014,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: height * 0.01),
                              Text(
                                "Opening Balance : 2kg",
                                style: TextStyle(
                                  fontFamily: "Lexand",
                                  fontSize: height * 0.014,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            _showThirdPopup(context, index);
                          },
                          child: Icon(
                            Icons.edit,
                            size: height * 0.025,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.02),
                    // Date range
                    Text(
                      "Date From: 1/8/2024, Date To: 14/8/2024",
                      style: TextStyle(
                        fontFamily: "Lexand",
                        fontSize: height * 0.013,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: height * 0.015),
                    // Table container
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          // Table header row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildTableHeader(
                                  "Opening\nBalance / kg", width, height),
                              _buildTableHeader(
                                  "Total\nStock In / kg", width, height),
                              _buildTableHeader(
                                  "Stock\nOut / kg", width, height),
                              _buildTableHeader(
                                  "Price /RM\nper kg", width, height),
                            ],
                          ),
                          const Divider(),
                          // Sample table rows
                          _buildTableRow("1/8/2024", "2", "3", "5.2", height),
                          _buildTableRow("2/8/2024", "1.5", "2.0", "5", height),
                          _buildTableRow("14/8/2024", "2", "3", "5.5", height),
                        ],
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    // Summaries
                    Text(
                      "Opening Stock + Stock In - Stock Out = Closing Balance",
                      style: TextStyle(
                        fontFamily: "Lexand",
                        fontSize: height * 0.013,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: height * 0.008),
                    Text(
                      "Total Stock In : 3kg",
                      style: TextStyle(
                        fontFamily: "Lexand",
                        fontSize: height * 0.013,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: height * 0.008),
                    Text(
                      "Total Stock Out : 2kg",
                      style: TextStyle(
                        fontFamily: "Lexand",
                        fontSize: height * 0.013,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: height * 0.008),
                    Text(
                      "Average Price /RM per kg: 2.24",
                      style: TextStyle(
                        fontFamily: "Lexand",
                        fontSize: height * 0.013,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  /// 3) Third pop-up: includes two tables, an edit icon next to "Wastage: 0.6kg",
  /// usage/wastage pie chart, and updated formula lines at the bottom
  void _showThirdPopup(BuildContext context, int index) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    // Data for the pie chart
    final Map<String, double> dataMap = {
      "Usage": 70,
      "Wastage": 30,
    };

    final List<Color> colorList = [
      Colors.blue,
      Colors.red,
    ];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: StatefulBuilder(builder: (context, setState) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    "Total Stock Out : 2kg",
                    style: TextStyle(
                      fontFamily: "Lexand",
                      fontSize: height * 0.016,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  // Usage row + Pie Chart
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          "Usage : 1.4kg",
                          style: TextStyle(
                            fontFamily: "Lexand",
                            fontSize: height * 0.015,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      PieChart(
                        dataMap: dataMap,
                        animationDuration: const Duration(milliseconds: 800),
                        chartLegendSpacing: 16,
                        chartRadius: width * 0.25,
                        colorList: colorList,
                        initialAngleInDegree: 0,
                        chartType: ChartType.disc,
                        ringStrokeWidth: 0,
                        centerText: "",
                        legendOptions: LegendOptions(
                          showLegends: true,
                          legendPosition: LegendPosition.bottom,
                          legendTextStyle: TextStyle(
                            fontFamily: "Lexand",
                            fontSize: height * 0.012,
                          ),
                        ),
                        chartValuesOptions: ChartValuesOptions(
                          showChartValues: true,
                          showChartValuesInPercentage: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.01),
                  // Wastage row + edit icon
                  Row(
                    children: [
                      Text(
                        "Wastage : 0.6kg",
                        style: TextStyle(
                          fontFamily: "Lexand",
                          fontSize: height * 0.015,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 6),
                      InkWell(
                        onTap: () {
                          // Action if needed on Wastage edit
                        },
                        child: Icon(
                          Icons.edit,
                          color: Colors.black54,
                          size: height * 0.020,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.02),
                  // First table: "Processing/%", "Packaging/%", "Environment/%"
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildTableHeader("Processing / %", width, height),
                            _buildTableHeader("Packaging / %", width, height),
                            _buildTableHeader("Environment / %", width, height),
                          ],
                        ),
                        const Divider(),
                        // Data row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildTableValue("40", height),
                            _buildTableValue("30", height),
                            _buildTableValue("30", height),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  // Second table: "Total Stock Out / kg", "Total Usage / kg", "Total Wastage / kg", "Total Cost / RM"
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildTableHeader(
                                "Total\nStock Out / kg", width, height),
                            _buildTableHeader(
                                "Total\nUsage / kg", width, height),
                            _buildTableHeader(
                                "Total\nWastage / kg", width, height),
                            _buildTableHeader(
                                "Total\nCost / RM", width, height),
                            _buildTableHeader(
                                "Actual\nUsage Price / RM", width, height),
                          ],
                        ),
                        const Divider(),
                        // Data row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildTableValue("2", height),
                            _buildTableValue("1.4", height),
                            _buildTableValue("0.6", height),
                            _buildTableValue("4.08", height),
                            _buildTableValue("2.86", height),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  // Formula lines
                  Text(
                    "Actual usage price",
                    style: TextStyle(
                      fontFamily: "Lexand",
                      fontSize: height * 0.015,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "2.86=1.4 x 2.04",
                    style: TextStyle(
                      fontFamily: "Lexand",
                      fontSize: height * 0.014,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Total Cost",
                    style: TextStyle(
                      fontFamily: "Lexand",
                      fontSize: height * 0.015,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "4.08=2.04 x 2",
                    style: TextStyle(
                      fontFamily: "Lexand",
                      fontSize: height * 0.014,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Total Wastage Cost = 4.08-2.86",
                    style: TextStyle(
                      fontFamily: "Lexand",
                      fontSize: height * 0.014,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }

  /// Helper for building table headers
  Widget _buildTableHeader(String text, double width, double height) {
    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: "Lexand",
          fontSize: height * 0.012,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Helper for building table values
  Widget _buildTableValue(String text, double height) {
    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: "Lexand",
          fontSize: height * 0.012,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  /// Helper row for the second pop-up table
  Widget _buildTableRow(String date, String stockIn, String stockOut,
      String price, double height) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                date,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Lexand",
                  fontSize: height * 0.012,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Expanded(
              child: Text(
                stockIn,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Lexand",
                  fontSize: height * 0.012,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Expanded(
              child: Text(
                stockOut,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Lexand",
                  fontSize: height * 0.012,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Expanded(
              child: Text(
                price,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Lexand",
                  fontSize: height * 0.012,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
