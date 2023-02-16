import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:s4s_mobileapp/main.dart';
import 'package:s4s_mobileapp/widgets/custom_horizontal_picker/custom_horizontal_picker.dart';
import 'package:imageview360/imageview360.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:s4s_mobileapp/account/page_account.dart';
import 'package:s4s_mobileapp/tools/functions.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_share/social_share.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/services.dart';
// import 'package:flutter/services.dart' show rootBundle;
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:s4s_mobileapp/widgets/custom_flutter_multi_select_items/flutter_multi_select_items.dart';
// import 'package:get/get.dart';
// import 'dart:convert';

// dev packages
// import 'package:pretty_json/pretty_json.dart';
// import 'dart:developer' as dev;

int positionCalendarPage = 0;

bool is360 = false;

bool is360Able = false;

List<ImageProvider> imageList360 = [];

// ScrollController scrollCalendarMain = ScrollController();
// ScrollController scrollCalendarMain =
//     ScrollController(initialScrollOffset: 20.0);

bool isUpcoming = true;
bool isPast = false;

bool isCalendarFav = false;

bool isRaffles = false;
bool isRetail = true;
bool isResell = false;

var listResellPrices = [];

// bool isMarked = false;
// var mark = [];

var specifications = ["", "", "", ""];

/*temporary: like Examples*/
double likeBar = 0.5;
int like = 0;
int dislike = 0;

var listRetailContainer = [[]];
// var listRafflesContainer = [[]];
var listResellContainer = [[]];

