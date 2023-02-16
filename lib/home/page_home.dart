// import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:s4s_mobileapp/account/page_account.dart';
import 'package:s4s_mobileapp/calendar/page_calendar.dart';
// import 'package:s4s_mobileapp/restock/page_restock.dart';
import 'package:s4s_mobileapp/tools/functions.dart';
// import 'package:s4s_mobileapp/trend/page_trend.dart';
// import 'package:fluttertoast/fluttertoast.dart';

int selectedIndex = 0;
// bool previousIndexSearch = false;
int positionSearchPage = 0;
int selectedInitialPositionAccountPage = 0;
bool is360Search = false;
bool isOutfits = false;
bool isSpecs = true;

class HomePage extends StatefulWidget {
  final List<Widget> pages;
  final int? initialIndex;
  final int? initialPositionAccountPage;
  const HomePage(this.pages, this.initialIndex, this.initialPositionAccountPage,
      {Key? key})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    if (widget.initialIndex != null) {
      selectedIndex = widget.initialIndex!;
    }
    if (widget.initialPositionAccountPage != null) {
      selectedInitialPositionAccountPage = widget.initialPositionAccountPage!;
    }
    super.initState();
  }

  void onBottomBarButtonTapped(int index) {
    // int previousIndex = selectedIndex;

    setState(() {
      if (selectedIndex == 1) positionCalendarPage = 0;
      selectedIndex = index;
    });

    Navigator.of(context).pushNamedAndRemoveUntil('/Home', (route) => false);

    // (the tap again / scroll up features)
    // if (previousIndex == selectedIndex && selectedIndex == 4) {
    //   setState(() {
    //     positionAccountPage = 0;
    //   });
    //   Navigator.pushReplacement(context,
    //       MaterialPageRoute(builder: (BuildContext context) => widget));
    // }
    // if (previousIndex == selectedIndex && selectedIndex == 0) {
    //   scrollTrend.animateTo(0,
    //       duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    // }
    // if (previousIndex == selectedIndex && selectedIndex == 3) {
    //   if (positionRestockPage == 0) {
    //     scrollRestock.animateTo(0,
    //         duration: const Duration(milliseconds: 300),
    //         curve: Curves.easeInOut);
    //   } else {
    //     setState(() {
    //       positionRestockPage = 0;
    //     });
    //     Navigator.pushReplacement(context,
    //         MaterialPageRoute(builder: (BuildContext context) => widget));
    //   }
    // }
    // if (previousIndex == selectedIndex && selectedIndex == 1) {
    //   setState(() {
    //     is360 = false;
    //   });
    //   if (positionCalendarPage == 0 || positionCalendarPage == 1) {
    //     scrollCalendarMain.animateTo(0,
    //         duration: const Duration(milliseconds: 300),
    //         curve: Curves.easeInOut);
    //   } else {
    //     setState(() {
    //       if (isUpcoming) {
    //         positionCalendarPage = 0;
    //       } else {
    //         positionCalendarPage = 1;
    //       }
    //       itemChosen = ["", ""];
    //       isRaffles = false;
    //       isRetail = true;
    //       isResell = false;
    //     });

    //     // Navigator.pushReplacement(context,
    //     //     MaterialPageRoute(builder: (BuildContext context) => widget));
    //   }
    // }
    // if (selectedIndex == 1 && previousIndex != selectedIndex && isResell) {
    //   setState(() {
    //     isRaffles = false;
    //     isRetail = false;
    //     isResell = true;
    //     // Call API to retrieve the list of lists (Example below)
    //     // w/ US size (Default: 8 US)
    //     listResellContainer = [
    //       [
    //         "110",
    //         "assets/resell_shop.png",
    //         "https://www.goat.com/",
    //       ],
    //       [
    //         "120",
    //         "assets/resell_shop.png",
    //         "https://www.goat.com/",
    //       ],
    //       [
    //         "130",
    //         "assets/resell_shop.png",
    //         "https://www.goat.com/",
    //       ],
    //     ];
    //     // Find best price
    //     listResellPrices = [];
    //     for (int x = 0; x < listResellContainer.length; x++) {
    //       listResellPrices.add(int.parse(listResellContainer[x][0]));
    //     }
    //   });
    // }
  }

  Widget buildBottomBar() {
    return BottomAppBar(
      color: Colors.white,
      shape: const CircularNotchedRectangle(),
      notchMargin: 5.0,
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: kBottomNavigationBarHeight,
        child: Wrap(
          children: [
            BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              iconSize: 28,
              elevation: 0.0,
              currentIndex: selectedIndex == 5 ? 2 : selectedIndex,
              selectedLabelStyle: robotoStyle(FontWeight.w500,
                  const Color.fromARGB(255, 49, 48, 54), null, null),
              showUnselectedLabels: true,
              unselectedLabelStyle: robotoStyle(
                  FontWeight.w500, const Color(0xff313036), null, null),
              unselectedItemColor: const Color(0xff313036),
              selectedItemColor: const Color(0xff313036),
              selectedIconTheme: const IconThemeData(color: Color(0xffff2323)),
              onTap: onBottomBarButtonTapped,
              backgroundColor: Colors.white,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  activeIcon: Icon(
                    Icons.signal_cellular_alt_rounded,
                    color: Color(0xffff2323),
                  ),
                  icon: Icon(
                    Icons.signal_cellular_alt_rounded,
                    color: Color(0xff313036),
                  ),
                  label: "Trend",
                ),
                BottomNavigationBarItem(
                  activeIcon: Icon(
                    CupertinoIcons.calendar,
                    color: Color(0xffff2323),
                  ),
                  icon: Icon(
                    CupertinoIcons.calendar,
                    color: Color(0xff313036),
                  ),
                  label: "Calendar",
                ),
                BottomNavigationBarItem(
                  activeIcon: Icon(
                    Icons.search_rounded,
                    color: Colors.transparent,
                  ),
                  icon: Icon(
                    Icons.search_rounded,
                    color: Colors.transparent,
                  ),
                  label: "",
                ),
                BottomNavigationBarItem(
                  activeIcon: Icon(
                    CupertinoIcons.arrow_2_circlepath,
                    color: Color(0xffff2323),
                  ),
                  icon: Icon(
                    CupertinoIcons.arrow_2_circlepath,
                    color: Color(0xff313036),
                  ),
                  label: "Restock",
                ),
                BottomNavigationBarItem(
                  activeIcon: Icon(
                    Icons.account_circle,
                    color: Color(0xffff2323),
                  ),
                  icon: Icon(
                    Icons.account_circle,
                    color: Color(0xff313036),
                  ),
                  label: "Account",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      appBar: null,
      backgroundColor: Colors.white,
      // body: WillPopScope(
      //   onWillPop: onWillPop,
      //   child: widget.pages[selectedIndex],
      // ),
      body: widget.pages[selectedIndex],
      bottomNavigationBar: buildBottomBar(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(5.0),
        child: FloatingActionButton(
          elevation: 4.0,
          backgroundColor: selectedIndex == 2
              ? const Color.fromARGB(255, 255, 35, 35)
              : Colors.white,
          onPressed: () {
            setState(() {
              // if (previousIndexSearch) {
              //   setState(() {
              //     positionSearchPage = 0;
              //     is360Search = false;
              //     isOutfits = false;
              //     isSpecs = true;
              //   });
              //   Navigator.pushReplacement(
              //       context,
              //       MaterialPageRoute(
              //           builder: (BuildContext context) => widget));
              // } else {
              //   // Call API to retrieve the list of lists (Example below)
              //   // w/ US size (Default: 8 US)
              //   listOfShops = [
              //     [
              //       "110",
              //       "assets/resell_shop.png",
              //       "https://www.goat.com/",
              //     ],
              //     [
              //       "120",
              //       "assets/resell_shop.png",
              //       "https://www.goat.com/",
              //     ],
              //     [
              //       "130",
              //       "assets/resell_shop.png",
              //       "https://www.goat.com/",
              //     ],
              //   ];
              //   // Find best price
              //   listPrices = [];
              //   for (int x = 0; x < listOfShops.length; x++) {
              //     listPrices.add(int.parse(listOfShops[x][0]));
              //   }
              // }
              selectedIndex = 2;
            });
          },
          child: Icon(
            Icons.search,
            color: selectedIndex == 2
                ? Colors.white
                : const Color.fromARGB(255, 255, 35, 35),
            size: 35,
          ),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
    );
  }

  // Future<bool> onWillPop() {
  //   DateTime now = DateTime.now();
  //   if (now.difference(currentBackPressTime) > const Duration(seconds: 2)) {
  //     currentBackPressTime = now;
  //     Fluttertoast.showToast(msg: 'Press Back Button Again to Exit');
  //     return Future.value(false);
  //   }
  //   return Future.value(true);
  // }
}
