import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:s4s_mobileapp/calendar/page_calendar.dart';
import 'package:s4s_mobileapp/home/page_home.dart';
import 'package:s4s_mobileapp/restock/page_restock.dart';
// import 'package:s4s_mobileapp/search/page_search.dart';
import 'package:s4s_mobileapp/tools/functions.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:country_picker/country_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:s4s_mobileapp/tools/firebase_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
// ignore: depend_on_referenced_packages
import 'package:uuid/uuid.dart';
import 'package:s4s_mobileapp/tools/address_search.dart';
import 'package:s4s_mobileapp/tools/place_service.dart';

bool accountStatus = false;
bool notifCalendar = false;
bool notifRestock = false;
int positionAccountPage = selectedInitialPositionAccountPage;
// String userMail = isEmail(userEmail) ? userEmail : '';

final controllerUsername = TextEditingController();
final controllerFirstName = TextEditingController();
final controllerLastName = TextEditingController();
final controllerPhone = TextEditingController();
final controllerAL1 = TextEditingController();
final controllerAL2 = TextEditingController();
final controllerCity = TextEditingController();
final controllerZipcode = TextEditingController();
final controllerState = TextEditingController();
final controllerUserMail = TextEditingController();

String selectedCountryFlag = "";
String selectedCountryText = "";

var checkSizeField = [0, 0];
var checkCurrencyField = [0, 0];
var checkAreaField = [0, 0];
var checkUsernameField = [0, 0];
var checkFirstNameField = [0, 0];
var checkLastNameField = [0, 0];
var checkPhoneField = [0, 0];
var checkAL1Field = [0, 0];
var checkAL2Field = [0, 0];
var checkCityField = [0, 0];
var checkZipcodeField = [0, 0];
var checkStateField = [0, 0];
var checkCountryField = [0, 0];
var checkUserMailField = [0, 0];

final List<String> listSizes = [
  'US 4',
  'US 4.5',
  'US 5',
  'US 5.5',
  'US 6',
  'US 6.5',
  'US 7',
  'US 7.5',
  'US 8',
  'US 8.5',
  'US 9',
  'US 9.5',
  'US 10',
  'US 10.5',
  'US 11',
  'US 11.5',
  'US 12',
];
String? defaultSizes;

final List<String> listCurrencies = [
  '€ - EUR',
  r'$ - USD',
  r'$ - CAD',
  '£ - GBP',
  '¥ - YEN',
  '¥ - CNY',
];
String? defaultCurrencies;

final List<String> listLocations = [
  'Canada  🇨🇦',
  'China  🇨🇳',
  'Europe  🇪🇺',
  'Japan  🇯🇵',
  'USA  🇺🇸',
  'Worldwide  🌎',
];
String? defaultLocations;

List<String> wishlistTest = [
  // Future wishlist sorted by date from DB
  'Jordan 8',
  'Jordan 7',
  'Jordan 6',
  'Jordan 5',
  'Jordan 4',
  'Jordan 3',
  'Jordan 2',
  'Jordan 1 Low Travis Scott x Fragment White Blue',
  'Jordan 1 Mid SE Royal Blue (2020)',
  'Jordan 1 High',
];
List<String> wishlistTestPriced = [
  // Future wishlist sorted by price from DB
  'Jordan 2',
  'Jordan 1 Low Travis Scott x Fragment White Blue',
  'Jordan 8',
  'Jordan 1 Mid SE Royal Blue (2020)',
  'Jordan 1 High',
  'Jordan 4',
  'Jordan 3',
  'Jordan 6',
  'Jordan 7',
  'Jordan 5',
];
List<String> wishlistTestNamed = [
  // Future wishlist sorted by name from DB
  'Jordan 1 High',
  'Jordan 1 Low Travis Scott x Fragment White Blue',
  'Jordan 1 Mid SE Royal Blue (2020)',
  'Jordan 2',
  'Jordan 3',
  'Jordan 4',
  'Jordan 5',
  'Jordan 6',
  'Jordan 7',
  'Jordan 8'
];

bool sortWishlistPrice = false;
bool sortWishlistName = false;

File? image;

bool isNotifsExpanded = false;

