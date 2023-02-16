// class Product {
//   final int id;
//   final String name;
//   final String image;
//   final double price;
//   int quantity;
//
//   Product(
//       {required this.id,
//       required this.name,
//       required this.image,
//       required this.price,
//       this.quantity = 0});
// }

import 'package:s4s_mobileapp/tools/functions.dart';

class Product {
  final int bestPrice;
  final String description;
  final String dfGroupingId;
  final String dfid;
  final double dfscore;
  final String gender;
  final Map highlight;
  final String id;
  final String imageLink;
  final String link;
  final int price;
  final String productChangeArrow;
  final String productChangeValue;
  late final String productCount;
  final String productReleaseDate;
  final String productSubcategory;
  final String shopfoundsearch;
  final String showprice;
  final String title;
  final String type;

  Product({
    required this.id,
    required this.description,
    required this.link,
    required this.imageLink,
    required this.productChangeArrow,
    required this.shopfoundsearch,
    required this.productSubcategory,
    required this.bestPrice,
    required this.gender,
    required this.dfGroupingId,
    required this.dfid,
    required this.dfscore,
    required this.highlight,
    required this.price,
    required this.productChangeValue,
    required this.productCount,
    required this.productReleaseDate,
    required this.showprice,
    required this.title,
    required this.type,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      // userId: json['userId'],
      // id: json['id'],
      // title: json['title'],
      id: json['id'] ?? '',
      description: json['description'] ?? '',
      link: json['link'] ?? '',
      imageLink: json['image_link'] ?? '',
      productChangeArrow: json['product_change_arrow'] ?? '',
      shopfoundsearch: json['shopfoundsearch'] ?? '',
      productSubcategory: json['product_subcategory'] ?? '',
      bestPrice: json['best_price'] == null ? 0 : json['best_price'].toInt(),
      gender: json['gender'] ?? '',
      dfGroupingId: json['df_grouping_id'] ?? '',
      dfid: json['dfid'] ?? '',
      dfscore: json['dfscore'] ?? 0,
      highlight: json['highlight'] ?? {},
      price: json['price'] == null ? 0 : json['price'].toInt(),
      productChangeValue: json['product_change_value'] ?? '',
      productCount:
          json['product_count'] == null ? '' : json['product_count'].toString(),
      productReleaseDate: json['product_release_date'] ?? '',
      showprice: json['showprice'] == null
          ? ''
          : '${extractNumberFromPrice(json['showprice'].toString()).toInt().toString()}${extractUnitFromPrice(json['showprice'].toString())}',
      title: json['title'] ?? '',
      type: json['type'] ?? '',
    );
  }
  // "color": "black/grey/white/red",
  // "description": "The Air Jordan 4 Retro White Oreo features a white leather and mesh upper with hits of Tech Grey on its eyelets and midsole From there a red Jumpman logo is embroidered on the tongue adding a pop of color to the neutral-toned design br br The Air Jordan 4 Retro White Oreo released on Saturday July 3rd and retailed for 190",
  // "df_grouping_id": "CT8527-100",
  // "dfid": "30a5f46195133e966f269146a6805518@product@d9b481b4924964d0be0c79fc5c6aec97",
  // "dfscore": 5.349796,
  // "gender": "MEN",
  // "highlight": {
  // "description": [
  // "The Air <em>Jordan</em> 4 Retro White Oreo features a white leather and mesh upper with hits of Tech Grey on its",
  // "color to the neutral-toned design br br The Air <em>Jordan</em> 4 Retro White Oreo released on Saturday July 3rd"
  // ]
  // },
  // "id": "CT8527-100",
  // "image_link": "https://www.sneaks4sure.com/uploads/main_images/CT8527-100-imgthumb-999.jpg",
  // "link": "https://www.sneaks4sure.com/product/Jordan-4-Retro-White-Oreo--2021--CT8527-100",
  // "price": 379.0,
  // "product_change_arrow": "Green",
  // "product_change_value": "1",
  // "product_count": "0.13",
  // "product_release_date": "2021-07-03 00:00:00",
  // "product_subcategory": "Air Jordan 4",
  // "shopfoundsearch": "41",
  // "showprice": "379.00 €",
  // "title": "Jordan 4 Retro White Oreo 2021",
  // "type": "product"
}

// {
//   "best_price": 270.0,
//   "color": "white/blue/navyblue",
//   "description": "Nodding to the University of North Carolina Tarheels the Nike Dunk Low UNC is constructed of a white leather upper with University Blue overlays and Swooshes From there a white and University woven Nike tongue label completes the design br br The Nike Dunk Low UNC released in June of 2021 and retailed for 100",
//   "df_grouping_id": "DD1391-102",
//   "dfid": "30a5f46195133e966f269146a6805518@product@205662e2c60134fb0a6d4fc9bc9e6647",
//   "dfscore": 3.40764,
//   "gender": "WOMEN",
//   "highlight": {
//     "description": [
//       "to the University of North Carolina Tarheels the <em>Nike</em> Dunk Low UNC is constructed of a white leather upper",
//       "white and University woven <em>Nike</em> tongue label completes the design br br The <em>Nike</em> Dunk Low UNC released in"
//     ]
//   },
//   "id": "DD1391-102",
//   "image_link": "https://www.sneaks4sure.com/uploads/main_images/DD1391-102-imgthumb-999.jpg",
//   "link": "https://www.sneaks4sure.com/product/Nike-Dunk-Low-UNC--2021--DD1391-102",
//   "price": 270.0,
//   "product_change_arrow": "Red",
//   "product_change_value": "-69",
//   "product_count": "0.04",
//   "product_release_date": "2021-06-24 00:00:00",
//   "product_subcategory": "Nike Dunk Low",
//   "shopfoundsearch": "37",
//   "showprice": "270.00 €",
//   "title": "Nike Dunk Low UNC 2021",
//   "type": "product"
// }
