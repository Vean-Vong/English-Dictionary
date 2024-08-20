import 'package:english_dictionary/data/appState.dart';
import 'package:english_dictionary/data/db_utill.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khmer_fonts/khmer_fonts.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TextEditingController _searchController = TextEditingController();
  String selectedLanguage = 'English-Khmer'; // Default language
  List<Map<String, dynamic>> allWords = []; // Store all words initially

  @override
  void initState() {
    super.initState();
    fetchAllWords(); // Fetch all words from DB when the widget initializes
  }

  void fetchAllWords() async {
    DBUtil dbUtil = DBUtil();
    allWords = await dbUtil.select("SELECT * FROM englishkhmer");
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

// Method for alert change the language

  void _changeLanguage(String language) {
    setState(() {
      selectedLanguage = language;
    });
    // You can also add your logic here to change the app language
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(
            alignment: Alignment.center,
            child: Text(
              'Change Language',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  'English-Khmer',
                  style: TextStyle(fontSize: 15),
                ),
                leading: Radio<String>(
                  value: 'English-Khmer',
                  groupValue: selectedLanguage,
                  onChanged: (value) {
                    _changeLanguage(value!);
                    Navigator.of(context).pop();
                  },
                ),
              ),
              ListTile(
                title: Text(
                  'Khmer-Khmer',
                  style: TextStyle(fontSize: 15),
                ),
                leading: Radio<String>(
                  value: 'Khmer-Khmer',
                  groupValue: selectedLanguage,
                  onChanged: (value) {
                    _changeLanguage(value!);
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        centerTitle: true,
        // leading: IconButton(
        //   onPressed: () {},
        //   icon: Icon(
        //     Icons.font_download_outlined,
        //     color: Colors.white,
        //   ),
        // ),
        title: Text(
          "English Dictionary",
          style: TextStyle(
            fontFamily: KhmerFonts.moul,
            fontSize: 18,
            package: 'khmer_fonts',
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.black87,
            padding: EdgeInsets.only(
              left: 15,
              right: 15,
              top: 20,
              bottom: 15,
            ),
            child: TextField(
              onChanged: (value) async {
                if (value.isEmpty) {
                  // If search text is empty, show all words
                  Get.find<AppState>().list.value = List.from(allWords);
                } else {
                  // Perform search and update the list accordingly
                  DBUtil dbUtil = DBUtil();
                  Get.find<AppState>().list.value = await dbUtil.select(
                    "SELECT * FROM englishkhmer WHERE englishword LIKE '${value}%'",
                  );
                }
              },
              controller: _searchController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                hintText: 'Search for word here...',
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: () {
                    _searchController.clear();
                    // Clearing text should show all words again
                    Get.find<AppState>().list.value = List.from(allWords);
                  },
                  icon: Icon(
                    Icons.clear,
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: Obx(
              () {
                var searchResults = Get.find<AppState>().list;
                if (searchResults.isEmpty) {
                  return Center(
                    child: Text(
                      'No word found.!',
                      style: TextStyle(fontSize: 15),
                    ),
                  );
                }
                return ListView(
                  children: searchResults
                      .map(
                        (e) => ListText(
                          e,
                          Get.find<AppState>().isBookmarked(e)
                              ? Icon(
                                  Icons.bookmark,
                                  color: Color.fromARGB(172, 12, 0, 238),
                                )
                              : Icon(Icons.bookmark_border),
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Container ListText(Map<String, dynamic> item, Icon icon) {
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
          Get.find<AppState>().word.value = item["englishword"];
          Get.find<AppState>().definition.value = item["khmerdef"];
          Get.find<AppState>().partOfSpeech.value = item["partofspeech"];
          Get.find<AppState>().englishPhonetic.value = item["englishphonetic"];
          Get.find<AppState>().khmerPhonetic.value = item["khmerphonetic"];
          Get.find<AppState>().addHistory({
            'englishword': item["englishword"],
            'khmerdef': item["khmerdef"],
          });
          Navigator.pushNamed(context, '/DetailScreen');
        },
        // leading: IconButton(
        //   icon: icon,
        //   color: Color.fromARGB(172, 12, 0, 238),
        //   iconSize: 28,
        //   onPressed: () {
        //     Get.find<AppState>().toggleBookmark(item);
        //     setState(() {});
        //   },
        // ),

        title: Text(
          item["englishword"],
          style: TextStyle(fontSize: 17),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.blueGrey,
          size: 14,
        ),
      ),
    );
  }
}
