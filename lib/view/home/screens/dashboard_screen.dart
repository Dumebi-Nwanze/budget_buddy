import 'package:budget_buddy/utils/colors.dart';
import 'package:budget_buddy/utils/common.dart';
import 'package:budget_buddy/view/home/screens/budget_page.dart';
import 'package:budget_buddy/view/home/screens/entry_screen.dart';
import 'package:budget_buddy/view/home/screens/daily_page.dart';
import 'package:budget_buddy/view/home/screens/profile_page.dart';
import 'package:budget_buddy/view/home/screens/stats_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int pageIndex = 0;
  List<Widget> pages = [
    DailyPage(),
    StatsPage(),
    BudgetPage(),
    ProfilePage(),
    CreatBudgetPage()
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setStatusBarColor(appWhite);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: getBody(),
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: getFooter(),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              selectedTab(4);
            },
            child: Icon(
              Icons.add,
              size: 25,
              color: secondaryColor,
            ),
            backgroundColor: primaryColor
            //params
            ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.centerDocked);
  }

  Widget getBody() {
    switch (pageIndex) {
      case 0:
        return DailyPage();
      case 1:
        return StatsPage();
      case 2:
        return BudgetPage();
      case 3:
        return ProfilePage();
      case 4:
        return CreatBudgetPage();
      default:
        return DailyPage();
    }
  }

  Widget getFooter() {
    List<IconData> iconItems = [
      CupertinoIcons.calendar,
      CupertinoIcons.graph_square,
      Icons.wallet,
      CupertinoIcons.person_fill,
    ];

    return AnimatedBottomNavigationBar(
      activeColor: secondaryColor,
      inactiveColor: Colors.black.withOpacity(0.5),
      icons: iconItems,
      activeIndex: pageIndex,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.softEdge,
      leftCornerRadius: 10,
      iconSize: 25,
      rightCornerRadius: 10,
      onTap: (index) {
        selectedTab(index);
      },
      //other params
    );
  }

  selectedTab(index) {
    setState(() {
      pageIndex = index;
    });
  }
}
