import 'package:flutter/material.dart';
import 'package:s4s_mobileapp/tools/functions.dart';
// ignore: depend_on_referenced_packages
import 'package:uuid/uuid.dart';
import 'package:s4s_mobileapp/tools/address_search.dart';
import 'package:s4s_mobileapp/tools/place_service.dart';
import 'package:country_picker/country_picker.dart';
import 'package:s4s_mobileapp/home/page_home.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:s4s_mobileapp/calendar/page_calendar.dart';
import 'package:s4s_mobileapp/restock/page_restock.dart';
import 'package:s4s_mobileapp/account/page_account.dart';
import 'package:s4s_mobileapp/search/page_search.dart';
import 'package:s4s_mobileapp/trend/page_trend.dart';
import 'package:s4s_mobileapp/product/product_detail.dart';

File? image;

class SaveProfile extends StatefulWidget {
  const SaveProfile({Key? key}) : super(key: key);

  @override
  State<SaveProfile> createState() => _SaveProfileState();
}

class _SaveProfileState extends State<SaveProfile> {
  List<Widget> pages = [
    const TrendPage(),
    const CalendarPage(),
    const SearchPage(),
    const RestockPage(),
    const AccountPage(),
    const ProductDetailPage(),
  ];
  List<String> listSizes =
      sizes.map((e) => e.keys.first).toList().cast<String>();
  String? defaultSizes;
  var checkSizeField = [0, 0];
  late final SharedPreferences prefs;

  final List<String> listCurrencies = [
    '€ - EUR',
    r'$ - USD',
    r'$ - CAD',
    '£ - GBP',
    '¥ - YEN',
    '¥ - CNY',
  ];
  String? defaultCurrencies;
  var checkCurrencyField = [0, 0];
  final List<String> listLocations = [
    'Canada  🇨🇦',
    'China  🇨🇳',
    'Europe  🇪🇺',
    'Japan  🇯🇵',
    'USA  🇺🇸',
    'Worldwide  🌎',
  ];
  String? defaultLocations;
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
  String? _streetNumber = '';
  String? _street = '';
  String? _city = '';
  String? _zipCode = '';
  String selectedCountryFlag = "";
  String selectedCountryText = "";
  String photoURL = '';

  @override
  void initState() {
    initSharePref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                                    setState(() {
                                      controllerAL1.text = result.description;
                                      _streetNumber = placeDetails.streetNumber;
                                      _street = placeDetails.street;
                                      _city = placeDetails.city;
                                      _zipCode = placeDetails.zipCode;
                                    });
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
                          prefs.setBool('savedProfile', true);
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => HomePage(pages, 4, 0)),
                              (route) => false);
                          // if (checkAL1Field[1] == 1 &&
                          //     checkAL2Field[1] == 1 &&
                          //     checkAreaField[1] == 1 &&
                          //     checkCityField[1] == 1 &&
                          //     checkCountryField[1] == 1 &&
                          //     checkCurrencyField[1] == 1 &&
                          //     checkFirstNameField[1] == 1 &&
                          //     checkLastNameField[1] == 1 &&
                          //     checkPhoneField[1] == 1 &&
                          //     checkSizeField[1] == 1 &&
                          //     checkStateField[1] == 1 &&
                          //     checkUsernameField[1] == 1 &&
                          //     checkZipcodeField[1] == 1) {
                          //   // Send here the user infos to the database
                          //   ScaffoldMessenger.of(context).showSnackBar(
                          //       launchSnackbar(
                          //           "Your informations have been successfully saved.",
                          //           Icons.check,
                          //           const Color.fromARGB(255, 255, 35, 35),
                          //           Colors.white,
                          //           const Color.fromARGB(255, 255, 35, 35)));
                          // } else {
                          //   if (checkAL1Field[1] != 1) {
                          //     setState(() {
                          //       checkAL1Field[0] = 1;
                          //     });
                          //   }
                          //   if (checkAL2Field[1] != 1) {
                          //     setState(() {
                          //       checkAL2Field[0] = 1;
                          //     });
                          //   }
                          //   if (checkAreaField[1] != 1) {
                          //     setState(() {
                          //       checkAreaField[0] = 1;
                          //     });
                          //   }
                          //   if (checkCityField[1] != 1) {
                          //     setState(() {
                          //       checkCityField[0] = 1;
                          //     });
                          //   }
                          //   if (checkCountryField[1] != 1) {
                          //     setState(() {
                          //       checkCountryField[0] = 1;
                          //     });
                          //   }
                          //   if (checkCurrencyField[1] != 1) {
                          //     setState(() {
                          //       checkCurrencyField[0] = 1;
                          //     });
                          //   }
                          //   if (checkFirstNameField[1] != 1) {
                          //     setState(() {
                          //       checkFirstNameField[0] = 1;
                          //     });
                          //   }
                          //   if (checkLastNameField[1] != 1) {
                          //     setState(() {
                          //       checkLastNameField[0] = 1;
                          //     });
                          //   }
                          //   if (checkPhoneField[1] != 1) {
                          //     setState(() {
                          //       checkPhoneField[0] = 1;
                          //     });
                          //   }
                          //   if (checkSizeField[1] != 1) {
                          //     setState(() {
                          //       checkSizeField[0] = 1;
                          //     });
                          //   }
                          //   if (checkStateField[1] != 1) {
                          //     setState(() {
                          //       checkStateField[0] = 1;
                          //     });
                          //   }
                          //   if (checkUsernameField[1] != 1) {
                          //     setState(() {
                          //       checkUsernameField[0] = 1;
                          //     });
                          //   }
                          //   if (checkZipcodeField[1] != 1) {
                          //     setState(() {
                          //       checkZipcodeField[0] = 1;
                          //     });
                          //   }
                          //   ScaffoldMessenger.of(context).showSnackBar(
                          //       launchSnackbar(
                          //           "At least one information is missing or invalid.",
                          //           Icons.info,
                          //           Colors.white,
                          //           const Color.fromARGB(255, 255, 35, 35),
                          //           Colors.white));
                          // }
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
}
