import 'package:english_dictionary/data/appState.dart';
import 'package:english_dictionary/data/db_utill.dart';
import 'package:english_dictionary/screen/Add.dart';
import 'package:english_dictionary/screen/bookmark.dart';
import 'package:english_dictionary/screen/NavigationBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:english_dictionary/screen/detail_screen.dart';
import 'package:english_dictionary/screen/homepage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(AppState());

  // Initialize database utility
  DBUtil dbUtil = DBUtil();
  await dbUtil.initDB(); // Ensure the database is initialized

  // Query database and add it to the list in AppState
  Get.find<AppState>().list.value =
      await dbUtil.select("SELECT * FROM englishkhmer LIMIT 100");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromARGB(255, 254, 248, 248),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => page(),
        '/Homepage': (context) => Homepage(),
        '/DetailScreen': (context) => DetailScreen(),
        '/Bookmark': (context) => Bookmark(),
        '/Add': (context) => AddPage(),
      },
    );
  }
}
