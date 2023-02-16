import 'package:flutter/material.dart';
import 'package:s4s_mobileapp/calendar/page_calendar.dart';
import 'package:s4s_mobileapp/home/page_home.dart';
// import 'package:s4s_mobileapp/search/page_search.dart';
import 'package:s4s_mobileapp/tools/functions.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:page_indicator/page_indicator.dart';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:s4s_mobileapp/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import "dart:async";
import 'package:s4s_mobileapp/product/product_detail.dart';
// import 'dart:async';

// ignore: depend_on_referenced_packages
// import 'package:pretty_json/pretty_json.dart';
// import 'dart:developer';

final ScrollController scrollTrend = ScrollController();
final PageController controllerNews = PageController();
GlobalKey<PageContainerState> key = GlobalKey();

class TrendPage extends StatefulWidget {
  const TrendPage({Key? key}) : super(key: key);

  @override
  State<TrendPage> createState() => _TrendPageState();
}

class _TrendPageState extends State<TrendPage> {
  int max = 2;
  List listHeats = [];
  List listRecently = [];
  List listNews = [];
  List listTops = [];
  Timer? timer;

  @override
  void initState() {
    listHeats = heats;
    listRecently = recently;
    listNews = news;
    listTops = tops;

    timer = Timer.periodic(const Duration(minutes: 3), (Timer timer) {
      // setState(() {
      getListHeats().then((e) {
        if (mounted) {
          setState(() {
            listHeats = e;
          });
        }
      });
      getListRecently().then((e) {
        if (mounted) {
          setState(() {
            listRecently = e;
          });
        }
      });
      getListNews().then((e) {
        if (mounted) {
          setState(() {
            listNews = e;
          });
        }
      });
      getListTops().then((e) {
        if (mounted) {
          setState(() {
            listTops = e;
          });
        }
      });
      // listHeats = await getListHeats();
      // listRecently = await getListRecently();
      // listNews = await getListNews();
      // listTops = await getListTops();
      // });
    });

    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        //key: const PageStorageKey<String>('ScrollView Default'),
        controller: scrollTrend,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top + 5,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: Container(
                height: 280,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 255, 35, 35),
                      Color.fromARGB(255, 255, 135, 135),
                      Color.fromARGB(221, 255, 190, 190),
                      Color.fromARGB(255, 252, 232, 232),
                    ],
                  ),
                ),
                child: Stack(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  alignment: Alignment.topLeft,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 5, 0, 0),
                          child: ColumnSuper(
                            children: [
                              Container(
                                color: Colors.transparent,
                                child: ColumnSuper(
                                  alignment: Alignment.bottomLeft,
                                  innerDistance: -15,
                                  children: [
                                    Text(
                                      textAlign: TextAlign.start,
                                      style: robotoStyle(FontWeight.w900,
                                          Colors.white, 35, null),
                                      "Heats",
                                    ),
                                    Text(
                                      style: robotoStyle(FontWeight.w400,
                                          Colors.white, 35, null),
                                      "of the weeks",
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        InkWell(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 20,
                            ),
                            child: Text(
                              style: robotoStyle(FontWeight.w400, Colors.white,
                                  20, TextDecoration.underline),
                              "See More",
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              selectedIndex = 1;
                              isUpcoming = true;
                              isPast = false;
                              positionCalendarPage = 0;
                            });
                            Navigator.pushReplacementNamed(context, '/Home');
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 50,
                      ),
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        //key: const PageStorageKey<String>('Listview Heats'),
                        scrollDirection: Axis.horizontal,
                        itemCount: listHeats.length,
                        itemBuilder: (context, position) {
                          // print(listHeats[position]['ProducImage']);
                          return InkWell(
                            onTap: () async {
                              // if (mounted) {
                              // setState(() async {
                              raffleDetail = await getRaffles(
                                  listHeats[position]['ProductSKU']);
                              retailDetail = await getRetails(
                                  listHeats[position]['ProductSKU']);
                              resellDetail = await getResells(
                                  listHeats[position]['ProductSKU']);
                              cUSSizes = getMainSizeData(
                                  resellDetail['ProductSizeBest']);
                              cUKSizes = getUKSize(cUSSizes);
                              cEUSizes = getEUSize(cUSSizes);
                              cPricesPerSize = cUSSizes
                                  .map((e) => getPricePerSize(
                                      e, resellDetail['ProductSizeBest']))
                                  .toList();
                              is360Able = false;
                              selectedIndex = 1;
                              positionCalendarPage = 2;
                              //   });
                              // }
                              // ignore: use_build_context_synchronously
                              Navigator.pushReplacementNamed(context, '/Home');
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                              child: Container(
                                color: Colors.transparent,
                                child: Center(
                                    // child: ColumnSuper(
                                    // children: [
                                    child: Container(
                                  color: Colors.transparent,
                                  child: ColumnSuper(
                                    alignment: Alignment.center,
                                    innerDistance: -2,
                                    invert: true,
                                    children: [
                                      // Image.network(url, height, width)
                                      SizedBox(
                                        width: 160,
                                        height: 106.7,
                                        child: listHeats[position]
                                                    ['ProductImage'] !=
                                                ''
                                            ? Image.network(
                                                listHeats[position]
                                                    ['ProductImage'],
                                                fit: BoxFit.fill,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Image.asset(
                                                    'assets/etc/NoImage-trans.png',
                                                    fit: BoxFit.fill,
                                                  );
                                                },
                                              )
                                            : Image.asset(
                                                'assets/etc/NoImage-trans.png',
                                                fit: BoxFit.fill,
                                              ),
                                        // child: Image.file(
                                        //   listHeats[position]['ProductImage'],
                                        //   fit: BoxFit.fill,
                                        //   errorBuilder:
                                        //       (context, error, stackTrace) {
                                        //     return Image.asset(
                                        //       'assets/etc/NoImage.png',
                                        //       fit: BoxFit.fill,
                                        //     );
                                        //   },
                                        // ),
                                      ),
                                      Material(
                                        elevation: 5,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20.0)),
                                        child: Container(
                                          height: 75,
                                          width: 145,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20.0)),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 3, 10, 3),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  listHeats[position]
                                                      ['ProductName'],
                                                  style: robotoStyle(
                                                      FontWeight.w900,
                                                      const Color.fromARGB(
                                                          255, 49, 48, 54),
                                                      14,
                                                      null),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                ),
                                                // const SizedBox(
                                                //   height: 3,
                                                // ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      '${listHeats[position]['MonthDay'].split(',')[0]},',
                                                      style: robotoStyle(
                                                          FontWeight.normal,
                                                          const Color.fromARGB(
                                                              255, 49, 48, 54),
                                                          13,
                                                          null),
                                                      maxLines: max,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    Text(
                                                      '${listHeats[position]['MonthDay'].split(',')[1]}',
                                                      style: robotoStyle(
                                                          FontWeight.w800,
                                                          const Color.fromARGB(
                                                              255, 49, 48, 54),
                                                          13,
                                                          null),
                                                      maxLines: max,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),

                                                // const SizedBox(
                                                //   height: 3,
                                                // ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Resell   ",
                                                      style: robotoStyle(
                                                          FontWeight.normal,
                                                          returnColorCalendarCote(
                                                            listHeats[position][
                                                                    'ResellValuePourcent']
                                                                .replaceAll(
                                                                    '%', ''),
                                                          ),
                                                          11,
                                                          null),
                                                      maxLines: max,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    Text(
                                                      listHeats[position][
                                                              'ResellValuePourcent']
                                                          .toString(),
                                                      style: robotoStyle(
                                                          FontWeight.w900,
                                                          returnColorCalendarCote(
                                                            listHeats[position][
                                                                    'ResellValuePourcent']
                                                                .replaceAll(
                                                                    '%', ''),
                                                          ),
                                                          15,
                                                          null),
                                                      maxLines: max,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                    // ],
                                    // ),
                                    ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
              child: Container(
                height: 260,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    color: Colors.transparent),
                child: PageIndicatorContainer(
                  // key: key,
                  //key: const PageStorageKey<String>('Pageview News'),
                  align: IndicatorAlign.bottom,
                  length: listNews.length,
                  indicatorSpace: 12.0,
                  padding: const EdgeInsets.all(10),
                  indicatorColor: Colors.white,
                  indicatorSelectorColor: const Color.fromARGB(255, 49, 48, 54),
                  shape: IndicatorShape.circle(size: 8),
                  child: PageView.builder(
                    //key: const PageStorageKey<String>('Pageview News'),
                    itemCount: listNews.length,
                    controller: controllerNews,
                    itemBuilder: (BuildContext context, int position) {
                      return InkWell(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            launchSnackbar(
                              "S4S News: Widget $position clicked",
                              Icons.check,
                              const Color.fromARGB(255, 255, 35, 35),
                              Colors.white,
                              const Color.fromARGB(255, 255, 35, 35),
                            ),
                          );
                        },
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: SizedBox(
                                width: 400, height: 270,
                                // child: Image.network(
                                //   listNews[position],
                                //   fit: BoxFit.cover,
                                //   errorBuilder: (context, error, stackTrace) {
                                //     return Image.asset(
                                //       'assets/etc/NoImage.png',
                                //       fit: BoxFit.contain,
                                //     );
                                //   },
                                // ),
                                child: CachedNetworkImage(
                                  imageUrl: listNews[position],
                                  fit: BoxFit.cover,
                                  errorWidget: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/etc/NoImage.png',
                                      fit: BoxFit.contain,
                                    );
                                  },
                                ),
                                // child: Image.file(
                                //   listNews[position],
                                //   fit: BoxFit.cover,
                                //   errorBuilder: (context, error, stackTrace) {
                                //     return Image.asset(
                                //       'assets/etc/NoImage.png',
                                //       fit: BoxFit.contain,
                                //     );
                                //   },
                                // ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 10, 0, 0),
                              child: Text(
                                style: robotoStyle(
                                    FontWeight.w900, Colors.white, 35, null),
                                "S4S",
                              ),
                            ),
                            Positioned(
                              top: 30.0,
                              left: 30.0,
                              child: Text(
                                style: robotoStyle(
                                    FontWeight.w400, Colors.white, 35, null),
                                "news",
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 25),
              child: Container(
                height: 270,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 110, 120, 140),
                      Color.fromARGB(255, 190, 196, 208),
                      Color.fromARGB(255, 216, 221, 229),
                      Color.fromARGB(255, 231, 234, 239),
                    ],
                  ),
                ),
                child: Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 5, 0, 0),
                          child: Container(
                            color: Colors.transparent,
                            child: ColumnSuper(
                              alignment: Alignment.bottomLeft,
                              innerDistance: -15,
                              children: [
                                Text(
                                  textAlign: TextAlign.start,
                                  style: robotoStyle(
                                      FontWeight.w900, Colors.white, 35, null),
                                  "Recently",
                                ),
                                Text(
                                  style: robotoStyle(
                                      FontWeight.w400, Colors.white, 35, null),
                                  "Dropped",
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 20,
                            ),
                            child: Text(
                              style: robotoStyle(FontWeight.w400, Colors.white,
                                  20, TextDecoration.underline),
                              "See More",
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              selectedIndex = 1;
                              isUpcoming = false;
                              isPast = true;
                              positionCalendarPage = 1;
                            });
                            Navigator.pushReplacementNamed(context, '/Home');
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 60,
                      ),
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        //key: const PageStorageKey<String>('Listview Drops'),
                        scrollDirection: Axis.horizontal,
                        itemCount: listRecently.length,
                        itemBuilder: (context, position) {
                          return InkWell(
                            onTap: () async {
                              productDetail = await getProductDetail(
                                  listRecently[position]['ProductSKU']);
                              USSizes = getMainSizeData(
                                  productDetail['ProductSizeBest']);
                              UKSizes = getUKSize(USSizes);
                              EUSizes = getEUSize(USSizes);
                              pricesPerSize = USSizes.map((e) =>
                                      getPricePerSize(
                                          e, productDetail['ProductSizeBest']))
                                  .toList();
                              // is360Possible = productDetail['360Pictures'];
                              selectedIndex = 5;
                              // ignore: use_build_context_synchronously
                              Navigator.of(context).pushNamed('/Home');
                              // Navigator.pushReplacementNamed(context, '/Home');
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                              child: Container(
                                color: Colors.transparent,
                                child: Center(
                                  child: ColumnSuper(
                                    children: [
                                      Container(
                                        color: Colors.transparent,
                                        child: ColumnSuper(
                                          alignment: Alignment.center,
                                          innerDistance: -2,
                                          invert: true,
                                          children: [
                                            // Image.network(url, height, width)
                                            SizedBox(
                                              width: 160,
                                              height: 106.7,
                                              child: listRecently[position]
                                                          ['ProductImage'] !=
                                                      ''
                                                  ? Image.network(
                                                      listRecently[position]
                                                          ['ProductImage'],
                                                      fit: BoxFit.fill,
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        return Image.asset(
                                                          'assets/etc/NoImage-trans.png',
                                                          fit: BoxFit.fill,
                                                        );
                                                      },
                                                      // height: 108,
                                                    )
                                                  : Image.asset(
                                                      'assets/etc/NoImage-trans.png',
                                                      fit: BoxFit.fill,
                                                    ),

                                              // child: Image.file(
                                              //   listRecently[position]
                                              //       ['ProductImage'],
                                              //   fit: BoxFit.fill,
                                              //   errorBuilder: (context, error,
                                              //       stackTrace) {
                                              //     return Image.asset(
                                              //       'assets/etc/NoImage.png',
                                              //       fit: BoxFit.fill,
                                              //     );
                                              //   },
                                              // ),
                                            ),
                                            Material(
                                              elevation: 5,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(20.0)),
                                              child: Container(
                                                height: 75,
                                                width: 145,
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              20.0)),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 3, 10, 3),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Text(
                                                        listRecently[position]
                                                            ['ProductName'],
                                                        style: robotoStyle(
                                                            FontWeight.w900,
                                                            const Color
                                                                    .fromARGB(
                                                                255,
                                                                49,
                                                                48,
                                                                54),
                                                            14,
                                                            null),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            listRecently[
                                                                        position]
                                                                    ['xxShops']
                                                                .toString(),
                                                            style: robotoStyle(
                                                                FontWeight.w800,
                                                                const Color
                                                                        .fromARGB(
                                                                    255,
                                                                    49,
                                                                    48,
                                                                    54),
                                                                13,
                                                                null),
                                                            maxLines: max,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          Text(
                                                            style: robotoStyle(
                                                                FontWeight
                                                                    .normal,
                                                                const Color
                                                                        .fromARGB(
                                                                    255,
                                                                    49,
                                                                    48,
                                                                    54),
                                                                13,
                                                                null),
                                                            maxLines: max,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            " Shops",
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            r"€" +
                                                                listRecently[
                                                                            position]
                                                                        [
                                                                        'ProductMarketValue']
                                                                    .toString(),
                                                            style: robotoStyle(
                                                                FontWeight.w500,
                                                                listRecently[position]
                                                                            [
                                                                            'ProductResellArrow'] ==
                                                                        'Down'
                                                                    ? const Color
                                                                            .fromARGB(
                                                                        255,
                                                                        255,
                                                                        35,
                                                                        35)
                                                                    : const Color
                                                                            .fromARGB(
                                                                        255,
                                                                        33,
                                                                        237,
                                                                        91),
                                                                14,
                                                                null),
                                                            maxLines: max,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          const SizedBox(
                                                            width: 4,
                                                          ),
                                                          Icon(
                                                            listRecently[position]
                                                                        [
                                                                        'ProductResellArrow'] ==
                                                                    "Up"
                                                                ? Icons
                                                                    .trending_up_rounded
                                                                : Icons
                                                                    .trending_down_rounded,
                                                            color: listRecently[
                                                                            position]
                                                                        [
                                                                        'ProductResellArrow'] ==
                                                                    "Up"
                                                                ? const Color(
                                                                    0xff21ED5B)
                                                                : const Color(
                                                                    0xffF55E5E),
                                                            size: 20,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: const Alignment(-0.75, 0),
              child: ColumnSuper(
                children: [
                  Container(
                    color: Colors.transparent,
                    child: ColumnSuper(
                      alignment: Alignment.bottomLeft,
                      innerDistance: -15,
                      children: [
                        Text(
                          style: robotoStyle(FontWeight.w900,
                              const Color.fromARGB(255, 49, 48, 54), 35, null),
                          "Top Clicked",
                        ),
                        Text(
                          style: robotoStyle(FontWeight.w400,
                              const Color.fromARGB(255, 49, 48, 54), 35, null),
                          "by users",
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Wrap(
              children: [
                for (int index = 0; index < listTops.length; index++)
                  InkWell(
                    onTap: () async {
                      productDetail =
                          await getProductDetail(listTops[index]['ProductSKU']);
                      USSizes =
                          getMainSizeData(productDetail['ProductSizeBest']);
                      UKSizes = getUKSize(USSizes);
                      EUSizes = getEUSize(USSizes);
                      pricesPerSize = USSizes.map((e) => getPricePerSize(
                          e, productDetail['ProductSizeBest'])).toList();
                      // is360Possible = productDetail['360Pictures'];
                      selectedIndex = 5;
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pushNamed('/Home');
                    },
                    child: SizedBox(
                      width:
                          (MediaQuery.of(context).size.width ~/ 2).toDouble(),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 15,
                              left: 15,
                              right: 10,
                              bottom: 0,
                            ),
                            child: SizedBox(
                              width: 172,
                              height: 115,
                              child: listTops[index]['ProductImage'] != ''
                                  ? Image.network(
                                      listTops[index]['ProductImage'],
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                          'assets/etc/NoImage.png',
                                          fit: BoxFit.contain,
                                        );
                                      },
                                    )
                                  : Image.asset(
                                      'assets/etc/NoImage.png',
                                      fit: BoxFit.fitWidth,
                                    ),
                              // child: Image.file(
                              //   listTops[index]['ProductImage'],
                              //   fit: BoxFit.contain,
                              //   errorBuilder: (context, error, stackTrace) {
                              //     return Image.asset(
                              //       'assets/etc/NoImage.png',
                              //       fit: BoxFit.contain,
                              //     );
                              //   },
                              // ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 7,
                              left: 30,
                              right: 30,
                              bottom: 5,
                            ),
                            child: Text(
                              '${listTops[index]['ProductName']}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                color: Color(0xff757D90),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${listTops[index]['xxShops']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff757D90),
                                ),
                              ),
                              const Text(
                                '  Shops',
                                style: TextStyle(
                                  color: Color(0xff757D90),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '€${listTops[index]['ProductMarketValue']} ',
                                style: TextStyle(
                                  color: listTops[index]
                                              ['ProductResellArrow'] ==
                                          "Up"
                                      ? const Color(0xff21ED5B)
                                      : const Color(0xffF55E5E),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Icon(
                                listTops[index]['ProductResellArrow'] == "Up"
                                    ? Icons.trending_up_rounded
                                    : Icons.trending_down_rounded,
                                size: 22,
                                color: listTops[index]['ProductResellArrow'] ==
                                        "Up"
                                    ? const Color(0xff21ED5B)
                                    : const Color(0xffF55E5E),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            // ),
            const SizedBox(
              height: 30,
            ),
            InkWell(
              child: Text(
                textAlign: TextAlign.center,
                style: robotoStyle(
                    FontWeight.w500,
                    const Color.fromARGB(255, 255, 35, 35),
                    20,
                    TextDecoration.underline),
                "Browse More",
              ),
              onTap: () {
                setState(() {
                  selectedIndex = 2;
                  positionSearchPage = 0;
                });
                Navigator.pushReplacementNamed(context, '/Home');
              },
            ),
            const SizedBox(height: 100)
          ],
        ),
      ),
    );
  }

  // getListHeats() async {
  //   var result = await getData('http://194.163.152.120:3000/heats');
  //   listHeats = jsonDecode(result)['data']['heats']
  //       .map((e) {
  //         return {
  //           "ProductSKU": e['ProductSKU'],
  //           "ProductImage": e['ProductImage'] == ''
  //               ? 'https://placehold.co/200/png'
  //               : e['ProductImage'],
  //           "ProductName": e['ProductName'],
  //           "MonthDay": e['MonthDay'],
  //           "ResellValuePourcent": e['ResellValuePourcent']
  //         };
  //       })
  //       .toList()
  //       .cast<Map>();
  //   // if (!mounted) return;
  //   if (mounted) setState(() {});
  // }

  // getListRecently() async {
  //   var result = await getData('http://194.163.152.120:3000/recent');
  //   listRecently = jsonDecode(result)['data']['recentlyDropped']
  //       .map((e) {
  //         return {
  //           "ProductSKU": e['ProductSKU'],
  //           "ProductImage": e['ProductImage'] == ''
  //               ? 'https://placehold.co/200/png'
  //               : e['ProductImage'],
  //           "ProductName": e['ProductName'],
  //           "xxShops": e['xxShops'],
  //           "ProductMarketValue": e['ProductMarketValue'],
  //           "ResellValuePourcent": e['ResellValuePourcent'],
  //           "ProductResellArrow": e['ProductResellArrow'],
  //         };
  //       })
  //       .toList()
  //       .cast<Map>();
  //   // if (!mounted) return;
  //   if (mounted) setState(() {});
  // }

  // getListNews() async {
  //   var result = await getData('http://194.163.152.120:3000/s4snews');
  //   listNews = jsonDecode(result)['data']['s4sNews']
  //       .map((e) {
  //         return e.toString();
  //       })
  //       .toList()
  //       .cast<String>();
  //   if (mounted) setState(() {});
  // }

  // getListTops() async {
  //   var result = await getData('http://194.163.152.120:3000/top');
  //   listTops = jsonDecode(result)['data']['topClicked']
  //       .map((e) {
  //         return {
  //           'ProductSKU': e['ProductSKU'],
  //           'ProductImage': e['ProductImage'] == ''
  //               ? 'https://placehold.co/200/png'
  //               : e['ProductImage'],
  //           'ProductName': e['ProductName'],
  //           'product_change_arrow': e['product_change_arrow'],
  //           'xxShops': e['xxShops'],
  //           'ProductMarketValue': e['ProductMarketValue'],
  //           'ProductResellArrow': e['ProductResellArrow'],
  //         };
  //       })
  //       .toList()
  //       .cast<Map>();
  //   // if (!mounted) return;
  //   if (mounted) setState(() {});
  // }
}
