// import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:s4s_mobileapp/home/page_home.dart';
import 'package:s4s_mobileapp/tools/functions.dart';
import 'package:s4s_mobileapp/widgets/custom_horizontal_picker/custom_horizontal_picker.dart';
import 'package:imageview360/imageview360.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:flutter/services.dart';

Map productDetail = {};
List<ImageProvider> imageList360 = [];
List USSizes = [];
List UKSizes = [];
List EUSizes = [];
List pricesPerSize = [];
bool is360 = false;
bool is360Possible = false;

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({Key? key}) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPage();
}

class _ProductDetailPage extends State<ProductDetailPage> {
  bool isSpecs = false;
  bool isFav = false;
  bool is360Possible = false;
  bool is360 = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (is360) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    } else {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: !is360
          ? Stack(
              children: [
                // SizedBox(
                //   height: MediaQuery.of(context).padding.top,
                // ),
                Positioned(
                  top: MediaQuery.of(context).padding.top,
                  left: 20,
                  right: 20,
                  child: Row(
                    // alignment: Alignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Align(
                      //   alignment: const Alignment(-0.9, 0),
                      // child: IconButton(
                      IconButton(
                        icon: const Icon(Icons.arrow_circle_left_outlined),
                        color: const Color(0xffF55E5E),
                        iconSize: 40,
                        onPressed: () {
                          // setState(() {
                          Navigator.pop(context);
                          // });
                        },
                      ),
                      // ),
                      // Align(
                      //   alignment: Alignment.center,
                      // child: SizedBox(
                      SizedBox(
                        width: 130,
                        child: Image.asset(
                          'assets/etc/splash-cropped.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      // ),
                      // Align(
                      //   alignment: const Alignment(0.9, 0),
                      // child: IconButton(
                      IconButton(
                        icon: isFav
                            ? const Icon(Icons.favorite_rounded)
                            : const Icon(Icons.favorite_border_rounded),
                        color: const Color(0xffF55E5E),
                        iconSize: 40,
                        onPressed: () {
                          setState(() {
                            isFav = !isFav;
                          });
                        },
                      ),
                      // ),
                    ],
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 55,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(40, 10, 40, 20),
                    child: Text(
                      productDetail['ProductName'],
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: robotoStyle(FontWeight.w900,
                          const Color.fromARGB(255, 49, 48, 54), 20, null),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 115,
                  left: 20,
                  right: 20,
                  bottom: kBottomNavigationBarHeight,
                  // child: Expanded(
                  child: SingleChildScrollView(
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          is360Possible
                              ? GestureDetector(
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          child: SizedBox(
                                            width: 330, height: 210,
                                            child: productDetail[
                                                        'ProductImage'] !=
                                                    ''
                                                ? Image.network(
                                                    productDetail[
                                                        'ProductImage'],
                                                    fit: BoxFit.fitWidth,
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      return Image.asset(
                                                        'assets/etc/NoImage.png',
                                                        fit: BoxFit.contain,
                                                      );
                                                    },
                                                  )
                                                : Image.asset(
                                                    'assets/etc/NoImage.png',
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
                                  onTap: () {
                                    setState(() {
                                      is360 = true;
                                      imageList360 =
                                          productDetail['ProductImage360']
                                              .map((e) => ResizeImage(
                                                    NetworkImage(e),
                                                    height:
                                                        (MediaQuery.of(context)
                                                                    .size
                                                                    .width -
                                                                MediaQuery.of(
                                                                        context)
                                                                    .padding
                                                                    .top -
                                                                MediaQuery.of(
                                                                        context)
                                                                    .padding
                                                                    .bottom -
                                                                30)
                                                            .toInt(),
                                                  ))
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
                                      child: productDetail['ProductImage'] != ''
                                          ? Image.network(
                                              productDetail['ProductImage'],
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Image.asset(
                                                  'assets/etc/NoImage.png',
                                                  fit: BoxFit.fitWidth,
                                                );
                                              },
                                            )
                                          : Image.asset(
                                              'assets/etc/NoImage.png',
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 15,
                            ),
                            child: InkWell(
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
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (USSizes.isNotEmpty)
                                Center(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(35, 0, 35, 0),
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
                                        activeItemTextColor:
                                            const Color.fromARGB(
                                                255, 49, 48, 54),
                                        passiveItemsTextColor:
                                            Colors.grey.withOpacity(0.5),
                                        mainData: USSizes,
                                        subDataRight: UKSizes,
                                        subDataLeft: EUSizes,
                                        sizePrice: pricesPerSize,
                                        onChanged: (value) {
                                          // detailsPerSize =
                                          //     getProductsPerSize(value, resellDetail['ProductSize']);
                                          // setState(() {});
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              // if (USSizes.isNotEmpty)
                              //   ListView.builder(
                              //     physics: const NeverScrollableScrollPhysics(),
                              //     scrollDirection: Axis.vertical,
                              //     shrinkWrap: true,
                              //     // itemCount: detailsPerSize.length,
                              //     itemBuilder: (BuildContext ctx, int index) {
                              //       return Padding(
                              //         padding: const EdgeInsets.only(
                              //             left: 40, right: 40, top: 20, bottom: 20),
                              //         child: Row(
                              //           mainAxisAlignment:
                              //               MainAxisAlignment.spaceBetween,
                              //           children: [
                              //             Text(
                              //               '€${detailsPerSize[index]['Price'].toString()}',
                              //               style: const TextStyle(
                              //                 color: Color(0xff313036),
                              //                 fontSize: 22,
                              //               ),
                              //             ),
                              //             SizedBox(
                              //               width: 50,
                              //               child: detailsPerSize[index]
                              //                           ['imageURL'] !=
                              //                       null
                              //                   ? Image.network(
                              //                       detailsPerSize[index]['imageURL'],
                              //                       fit: BoxFit.contain,
                              //                       errorBuilder:
                              //                           (context, error, stackTrace) {
                              //                         return Image.asset(
                              //                           'assets/etc/NoImage.png',
                              //                           fit: BoxFit.fill,
                              //                         );
                              //                       },
                              //                     )
                              //                   : Image.asset(
                              //                       'assets/etc/NoImage.png',
                              //                       fit: BoxFit.fill,
                              //                     ),
                              //             ),
                              //           ],
                              //         ),
                              //       );
                              //     },
                              //   ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // ),
              ],
            )
          : Container(
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
                  allowSwipeToRotate: true,
                ),
                // ],
                // ),
              ),
            ),
    );
  }
}
