import 'dart:convert';
import 'dart:io';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:s4s_mobileapp/home/page_home.dart';
// import 'package:s4s_mobileapp/home/page_home.dart';
import 'package:s4s_mobileapp/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pagination_view/pagination_view.dart';
import 'package:s4s_mobileapp/tools/functions.dart';
import 'package:s4s_mobileapp/widgets/custom_expansion_tile.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:s4s_mobileapp/product/product_detail.dart';
import 'package:flutter_speech/flutter_speech.dart';
// import 'dart:math';
// ignore: depend_on_referenced_packages
// import 'package:pretty_json/pretty_json.dart';
// import 'dart:developer';

// bool isSearchFav = false;

// List<dynamic> listSearchItem = [];
// var listOfShops = [[]];
// var listPrices = [];

// bool is360possibleSearch = false;

const List productColorMap = [
  {'white': Color(0xffffffff)},
  {'black': Color(0xff000000)},
  {'grey': Color(0xff808080)},
  {'silver': Color(0xffc0c0c0)},
  {'blue': Color(0xff0000ff)},
  {'navyblue': Color(0xff000080)},
  {'purple': Color(0xff6a0dad)},
  {'pink': Color(0xffffc0cb)},
  {'red': Color(0xffff0000)},
  {'orange': Color(0xffff7f00)},
  {'yellow': Color(0xffffff00)},
  {'gold': Color(0xffa57c00)},
  {'brown': Color(0xff88540b)},
  {'green': Color(0xff00ff00)},
  {'multicolor': Colors.transparent},
];

enum SortOptions {
  relevance,
  mostView,
  releaseDate,
  priceAsc,
  priceDsc,
}

enum GenderOptions {
  men,
  women,
  kids,
}

String getQueryParams(Map filter) {
  String query = '';
  // color filter
  List color = filter['filter']['color'];
  String colorQuery = '';
  for (var e in color) {
    colorQuery = '&filter%5Bcolor%5D%5B%5D=$e$colorQuery';
  }
  // brand filter
  String brandQuery = filter['filter']['brand'] != ''
      ? '&filter%5Bbrand%5D%5B%5D=${filter['filter']['brand']}'
      : '';
  // gender filter
  var gender = filter['filter']['gender'];
  String genderQuery = '';
  for (var e in gender) {
    if (e != '') {
      genderQuery = '&filter%5Bgender%5D%5B%5D=$e$genderQuery';
    }
  }
  String sortQuery = '';
  switch (filter['sort']) {
    case 'latest_release_date':
      {
        sortQuery = '&sort%5B0%5D%5Bproduct_release_date%5D=desc';
      }
      break;
    case 'price_asc':
      {
        sortQuery = '&sort%5B0%5D%5Bprice%5D=asc';
      }
      break;
    case 'price_desc':
      {
        sortQuery = '&sort%5B0%5D%5Bprice%5D=desc';
      }
      break;
    default:
      {
        sortQuery = '';
      }
      break;
  }
  // price filter
  String priceQuery = '';
  priceQuery =
      '&filter%5Bprice%5D%5Bgte%5D=${filter['filter']['price']['gte']}&filter%5Bprice%5D%5Blt%5D=${filter['filter']['price']['lte']}';

  query = '$colorQuery$brandQuery$genderQuery$sortQuery$priceQuery';
  return query;
}

