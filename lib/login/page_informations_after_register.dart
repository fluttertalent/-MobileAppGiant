import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:s4s_mobileapp/account/page_account.dart';
import 'package:s4s_mobileapp/home/page_home.dart';
import 'package:s4s_mobileapp/tools/functions.dart';

class InformationsAfterRegister extends StatefulWidget {
  const InformationsAfterRegister({Key? key}) : super(key: key);

  @override
  State<InformationsAfterRegister> createState() =>
      _InformationsAfterRegisterState();
}

class _InformationsAfterRegisterState extends State<InformationsAfterRegister> {
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

  Widget buildTextField(
      String title, Icon icon, Color color, TextEditingController controller) {
    return TextField(
      textAlign: TextAlign.left,
      cursorColor: const Color.fromARGB(255, 255, 35, 35),
      controller: controller,
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
          )),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 60),
          Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Registration",
                  style: robotoStyle(FontWeight.w700,
                      const Color.fromARGB(255, 255, 35, 35), 20, null),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 5,
            width: 80,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 255, 35, 35),
            ),
          ),
          const Divider(
            color: Colors.grey,
            height: 0,
            thickness: 1,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        textAlign: TextAlign.center,
                        "You're almost done !",
                        style: robotoStyle(FontWeight.w400,
                            const Color.fromARGB(255, 49, 48, 54), 16, null),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        textAlign: TextAlign.center,
                        "Please complete your registration below.",
                        style: robotoStyle(FontWeight.w700,
                            const Color.fromARGB(255, 49, 48, 54), null, null),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 30),
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
                                child: buildTextFieldEmailReadOnly(
                              "exemple.exemple@gmail.com", // to be replaced by the real user infos from DB
                              const Icon(
                                Icons.alternate_email_rounded,
                                color: Colors.grey,
                                size: 25,
                              ),
                            )),
                            const SizedBox(
                              width: 10,
                            ),
                            const Icon(Icons.check,
                                color: Color.fromARGB(255, 33, 237, 91),
                                size: 30),
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
                              child: buildTextField(
                                "Address Line 1",
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.grey,
                                  size: 25,
                                ),
                                const Color.fromARGB(255, 235, 235, 235),
                                controllerAL1,
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
                      padding: const EdgeInsets.only(top: 20),
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
                    Container(
                      padding: const EdgeInsets.only(top: 30, bottom: 20),
                      child: buildSimpleButton(
                        "Complete",
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
                            ScaffoldMessenger.of(context).showSnackBar(
                                launchSnackbar(
                                    "You have been successfully registered.",
                                    Icons.check,
                                    const Color.fromARGB(255, 255, 35, 35),
                                    Colors.white,
                                    const Color.fromARGB(255, 255, 35, 35)));
                            setState(() {
                              selectedIndex = 4;
                            });
                            Navigator.pushNamed(context, '/Home');
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
}
