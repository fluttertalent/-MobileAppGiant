import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
import 'package:s4s_mobileapp/account/page_account.dart';
import 'package:s4s_mobileapp/tools/functions.dart';
import 'package:s4s_mobileapp/main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:s4s_mobileapp/widgets/custom_expansion_tile.dart';
import 'dart:async';

int positionRestockPage = 0;

List listBrand1 = [
  "assets/jordan_logo.png",
  "assets/nike_logo.png",
  "assets/newbalance_logo.png"
];

List listBrand2 = [
  "assets/adidas_logo.png",
  "assets/yeezy_logo.png",
];

bool isJordan = false;
bool isNike = false;
bool isAdidas = false;
bool isYeezy = false;
bool isNewbalance = false;

final ScrollController scrollRestock = ScrollController();

class RestockPage extends StatefulWidget {
  const RestockPage({Key? key}) : super(key: key);

  @override
  State<RestockPage> createState() => _RestockPageState();
}

class _RestockPageState extends State<RestockPage> {
  List<Map> restock = [];
  bool isExpanded1 = false;
  bool isExpanded2 = false;
  Timer? timer;

  @override
  void initState() {
    restock = restocks;
    getRestock().then((e) {
      if (mounted) {
        setState(() {
          restock = e;
        });
      }
    });
    timer = Timer.periodic(const Duration(minutes: 3), (Timer timer) {
      getRestock().then((e) {
        if (mounted) {
          setState(() {
            restock = e;
          });
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Widget pageRestockMain() {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).padding.top + 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                ),
                child: IconButton(
                  icon: const Icon(Icons.settings),
                  color:
                      isJordan || isNike || isNewbalance || isAdidas || isYeezy
                          ? Color.fromARGB(255, 85, 32, 32)
                          : const Color.fromARGB(255, 49, 48, 54),
                  iconSize: 30,
                  onPressed: () {
                    setState(() {
                      positionRestockPage = 1;
                    });
                  },
                ),
              ),
            ),
            const Align(
              alignment: Alignment.center,
              child: Image(
                height: 23,
                image: AssetImage('./assets/etc/splash-cropped.png'),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 20,
                ),
                child: Transform.scale(
                  scale: 0.8,
                  child: CupertinoSwitch(
                    onChanged: (value) {
                      setState(
                        () {
                          notifRestock = value;
                        },
                      );
                    },
                    value: notifRestock,
                    activeColor: const Color.fromARGB(255, 33, 237, 91),
                    trackColor: const Color.fromARGB(255, 255, 35, 35),
                    thumbColor: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        const Divider(
          color: Colors.grey,
          height: 0,
          thickness: 1,
        ),
        Expanded(
          // child: RefreshIndicator(
          // onRefresh: () async {
          //   await getRestock();
          //   // ignore: use_build_context_synchronously
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     launchSnackbar(
          //       "Restock List Successfully Refreshed",
          //       Icons.check,
          //       const Color.fromARGB(255, 255, 35, 35),
          //       Colors.white,
          //       const Color.fromARGB(255, 255, 35, 35),
          //     ),
          //   );
          //   // Call API to retrieve the new list of restock
          //   // ignore: use_build_context_synchronously
          //   // Navigator.pushReplacementNamed(context, '/Home');
          // },
          child: RefreshIndicator(
            onRefresh: _pullRefresh,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: scrollRestock,
              key: const PageStorageKey<String>('Listview Restock'),
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 70),
              itemCount: restock.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(),
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 35,
                      decoration: const BoxDecoration(
                        color: Color(0xff757D90),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(restock[index]['ShopName'],
                              style: robotoStyle(
                                  FontWeight.w900, Colors.white, 18, null)),
                          Text(
                              " - ${returnRestockDate(restock[index]['DateTime'])}",
                              style: robotoStyle(
                                  FontWeight.w400, Colors.white, 18, null)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 25, 10, 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Image.network(url, height, width)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: SizedBox(
                              width: 120,
                              // height: 50,
                              child: Image.network(
                                restock[index]['ProductImage'],
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/etc/NoImage.png',
                                    fit: BoxFit.contain,
                                  );
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  restock[index]['ProductName'],
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: robotoStyle(
                                      FontWeight.w700,
                                      const Color.fromARGB(255, 49, 48, 54),
                                      18,
                                      null),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Select your Shop area",
                                  textAlign: TextAlign.center,
                                  style: robotoStyle(
                                      FontWeight.w400,
                                      const Color.fromARGB(255, 119, 131, 143),
                                      12,
                                      null),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  alignment: WrapAlignment.center,
                                  verticalDirection: VerticalDirection.down,
                                  spacing: 4,
                                  runSpacing: 10.0,
                                  children: [
                                    for (var v
                                        in restock[index]['Url_Link'].values)
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            3, 0, 3, 0),
                                        child: InkWell(
                                          onTap: () {
                                            urlLauncher(v['url']);
                                          },
                                          child: SizedBox(
                                            width: 30,
                                            // height: 20,
                                            child: Image.network(
                                              v['flag'],
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
              // },
            ),
            // ),
          ),
        ),
      ],
    );
  }

  Widget pageRestockFilters() {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).padding.top + 5,
        ),
        Stack(
          alignment: Alignment.center,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_circle_left_outlined),
                  color: const Color.fromARGB(255, 49, 48, 54),
                  iconSize: 32,
                  onPressed: () {
                    setState(
                      () {
                        positionRestockPage = 0;
                      },
                    );
                  },
                ),
              ),
            ),
            const Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 25,
                child: Image(
                  image: AssetImage('./assets/etc/splash-cropped.png'),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          height: 35,
          decoration: const BoxDecoration(
              color: Color(0xff757D90) //Color.fromARGB(255, 255, 35, 35),
              ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Restock Notification",
                  style: robotoStyle(FontWeight.w900, Colors.white, 20, null)),
              Text(" filters",
                  style: robotoStyle(FontWeight.w400, Colors.white, 20, null)),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(top: 30),
                    child: Align(
                      alignment: const Alignment(-0.75, 0),
                      child: Text(
                        "By Brands",
                        style: robotoStyle(
                            FontWeight.w800, const Color(0xff313036), 25, null),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 5),
                    child: const Align(
                      alignment: Alignment(-0.67, 0),
                      child: Text(
                        "Filter from these selected Brands",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color(0xff77838F),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 30,
                      right: 30,
                    ),
                    child: Wrap(
                      spacing: 0,
                      runSpacing: 0,
                      alignment: WrapAlignment.center,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xffc5c5c5),
                                width: 0.2,
                              ),
                            ),
                          ),
                          child: IconButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () {},
                            icon: Image.asset('assets/brands/jordan.png'),
                            iconSize:
                                (MediaQuery.of(context).size.width / 3) - 20,
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xffc5c5c5),
                                width: 0.2,
                              ),
                            ),
                          ),
                          child: IconButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () {},
                            icon: Image.asset('assets/brands/nike.png'),
                            iconSize:
                                (MediaQuery.of(context).size.width / 3) - 20,
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xffc5c5c5),
                                width: 0.2,
                              ),
                            ),
                          ),
                          child: IconButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () {},
                            icon: Image.asset('assets/brands/yeezy.png'),
                            iconSize:
                                (MediaQuery.of(context).size.width / 3) - 20,
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xffc5c5c5),
                                width: 0.2,
                              ),
                            ),
                          ),
                          child: IconButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () {},
                            icon: Image.asset('assets/brands/adidas.png'),
                            iconSize:
                                (MediaQuery.of(context).size.width / 3) - 20,
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xffc5c5c5),
                                width: 0.2,
                              ),
                            ),
                          ),
                          child: IconButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () {},
                            icon: Image.asset('assets/brands/new-balance.png'),
                            iconSize:
                                (MediaQuery.of(context).size.width / 3) - 20,
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xffc5c5c5),
                                width: 0.2,
                              ),
                            ),
                          ),
                          child: IconButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () {},
                            icon: Image.asset('assets/brands/asics.png'),
                            iconSize:
                                (MediaQuery.of(context).size.width / 3) - 20,
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xffc5c5c5),
                                width: 0.2,
                              ),
                            ),
                          ),
                          child: IconButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () {},
                            icon: Image.asset('assets/brands/converse.png'),
                            iconSize:
                                (MediaQuery.of(context).size.width / 3) - 20,
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xffc5c5c5),
                                width: 0.2,
                              ),
                            ),
                          ),
                          child: IconButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () {},
                            icon: Image.asset('assets/brands/off-white.png'),
                            iconSize:
                                (MediaQuery.of(context).size.width / 3) - 20,
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xffc5c5c5),
                                width: 0.2,
                              ),
                            ),
                          ),
                          child: IconButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () {},
                            icon: Image.asset('assets/brands/travis-scott.png'),
                            iconSize:
                                (MediaQuery.of(context).size.width / 3) - 20,
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.transparent,
                                width: 0.2,
                              ),
                            ),
                          ),
                          child: IconButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () {},
                            icon: Image.asset('assets/brands/reebok.png'),
                            iconSize:
                                (MediaQuery.of(context).size.width / 3) - 20,
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.transparent,
                                width: 0.2,
                              ),
                            ),
                          ),
                          child: IconButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () {},
                            icon: Image.asset('assets/brands/puma.png'),
                            iconSize:
                                (MediaQuery.of(context).size.width / 3) - 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 5),
                    child: Align(
                      alignment: const Alignment(-0.75, 0),
                      child: Text(
                        "By Shops",
                        style: robotoStyle(
                            FontWeight.w800, const Color(0xff313036), 25, null),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 5),
                    child: const Align(
                      alignment: Alignment(-0.713, 0),
                      child: Text(
                        "Filter your favorites Shops",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 120, 130, 150),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  CustomExpansionTile(
                    trailing: isExpanded1
                        ? const Icon(CupertinoIcons.rectangle_expand_vertical)
                        : const Icon(
                            CupertinoIcons.rectangle_compress_vertical),
                    initiallyExpanded: false,
                    title: const Text('SORT BY:'),
                    children: [
                      Text('Hello'),
                    ],
                    onExpansionChanged: (bool expanded) {
                      setState(() => isExpanded1 = expanded);
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).padding.bottom + 25,
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget buildBody() {
    if (positionRestockPage == 0) {
      return pageRestockMain();
    } else {
      return pageRestockFilters();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(body: buildBody()),
    );
  }

  DateTime currentBackPressTime = DateTime.now();

  Future<bool> _onBackPressed() {
    if (positionRestockPage != 0) {
      setState(() {
        positionRestockPage = 0;
        // SchedulerBinding.instance.addPostFrameCallback((_) {
        //   scrollRestock.jumpTo(scrollRestock.position.minScrollExtent);
        // });
      });
      return Future.value(false);
    } else {
      DateTime now = DateTime.now();
      if (now.difference(currentBackPressTime) > const Duration(seconds: 2)) {
        currentBackPressTime = now;
        Fluttertoast.showToast(msg: 'Press Back Button Again to Exit');
        return Future.value(false);
      }
      exit(0);
      // return Future.value(false);
    }
  }

  Future<void> _pullRefresh() async {
    restock = await getRestock();
    if (mounted) setState(() {});
  }
}
