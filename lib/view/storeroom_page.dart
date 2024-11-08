import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StoreRoomPage extends StatefulWidget {
  const StoreRoomPage({Key? key}) : super(key: key);

  @override
  State<StoreRoomPage> createState() => _StoreRoomPageState();
}

class _StoreRoomPageState extends State<StoreRoomPage> {
  // Dummy data for categories and ingredients
  List<String> categories = ["Category 1", "Category 2", "Category 3"];
  Map<String, List<String>> categoryIngredients = {
    "Category 1": ["Ingredient A", "Ingredient B", "Ingredient C"],
    "Category 2": ["Ingredient D", "Ingredient E"],
    "Category 3": ["Ingredient F", "Ingredient G", "Ingredient H"],
  };

  String selectedCategory = "Category 1";

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back_ios_rounded,
              size: height * 0.035,
            ),
          ),
          title: Text(
            "Pick your ingredients from the table.",
            style: TextStyle(
              fontFamily: "Lexand",
              fontSize: height * 0.02,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left side (categories list)
            Container(
              width: width * 0.3, // 30% of screen width
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  String category = categories[index];
                  return ListTile(
                    title: Text(category),
                    onTap: () {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                    selected: selectedCategory == category,
                  );
                },
              ),
            ),
            // Right side (category ingredients list with checkboxes)
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: categoryIngredients[selectedCategory]!.length,
                  itemBuilder: (context, index) {
                    String ingredient =
                        categoryIngredients[selectedCategory]![index];
                    return CheckboxListTile(
                      title: Text(ingredient),
                      value: false, // Replace with actual logic for checkbox
                      onChanged: (bool? value) {
                        // Handle checkbox onChanged
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
