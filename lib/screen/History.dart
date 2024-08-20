import 'package:english_dictionary/data/appState.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khmer_fonts/khmer_fonts.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        centerTitle: true,
        title: Text(
          "Histories",
          style: TextStyle(
            fontFamily: KhmerFonts.moul,
            fontSize: 18,
            package: 'khmer_fonts',
            color: Colors.white,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () => _showClearAllDialog(context),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: Text(
                  "Clear All",
                  style: TextStyle(color: Colors.amber, fontSize: 13),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Obx(
        () {
          var history = Get.find<AppState>().history;
          if (history.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 45,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "No data available",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            );
          } else {
            return ListView(
              children: history.map((e) => HistoryText(e, context)).toList(),
            );
          }
        },
      ),
    );
  }

  Container HistoryText(Map<String, dynamic> Str, BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 20),
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.white],
          begin: Alignment.bottomLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black12, offset: Offset(0, 1), blurRadius: 2)
        ],
      ),
      child: ListTile(
        onTap: () {
          Get.find<AppState>().word.value = Str["englishword"];
          Get.find<AppState>().definition.value = Str["khmerdef"];
          Navigator.pushNamed(context, '/DetailScreen');
        },
        leading: Icon(
          Icons.history,
          color: Colors.black,
          size: 17,
        ),
        title: Text(
          Str["englishword"],
          style: TextStyle(fontSize: 18),
        ),
        trailing: IconButton(
          onPressed: () {
            Get.find<AppState>().removeHistory(Str);
          },
          icon: Icon(
            Icons.delete,
            color: Colors.red,
            size: 17,
          ),
        ),
      ),
    );
  }

  void _showClearAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Clear History'),
          content: Text('Are you sure you want to clear all history?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Clear All'),
              onPressed: () {
                Get.find<AppState>().clearHistory();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
