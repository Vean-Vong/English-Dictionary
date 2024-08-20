import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:english_dictionary/screen/History.dart';
import 'package:english_dictionary/screen/bookmark.dart';
import 'package:english_dictionary/screen/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class page extends StatefulWidget {
  @override
  _PageNavigationState createState() => _PageNavigationState();
}

class _PageNavigationState extends State<page> {
  int _page = 1; // Default page is Home
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  PageController _pageController = PageController(initialPage: 1);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget buildNavItem(IconData icon, String label, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 25,
          color: color,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _page = index;
          });
        },
        children: [
          Bookmark(),
          Homepage(),
          HistoryPage(),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _page,
        items: [
          buildNavItem(Icons.favorite_border_sharp, "Favorite", Colors.black),
          buildNavItem(Icons.search, "Search", Colors.black),
          buildNavItem(Icons.history, "History", Colors.black),
        ],
        color: Colors.white,
        buttonBackgroundColor: Color.fromARGB(255, 255, 255, 255),
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 150),
        onTap: (index) {
          _pageController.jumpToPage(index);
        },
        letIndexChange: (index) => true,
      ),
    );
  }
}