Future fetchProduct(query, filter) async {
  String filters = getQueryParams(filter);
  var response = await http.get(
    Uri.parse(
        'https://eu1-search.doofinder.com/5/search?hashid=30a5f46195133e966f269146a6805518&query=$query&page=${filter['page']}$filters'),
    headers: {'Authorization': 'c59dadc5d822ca2b134fb8c7048274a7ec68e170'},
  );
  if (response.statusCode == 200) {
    // log(prettyJson(jsonDecode(response.body)));
    return response.body;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load data');
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late SpeechRecognition _speech;
  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  String transcription = '';

  final TextEditingController? searchKeywordController =
      TextEditingController();

  int totalProducts = 0;

  Map filter = {
    'page': 1,
    'sort': '',
    'filter': {
      'color': [],
      'brand': '',
      'gender': ['', '', ''],
      'price': {
        'gte': 1.0,
        'lte': 1000000.0,
      },
    },
  };

  SortOptions _sortBy = SortOptions.relevance;

  double priceFrom = 1;
  double priceTo = 2500;
  RangeLabels rangeLabels = const RangeLabels('1', '2500');
  RangeValues rangeValues = const RangeValues(1, 2500);

  int _amount4Men = 0;
  int _amount4Women = 0;
  int _amount4Kids = 0;

  bool _startedSearch = false;

  late GlobalKey<PaginationViewState> paginationViewKey;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // paginationViewKey = GlobalKey<PaginationViewState>();
    super.initState();
    activateSpeechRecognizer();
    searchKeywordController?.addListener(_triggerChanged);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    searchKeywordController?.dispose();
    super.dispose();
  }

  void _triggerChanged() {
    EasyDebounce.debounce(
      'tFMemberController',
      const Duration(milliseconds: 300),
      () {
        if (searchKeywordController?.text != '') {
          _startedSearch = true;
          paginationViewKey = GlobalKey<PaginationViewState>();
          setState(() {});
        }
      },
    );
  }

  void activateSpeechRecognizer() {
    // print('_MyAppState.activateSpeechRecognizer... ');
    _speech = SpeechRecognition();
    _speech.setAvailabilityHandler(onSpeechAvailability);
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setErrorHandler(errorHandler);
    _speech.activate(Platform.localeName).then((res) {
      setState(() => _speechRecognitionAvailable = res);
    });
  }

  Future<List<Product>> getProductWithPage(int offset) async {
    filter['page'] = (offset / 10).round() == 0 ? 1 : (offset / 10).round() + 1;
    var result = await fetchProduct(searchKeywordController!.text, filter);
    List<Product> searchedProducts = jsonDecode(result)['results']
        ?.map((e) {
          return Product.fromJson(e);
        })
        .toList()
        .cast<Product>();
    totalProducts = jsonDecode(result)['total_found'];
    List temp = jsonDecode(result)['facets']['gender']['terms']['buckets'];
    for (var element in temp) {
      // print(element);
      switch (element['key']) {
        case 'MEN':
          _amount4Men = element['doc_count'];
          break;
        case 'WOMEN':
          _amount4Women = element['doc_count'];
          break;
        case 'KIDS':
          _amount4Kids = element['doc_count'];
          break;
      }
    }
    if (mounted) setState(() {});
    return searchedProducts;
  }

  Widget searchPage(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(
              5, MediaQuery.of(context).padding.top + 5, 5, 0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.95,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                width: 0.5,
                color: const Color(0xffC4C4C4),
              ),
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: 35,
                    height: 30,
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: Colors.black12,
                          width: 1,
                        ),
                      ),
                    ),
                    child: IconButton(
                      padding: const EdgeInsets.all(0.0),
                      icon: Icon(
                        Icons.mic,
                        color: _speechRecognitionAvailable && !_isListening
                            ? const Color(0xff757D90)
                            : const Color(0xffff2323),
                        size: 24,
                      ),
                      onPressed: () {
                        if (_speechRecognitionAvailable && !_isListening) {
                          start();
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 35,
                    height: 30,
                    child: Icon(
                      Icons.search_rounded,
                      color: Color(0xff757D90),
                      size: 24,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                      child: TextFormField(
                        controller: searchKeywordController,
                        obscureText: false,
                        onChanged: (_) => EasyDebounce.debounce(
                          'tFMemberController',
                          const Duration(milliseconds: 300),
                          () {
                            // if (searchKeywordController?.text != '') {
                            //   _startedSearch = true;
                            //   paginationViewKey =
                            //       GlobalKey<PaginationViewState>();
                            //   setState(() {});
                            // }
                          },
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Search...',
                          labelStyle: TextStyle(
                            color: Color(0xff757D90),
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4.0),
                              topRight: Radius.circular(4.0),
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4.0),
                              topRight: Radius.circular(4.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  _startedSearch
                      ? TextButton(
                          onPressed: () {
                            searchKeywordController?.text = '';
                            filter = {
                              'page': 1,
                              'sort': '',
                              'filter': {
                                'color': [],
                                'brand': '',
                                'gender': ['', '', ''],
                                'price': {
                                  'gte': 1.0,
                                  'lte': 1000000.0,
                                },
                              },
                            };
                            // paginationViewKey =
                            //     GlobalKey<PaginationViewState>();
                            _startedSearch = false;
                            setState(() {});
                          },
                          child: Row(
                            children: const [
                              Text(
                                'CLOSE  ',
                                style: TextStyle(
                                  color: Color(0xff757D90),
                                  fontSize: 12,
                                ),
                              ),
                              Icon(
                                CupertinoIcons.clear_circled,
                                color: Color(0xff757D90),
                                size: 20,
                              ),
                            ],
                          ),
                        )
                      : TextButton.icon(
                          label: const Icon(
                            FontAwesomeIcons.sliders,
                            size: 18,
                            color: Color(0xff757D90),
                          ),
                          icon: const Text(
                            '',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Color(0xff757D90),
                            ),
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black45,
                          ),
                          onPressed: () {
                            _scaffoldKey.currentState?.openEndDrawer();
                            setState(() {
                              _startedSearch = false;
                            });
                          },
                        ),
                ],
              ),
            ),
          ),
        ),
        _startedSearch
            ? Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'RESULTS: $totalProducts',
                      style: const TextStyle(
                        color: Color(0xff757D90),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextButton.icon(
                      // <-- TextButton
                      label: const Icon(
                        FontAwesomeIcons.sliders,
                        size: 15,
                        color: Color(0xff757D90),
                      ),
                      icon: const Text(
                        'FILTERS',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xff757D90),
                        ),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black45,
                      ),
                      onPressed: () {
                        _scaffoldKey.currentState?.openEndDrawer();
                      },
                    ),
                  ],
                ),
              )
            : const SizedBox(
                width: 0,
                height: 0,
              ),
        _startedSearch
            ? Expanded(
                key: paginationViewKey,
                child: PaginationView<Product>(
                  padding: const EdgeInsets.only(
                    left: 12,
                    right: 12,
                  ),
                  pullToRefresh: true,
                  paginationViewType: PaginationViewType.gridView,
                  itemBuilder:
                      (BuildContext context, Product product, int index) =>
                          GridTile(
                    child: Container(
                      decoration: BoxDecoration(
                        border: index % 2 == 0
                            ? index == 0
                                ? const Border(
                                    right: BorderSide(
                                      color: Color(0xffC4C4C4),
                                      width: 0.2,
                                    ),
                                  )
                                : const Border(
                                    right: BorderSide(
                                      color: Color(0xffC4C4C4),
                                      width: 0.2,
                                    ),
                                    top: BorderSide(
                                      color: Color(0xffC4C4C4),
                                      width: 0.2,
                                    ),
                                  )
                            : index == 1
                                ? const Border(
                                    top: BorderSide(
                                      color: Colors.transparent,
                                      width: 0,
                                    ),
                                  )
                                : const Border(
                                    top: BorderSide(
                                      color: Color(0xffC4C4C4),
                                      width: 0.2,
                                    ),
                                  ),
                      ),
                      child: InkWell(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  30, 20, 30, 5),
                              child: Image.network(
                                product.imageLink,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    Image.asset(
                                  'assets/etc/NoImage.png',
                                  fit: BoxFit.contain,
                                  width: 100,
                                  height: 100,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  25, 0, 25, 0),
                              child: Text(
                                product.title,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                  color: const Color(0xff757D90),
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 5, 0, 5),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Container(),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      '${product.shopfoundsearch} Shops',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff757D90),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Container(),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(0),
                              child: Row(
                                children: [
                                  const Expanded(
                                    flex: 3,
                                    child: SizedBox(),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: RichText(
                                      // key: _priceKey,
                                      textAlign: TextAlign.left,
                                      maxLines: 1,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: product.showprice,
                                            style: GoogleFonts.roboto(
                                              fontSize: 16,
                                              color:
                                                  product.productChangeArrow !=
                                                          'Red'
                                                      ? const Color(0xff21ED5B)
                                                      : const Color(0xffF55E5E),
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          WidgetSpan(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5),
                                              child: product
                                                          .productChangeArrow !=
                                                      'Red'
                                                  ? const Icon(
                                                      Icons.trending_up_rounded,
                                                      color: Color(0xff21ED5B),
                                                      size: 18,
                                                    )
                                                  : const Icon(
                                                      Icons
                                                          .trending_down_rounded,
                                                      color: Color(0xffF55E5E),
                                                      size: 18,
                                                    ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Expanded(
                                    flex: 3,
                                    child: SizedBox(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        onTap: () async {
                          // setState(() {
                          var temp = await getProductDetail(product.id);
                          print(product.id);
                          if (temp is Map && temp.isNotEmpty) {
                            productDetail = temp;
                            USSizes = getMainSizeData(
                                productDetail['ProductSizeBest']);
                            UKSizes = getUKSize(USSizes);
                            EUSizes = getEUSize(USSizes);
                            pricesPerSize = USSizes.map((e) => getPricePerSize(
                                e, productDetail['ProductSizeBest'])).toList();
                            selectedIndex = 5;
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pushNamed('/Home');
                          }
                        },
                      ),
                    ),
                  ),
                  // ),
                  pageFetch: getProductWithPage,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.87,
                  ),
                  physics: const BouncingScrollPhysics(),
                  onError: (dynamic error) => const Center(
                    child: Text('Some error occurred'),
                  ),
                  onEmpty: const Center(
                    child: Text('Sorry! This is empty'),
                  ),
                  bottomLoader: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  initialLoader: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              )
            : Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              FaIcon(
                                FontAwesomeIcons.arrowDownWideShort,
                                size: 20,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Brands',
                                style: TextStyle(
                                  // fontFamily: 'Roboto',
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff313036),
                                ),
                              )
                            ],
                          ),
                          Container(
                            width: 140,
                            height: 10,
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color(0xff59585d),
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                            width: 1,
                          ),
                          const Text(
                            'Filter from selected brands',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xff757D90),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 3,
                          height: 100,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xffc8c8c8),
                                width: 0.3,
                              ),
                            ),
                          ),
                          child: InkWell(
                            onTap: () {
                              // filter['filter']['brand'] = 'jordan';
                              // _startedSearch = true;
                              // paginationViewKey =
                              //     GlobalKey<PaginationViewState>();

                              searchKeywordController?.text = 'jordan';
                              // setState(() {});
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(15),
                              child: Image(
                                image: AssetImage('assets/brands/jordan.png'),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 3,
                          height: 100,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xffc8c8c8),
                                width: 0.3,
                              ),
                            ),
                          ),
                          child: InkWell(
                            onTap: () {
                              // filter['filter']['brand'] = 'nike';
                              // _startedSearch = true;
                              // paginationViewKey =
                              //     GlobalKey<PaginationViewState>();
                              // setState(() {});
                              searchKeywordController?.text = 'nike';
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(15),
                              child: Image(
                                image: AssetImage('assets/brands/nike.png'),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 3,
                          height: 100,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xffc8c8c8),
                                width: 0.3,
                              ),
                            ),
                          ),
                          child: InkWell(
                            onTap: () {
                              // filter['filter']['brand'] = 'yeezy';
                              // _startedSearch = true;
                              // paginationViewKey =
                              //     GlobalKey<PaginationViewState>();
                              // setState(() {});
                              searchKeywordController?.text = 'yeezy';
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(15),
                              child: Image(
                                image: AssetImage('assets/brands/yeezy.png'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 3,
                          height: 100,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xffc8c8c8),
                                width: 0.3,
                              ),
                            ),
                          ),
                          child: InkWell(
                            onTap: () {
                              // filter['filter']['brand'] = 'adidas';
                              // _startedSearch = true;
                              // paginationViewKey =
                              //     GlobalKey<PaginationViewState>();
                              // setState(() {});
                              searchKeywordController?.text = 'adidas';
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(15),
                              child: Image(
                                image: AssetImage('assets/brands/adidas.png'),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 3,
                          height: 100,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xffc8c8c8),
                                width: 0.3,
                              ),
                            ),
                          ),
                          child: InkWell(
                            onTap: () {
                              // filter['filter']['brand'] = 'new-balance';
                              // _startedSearch = true;
                              // paginationViewKey =
                              //     GlobalKey<PaginationViewState>();
                              // setState(() {});
                              searchKeywordController?.text = 'new-balance';
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(15),
                              child: Image(
                                image:
                                    AssetImage('assets/brands/new-balance.png'),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 3,
                          height: 100,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xffc8c8c8),
                                width: 0.3,
                              ),
                            ),
                          ),
                          child: InkWell(
                            onTap: () {
                              // filter['filter']['brand'] = 'asics';
                              // _startedSearch = true;
                              // paginationViewKey =
                              //     GlobalKey<PaginationViewState>();
                              // setState(() {});
                              searchKeywordController?.text = 'asics';
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(15),
                              child: Image(
                                image: AssetImage('assets/brands/asics.png'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 3,
                          height: 100,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xffc8c8c8),
                                width: 0.3,
                              ),
                            ),
                          ),
                          child: InkWell(
                            onTap: () {
                              // filter['filter']['brand'] = 'converse';
                              // _startedSearch = true;
                              // paginationViewKey =
                              //     GlobalKey<PaginationViewState>();
                              // setState(() {});
                              searchKeywordController?.text = 'converse';
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(15),
                              child: Image(
                                image: AssetImage('assets/brands/converse.png'),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 3,
                          height: 100,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xffc8c8c8),
                                width: 0.3,
                              ),
                            ),
                          ),
                          child: InkWell(
                            onTap: () {
                              // filter['filter']['brand'] = 'off-white';
                              // _startedSearch = true;
                              // paginationViewKey =
                              //     GlobalKey<PaginationViewState>();
                              // setState(() {});
                              searchKeywordController?.text = 'off-white';
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(15),
                              child: Image(
                                image:
                                    AssetImage('assets/brands/off-white.png'),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 3,
                          height: 100,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xffc8c8c8),
                                width: 0.3,
                              ),
                            ),
                          ),
                          child: InkWell(
                            onTap: () {
                              // filter['filter']['brand'] = 'travis-scott';
                              // _startedSearch = true;
                              // paginationViewKey =
                              //     GlobalKey<PaginationViewState>();
                              // setState(() {});
                              searchKeywordController?.text = 'travis-scott';
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(15),
                              child: Image(
                                image: AssetImage(
                                    'assets/brands/travis-scott.png'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 3,
                          height: 100,
                          child: InkWell(
                            onTap: () {
                              // filter['filter']['brand'] = 'reebok';
                              // _startedSearch = true;
                              // paginationViewKey =
                              //     GlobalKey<PaginationViewState>();
                              // setState(() {});
                              searchKeywordController?.text = 'reebok';
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(15),
                              child: Image(
                                image: AssetImage('assets/brands/reebok.png'),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 3,
                          height: 100,
                          child: InkWell(
                            onTap: () {
                              // filter['filter']['brand'] = 'puma';
                              // _startedSearch = true;
                              // paginationViewKey =
                              //     GlobalKey<PaginationViewState>();
                              // setState(() {});
                              searchKeywordController?.text = 'puma';
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(15),
                              child: Image(
                                image: AssetImage('assets/brands/puma.png'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              FaIcon(
                                FontAwesomeIcons.arrowDownWideShort,
                                size: 20,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Gender',
                                style: TextStyle(
                                  // fontFamily: 'Roboto',
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                          Container(
                            width: 140,
                            height: 10,
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color(0xff59585d),
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                            width: 1,
                          ),
                          const Text(
                            'Adjust for specific gender',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xff757D90),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 80),
                      child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 4,
                            child: InkWell(
                              onTap: () {
                                filter['filter']['gender'] = ['', '', ''];
                                _startedSearch = true;
                                paginationViewKey =
                                    GlobalKey<PaginationViewState>();
                                setState(() {});
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(25),
                                child: Column(
                                  children: const [
                                    Image(
                                      image:
                                          AssetImage('assets/icons/unisex.png'),
                                    ),
                                    SizedBox(
                                      width: 1,
                                      height: 10,
                                    ),
                                    Text(
                                      'Unisex',
                                      style: TextStyle(
                                        color: Color(0xff757d90),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 4,
                            child: InkWell(
                              onTap: () {
                                filter['filter']['gender'][0] = 'MEN';
                                _startedSearch = true;
                                paginationViewKey =
                                    GlobalKey<PaginationViewState>();
                                setState(() {});
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  children: const [
                                    Image(
                                      image: AssetImage('assets/icons/men.png'),
                                    ),
                                    SizedBox(
                                      width: 1,
                                      height: 10,
                                    ),
                                    Text(
                                      'Men',
                                      style: TextStyle(
                                        color: Color(0xff757d90),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 4,
                            child: InkWell(
                              onTap: () {
                                filter['filter']['gender'][0] = 'WOMEN';
                                _startedSearch = true;
                                paginationViewKey =
                                    GlobalKey<PaginationViewState>();
                                setState(() {});
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(23),
                                child: Column(
                                  children: const [
                                    Image(
                                      image:
                                          AssetImage('assets/icons/women.png'),
                                    ),
                                    SizedBox(
                                      width: 1,
                                      height: 10,
                                    ),
                                    Text(
                                      'Women',
                                      style: TextStyle(
                                        color: Color(0xff757d90),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 4,
                            child: InkWell(
                              onTap: () {
                                filter['filter']['gender'][0] = 'KIDS';
                                _startedSearch = true;
                                paginationViewKey =
                                    GlobalKey<PaginationViewState>();
                                setState(() {});
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(25),
                                child: Column(
                                  children: const [
                                    Image(
                                      image:
                                          AssetImage('assets/icons/kids.png'),
                                    ),
                                    SizedBox(
                                      width: 1,
                                      height: 10,
                                    ),
                                    Text(
                                      'Kids',
                                      style: TextStyle(
                                        color: Color(0xff757d90),
                                      ),
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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor:
            _startedSearch ? const Color(0xffffffff) : const Color(0xfff6f6f6),
        body: searchPage(context),
        endDrawer: Drawer(
          child: Padding(
            padding: const EdgeInsets.only(top: 24, bottom: 80),
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: [
                Container(
                  color: const Color(0xffeeeeee),
                  child: Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                      width: 0.8,
                      color: Color(0xffdddddd),
                    ))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          child: const Text(
                            'CLEAR',
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          onPressed: () {},
                        ),
                        TextButton(
                          child: const Text(
                            'CLOSE',
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          onPressed: () {
                            _scaffoldKey.currentState?.closeEndDrawer();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: const Color(0xfff6f6f6),
                  child: Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                      width: 0.8,
                      color: Color(0xffdddddd),
                    ))),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: CustomExpansionTile(
                        initiallyExpanded: true,
                        title: const Text('SORT BY:'),
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                RadioListTile(
                                  title: const Text('Relevance'),
                                  value: SortOptions.relevance,
                                  groupValue: _sortBy,
                                  onChanged: (SortOptions? value) {
                                    setState(() {
                                      filter['sort'] = '';
                                      _sortBy = value!;
                                      if (_startedSearch) {
                                        paginationViewKey =
                                            GlobalKey<PaginationViewState>();
                                      }
                                    });
                                  },
                                ),
                                RadioListTile(
                                  title: const Text('Most View'),
                                  value: SortOptions.mostView,
                                  groupValue: _sortBy,
                                  onChanged: (SortOptions? value) {
                                    setState(() {
                                      filter['sort'] = '';
                                      _sortBy = value!;
                                      if (_startedSearch) {
                                        paginationViewKey =
                                            GlobalKey<PaginationViewState>();
                                      }
                                    });
                                  },
                                ),
                                RadioListTile(
                                  title: const Text('Release Date'),
                                  value: SortOptions.releaseDate,
                                  groupValue: _sortBy,
                                  onChanged: (SortOptions? value) {
                                    setState(() {
                                      filter['sort'] = 'latest_release_date';
                                      // _startedSearch = true;
                                      _sortBy = value!;
                                      if (_startedSearch) {
                                        paginationViewKey =
                                            GlobalKey<PaginationViewState>();
                                      }
                                    });
                                  },
                                ),
                                RadioListTile(
                                  title: const Text('Price Low to High'),
                                  value: SortOptions.priceAsc,
                                  groupValue: _sortBy,
                                  onChanged: (SortOptions? value) {
                                    setState(() {
                                      filter['sort'] = 'price_asc';
                                      _sortBy = value!;
                                      if (_startedSearch) {
                                        paginationViewKey =
                                            GlobalKey<PaginationViewState>();
                                      }
                                    });
                                  },
                                ),
                                RadioListTile(
                                    title: const Text('Price High to Low'),
                                    value: SortOptions.priceDsc,
                                    groupValue: _sortBy,
                                    onChanged: (SortOptions? value) {
                                      setState(() {
                                        filter['sort'] = 'price_desc';
                                        _sortBy = value!;
                                        if (_startedSearch) {
                                          paginationViewKey =
                                              GlobalKey<PaginationViewState>();
                                        }
                                      });
                                    }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  color: const Color(0xfff6f6f6),
                  child: Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                      width: 0.8,
                      color: Color(0xffdddddd),
                    ))),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: CustomExpansionTile(
                        initiallyExpanded: true,
                        title: const Text('PRICE'),
                        children: <Widget>[
                          RangeSlider(
                              divisions: 10,
                              activeColor: Colors.grey[700],
                              inactiveColor: Colors.grey[500],
                              min: priceFrom,
                              max: priceTo,
                              values: rangeValues,
                              labels: rangeLabels,
                              onChanged: (value) {
                                setState(() {
                                  rangeValues = value;
                                  rangeLabels = RangeLabels(
                                      "${value.start.toDouble().toString()}€",
                                      "${value.end.toDouble().toString()}€");
                                  filter['filter']['price']['gte'] =
                                      value.start;
                                  filter['filter']['price']['lte'] = value.end;
                                  if (_startedSearch) {
                                    paginationViewKey =
                                        GlobalKey<PaginationViewState>();
                                  }
                                });
                              }),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  color: const Color(0xfff6f6f6),
                  child: Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                      width: 0.8,
                      color: Color(0xffdddddd),
                    ))),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: CustomExpansionTile(
                        initiallyExpanded: true,
                        title: const Text('GENDER'),
                        children: <Widget>[
                          MultiSelectContainer<GenderOptions>(
                            prefix: MultiSelectPrefix(
                              selectedPrefix: const Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                            itemsDecoration: MultiSelectDecorations(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey[400]!),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              selectedDecoration: BoxDecoration(
                                color: Colors.grey[700]!,
                                border: Border.all(color: Colors.grey[900]!),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            items: [
                              MultiSelectCard(
                                selected:
                                    filter['filter']['gender'].contains('MEN'),
                                value: GenderOptions.men,
                                label: 'MEN ($_amount4Men)',
                              ),
                              MultiSelectCard(
                                selected: filter['filter']['gender']
                                    .contains('WOMEN'),
                                value: GenderOptions.women,
                                label: 'WOMEN ($_amount4Women)',
                              ),
                              MultiSelectCard(
                                selected:
                                    filter['filter']['gender'].contains('KIDS'),
                                value: GenderOptions.kids,
                                label: 'KIDS ($_amount4Kids)',
                              ),
                            ],
                            onChange: (allSelectedItems, selectedItem) {
                              filter['filter']['gender'] = allSelectedItems.map(
                                  (e) => e
                                      .toString()
                                      .split('.')
                                      .last
                                      .toUpperCase());
                              if (_startedSearch) {
                                paginationViewKey =
                                    GlobalKey<PaginationViewState>();
                              }
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  color: const Color(0xfff6f6f6),
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 0.8,
                          color: Color(0xffdddddd),
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: CustomExpansionTile(
                        initiallyExpanded: true,
                        title: const Text('COLORS'),
                        children: <Widget>[
                          MultiSelectContainer(
                            itemsDecoration: MultiSelectDecorations(
                              selectedDecoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                              ),
                            ),
                            items: productColorMap.map((e) {
                              var result = MultiSelectCard(
                                selected: filter['filter']['color']
                                    .contains(e.keys.toList().first),
                                value: e.keys.toList().first,
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.grey[400]!,
                                    ),
                                    color: e[e.keys.toList().first],
                                  ),
                                ),
                              );

                              if (e.keys.toList().first == 'multicolor') {
                                result = MultiSelectCard(
                                  value: e.keys.toList().first,
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.grey[400]!,
                                      ),
                                      gradient: const SweepGradient(
                                        colors: [
                                          Color(0xff8e1f23),
                                          Color(0xffd04514),
                                          Color(0xffe96321),
                                          Color(0xffee9100),
                                          Color(0xfff6b600),
                                          Color(0xffdec200),
                                          Color(0xff79a439),
                                          Color(0xff43744e),
                                          Color(0xff3a748f),
                                          Color(0xff4053a0),
                                          Color(0xff3a3d99),
                                          Color(0xff8b2e61),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return result;
                            }).toList(),
                            onChange: (allSelectedItems, selectedItem) {
                              filter['filter']['color'] = allSelectedItems;
                              if (_startedSearch) {
                                paginationViewKey =
                                    GlobalKey<PaginationViewState>();
                              }
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  DateTime currentBackPressTime = DateTime.now();

  Future<bool> _onBackPressed() {
    if (_startedSearch) {
      setState(() {
        searchKeywordController?.text = '';
        filter = {
          'page': 1,
          'sort': '',
          'filter': {
            'color': [],
            'brand': '',
            'gender': ['', '', ''],
            'price': {
              'gte': 1.0,
              'lte': 1000000.0,
            },
          },
        };
        paginationViewKey = GlobalKey<PaginationViewState>();
        _startedSearch = false;
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

  void start() => _speech.activate(Platform.localeName).then((_) {
        return _speech.listen().then((result) {
          // print('_MyAppState.start => result $result');
          setState(() {
            _isListening = result;
          });
        });
      });

  void cancel() =>
      _speech.cancel().then((_) => setState(() => _isListening = false));

  void stop() => _speech.stop().then((_) {
        setState(() => _isListening = false);
      });

  void onSpeechAvailability(bool result) =>
      setState(() => _speechRecognitionAvailable = result);

  // void onCurrentLocale(String locale) {
  //   print('_MyAppState.onCurrentLocale... $locale');

  //   setState(
  //       () => selectedLang = languages.firstWhere((l) => l.code == locale));
  // }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) {
    // print('_MyAppState.onRecognitionResult... $text');
    // setState(() => transcription = text);
    setState(() {
      searchKeywordController!.text = text;
    });
  }

  void onRecognitionComplete(String text) {
    // print('_MyAppState.onRecognitionComplete... $text');
    setState(() => _isListening = false);
  }

  void errorHandler() => activateSpeechRecognizer();
}