List<Map> listRaffle = [];
List<Map> listRetail = [];
List<Map> listResell = [];
Map raffleDetail = {};
Map retailDetail = {};
Map resellDetail = {};
List cUSSizes = [];
List cUKSizes = [];
List cEUSizes = [];
List cPricesPerSize = [];

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final ScrollController scrollCalendarMain = ScrollController();
  bool isLoading = false;
  List upcomings = [];
  List filteredUpcomings = [];
  List pasts = [];
  List filteredPasts = [];
  List detailsPerSize = [];
  Timer? timer1, timer2;
  List calendarFilter = [];
  String logoPath = '';

  @override
  void initState() {
    // positionCalendarPage = 0;
    upcomings = upcoming;
    pasts = past;
    timer1 = Timer.periodic(const Duration(minutes: 3), (Timer timer) {
      // setState(() {
      getUpcomings().then((e) {
        if (mounted) {
          setState(() {
            upcomings = e;
          });
        }
      });
      getPasts().then((e) {
        if (mounted) {
          setState(() {
            pasts = e;
          });
        }
      });
      // });
    });
    if (mounted) {
      scrollCalendarMain.addListener(() {
        calendarOffset = scrollCalendarMain.offset;
      });
      // timer2 = Timer(const Duration(microseconds: 10), () {
      scrollDown(scrollCalendarMain, calendarOffset);
      // });
    }

    getImageFileFromAssets('MobileAppLogo.png').then((e) {
      if (mounted) {
        setState(() {
          logoPath = e.path;
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    timer1?.cancel();
    timer2?.cancel();
    super.dispose();
  }

  Widget pageCalendarMainUpcoming() {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).padding.top,
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
                  icon: const Icon(
                    Icons.share,
                    // FontAwesomeIcons.upload,
                    size: 31.0,
                  ),
                  color: const Color.fromARGB(255, 49, 48, 54),
                  iconSize: 40,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Share with...'),
                          content: Wrap(
                            alignment: WrapAlignment.center,
                            children: <Widget>[
                              IconButton(
                                icon: Image.asset('assets/icons/facebook.png'),
                                color: const Color.fromARGB(255, 49, 48, 54),
                                iconSize: 35,
                                onPressed: () async {
                                  SocialShare.shareFacebookStory(
                                    logoPath,
                                    '#ffffff',
                                    '#000000',
                                    'https://www.sneaks4sure.com/',
                                  );
                                },
                              ),
                              IconButton(
                                icon: Image.asset('assets/icons/twitter.png'),
                                color: const Color.fromARGB(255, 49, 48, 54),
                                iconSize: 35,
                                onPressed: () {
                                  SocialShare.shareTwitter(
                                    'Sneaks4Sure',
                                    url: 'https://www.sneaks4sure.com/',
                                  );
                                },
                              ),
                              IconButton(
                                icon: Image.asset('assets/icons/instagram.png'),
                                color: const Color.fromARGB(255, 49, 48, 54),
                                iconSize: 35,
                                onPressed: () {
                                  SocialShare.shareInstagramStory(logoPath,
                                      attributionURL:
                                          'https://www.sneaks4sure.com/');
                                },
                              ),
                              IconButton(
                                icon: Image.asset('assets/icons/whatsapp.png'),
                                color: const Color.fromARGB(255, 49, 48, 54),
                                iconSize: 35,
                                onPressed: () {
                                  SocialShare.shareWhatsapp(
                                      "https://www.sneaks4sure.com/");
                                },
                              ),
                              IconButton(
                                icon: Image.asset('assets/icons/telegram.png'),
                                color: const Color.fromARGB(255, 49, 48, 54),
                                iconSize: 35,
                                onPressed: () {
                                  SocialShare.shareTelegram(
                                      'https://www.sneaks4sure.com/');
                                },
                              ),
                              // IconButton(
                              //   icon: const Icon(
                              //     FontAwesomeIcons.clipboard,
                              //     // size: 24.0,
                              //   ),
                              //   color: const Color.fromARGB(255, 49, 48, 54),
                              //   iconSize: 35,
                              //   onPressed: () {
                              //     SocialShare.copyToClipboard(
                              //         'https://www.sneaks4sure.com/');
                              //   },
                              // ),
                            ],
                          ),
                        );
                      },
                    );
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
                child: IconButton(
                  icon: const Icon(
                    FontAwesomeIcons.arrowDownWideShort,
                    size: 22.0,
                  ),
                  color: const Color.fromARGB(255, 49, 48, 54),
                  iconSize: 40,
                  onPressed: () {
                    calendarFilterPopUp(context);
                  },
                ),
              ),
            ),
          ],
        ),
        // const SizedBox(
        //   height: 12,
        // ),
        const Divider(
          color: Colors.grey,
          height: 0,
          thickness: 1,
        ),
        Expanded(
          child: SmartRefresher(
            enablePullDown: false,
            enablePullUp: true,
            footer: CustomFooter(
              builder: (BuildContext context, LoadStatus? mode) {
                return const SizedBox(height: 0, width: 0);
              },
            ),
            controller: _refreshController,
            // onLoading: () async {
            //   isLoading = true;
            //   upcomings = await getUpcomings();
            //   if(filteredUpcomings.isNotEmpty) upcomings =
            //   _refreshController.loadComplete();
            //   isLoading = false;
            //   if (mounted) setState(() {});
            // },
            child: ListView.separated(
              key: const PageStorageKey<String>('Listview Upcoming Parent'),
              controller: scrollCalendarMain,
              physics: const BouncingScrollPhysics(),
              itemCount: filteredUpcomings.isEmpty
                  ? upcomings.length
                  : filteredUpcomings.length,
              separatorBuilder: (BuildContext context, int index) {
                // print(index);
                // return calendarDateBarUpcoming(upcomings[index]);
                return const SizedBox(
                  height: 0,
                );
              },
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    calendarDateBarUpcoming(filteredUpcomings.isEmpty
                        ? upcomings[index]
                        : filteredUpcomings[index]),
                    ListView.builder(
                      padding: const EdgeInsets.only(bottom: 0),
                      key: const PageStorageKey<String>(
                          'Listview Upcoming Child 0'),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredUpcomings.isEmpty
                          ? upcomings[index][upcomings[index].keys.first].length
                          : filteredUpcomings[index]
                                  [filteredUpcomings[index].keys.first]
                              .length,
                      itemBuilder: (BuildContext context, int indexProduct) {
                        var product = filteredUpcomings.isEmpty
                            ? upcomings[index][upcomings[index].keys.first]
                            : filteredUpcomings[index]
                                [filteredUpcomings[index].keys.first];
                        return InkWell(
                          onTap: () async {
                            raffleDetail = await getRaffles(
                                product[indexProduct]['ProductSKU']);
                            for (int i = 0;
                                i < raffleDetail['ProductImage360'].length;
                                i++) {
                              if (mounted) {
                                await precacheImage(
                                    NetworkImage(
                                        raffleDetail['ProductImage360'][i]),
                                    context);
                              }
                            }

                            retailDetail = await getRetails(
                                product[indexProduct]['ProductSKU']);
                            resellDetail = await getResells(
                                product[indexProduct]['ProductSKU']);
                            cUSSizes = getMainSizeData(
                                resellDetail['ProductSizeBest']);
                            cUKSizes = getUKSize(cUSSizes);
                            cEUSizes = getEUSize(cUSSizes);
                            cPricesPerSize = cUSSizes
                                .map((e) => getPricePerSize(
                                    e, resellDetail['ProductSizeBest']))
                                .toList();
                            is360Able = product[indexProduct]['360Pictures'];
                            positionCalendarPage = 2;
                            isRetail = true;
                            isRaffles = false;
                            isResell = false;
                            if (mounted) setState(() {});
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color:
                                      const Color(0xffc5c5c5).withOpacity(0.8),
                                  width: 0.2,
                                ),
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(30, 15, 30, 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          product[indexProduct]
                                                      ['ProductName'] !=
                                                  null
                                              ? product[indexProduct]
                                                      ['ProductName']
                                                  .toString()
                                              : '',
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: robotoStyle(
                                              FontWeight.w800,
                                              const Color.fromARGB(
                                                  255, 49, 48, 54),
                                              16,
                                              null),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              product[indexProduct]
                                                          ['xxShops'] !=
                                                      null
                                                  ? product[indexProduct]
                                                          ['xxShops']
                                                      .toString()
                                                  : '',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle: FontStyle.italic),
                                            ),
                                            const Text(
                                              " Shops",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  fontStyle: FontStyle.italic),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Wrap(
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: product[indexProduct][
                                                          'ResellValuePourcent'] !=
                                                      null &&
                                                  product[indexProduct][
                                                          'ResellValuePourcent'] !=
                                                      'TBC' &&
                                                  product[indexProduct][
                                                          'ResellValuePourcent'] !=
                                                      "" &&
                                                  product[indexProduct]
                                                          ['ResellValueProfit']
                                                      is! String
                                              ? [
                                                  Text(
                                                    product[indexProduct]
                                                        ['ResellValuePourcent'],
                                                    style: robotoStyle(
                                                        FontWeight.w800,
                                                        returnColorCalendarCote(
                                                            product[indexProduct]
                                                                    [
                                                                    'ResellValuePourcent']
                                                                .toString()
                                                                .replaceAll(
                                                                    '%', '')),
                                                        18,
                                                        null),
                                                  ),
                                                  Icon(
                                                    isNumber(product[
                                                                    indexProduct]
                                                                [
                                                                'ResellValuePourcent']) &&
                                                            int.parse(product[
                                                                            indexProduct]
                                                                        [
                                                                        'ResellValuePourcent']
                                                                    .toString()
                                                                    .replaceAll(
                                                                        '%',
                                                                        '')) >=
                                                                0
                                                        ? Icons
                                                            .trending_up_rounded
                                                        : Icons
                                                            .trending_down_rounded,
                                                    size: 25,
                                                    color: returnColorCalendarCote(
                                                        product[indexProduct][
                                                                'ResellValuePourcent']
                                                            .toString()
                                                            .replaceAll(
                                                                '%', '')),
                                                  ),
                                                  Text(
                                                    "  (profit >€${product[indexProduct]['ResellValueProfit'] == '-' ? '' : product[indexProduct]['ResellValueProfit'].toString()})",
                                                    style: robotoStyle(
                                                        FontWeight.w600,
                                                        returnColorCalendarCote(
                                                            product[indexProduct]
                                                                    [
                                                                    'ResellValuePourcent']
                                                                .toString()
                                                                .replaceAll(
                                                                    '%', '')),
                                                        12,
                                                        null),
                                                  ),
                                                ]
                                              : [
                                                  const Text(
                                                    'TBC',
                                                    style: TextStyle(
                                                      color: Color(0xff313036),
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Image.network(url, height, width)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: SizedBox(
                                      height: 95,
                                      width: 155,
                                      child: product[indexProduct]
                                                  ['ProductImage'] !=
                                              ''
                                          ? Image.network(
                                              product[indexProduct]
                                                  ['ProductImage'],
                                              fit: BoxFit.contain,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Image.asset(
                                                  'assets/etc/NoImage-trans.png',
                                                  fit: BoxFit.contain,
                                                );
                                              },
                                            )
                                          : Image.asset(
                                              'assets/etc/NoImage-trans.png',
                                              fit: BoxFit.contain,
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    // ),
                  ],
                );
                // }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget pageCalendarMainPast() {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).padding.top,
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
                  icon: const Icon(
                    Icons.share,
                    // FontAwesomeIcons.upload,
                    size: 31.0,
                  ),
                  color: const Color.fromARGB(255, 49, 48, 54),
                  iconSize: 40,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Share with...'),
                          content: Wrap(
                            alignment: WrapAlignment.center,
                            children: <Widget>[
                              IconButton(
                                icon: Image.asset('assets/icons/facebook.png'),
                                color: const Color.fromARGB(255, 49, 48, 54),
                                iconSize: 35,
                                onPressed: () async {
                                  SocialShare.shareFacebookStory(
                                    logoPath,
                                    '#ffffff',
                                    '#000000',
                                    'https://www.sneaks4sure.com/',
                                  );
                                },
                              ),
                              IconButton(
                                icon: Image.asset('assets/icons/twitter.png'),
                                color: const Color.fromARGB(255, 49, 48, 54),
                                iconSize: 35,
                                onPressed: () {
                                  SocialShare.shareTwitter(
                                    'Sneaks4Sure',
                                    url: 'https://www.sneaks4sure.com/',
                                  );
                                },
                              ),
                              IconButton(
                                icon: Image.asset('assets/icons/instagram.png'),
                                color: const Color.fromARGB(255, 49, 48, 54),
                                iconSize: 35,
                                onPressed: () {
                                  SocialShare.shareInstagramStory(logoPath,
                                      attributionURL:
                                          'https://www.sneaks4sure.com/');
                                },
                              ),
                              IconButton(
                                icon: Image.asset('assets/icons/whatsapp.png'),
                                color: const Color.fromARGB(255, 49, 48, 54),
                                iconSize: 35,
                                onPressed: () {
                                  SocialShare.shareWhatsapp(
                                      "https://www.sneaks4sure.com/");
                                },
                              ),
                              IconButton(
                                icon: Image.asset('assets/icons/telegram.png'),
                                color: const Color.fromARGB(255, 49, 48, 54),
                                iconSize: 35,
                                onPressed: () {
                                  SocialShare.shareTelegram(
                                      'https://www.sneaks4sure.com/');
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
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
                child: IconButton(
                  icon: const Icon(
                    FontAwesomeIcons.arrowDownWideShort,
                    size: 22.0,
                  ),
                  color: const Color.fromARGB(255, 49, 48, 54),
                  iconSize: 40,
                  onPressed: () {
                    calendarFilterPopUp(context);
                  },
                ),
              ),
            ),
          ],
        ),
        // const SizedBox(
        //   height: 12,
        // ),
        const Divider(
          color: Colors.grey,
          height: 0,
          thickness: 1,
        ),
        Expanded(
          child: SmartRefresher(
            enablePullDown: false,
            enablePullUp: true,
            footer: CustomFooter(
              builder: (BuildContext context, LoadStatus? mode) {
                return const SizedBox(height: 0, width: 0);
              },
            ),
            controller: _refreshController,
            // onLoading: () async {
            //   isLoading = true;
            //   pasts = await getPasts();
            //   _refreshController.loadComplete();
            //   isLoading = false;
            //   if (mounted) setState(() {});
            // },
            child: ListView.separated(
              key: const PageStorageKey<String>('Listview Past Parent'),
              controller: scrollCalendarMain,
              // padding: const EdgeInsets.only(bottom: 0),
              physics: const BouncingScrollPhysics(),
              itemCount:
                  filteredPasts.isEmpty ? pasts.length : filteredPasts.length,
              separatorBuilder: (BuildContext context, int index) {
                // print(index);
                // return calendarDateBarUpcoming(upcomings[index]);
                return const SizedBox(
                  height: 0,
                );
              },
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    calendarDateBarUpcoming(filteredPasts.isEmpty
                        ? pasts[index]
                        : filteredPasts[index]),
                    ListView.builder(
                      padding: const EdgeInsets.only(bottom: 0),
                      key:
                          const PageStorageKey<String>('Listview Past Child 0'),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredPasts.isEmpty
                          ? pasts[index][pasts[index].keys.first].length
                          : filteredPasts[index]
                                  [filteredPasts[index].keys.first]
                              .length,
                      itemBuilder: (BuildContext context, int indexProduct) {
                        var product = filteredPasts.isEmpty
                            ? pasts[index][pasts[index].keys.first]
                            : filteredPasts[index]
                                [filteredPasts[index].keys.first];
                        return InkWell(
                          onTap: () async {
                            raffleDetail = await getRaffles(
                                product[indexProduct]['ProductSKU']);
                            retailDetail = await getRetails(
                                product[indexProduct]['ProductSKU']);
                            resellDetail = await getResells(
                                product[indexProduct]['ProductSKU']);
                            cUSSizes = getMainSizeData(
                                resellDetail['ProductSizeBest']);
                            cUKSizes = getUKSize(cUSSizes);
                            cEUSizes = getEUSize(cUSSizes);
                            cPricesPerSize = cUSSizes
                                .map((e) => getPricePerSize(
                                    e, resellDetail['ProductSizeBest']))
                                .toList();

                            if (cUSSizes.isNotEmpty) {
                              detailsPerSize = getProductsPerSize(
                                  cUSSizes[(cUSSizes.length ~/ 2)],
                                  resellDetail['ProductSize']);
                            }

                            is360Able = product[indexProduct]['360Pictures'];
                            positionCalendarPage = 2;
                            if (mounted) setState(() {});
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color(0xffc5c5c5),
                                  width: 0.5,
                                ),
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(30, 15, 30, 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          product[indexProduct]['ProductName']
                                              .toString(),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: robotoStyle(
                                              FontWeight.w800,
                                              const Color.fromARGB(
                                                  255, 49, 48, 54),
                                              16,
                                              null),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              product[indexProduct]['xxShops']
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle: FontStyle.italic),
                                            ),
                                            const Text(
                                              " Shops",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  fontStyle: FontStyle.italic),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Wrap(
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: product[indexProduct][
                                                          'ResellValuePourcent'] !=
                                                      null &&
                                                  product[indexProduct][
                                                          'ResellValuePourcent'] !=
                                                      'TBC' &&
                                                  product[indexProduct][
                                                          'ResellValuePourcent'] !=
                                                      "" &&
                                                  product[indexProduct]
                                                          ['ResellValueProfit']
                                                      is! String
                                              ? [
                                                  Text(
                                                    product[indexProduct][
                                                            'ResellValuePourcent']
                                                        .toString(),
                                                    style: robotoStyle(
                                                        FontWeight.w800,
                                                        returnColorCalendarCote(
                                                            product[indexProduct]
                                                                    [
                                                                    'ResellValuePourcent']
                                                                .toString()
                                                                .replaceAll(
                                                                    '%', '')),
                                                        18,
                                                        null),
                                                  ),
                                                  Icon(
                                                    isNumber(product[
                                                                    indexProduct]
                                                                [
                                                                'ResellValuePourcent']) &&
                                                            int.parse(product[
                                                                            indexProduct]
                                                                        [
                                                                        'ResellValuePourcent']
                                                                    .toString()
                                                                    .replaceAll(
                                                                        '%',
                                                                        '')) >=
                                                                0
                                                        ? Icons
                                                            .trending_up_rounded
                                                        : Icons
                                                            .trending_down_rounded,
                                                    size: 25,
                                                    color: returnColorCalendarCote(
                                                        product[indexProduct][
                                                                'ResellValuePourcent']
                                                            .toString()
                                                            .replaceAll(
                                                                '%', '')),
                                                  ),
                                                  Text(
                                                    "  (profit >\$${product[indexProduct]['ResellValueProfit'] == '-' ? '' : product[indexProduct]['ResellValueProfit'].toString()})",
                                                    style: robotoStyle(
                                                        FontWeight.w600,
                                                        returnColorCalendarCote(
                                                            product[indexProduct]
                                                                    [
                                                                    'ResellValuePourcent']
                                                                .toString()
                                                                .replaceAll(
                                                                    '%', '')),
                                                        12,
                                                        null),
                                                  ),
                                                ]
                                              : [
                                                  const Text(
                                                    'TBC',
                                                    style: TextStyle(
                                                      color: Color(0xff313036),
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Image.network(url, height, width)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: SizedBox(
                                      height: 95,
                                      width: 155,
                                      child: product[indexProduct]
                                                  ['ProductImage'] !=
                                              ''
                                          ? Image.network(
                                              product[indexProduct]
                                                  ['ProductImage'],
                                              fit: BoxFit.contain,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Image.asset(
                                                  'assets/etc/NoImage-trans.png',
                                                  fit: BoxFit.contain,
                                                );
                                              },
                                            )
                                          : Image.asset(
                                              'assets/etc/NoImage-trans.png',
                                              fit: BoxFit.contain,
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    // ),
                  ],
                );
                // }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget pageCalendarItem() {
    return is360
        ? Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              bottom: MediaQuery.of(context).padding.bottom,
            ),
            alignment: Alignment.center,
            child: PinchZoom(
              resetDuration: const Duration(milliseconds: 50),
              maxScale: 5,
              onZoomStart: () {},
              onZoomEnd: () {},
              // child: Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              // children: [
              child: ImageView360(
                key: UniqueKey(),
                imageList: imageList360,
                rotationDirection: RotationDirection.anticlockwise,
                frameChangeDuration: const Duration(milliseconds: 100),
              ),
              // ],
              // ),
            ),
          )
        : Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: const Alignment(-0.9, 0),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_circle_left_outlined),
                      color: const Color(0xffF55E5E),
                      iconSize: 40,
                      onPressed: () {
                        setState(
                          () {
                            if (isUpcoming) {
                              positionCalendarPage = 0;
                            } else {
                              positionCalendarPage = 1;
                            }
                            setState(() {
                              isRaffles = false;
                              isRetail = true;
                              isResell = false;
                            });
                          },
                        );
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 130,
                      child: Image.asset(
                        'assets/etc/splash-cropped.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Align(
                    alignment: const Alignment(0.9, 0),
                    child: IconButton(
                      icon: isCalendarFav
                          ? const Icon(Icons.favorite_rounded)
                          : const Icon(Icons.favorite_border_rounded),
                      color: const Color(0xffF55E5E),
                      iconSize: 40,
                      onPressed: () {
                        setState(() {
                          isCalendarFav = !isCalendarFav;
                        });
                      },
                    ),
                  ),
                ],
              ),
              // const Divider(
              //   color: Colors.grey,
              //   height: 0,
              //   thickness: 1,
              // ),
              Container(
                padding: const EdgeInsets.fromLTRB(40, 10, 40, 20),
                child: Text(
                  raffleDetail['ProductName'],
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: robotoStyle(FontWeight.w900,
                      const Color.fromARGB(255, 49, 48, 54), 20, null),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Align(
                                alignment: const Alignment(-0.85, 0),
                                child: Image.asset(
                                  returnCalendarIcon(DateTime.parse(
                                          raffleDetail['ReleaseDate'])
                                      .day
                                      .toString()),
                                  height: 30,
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.thumb_up_alt_rounded,
                                      ),
                                      iconSize: 20,
                                      color: const Color.fromARGB(
                                          255, 33, 237, 91),
                                      onPressed: () {
                                        setState(() {
                                          like++;
                                          likeBar = like / (like + dislike);
                                        });
                                      },
                                    ),
                                    Container(
                                      height: 25,
                                      width: 110,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(100.0)),
                                        gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          stops: [0.0, likeBar, likeBar, 1.0],
                                          colors: const [
                                            Color.fromARGB(255, 33, 237, 91),
                                            Color.fromARGB(255, 33, 237, 91),
                                            Color.fromARGB(255, 255, 35, 35),
                                            Color.fromARGB(255, 255, 35, 35)
                                          ],
                                        ),
                                      ),
                                      child: Align(
                                        alignment:
                                            returnAlignment(likeBar * 100),
                                        child: Text(
                                          (likeBar * 100) > 50
                                              ? "${(likeBar * 100).toStringAsFixed(0)}%"
                                              : "${(100 - (likeBar * 100)).toStringAsFixed(0)}%",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.thumb_down_alt_rounded,
                                      ),
                                      iconSize: 20,
                                      color: const Color.fromARGB(
                                          255, 255, 35, 35),
                                      onPressed: () {
                                        setState(() {
                                          dislike++;
                                          likeBar = like / (like + dislike);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Align(
                                alignment: const Alignment(0.9, 0),
                                child: IconButton(
                                  icon: Icon(
                                    notifCalendar
                                        ? Icons.notifications_none_rounded
                                        : Icons.notifications_off_outlined,
                                  ),
                                  iconSize: 35,
                                  color: notifCalendar
                                      ? const Color.fromARGB(255, 255, 35, 35)
                                      : const Color.fromARGB(255, 49, 48, 54),
                                  onPressed: () {
                                    setState(() {
                                      notifCalendar = !notifCalendar;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        is360Able
                            ? GestureDetector(
                                child: Stack(
                                  children: [
                                    Center(
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        child: SizedBox(
                                          width: 330, height: 210,
                                          child: raffleDetail['ProductImage'] !=
                                                  ''
                                              ? Image.network(
                                                  raffleDetail['ProductImage'],
                                                  fit: BoxFit.fitWidth,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return Image.asset(
                                                      'assets/etc/NoImage-trans.png',
                                                      fit: BoxFit.contain,
                                                    );
                                                  },
                                                )
                                              : Image.asset(
                                                  'assets/etc/NoImage-trans.png',
                                                  fit: BoxFit.fitWidth,
                                                ), // Image.network(url, height, width)
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Align(
                                        alignment: Alignment(0.6, 0),
                                        child: Icon(
                                          Icons.threesixty,
                                          size: 35,
                                          color: Color.fromARGB(
                                              255, 119, 131, 143),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () async {
                                  setState(() {
                                    is360 = true;
                                    imageList360 =
                                        raffleDetail['ProductImage360']
                                            .map((e) {
                                              return ResizeImage(
                                                NetworkImage(e),
                                                height: (MediaQuery
                                                                .of(context)
                                                            .size
                                                            .width -
                                                        MediaQuery.of(context)
                                                            .padding
                                                            .top -
                                                        MediaQuery.of(context)
                                                            .padding
                                                            .bottom -
                                                        30)
                                                    .toInt(),
                                              );
                                            })
                                            .toList()
                                            .cast<ImageProvider>();
                                  });
                                },
                              )
                            : Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: SizedBox(
                                    width: 300,
                                    // height: 210,
                                    child: raffleDetail['ProductImage'] != ''
                                        ? Image.network(
                                            raffleDetail['ProductImage'],
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Image.asset(
                                                'assets/etc/NoImage-trans.png',
                                                fit: BoxFit.fitWidth,
                                              );
                                            },
                                          )
                                        : Image.asset(
                                            'assets/etc/NoImage-trans.png',
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                              ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          child: const Text(
                            "Size Guide",
                            style: TextStyle(
                                fontSize: 15,
                                fontStyle: FontStyle.italic,
                                decoration: TextDecoration.underline,
                                color: Color.fromARGB(255, 119, 131, 143)),
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/SizeGuide');
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 25, 0, 33),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              buildFloatingButtonProductCalendar(
                                  context,
                                  "Raffles",
                                  isRaffles,
                                  isRaffles ? Colors.white : Colors.grey, () {
                                setState(() {
                                  isRaffles = true;
                                  isRetail = false;
                                  isResell = false;
                                });
                              }),
                              // const SizedBox(
                              //   width: 15,
                              // ),
                              buildFloatingButtonProductCalendar(
                                  context,
                                  "Retail",
                                  isRetail,
                                  isRetail ? Colors.white : Colors.grey, () {
                                setState(() {
                                  isRaffles = false;
                                  isRetail = true;
                                  isResell = false;
                                });
                              }),
                              // const SizedBox(
                              //   width: 15,
                              // ),
                              buildFloatingButtonProductCalendar(
                                  context,
                                  "Resell",
                                  isResell,
                                  isResell ? Colors.white : Colors.grey, () {
                                setState(() {
                                  isRaffles = false;
                                  isRetail = false;
                                  isResell = true;
                                  // Call API to retrieve the list of lists (Example below)
                                  // w/ US size (Default: 8 US)
                                  listResellContainer = [
                                    [
                                      "110",
                                      "assets/resell_shop.png",
                                      "https://www.goat.com/",
                                    ],
                                    [
                                      "120",
                                      "assets/resell_shop.png",
                                      "https://www.goat.com/",
                                    ],
                                    [
                                      "130",
                                      "assets/resell_shop.png",
                                      "https://www.goat.com/",
                                    ],
                                  ];
                                  // Find best price
                                  listResellPrices = [];
                                  for (int x = 0;
                                      x < listResellContainer.length;
                                      x++) {
                                    listResellPrices.add(
                                        int.parse(listResellContainer[x][0]));
                                  }
                                });
                              }),
                            ],
                          ),
                        ),
                        if (isRaffles)
                          returnCalendarItemRafflesContainer(raffleDetail)
                        else if (isRetail)
                          returnCalendarItemRetailContainer(retailDetail)
                        else
                          returnCalendarItemResellContainer(resellDetail),
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 15, 20, 5),
                          child: Text(
                            "Specifications",
                            textAlign: TextAlign.center,
                            style: robotoStyle(
                                FontWeight.w600,
                                const Color.fromARGB(255, 49, 48, 54),
                                20,
                                null),
                          ),
                        ),
                        Center(
                          child: Container(
                            height: 4,
                            width: 130,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: const Color.fromARGB(255, 255, 35, 35),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Center(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Retail Price :  ",
                                    style: robotoStyle(
                                        FontWeight.w400,
                                        const Color.fromARGB(
                                            255, 101, 101, 101),
                                        16,
                                        null),
                                  ),
                                  Text(
                                      r"€" +
                                          raffleDetail['RetailPrice']
                                              .toString(),
                                      style: robotoStyle(
                                          FontWeight.w700,
                                          const Color.fromARGB(
                                              255, 101, 101, 101),
                                          16,
                                          null))
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("SKU :  ",
                                      style: robotoStyle(
                                          FontWeight.w400,
                                          const Color.fromARGB(
                                              255, 101, 101, 101),
                                          16,
                                          null)),
                                  Text(raffleDetail['ProductSKU'].toString(),
                                      style: robotoStyle(
                                          FontWeight.w700,
                                          const Color.fromARGB(
                                              255, 101, 101, 101),
                                          16,
                                          null))
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Release Date :  ",
                                      style: robotoStyle(
                                          FontWeight.w400,
                                          const Color.fromARGB(
                                              255, 101, 101, 101),
                                          16,
                                          null)),
                                  Text(raffleDetail['ReleaseDate'].toString(),
                                      style: robotoStyle(
                                          FontWeight.w700,
                                          const Color.fromARGB(
                                              255, 101, 101, 101),
                                          16,
                                          null))
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              FittedBox(
                                child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    child: Text(
                                        textAlign: TextAlign.center,
                                        raffleDetail['ColorWay'].toString(),
                                        style: robotoStyle(
                                            FontWeight.w400,
                                            const Color.fromARGB(
                                                255, 101, 101, 101),
                                            16,
                                            null))),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
  }

  Widget returnCalendarItemRetailContainer(Map retailDetail) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(alignment: Alignment.center, children: [
          Align(
            alignment: const Alignment(-0.6, 0),
            child: Text("Shops",
                style: robotoStyle(
                    FontWeight.w600, const Color(0xffFF2323), 14, null)),
          ),
          Align(
            alignment: Alignment.center,
            child: Text("Price",
                style: robotoStyle(
                    FontWeight.w600, const Color(0xffFF2323), 14, null)),
          ),
          Align(
            alignment: const Alignment(0.6, 0),
            child: Text("Link",
                style: robotoStyle(
                    FontWeight.w600, const Color(0xffFF2323), 14, null)),
          ),
        ]),
        const SizedBox(
          height: 10,
        ),
        if (retailDetail['Shops'] != null)
          for (int x = 0; x < retailDetail['Shops'].length; x++)
            Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                      '€${retailDetail['Shops'][x]['_ShopPrice'] ?? ""}',
                      style: robotoStyle(FontWeight.w600,
                          const Color.fromARGB(255, 49, 48, 54), 16, null)),
                ),
                Align(
                  alignment: const Alignment(-0.6, 0),
                  child: SizedBox(
                    width: 50,
                    child: Image.network(
                      // Image Network URL
                      retailDetail['Shops'][x]['ShopLogo'],
                      // height: 40,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/etc/NoImage-trans.png',
                          fit: BoxFit.contain,
                        );
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: const Alignment(0.6, 0),
                  child: InkWell(
                      onTap: () {
                        urlLauncher(retailDetail['Shops'][x]['_ShopLink']);
                      },
                      child: const Icon(CupertinoIcons.link,
                          size: 25, color: Color.fromARGB(255, 255, 35, 35))),
                ),
                const SizedBox(height: 60)
              ],
            ),
      ],
    );
  }

  Widget returnCalendarItemRafflesContainer(Map raffle) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: const Alignment(0.3, 0),
              child: Text("Shipping",
                  style: robotoStyle(
                      FontWeight.w600, const Color(0xffFF2323), 14, null)),
            ),
            Align(
              alignment: const Alignment(-0.25, 0),
              child: Text("Date",
                  style: robotoStyle(
                      FontWeight.w600, const Color(0xffFF2323), 14, null)),
            ),
            Align(
              alignment: const Alignment(-0.8, 0),
              child: Text("Shops",
                  style: robotoStyle(
                      FontWeight.w600, const Color(0xffFF2323), 14, null)),
            ),
            Align(
              alignment: const Alignment(0.8, 0),
              child: Text("Link",
                  style: robotoStyle(
                      FontWeight.w600, const Color(0xffFF2323), 14, null)),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        if (raffleDetail['ShopShipping'] != null)
          for (int index = 0;
              index < raffleDetail['ShopShipping'].length;
              index++)
            Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: const Alignment(-0.8, 0),
                  child: SizedBox(
                    width: 40,
                    child: Image.network(
                      raffleDetail['ShopLogo'][index],
                      // height: 40,
                      fit: BoxFit.fitWidth,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/etc/NoImage-trans.png',
                          fit: BoxFit.contain,
                        );
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: const Alignment(-0.35, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        raffleDetail['ShopCloseTime'][index] != '-' &&
                                DateTime.parse(
                                        raffleDetail['ShopCloseTime'][index])
                                    .isBefore(DateTime.now())
                            ? "ended"
                            : "end",
                        style: robotoStyle(
                            FontWeight.w400,
                            raffleDetail['ShopCloseTime'][index] != '-' &&
                                    DateTime.parse(raffleDetail['ShopCloseTime']
                                            [index])
                                        .isAfter(DateTime.now())
                                ? const Color.fromARGB(255, 119, 131, 143)
                                : const Color.fromARGB(255, 119, 131, 143)
                                    .withOpacity(0.5),
                            12,
                            null),
                      ),
                      Text(
                        raffleDetail['ShopCloseTime'][index],
                        style: robotoStyle(
                            FontWeight.w800,
                            raffleDetail['ShopCloseTime'][index] != '-' &&
                                    DateTime.parse(raffleDetail['ShopCloseTime']
                                            [index])
                                        .isAfter(DateTime.now())
                                ? const Color.fromARGB(255, 119, 131, 143)
                                : const Color.fromARGB(255, 119, 131, 143)
                                    .withOpacity(0.5),
                            12,
                            null),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: const Alignment(0.35, 0),
                  child: raffleDetail['ShopShipping'][index] != 'local'
                      ? Icon(
                          FontAwesomeIcons.truck,
                          color: raffleDetail['ShopCloseTime'][index] != '-' &&
                                  DateTime.parse(
                                          raffleDetail['ShopCloseTime'][index])
                                      .isAfter(DateTime.now())
                              ? const Color.fromARGB(255, 49, 48, 54)
                              : const Color.fromARGB(255, 119, 131, 143)
                                  .withOpacity(0.5),
                          size: 25,
                        )
                      : Icon(
                          FontAwesomeIcons.mapPin,
                          color: raffleDetail['ShopCloseTime'][index] != '-' &&
                                  DateTime.parse(
                                          raffleDetail['ShopCloseTime'][index])
                                      .isAfter(DateTime.now())
                              ? const Color.fromARGB(255, 49, 48, 54)
                              : const Color.fromARGB(255, 119, 131, 143)
                                  .withOpacity(0.5),
                          size: 30,
                        ),
                ),
                Align(
                    alignment: const Alignment(0.8, 0),
                    child: InkWell(
                        onTap: () {
                          urlLauncher(raffleDetail['ShopRaffeLink'][index]);
                        },
                        child: const Icon(CupertinoIcons.link,
                            size: 25, color: Color.fromARGB(255, 255, 35, 35)))
                    // : Icon(
                    //     CupertinoIcons.link,
                    //     size: 25,
                    //     color: const Color.fromARGB(255, 119, 131, 143)
                    //         .withOpacity(0.5),
                    //   ),
                    ),
                const SizedBox(height: 60),
              ],
            ),
      ],
    );
  }

  Widget returnCalendarItemResellContainer(Map list) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (cUSSizes.isNotEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(35, 0, 35, 0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: const Color(0xffF6F6F6),
                ),
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                ),
                child: HorizontalPicker(
                  height: 70,
                  prefix: "US ",
                  subLeftPrefix: "EU",
                  subRightPrefix: "UK",
                  showCursor: false,
                  initialPosition: InitialPosition.center,
                  backgroundColor: Colors.transparent,
                  activeItemTextColor: const Color.fromARGB(255, 49, 48, 54),
                  passiveItemsTextColor: Colors.grey.withOpacity(0.5),
                  mainData: cUSSizes,
                  subDataRight: cUKSizes,
                  subDataLeft: cEUSizes,
                  sizePrice: cPricesPerSize,
                  onChanged: (value) {
                    detailsPerSize =
                        getProductsPerSize(value, resellDetail['ProductSize']);
                    setState(() {});
                  },
                ),
              ),
            ),
          ),
        if (cUSSizes.isNotEmpty)
          ListView.builder(
            padding: const EdgeInsets.only(
              bottom: 0,
              top: 33,
            ),
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: detailsPerSize.length,
            itemBuilder: (BuildContext ctx, int index) {
              return Container(
                color:
                    index == 0 ? const Color(0xffF6F6F6) : Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 40, right: 40, top: 7, bottom: 7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '€${detailsPerSize[index]['Price'].toString()}',
                        style: TextStyle(
                          color: index == 0
                              ? const Color(0xff21ED5B)
                              : const Color(0xff313036),
                          fontSize: 22,
                          fontWeight:
                              index == 0 ? FontWeight.w500 : FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        width: 50,
                        child: detailsPerSize[index]['imageURL'] != null
                            ? Image.network(
                                detailsPerSize[index]['imageURL'],
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
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
                      ),
                      RatingBarIndicator(
                        rating: detailsPerSize[index]['ShopScore'].toDouble(),
                        itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 15.0,
                        // direction: Axis.vertical,
                      ),
                      InkWell(
                        onTap: () {
                          urlLauncher(detailsPerSize[index]['Link']);
                        },
                        child: const Icon(
                          CupertinoIcons.link,
                          size: 25,
                          color: Color(0xffFF2323),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        //     for (int x = 0; x < resellDetail.length; x++)
        //       Stack(
        //         alignment: Alignment.center,
        //         children: [
        //           Align(
        //             alignment: const Alignment(-0.6, 0),
        //             child: Text(r"$" + list[x][0],
        //                 style: robotoStyle(
        //                     FontWeight.w600,
        //                     listResellPrices.reduce((current, next) =>
        //                                 current < next ? current : next) ==
        //                             int.parse(list[x][0])
        //                         ? const Color.fromARGB(255, 33, 237, 91)
        //                         : const Color.fromARGB(255, 49, 48, 54),
        //                     22,
        //                     null)),
        //           ),
        //           Align(
        //             alignment: Alignment.center,
        //             child: Image.asset(
        //               // Image Network URL
        //               list[x][1],
        //               height: 40,
        //             ),
        //           ),
        //           Align(
        //             alignment: const Alignment(0.6, 0),
        //             child: InkWell(
        //                 onTap: () {
        //                   urlLauncher(list[x][2]);
        //                 },
        //                 child: const Icon(CupertinoIcons.link,
        //                     size: 25, color: Color.fromARGB(255, 255, 35, 35))),
        //           ),
        //           const SizedBox(height: 60)
        //         ],
        //       ),
      ],
    );
  }

  Future calendarFilterPopUp(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(0),
          backgroundColor: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(
                  left: 30,
                  top: 30,
                  bottom: 0,
                  right: 30,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                ),
                width: 260,
                height: 230,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(
                          FontAwesomeIcons.arrowDownWideShort,
                          size: 27,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Filters',
                              style: robotoStyle(
                                  FontWeight.w700,
                                  const Color.fromARGB(255, 49, 48, 54),
                                  20,
                                  null),
                            ),
                            Text(
                              'By Resell Value',
                              style: robotoStyle(
                                  FontWeight.w300,
                                  const Color.fromARGB(255, 49, 48, 54),
                                  12,
                                  null),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Center(
                      child: SizedBox(
                        width: 125,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 14,
                          ),
                          child: MultiSelectCheckList(
                            maxSelectableCount: 5,
                            itemsDecoration: const MultiSelectDecorations(
                              selectedDecoration:
                                  BoxDecoration(color: Colors.transparent),
                            ),
                            itemPadding: const EdgeInsets.only(
                              top: 10,
                              bottom: 10,
                            ),
                            items: [
                              CheckListCard(
                                selected: calendarFilter.contains('Low'),
                                value: 'Low',
                                title: const Text('Low Resell'),
                                checkColor: const Color(0xffF55E5E),
                                selectedColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              CheckListCard(
                                selected: calendarFilter.contains('Medium'),
                                value: 'Medium',
                                title: const Text('Medium Resell'),
                                checkColor: const Color(0xffF55E5E),
                                selectedColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              CheckListCard(
                                selected: calendarFilter.contains('High'),
                                value: 'High',
                                title: const Text('High Resell'),
                                checkColor: const Color(0xffF55E5E),
                                selectedColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ],
                            onChange: (allSelectedItems, selectedItem) {
                              // setState(() {
                              //   calendarFilter = allSelectedItems;
                              // });
                              setState(() {
                                calendarFilter = allSelectedItems;
                                // if (isUpcoming) {
                                filteredUpcomings = calendarFilterFunc(
                                    upcomings, calendarFilter);
                                // }
                                // if (isPast) {
                                filteredPasts =
                                    calendarFilterFunc(pasts, calendarFilter);
                                // }
                              });
                            },
                          ),
                        ),
                        // ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
    // return showDialog(
    //   context: context,
    //   builder: (context) => Dialog(
    //     // backgroundColor: Colors.transparent,
    //     insetPadding: EdgeInsets.all(10),
    //     child: Row(
    //       // clipBehavior: Clip.none,
    //       // alignment: Alignment.center,
    //       children: <Widget>[
    //         Container(
    //           width: 100,
    //           height: 200,
    //           decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(15),
    //               color: Colors.lightBlue),
    //           padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
    //           child: Text("You can make cool stuff!",
    //               style: TextStyle(fontSize: 24), textAlign: TextAlign.center),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

  Widget buildBody() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    if (positionCalendarPage == 0) {
      return pageCalendarMainUpcoming();
    } else if (positionCalendarPage == 1) {
      return pageCalendarMainPast();
    } else {
      if (is360 && positionCalendarPage == 2) {
        SystemChrome.setPreferredOrientations(
            [DeviceOrientation.landscapeLeft]);
      }
      return pageCalendarItem();
      // return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: buildBody(),
        floatingActionButtonLocation:
            returnFloatingButtonLocationCalendar(positionCalendarPage, is360),
        floatingActionButton:
            returnFloatingButtonCalendar(positionCalendarPage, is360) == 0
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: const Alignment(-0.75, 0.85),
                        child: buildFloatingButtonMainCalendar(
                          "Upcoming",
                          isUpcoming
                              ? const Color.fromARGB(255, 255, 35, 35)
                              : Colors.white,
                          isUpcoming
                              ? Colors.white
                              : const Color.fromARGB(255, 255, 35, 35),
                          () {
                            setState(
                              () {
                                // upcomings = await getUpcomings();
                                isUpcoming = true;
                                isPast = false;
                                positionCalendarPage = 0;
                                // scrollCalendarMain.animateTo(0,
                                //     duration: const Duration(milliseconds: 300),
                                //     curve: Curves.easeInOut);
                              },
                            );
                          },
                        ),
                      ),
                      Align(
                        alignment: const Alignment(0.75, 0.85),
                        child: buildFloatingButtonMainCalendar(
                          "Past",
                          !isPast
                              ? Colors.white
                              : const Color.fromARGB(255, 255, 35, 35),
                          !isPast
                              ? const Color.fromARGB(255, 255, 35, 35)
                              : Colors.white,
                          () {
                            setState(
                              () {
                                // pasts = await getPasts();
                                isPast = true;
                                isUpcoming = false;
                                positionCalendarPage = 1;
                                // scrollCalendarMain.animateTo(0,
                                //     duration: const Duration(milliseconds: 300),
                                //     curve: Curves.easeInOut);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : (returnFloatingButtonCalendar(positionCalendarPage, is360) ==
                        1
                    ? Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              is360 = false;
                            });
                          },
                          icon: const Icon(Icons.close_rounded),
                          iconSize: 35,
                          color: const Color.fromARGB(255, 255, 35, 35),
                        ),
                      )
                    : null),
      ),
    );
  }

  DateTime currentBackPressTime = DateTime.now();

  Future<bool> _onBackPressed() {
    if (positionCalendarPage != 0 || positionCalendarPage != 1) {
      setState(() {
        positionCalendarPage = isUpcoming ? 0 : 1;
        // SchedulerBinding.instance.addPostFrameCallback((_) {
        //   scrollCalendarMain
        //       .jumpTo(scrollCalendarMain.position.minScrollExtent);
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

  List calendarFilterFunc(List data, List keys) {
    List result = [];
    for (var n in data) {
      if (n is Map) {
        List temp = [];
        if (n.values.first is List) {
          for (var element in n.values.first) {
            if (element["ResellValueState"] != null) {
              for (var i = 0; i < keys.length; i++) {
                if (element["ResellValueState"] == keys[i]) {
                  temp.add(element);
                }
              }
            }
          }
        }
        if (temp.isNotEmpty) {
          result.add({n.keys.first: temp});
        }
      }
    }
    return result;
    // var newMap = Map.fromIterable data.keys,
    //     key: (k) => k,
    //     value: (v) {
    //       List temp = [];
    //       if (v is List) {
    //         for (var element in v) {
    //           if (element["ResellValueState"] != null) {
    //             for (var i = 0; i < keys.length; i++) {
    //               if (element["ResellValueState"] == keys[i]) {
    //                 temp.add(element);
    //               }
    //             }
    //           }
    //         }
    //       }
    //       return temp;
    //     });
    // return newMap;
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String imagesAppDirectory = appDocDir.path;
    final file =
        await File('$imagesAppDirectory/$path').create(recursive: true);

    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }
}