String? _streetNumber = '';
String? _street = '';
String? _city = '';
String? _zipCode = '';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  void initState() {
    initSharePref();
    super.initState();
  }

  initSharePref() async {
    prefs = await SharedPreferences.getInstance();
    controllerUsername.text = prefs.getString('username') ?? '';
    controllerFirstName.text = prefs.getString('firstname') ?? '';
    controllerLastName.text = prefs.getString('lastname') ?? '';
    controllerPhone.text = prefs.getString('phone') ?? '';
    controllerUserMail.text = prefs.getString('email') ?? '';
    if (mounted) {
      setState(() {
        prefs.getString('username') != '' && prefs.getString('username') != null
            ? checkUsernameField = [0, 1]
            : checkUsernameField = [0, 0];
        prefs.getString('firstname') != '' &&
                prefs.getString('firstname') != null
            ? checkFirstNameField = [0, 1]
            : checkFirstNameField = [0, 0];
        prefs.getString('lastname') != '' && prefs.getString('lastname') != null
            ? checkLastNameField = [0, 1]
            : checkLastNameField = [0, 0];
        prefs.getString('phone') != '' && prefs.getString('phone') != null
            ? checkPhoneField = [0, 1]
            : checkPhoneField = [0, 0];
        prefs.getString('email') != '' && prefs.getString('email') != null
            ? checkUserMailField = [0, 1]
            : checkUserMailField = [0, 0];
        photoURL = prefs.getString('photo') ?? '';
      });
    }
  }

  String photoURL = '';

  final FirebaseService _fireService = FirebaseService();

  late final SharedPreferences prefs;

  final ScrollController scroll = ScrollController();

  Future pickImage() async {
    try {
      final imageInit =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (imageInit == null) return;
      final imageTemporary = File(imageInit.path);
      if (mounted) setState(() => image = imageTemporary);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(launchSnackbar(
          "Profile Picture successfully updated.",
          Icons.check,
          const Color.fromARGB(255, 255, 35, 35),
          Colors.white,
          const Color.fromARGB(255, 255, 35, 35)));
      // send picture data to DB
    } on PlatformException {
      ScaffoldMessenger.of(context).showSnackBar(launchSnackbar(
          "Failed to edit profile picture.",
          Icons.info,
          Colors.white,
          const Color.fromARGB(255, 255, 35, 35),
          Colors.white));
    }
  }

  void scrollDown() {
    scroll.animateTo(scroll.position.maxScrollExtent * 2,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  List<String> goodList() {
    if (sortWishlistName == false && sortWishlistPrice == false) {
      return wishlistTest;
    } else if (sortWishlistName) {
      return wishlistTestNamed;
    } else {
      return wishlistTestPriced;
    }
  }

  void checkUsername(String value) {
    if (isAlphaNum(value)) {
      setState(() {
        //isUsername = true;
        checkUsernameField[0] = 0;
        checkUsernameField[1] = 1;
      });
    } else {
      setState(() {
        //isUsername = false;
        checkUsernameField[0] = 1;
        checkUsernameField[1] = 0;
      });
    }
  }

  Widget buildTextField(String title, Icon icon, Color color,
      TextEditingController controller, TextInputType keyType) {
    return TextField(
      textAlign: TextAlign.left,
      cursorColor: const Color.fromARGB(255, 255, 35, 35),
      controller: controller,
      keyboardType: keyType,
      decoration: InputDecoration(
        filled: true,
        fillColor: color,
        prefixIcon: icon,
        prefixIconColor: color,
        hintText: title,
        contentPadding: const EdgeInsets.all(15),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onChanged: (value) {
        if (controller == controllerUsername) checkUsername(value);
        if (controller == controllerFirstName) {
          if (isAlphabetics(value)) {
            setState(() {
              //isFirstName = true;
              checkFirstNameField[0] = 0;
              checkFirstNameField[1] = 1;
            });
          } else {
            setState(() {
              //isFirstName = false;
              checkFirstNameField[0] = 1;
              checkFirstNameField[1] = 0;
            });
          }
        }
        if (controller == controllerLastName) {
          if (isAlphabetics(value)) {
            setState(() {
              //isLastName = true;
              checkLastNameField[0] = 0;
              checkLastNameField[1] = 1;
            });
          } else {
            setState(() {
              //isLastName = false;
              checkLastNameField[0] = 1;
              checkLastNameField[1] = 0;
            });
          }
        }
        if (controller == controllerPhone) {
          if (isNumerics(value)) {
            setState(() {
              //isPhone = true;
              checkPhoneField[0] = 0;
              checkPhoneField[1] = 1;
            });
          } else {
            setState(() {
              //isPhone = false;
              checkPhoneField[0] = 1;
              checkPhoneField[1] = 0;
            });
          }
        }
        if (controller == controllerAL1) {
          if (isAlphaNum(value)) {
            setState(() {
              //isAL1 = true;
              checkAL1Field[0] = 0;
              checkAL1Field[1] = 1;
            });
          } else {
            setState(() {
              //isAL1 = false;
              checkAL1Field[0] = 1;
              checkAL1Field[1] = 0;
            });
          }
        }
        if (controller == controllerAL2) {
          if (isAlphaNum(value)) {
            setState(() {
              //isAL2 = true;
              checkAL2Field[0] = 0;
              checkAL2Field[1] = 1;
            });
          } else {
            setState(() {
              //isAL2 = false;
              checkAL2Field[0] = 1;
              checkAL2Field[1] = 0;
            });
          }
        }
        if (controller == controllerCity) {
          if (isAlphabetics(value)) {
            setState(() {
              //isCity = true;
              checkCityField[0] = 0;
              checkCityField[1] = 1;
            });
          } else {
            setState(() {
              //isCity = false;
              checkCityField[0] = 1;
              checkCityField[1] = 0;
            });
          }
        }
        if (controller == controllerZipcode) {
          if (isNumerics(value)) {
            setState(() {
              //isZipcode = true;
              checkZipcodeField[0] = 0;
              checkZipcodeField[1] = 1;
            });
          } else {
            setState(() {
              //isZipcode = false;
              checkZipcodeField[0] = 1;
              checkZipcodeField[1] = 0;
            });
          }
        }
        if (controller == controllerState) {
          if (isAlphabetics(value)) {
            setState(() {
              //isState = true;
              checkStateField[0] = 0;
              checkStateField[1] = 1;
            });
          } else {
            setState(() {
              //isState = false;
              checkStateField[0] = 1;
              checkStateField[1] = 0;
            });
          }
        }
      },
    );
  }

  Widget buildAddressTextField(String title, Icon icon, Color color,
      TextEditingController controller, TextInputType keyType, addressTap) {
    return TextField(
      textAlign: TextAlign.left,
      cursorColor: const Color.fromARGB(255, 255, 35, 35),
      controller: controller,
      keyboardType: keyType,
      readOnly: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: color,
        prefixIcon: icon,
        prefixIconColor: color,
        hintText: title,
        contentPadding: const EdgeInsets.all(15),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onTap: addressTap,
    );
  }

  Future wishlistSortPopUp(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          title: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.sort_rounded),
              const SizedBox(
                width: 5,
              ),
              Text(
                'Sort by',
                style: robotoStyle(FontWeight.w700,
                    const Color.fromARGB(255, 49, 48, 54), null, null),
              ),
            ],
          )),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 30,
                  ),
                  InkWell(
                      splashColor: Colors.transparent,
                      onTap: () {
                        if (sortWishlistPrice) {
                          setState(
                            () {
                              sortWishlistPrice = false;
                            },
                          );
                        } else {
                          setState(
                            () {
                              sortWishlistPrice = true;
                              sortWishlistName = false;
                            },
                          );
                        }
                        Navigator.pop(context);
                      },
                      child: Icon(
                        sortWishlistPrice
                            ? CupertinoIcons.checkmark_alt_circle_fill
                            : CupertinoIcons.circle,
                        color: sortWishlistPrice
                            ? const Color.fromARGB(255, 255, 35, 35)
                            : Colors.grey,
                        size: 30,
                      )),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Price',
                    style: robotoStyle(FontWeight.w400,
                        const Color.fromARGB(255, 49, 48, 54), null, null),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 30,
                  ),
                  InkWell(
                      splashColor: Colors.transparent,
                      onTap: () {
                        if (sortWishlistName) {
                          setState(
                            () {
                              sortWishlistName = false;
                            },
                          );
                        } else {
                          setState(
                            () {
                              sortWishlistPrice = false;
                              sortWishlistName = true;
                            },
                          );
                        }
                        Navigator.pop(context);
                      },
                      child: Icon(
                        sortWishlistName
                            ? CupertinoIcons.checkmark_alt_circle_fill
                            : CupertinoIcons.circle,
                        color: sortWishlistName
                            ? const Color.fromARGB(255, 255, 35, 35)
                            : Colors.grey,
                        size: 30,
                      )),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Product Name',
                    style: robotoStyle(FontWeight.w400,
                        const Color.fromARGB(255, 49, 48, 54), null, null),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future logoutPopUp(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            title: Text(
              'Logout',
              textAlign: TextAlign.center,
              style: robotoStyle(FontWeight.w800,
                  const Color.fromARGB(255, 49, 48, 54), null, null),
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "Are you sure you want to logout ?",
                  style: robotoStyle(FontWeight.w400,
                      const Color.fromARGB(255, 49, 48, 54), null, null),
                ),
              ],
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 235, 235, 235)),
                    ),
                    child: Text(
                      'Cancel',
                      style:
                          robotoStyle(FontWeight.w600, Colors.grey, 17, null),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  TextButton(
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 235, 235, 235)),
                    ),
                    child: Text(
                      'Confirm',
                      style: robotoStyle(FontWeight.w600,
                          const Color.fromARGB(255, 255, 35, 35), 17, null),
                    ),
                    onPressed: () {
                      setState(
                        () {
                          positionAccountPage = 0;
                          positionCalendarPage = 0;
                          selectedIndex = 0;
                          positionRestockPage = 0;
                          positionSearchPage = 0;
                          isRaffles = false;
                          isRetail = true;
                          isResell = false;
                          isUpcoming = true;
                          isPast = false;
                          // filterLowResell = false;
                          // filterMediumResell = false;
                          // filterHighResell = false;
                          is360 = false;
                          is360Search = false;
                          isOutfits = false;
                          isSpecs = true;
                          isJordan = false;
                          isNike = false;
                          isAdidas = false;
                          isYeezy = false;
                          isNewbalance = false;
                          sortWishlistPrice = false;
                          sortWishlistName = false;
                          isNotifsExpanded = false;
                          // here to reinit all the positions used to go to other pages inside onglet
                        },
                      );
                      _fireService.signOut();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/Landing', (route) => false);
                      ScaffoldMessenger.of(context).showSnackBar(launchSnackbar(
                          "You are successfully logged out.",
                          Icons.check,
                          const Color.fromARGB(255, 255, 35, 35),
                          Colors.white,
                          const Color.fromARGB(255, 255, 35, 35)));
                    },
                  ),
                ],
              ),
            ],
          );
        });
      },
    );
  }

  Widget pageAccountMain() {
    return SingleChildScrollView(
      controller: scroll,
      key: const PageStorageKey<String>('Account Scroll Main'),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).padding.top + 25,
            ),
            Stack(
              children: [
                Align(
                  alignment: const Alignment(-0.9, 0),
                  child: SizedBox(
                    width: 50,
                    child: Image.asset(
                      'assets/etc/logo_account.png',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                // Have to retrieve the account picture from database
                Align(
                  alignment: Alignment.bottomCenter,
                  // Image.network(url, height, width)
                  child: ClipOval(
                    child: image == null
                        // ? Image.asset('assets/profile_picture_default.png',
                        //     width: 210, height: 210, fit: BoxFit.cover)
                        ? Container(
                            width: 210,
                            height: 210,
                            // padding: EdgeInsets.all(50),
                            color: const Color(0xffd1d3d4),
                            child: const Icon(
                              FontAwesomeIcons.user,
                              size: 140,
                              color: Color(0xffa7a9ac),
                            ),
                          )
                        : Image.file(
                            image!,
                            width: 210,
                            height: 210,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    logoutPopUp(context);
                  },
                  child: const Align(
                      alignment: Alignment(0.9, 0),
                      child: Icon(
                        Icons.power_settings_new_rounded,
                        color: Color.fromARGB(255, 255, 35, 35),
                        size: 40,
                      )),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Have to retrieve account username from database
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Username",
                    style: robotoStyle(FontWeight.w800,
                        const Color.fromARGB(255, 49, 48, 54), 22, null),
                  ),
                  const SizedBox(width: 5),
                  const Icon(
                    Icons.circle_rounded,
                    size: 16,
                    color: Color.fromARGB(255, 33, 237, 91),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 15),
              child: Text(
                "Joined us since Aug 18, 2021",
                style: robotoStyle(FontWeight.w400,
                    const Color.fromARGB(255, 49, 48, 54), null, null),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 10, bottom: 5),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      CupertinoIcons.flag,
                      size: 25,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "Country, City",
                      style: robotoStyle(FontWeight.w600,
                          const Color.fromARGB(255, 49, 48, 54), 18, null),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 5),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Public",
                      style: robotoStyle(
                          FontWeight.w500,
                          accountStatus
                              ? const Color.fromARGB(255, 33, 237, 91)
                              : const Color.fromARGB(255, 49, 48, 54),
                          16,
                          null),
                    ),
                    Text(
                      " - ",
                      style: robotoStyle(FontWeight.w500,
                          const Color.fromARGB(255, 49, 48, 54), 16, null),
                    ),
                    Text(
                      "Private",
                      style: robotoStyle(
                          FontWeight.w500,
                          !accountStatus
                              ? const Color.fromARGB(255, 255, 35, 35)
                              : const Color.fromARGB(255, 49, 48, 54),
                          16,
                          null),
                    ),
                  ],
                ),
              ),
            ),
            Transform.scale(
              scale: 0.6,
              child: CupertinoSwitch(
                onChanged: (value) {
                  setState(
                    () {
                      accountStatus = value;
                    },
                  );
                },
                value: accountStatus,
                activeColor: const Color.fromARGB(255, 33, 237, 91),
                trackColor: const Color.fromARGB(255, 255, 35, 35),
                thumbColor: Colors.white,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 10),
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildIconButton(
                      const Icon(
                        Icons.vpn_key_outlined,
                        color: Color.fromARGB(255, 255, 35, 35),
                        size: 30,
                      ),
                      "My Profile",
                      "Everything about your profile",
                      () {
                        setState(
                          () {
                            positionAccountPage = 1;
                          },
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios_rounded),
                      color: const Color.fromARGB(255, 49, 48, 54),
                      onPressed: () {
                        setState(
                          () {
                            positionAccountPage = 1;
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 10),
              child: Align(
                alignment: const Alignment(-0.8, 0),
                child: Text(
                  "All Settings",
                  style: robotoStyle(FontWeight.w900,
                      const Color.fromARGB(255, 49, 48, 54), 18, null),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 5),
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildIconButton(
                      const Icon(
                        Icons.notifications_none_rounded,
                        color: Color.fromARGB(255, 255, 35, 35),
                        size: 30,
                      ),
                      "My Notifications",
                      "Manage your push message alert",
                      () {
                        setState(
                          () {
                            isNotifsExpanded = !isNotifsExpanded;
                          },
                        );
                        if (isNotifsExpanded) scrollDown();
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        !isNotifsExpanded
                            ? Icons.expand_more_rounded
                            : Icons.expand_less_rounded,
                        size: 35,
                      ),
                      color: const Color.fromARGB(255, 49, 48, 54),
                      onPressed: () {
                        setState(
                          () {
                            isNotifsExpanded = !isNotifsExpanded;
                          },
                        );
                        if (isNotifsExpanded) scrollDown();
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: isNotifsExpanded ? 280 : 0,
              child: Visibility(
                key: const PageStorageKey<String>('Scroll MyNotifications'),
                visible: isNotifsExpanded,
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    Column(
                      children: [
                        Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            const Align(
                              alignment: Alignment(-0.8, 0),
                              child: Icon(
                                CupertinoIcons.calendar,
                                size: 35,
                                color: Color.fromARGB(255, 107, 107, 107),
                              ),
                            ),
                            Align(
                                alignment: Alignment.center,
                                child: Text("Calendar",
                                    style: robotoStyle(
                                        FontWeight.w800,
                                        const Color.fromARGB(255, 49, 48, 54),
                                        22,
                                        null))),
                            Align(
                              alignment: const Alignment(0.8, 0),
                              child: Transform.scale(
                                scale: 0.75,
                                child: CupertinoSwitch(
                                  onChanged: (value) {
                                    setState(
                                      () {
                                        notifCalendar = value;
                                      },
                                    );
                                  },
                                  value: notifCalendar,
                                  activeColor:
                                      const Color.fromARGB(255, 33, 237, 91),
                                  trackColor:
                                      const Color.fromARGB(255, 255, 35, 35),
                                  thumbColor: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text("Advanced Settings",
                            style: robotoStyle(
                                FontWeight.w400,
                                const Color.fromARGB(255, 49, 48, 54),
                                null,
                                TextDecoration.underline)),
                        const Divider(
                          color: Colors.grey,
                          height: 60,
                          thickness: 1,
                          indent: 100,
                          endIndent: 100,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            const Align(
                              alignment: Alignment(-0.8, 0),
                              child: Icon(
                                CupertinoIcons.arrow_2_circlepath,
                                size: 35,
                                color: Color.fromARGB(255, 107, 107, 107),
                              ),
                            ),
                            Align(
                                alignment: Alignment.center,
                                child: Text("Restock",
                                    style: robotoStyle(
                                        FontWeight.w800,
                                        const Color.fromARGB(255, 49, 48, 54),
                                        22,
                                        null))),
                            Align(
                              alignment: const Alignment(0.8, 0),
                              child: Transform.scale(
                                scale: 0.75,
                                child: CupertinoSwitch(
                                  onChanged: (value) {
                                    setState(
                                      () {
                                        notifRestock = value;
                                      },
                                    );
                                  },
                                  value: notifRestock,
                                  activeColor:
                                      const Color.fromARGB(255, 33, 237, 91),
                                  trackColor:
                                      const Color.fromARGB(255, 255, 35, 35),
                                  thumbColor: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text("Advanced Settings",
                            style: robotoStyle(
                                FontWeight.w400,
                                const Color.fromARGB(255, 49, 48, 54),
                                null,
                                TextDecoration.underline)),
                        const Divider(
                          color: Colors.grey,
                          height: 60,
                          thickness: 1,
                          indent: 100,
                          endIndent: 100,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 15),
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildIconButton(
                      const Icon(
                        Icons.favorite_border_rounded,
                        color: Color.fromARGB(255, 255, 35, 35),
                        size: 30,
                      ),
                      "My Wishlist",
                      "All products you spotted",
                      () {
                        setState(
                          () {
                            positionAccountPage = 2;
                          },
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios_rounded),
                      color: const Color.fromARGB(255, 49, 48, 54),
                      onPressed: () {
                        setState(
                          () {
                            positionAccountPage = 2;
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 0, bottom: 10),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        urlLauncher("https://www.instagram.com/");
                      },
                      child: Image.asset(
                        'assets/icons/instagram_outlined.png',
                        height: 30,
                      ),
                    ),
                    const SizedBox(width: 30),
                    GestureDetector(
                      onTap: () {
                        urlLauncher("https://www.tiktok.com/");
                      },
                      child: Image.asset(
                        'assets/icons/tiktok_outlined.png',
                        height: 30,
                      ),
                    ),
                    const SizedBox(width: 30),
                    GestureDetector(
                      onTap: () {
                        urlLauncher("https://twitter.com/");
                      },
                      child: Image.asset(
                        'assets/icons/twitter_outlined.png',
                        height: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              "Join us on Social Networks",
              style: robotoStyle(FontWeight.w800,
                  const Color.fromARGB(255, 49, 48, 54), 12, null),
            ),
            const SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }

  Widget pageAccountMyProfile() {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top + 18,
          ),
          Center(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "Informations",
                style: robotoStyle(
                    FontWeight.w700, const Color(0xff313036), 20, null),
              ),
            ),
          ),
          const SizedBox(
            height: 18,
          ),
          Container(
            height: 6,
            width: 80,
            decoration: const BoxDecoration(
              color: Color(0xff313036),
            ),
          ),
          const Divider(
            color: Colors.grey,
            height: 0,
            thickness: 1,
          ),
          Expanded(
            child: SingleChildScrollView(
              key: const PageStorageKey<String>('Account Scroll MyProfile'),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(top: 35),
                      child: Align(
                        alignment: const Alignment(-0.8, 0),
                        child: Text(
                          "General",
                          style: robotoStyle(FontWeight.w800,
                              const Color.fromARGB(255, 49, 48, 54), 16, null),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 20),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            myDropDownButton(
                                const Icon(
                                  Icons.stars_rounded,
                                  size: 25,
                                  color: Colors.grey,
                                ),
                                "Preferred Size",
                                listSizes,
                                defaultSizes, (value) {
                              setState(() {
                                defaultSizes = value as String;
                                checkSizeField[0] = 0;
                                checkSizeField[1] = 1;
                              });
                            }),
                            const SizedBox(
                              width: 10,
                            ),
                            returnCheckingIcon(checkSizeField)
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 20),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            myDropDownButton(
                                const Icon(
                                  Icons.payments,
                                  size: 25,
                                  color: Colors.grey,
                                ),
                                "Default Currency",
                                listCurrencies,
                                defaultCurrencies, (value) {
                              setState(() {
                                defaultCurrencies = value as String;
                                checkCurrencyField[0] = 0;
                                checkCurrencyField[1] = 1;
                              });
                            }),
                            const SizedBox(
                              width: 10,
                            ),
                            returnCheckingIcon(checkCurrencyField)
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 20),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            myDropDownButton(
                                const Icon(
                                  Icons.my_location_rounded,
                                  size: 25,
                                  color: Colors.grey,
                                ),
                                "Location Area",
                                listLocations,
                                defaultLocations, (value) {
                              setState(() {
                                defaultLocations = value as String;
                                checkAreaField[0] = 0;
                                checkAreaField[1] = 1;
                              });
                            }),
                            const SizedBox(
                              width: 10,
                            ),
                            returnCheckingIcon(checkAreaField)
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 40),
                      child: Align(
                        alignment: const Alignment(-0.8, 0),
                        child: Text(
                          "Personal",
                          style: robotoStyle(FontWeight.w800,
                              const Color.fromARGB(255, 49, 48, 54), 16, null),
                        ),
                      ),
                    ),
                    Container(
                      width: 300,
                      padding: const EdgeInsets.only(top: 20),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: buildTextField(
                                "Username",
                                const Icon(
                                  Icons.account_circle_outlined,
                                  color: Colors.grey,
                                  size: 25,
                                ),
                                const Color.fromARGB(255, 235, 235, 235),
                                controllerUsername,
                                TextInputType.name,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            returnCheckingIcon(checkUsernameField)
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 300,
                      padding: const EdgeInsets.only(top: 20),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: buildTextFieldEmail(
                                "example.example@gmail.com", // to be replaced by the real user infos from DB
                                const Icon(
                                  Icons.alternate_email_rounded,
                                  color: Colors.grey,
                                  size: 25,
                                ),
                                controllerUserMail,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            returnCheckingIcon(checkUserMailField)
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 300,
                      padding: const EdgeInsets.only(top: 20),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: buildTextField(
                                "First Name",
                                const Icon(
                                  Icons.abc_rounded,
                                  color: Colors.grey,
                                  size: 25,
                                ),
                                const Color.fromARGB(255, 235, 235, 235),
                                controllerFirstName,
                                TextInputType.name,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            returnCheckingIcon(checkFirstNameField)
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 300,
                      padding: const EdgeInsets.only(top: 20),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: buildTextField(
                                "Last Name",
                                const Icon(
                                  Icons.abc_rounded,
                                  color: Colors.grey,
                                  size: 25,
                                ),
                                const Color.fromARGB(255, 235, 235, 235),
                                controllerLastName,
                                TextInputType.name,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            returnCheckingIcon(checkLastNameField)
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 300,
                      padding: const EdgeInsets.only(top: 20),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: buildTextField(
                                "Phone Number",
                                const Icon(
                                  Icons.phone_outlined,
                                  color: Colors.grey,
                                  size: 25,
                                ),
                                const Color.fromARGB(255, 235, 235, 235),
                                controllerPhone,
                                TextInputType.phone,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            returnCheckingIcon(checkPhoneField)
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 40),
                      child: Align(
                        alignment: const Alignment(-0.8, 0),
                        child: Text(
                          "Shipping Address",
                          style: robotoStyle(FontWeight.w800,
                              const Color.fromARGB(255, 49, 48, 54), 16, null),
                        ),
                      ),
                    ),
                    Container(
                      width: 300,
                      padding: const EdgeInsets.only(top: 20),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: buildAddressTextField(
                                "Address Line 1",
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.grey,
                                  size: 25,
                                ),
                                const Color.fromARGB(255, 235, 235, 235),
                                controllerAL1,
                                TextInputType.streetAddress,
                                () async {
                                  final sessionToken = const Uuid().v4();
                                  final Suggestion? result = await showSearch(
                                    context: context,
                                    delegate: AddressSearch(sessionToken),
                                  );
                                  // This will change the text displayed in the TextField
                                  if (result != null) {
                                    final placeDetails = await PlaceApiProvider(
                                            sessionToken)
                                        .getPlaceDetailFromId(result.placeId);
                                    // setState(() {
                                    controllerAL1.text = result.description;
                                    controllerCity.text =
                                        placeDetails.city ?? '';
                                    controllerZipcode.text =
                                        placeDetails.zipCode ?? '';
                                    controllerState.text =
                                        placeDetails.state ?? '';
                                    // _streetNumber = placeDetails.streetNumber;
                                    // _street = placeDetails.street;
                                    // _city = placeDetails.city;
                                    // _zipCode = placeDetails.zipCode;

                                    // });
                                  }
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            returnCheckingIcon(checkAL1Field)
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 300,
                      padding: const EdgeInsets.only(top: 20),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: buildTextField(
                                "Address Line 2",
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.grey,
                                  size: 25,
                                ),
                                const Color.fromARGB(255, 235, 235, 235),
                                controllerAL2,
                                TextInputType.streetAddress,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            returnCheckingIcon(checkAL2Field)
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 300,
                      padding: const EdgeInsets.only(top: 20),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: buildTextField(
                                "City",
                                const Icon(
                                  Icons.map_outlined,
                                  color: Colors.grey,
                                  size: 25,
                                ),
                                const Color.fromARGB(255, 235, 235, 235),
                                controllerCity,
                                TextInputType.streetAddress,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            returnCheckingIcon(checkCityField)
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 300,
                      padding: const EdgeInsets.only(top: 20),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: buildTextField(
                                "Zipcode",
                                const Icon(
                                  Icons.markunread_mailbox_outlined,
                                  color: Colors.grey,
                                  size: 25,
                                ),
                                const Color.fromARGB(255, 235, 235, 235),
                                controllerZipcode,
                                TextInputType.number,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            returnCheckingIcon(checkZipcodeField)
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 300,
                      padding: const EdgeInsets.only(top: 20),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: buildTextField(
                                "State",
                                const Icon(
                                  Icons.share_location_rounded,
                                  color: Colors.grey,
                                  size: 25,
                                ),
                                const Color.fromARGB(255, 235, 235, 235),
                                controllerState,
                                TextInputType.streetAddress,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            returnCheckingIcon(checkStateField)
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 300,
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: buildTextFieldCountryReadOnly(
                                "Country",
                                selectedCountryText,
                                const Icon(
                                  Icons.flag_rounded,
                                  size: 25,
                                  color: Colors.grey,
                                ),
                                selectedCountryFlag,
                                const Icon(
                                  Icons.arrow_drop_down_rounded,
                                  size: 30,
                                  color: Color.fromARGB(255, 49, 48, 54),
                                ),
                                (() {
                                  showCountryPicker(
                                    context: context,
                                    showPhoneCode: false,
                                    onSelect: (Country country) {
                                      setState(
                                        () {
                                          selectedCountryFlag =
                                              country.flagEmoji;
                                          selectedCountryText = country.name;
                                          checkCountryField[0] = 0;
                                          checkCountryField[1] = 1;
                                        },
                                      );
                                    },
                                    countryListTheme:
                                        const CountryListThemeData(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30.0),
                                        topRight: Radius.circular(30.0),
                                      ),
                                      inputDecoration: InputDecoration(
                                        labelText: 'Search',
                                        hintText: 'Start typing to search',
                                        prefixIcon: Icon(Icons.search,
                                            color: Color.fromARGB(
                                                255, 255, 35, 35)),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30.0)),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            returnCheckingIcon(checkCountryField)
                          ],
                        ),
                      ),
                    ),
                    photoURL == ''
                        ? GestureDetector(
                            onTap: () {
                              pickImage();
                            },
                            child: Image.asset(
                              "assets/icons/add_profile_picture.png",
                              height: 110,
                            ),
                          )
                        : ClipOval(
                            child: Image.network(photoURL),
                          ),
                    Container(
                      padding: const EdgeInsets.only(top: 30, bottom: 80),
                      child: buildSimpleButton(
                        "Save",
                        () {
                          if (checkAL1Field[1] == 1 &&
                              checkAL2Field[1] == 1 &&
                              checkAreaField[1] == 1 &&
                              checkCityField[1] == 1 &&
                              checkCountryField[1] == 1 &&
                              checkCurrencyField[1] == 1 &&
                              checkFirstNameField[1] == 1 &&
                              checkLastNameField[1] == 1 &&
                              checkPhoneField[1] == 1 &&
                              checkSizeField[1] == 1 &&
                              checkStateField[1] == 1 &&
                              checkUsernameField[1] == 1 &&
                              checkZipcodeField[1] == 1) {
                            // Send here the user infos to the database
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //     launchSnackbar(
                            //         "Your informations have been successfully saved.",
                            //         Icons.check,
                            //         const Color.fromARGB(255, 255, 35, 35),
                            //         Colors.white,
                            //         const Color.fromARGB(255, 255, 35, 35)));

                            // prefs.setBool('savedProfile', true);
                            // setState(() {
                            //   positionAccountPage = 0;
                            // });
                          } else {
                            if (checkAL1Field[1] != 1) {
                              setState(() {
                                checkAL1Field[0] = 1;
                              });
                            }
                            if (checkAL2Field[1] != 1) {
                              setState(() {
                                checkAL2Field[0] = 1;
                              });
                            }
                            if (checkAreaField[1] != 1) {
                              setState(() {
                                checkAreaField[0] = 1;
                              });
                            }
                            if (checkCityField[1] != 1) {
                              setState(() {
                                checkCityField[0] = 1;
                              });
                            }
                            if (checkCountryField[1] != 1) {
                              setState(() {
                                checkCountryField[0] = 1;
                              });
                            }
                            if (checkCurrencyField[1] != 1) {
                              setState(() {
                                checkCurrencyField[0] = 1;
                              });
                            }
                            if (checkFirstNameField[1] != 1) {
                              setState(() {
                                checkFirstNameField[0] = 1;
                              });
                            }
                            if (checkLastNameField[1] != 1) {
                              setState(() {
                                checkLastNameField[0] = 1;
                              });
                            }
                            if (checkPhoneField[1] != 1) {
                              setState(() {
                                checkPhoneField[0] = 1;
                              });
                            }
                            if (checkSizeField[1] != 1) {
                              setState(() {
                                checkSizeField[0] = 1;
                              });
                            }
                            if (checkStateField[1] != 1) {
                              setState(() {
                                checkStateField[0] = 1;
                              });
                            }
                            if (checkUsernameField[1] != 1) {
                              setState(() {
                                checkUsernameField[0] = 1;
                              });
                            }
                            if (checkZipcodeField[1] != 1) {
                              setState(() {
                                checkZipcodeField[0] = 1;
                              });
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                                launchSnackbar(
                                    "At least one information is missing or invalid.",
                                    Icons.info,
                                    Colors.white,
                                    const Color.fromARGB(255, 255, 35, 35),
                                    Colors.white));
                          }
                        },
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

  Widget pageAccountMyWishlist() {
    return Scaffold(
      body: goodList().isEmpty
          ? Column(children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top + 25,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: const Alignment(-0.85, 0),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_circle_left_outlined),
                      color: const Color.fromARGB(255, 49, 48, 54),
                      iconSize: 32,
                      onPressed: () {
                        setState(
                          () {
                            positionAccountPage = 0;
                          },
                        );
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "My Wishlist",
                      style: robotoStyle(FontWeight.w700,
                          const Color.fromARGB(255, 49, 48, 54), 20, null),
                    ),
                  ),
                ],
              ),
              Container(
                height: 5,
                width: 80,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 49, 48, 54),
                ),
              ),
              const Divider(
                color: Colors.grey,
                height: 0,
                thickness: 1,
              ),
              const SizedBox(height: 250),
              Text(
                "Your Wishlist is currently empty.",
                style: robotoStyle(FontWeight.w500,
                    const Color.fromARGB(255, 49, 48, 54), null, null),
              ),
            ])
          : Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).padding.top + 5,
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: const Alignment(-0.9, 0),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_circle_left_outlined),
                        color: const Color.fromARGB(255, 49, 48, 54),
                        iconSize: 32,
                        onPressed: () {
                          setState(
                            () {
                              positionAccountPage = 0;
                            },
                          );
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "My Wishlist",
                        style: robotoStyle(FontWeight.w700,
                            const Color.fromARGB(255, 49, 48, 54), 20, null),
                      ),
                    ),
                    Align(
                      alignment: const Alignment(0.9, 0),
                      child: IconButton(
                        icon: const Icon(Icons.sort_rounded),
                        color: sortWishlistName || sortWishlistPrice
                            ? const Color.fromARGB(255, 255, 35, 35)
                            : const Color.fromARGB(255, 49, 48, 54),
                        iconSize: 32,
                        onPressed: () {
                          wishlistSortPopUp(context);
                        },
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 5,
                  width: 80,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 49, 48, 54),
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                  height: 0,
                  thickness: 1,
                ),
                Expanded(
                  child: ListView.separated(
                    key: const PageStorageKey<String>(
                        'Account Listview MyWishlist'),
                    itemCount: goodList().length,
                    padding: const EdgeInsets.only(bottom: 80),
                    separatorBuilder: (context, position) => const Divider(
                      color: Colors.transparent,
                    ),
                    itemBuilder: (context, position) {
                      return Dismissible(
                        direction: DismissDirection.endToStart,
                        key: Key('item ${goodList()[position]}'),
                        background: Container(
                          alignment: Alignment.center,
                          color: const Color.fromARGB(255, 255, 35, 35),
                          child: Text(
                            "Remove",
                            style: robotoStyle(
                                FontWeight.w800, Colors.white, null, null),
                          ),
                        ),
                        confirmDismiss: (_) async {
                          return showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                title: Text('Remove Item',
                                    style: robotoStyle(
                                        FontWeight.w700,
                                        const Color.fromARGB(255, 49, 48, 54),
                                        null,
                                        null),
                                    textAlign: TextAlign.center),
                                content: Text(
                                  "Do you really want to remove this item from your Wishlist ?",
                                  style: robotoStyle(
                                      FontWeight.w400,
                                      const Color.fromARGB(255, 49, 48, 54),
                                      null,
                                      null),
                                  textAlign: TextAlign.center,
                                ),
                                actions: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        style: ButtonStyle(
                                          overlayColor:
                                              MaterialStateProperty.all(
                                                  const Color.fromARGB(
                                                      255, 235, 235, 235)),
                                        ),
                                        child: Text(
                                          'Cancel',
                                          style: robotoStyle(FontWeight.w600,
                                              Colors.grey, 17, null),
                                        ),
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                      ),
                                      TextButton(
                                        style: ButtonStyle(
                                          overlayColor:
                                              MaterialStateProperty.all(
                                                  const Color.fromARGB(
                                                      255, 235, 235, 235)),
                                        ),
                                        child: Text(
                                          'Remove',
                                          style: robotoStyle(
                                              FontWeight.w600,
                                              const Color.fromARGB(
                                                  255, 255, 35, 35),
                                              17,
                                              null),
                                        ),
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        onDismissed: (_) {
                          setState(() {
                            String elmt = goodList()[position];
                            wishlistTest.remove(elmt);
                            wishlistTestNamed.remove(elmt);
                            wishlistTestPriced.remove(elmt);
                          });
                        },
                        child: ListTile(
                          // Image.network(url, height, width)
                          leading: Image.asset(
                            "assets/aj1_mid_wishlist.png",
                          ),
                          title: Center(
                            child: Text(
                              goodList()[position],
                              style: robotoStyle(
                                  FontWeight.w800,
                                  const Color.fromARGB(255, 49, 48, 54),
                                  null,
                                  null),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          subtitle: const Center(child: Text('Size: 7 US')),
                          trailing: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 10,
                            children: <Widget>[
                              Icon(
                                  position % 2 == 0
                                      ? Icons.trending_down_rounded
                                      : Icons.trending_up_rounded,
                                  color: position % 2 == 0
                                      ? const Color.fromARGB(255, 255, 35, 35)
                                      : const Color.fromARGB(255, 33, 237, 91)),
                              Text(
                                r"$165",
                                style: TextStyle(
                                    color: position % 2 == 0
                                        ? const Color.fromARGB(255, 255, 35, 35)
                                        : const Color.fromARGB(
                                            255, 33, 237, 91)),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget buildBody() {
    if (positionAccountPage == 0) {
      return pageAccountMain();
    } else if (positionAccountPage == 1) {
      return pageAccountMyProfile();
    } else {
      return pageAccountMyWishlist();
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
    if (positionAccountPage != 0 || positionAccountPage != 1) {
      setState(() {
        positionAccountPage = 0;
        // SchedulerBinding.instance.addPostFrameCallback((_) {
        //   scroll.jumpTo(scroll.position.minScrollExtent);
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
}
