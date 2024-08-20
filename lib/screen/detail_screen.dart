import 'package:english_dictionary/data/appState.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:khmer_fonts/khmer_fonts.dart';
import 'package:share/share.dart';

class DetailScreen extends StatelessWidget {
  final FlutterTts flutterTts = FlutterTts();

  // For Share code
  void _shareContent() {
    final text =
        '${Get.find<AppState>().word.value}\n\n${Get.find<AppState>().definition.value}';
    Share.share(text);
  }

  // Method to speak the word
  Future<void> speak(String text) async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setPitch(1.0); // Adjust pitch as needed
    await flutterTts
        .setSpeechRate(0.2); // Adjust speech rate for smoother speech
    await flutterTts.setVolume(1.0); // Adjust volume if necessary
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Definition",
          style: TextStyle(
            fontFamily: KhmerFonts.angkor,
            fontSize: 17,
            package: 'khmer_fonts',
            color: Colors.white,
            letterSpacing: 1,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              speak(Get.find<AppState>().word.value);
            },
            icon: Icon(Icons.mic),
            color: Colors.grey,
          ),
          Obx(
            () {
              final isBookmarked = Get.find<AppState>().isBookmarked({
                'englishword': Get.find<AppState>().word.value,
                'khmerdef': Get.find<AppState>().definition.value,
              });
              return IconButton(
                icon: Icon(
                  isBookmarked
                      ? Icons.favorite_sharp
                      : Icons.favorite_border_sharp,
                  color: Color.fromARGB(175, 255, 255, 255),
                ),
                onPressed: () {
                  Get.find<AppState>().toggleBookmark({
                    'englishword': Get.find<AppState>().word.value,
                    'khmerdef': Get.find<AppState>().definition.value,
                  });
                },
              );
            },
          ),
          IconButton(
            onPressed: () {
              _shareContent();
            },
            icon: Icon(Icons.ios_share),
            color: Colors.grey,
          ),
          // IconButton(
          //   onPressed: () {
          //     Clipboard.setData(
          //       ClipboardData(text: Get.find<AppState>().word.value),
          //     );
          //     ScaffoldMessenger.of(context).showSnackBar(
          //       SnackBar(
          //         duration: Duration(seconds: 1),
          //         content: Text('Word has been Copied'),
          //       ),
          //     );
          //   },
          //   icon: Icon(Icons.copy),
          //   color: Colors.grey,
          // ),
        ],
      ),
      body: Column(
        children: [
          Column(
            children: [
              words(Get.find<AppState>().word.value,
                  Get.find<AppState>().partOfSpeech.value),
            ],
          ),
          // List of Icons
          // listIcons(context),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.white],
                    begin: Alignment.bottomLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 1),
                        blurRadius: 2)
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            Get.find<AppState>().englishPhonetic.value,
                            style: TextStyle(fontSize: 18, color: Colors.red),
                          ),
                        ),
                        Text(
                          Get.find<AppState>().khmerPhonetic.value,
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                    Divider(),
                    ListTile(
                      title: Text(
                        Get.find<AppState>().word.value,
                        style: TextStyle(
                          fontFamily: KhmerFonts.bokor,
                          fontSize: 18,
                          package: 'khmer_fonts',
                          letterSpacing: 1,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.copy,
                          size: 18,
                        ),
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(
                                text: Get.find<AppState>().definition.value),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: Duration(seconds: 1),
                              content: Text('Definition has been Copied'),
                            ),
                          );
                        },
                      ),
                    ),
                    ListTile(
                      title: HtmlWidget(
                        Get.find<AppState>().definition.value,
                        textStyle: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Style  of Words
  Container words(var1, var2) {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      color: Colors.black87,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Text(
                var1,
                style: TextStyle(
                  fontFamily: KhmerFonts.bokor,
                  fontSize: 18,
                  package: 'khmer_fonts',
                  color: Colors.white,
                ),
              ),
              // Text(
              //   var2,
              //   style: TextStyle(
              //     fontFamily: KhmerFonts.bokor,
              //     fontSize: 15,
              //     package: 'khmer_fonts',
              //     color: Colors.amber,
              //   ),
              // ),
            ],
          )
        ],
      ),
    );
  }

  // List Style of Icons
  Container listIcons(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.black87,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(3),
            margin: EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Color.fromARGB(49, 92, 90, 90),
            ),
            child: IconButton(
              icon: Icon(
                Icons.copy,
                color: Color.fromARGB(175, 255, 255, 255),
              ),
              onPressed: () {
                Clipboard.setData(
                  ClipboardData(text: Get.find<AppState>().word.value),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: Duration(seconds: 1),
                    content: Text('Word has been Copied'),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(3),
            margin: EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Color.fromARGB(49, 92, 90, 90),
            ),
            child: Obx(
              () {
                final isBookmarked = Get.find<AppState>().isBookmarked({
                  'englishword': Get.find<AppState>().word.value,
                  'khmerdef': Get.find<AppState>().definition.value,
                });
                return IconButton(
                  icon: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
                    color: Color.fromARGB(175, 255, 255, 255),
                  ),
                  onPressed: () {
                    Get.find<AppState>().toggleBookmark({
                      'englishword': Get.find<AppState>().word.value,
                      'khmerdef': Get.find<AppState>().definition.value,
                    });
                  },
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(3),
            margin: EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Color.fromARGB(49, 92, 90, 90),
            ),
            child: IconButton(
              icon: Icon(
                Icons.ios_share,
                color: Color.fromARGB(175, 255, 255, 255),
              ),
              onPressed: () {
                _shareContent();
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(3),
            margin: EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Color.fromARGB(49, 92, 90, 90),
            ),
            child: IconButton(
              icon: Icon(
                Icons.mic,
                color: Color.fromARGB(175, 255, 255, 255),
              ),
              onPressed: () {
                speak(Get.find<AppState>().word.value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
