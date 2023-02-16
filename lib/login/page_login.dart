import 'package:flutter/material.dart';
import 'package:s4s_mobileapp/tools/firebase_service.dart';
import 'package:s4s_mobileapp/tools/functions.dart';
import 'package:s4s_mobileapp/trend/page_trend.dart';
import 'package:s4s_mobileapp/calendar/page_calendar.dart';
import 'package:s4s_mobileapp/search/page_search.dart';
import 'package:s4s_mobileapp/restock/page_restock.dart';
import 'package:s4s_mobileapp/account/page_account.dart';
import 'package:s4s_mobileapp/home/page_home.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Widget> pages = [
  const TrendPage(),
  const CalendarPage(),
  const SearchPage(),
  const RestockPage(),
  const AccountPage(),
];

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameemailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isObscure = true;
  final forgotpasswordController = TextEditingController();
  FirebaseService service = FirebaseService();
  late final SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    () async {
      prefs = await SharedPreferences.getInstance();
    }();
  }

  Widget buildTextField(String title, Icon icon, Color color,
      TextInputType keyboardType, TextEditingController controller) {
    return TextField(
      keyboardType: keyboardType,
      obscureText: (title == "Password" || title == "Confirm Password")
          ? isObscure
          : false,
      textAlign: TextAlign.left,
      cursorColor: const Color.fromARGB(255, 255, 35, 35),
      controller: controller,
      decoration: InputDecoration(
          suffixIcon: title == "Password"
              ? IconButton(
                  color: Colors.grey,
                  splashRadius: 1,
                  icon: Icon(
                    isObscure ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      isObscure = !isObscure;
                    });
                  },
                )
              : null,
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
    );
  }

  Future resetPasswordPopUp(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        String message = "";
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            title: Text('Forgot Password ?',
                textAlign: TextAlign.center,
                style: robotoStyle(FontWeight.w800,
                    const Color.fromARGB(255, 49, 48, 54), null, null)),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "Don't worry, just enter your Email address below and we'll send you a link to reset your password.",
                  style: robotoStyle(FontWeight.w400,
                      const Color.fromARGB(255, 49, 48, 54), null, null),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Flexible(
                  child: buildTextField(
                    "Email",
                    const Icon(
                      Icons.alternate_email_rounded,
                      color: Color.fromARGB(255, 255, 35, 35),
                    ),
                    const Color.fromARGB(255, 235, 235, 235),
                    TextInputType.emailAddress,
                    forgotpasswordController,
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: robotoStyle(FontWeight.w500,
                      const Color.fromARGB(255, 255, 35, 35), null, null),
                )
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
                      forgotpasswordController.clear();
                      Navigator.pop(context);
                    },
                  ),
                  TextButton(
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 235, 235, 235)),
                    ),
                    child: Text(
                      'Send',
                      style: robotoStyle(FontWeight.w600,
                          const Color.fromARGB(255, 255, 35, 35), 17, null),
                    ),
                    onPressed: () async {
                      if (isEmail(forgotpasswordController
                          .text) /*&& forgotpasswordController.text is already inside the database*/) {
                        await service.resetPassword(
                            email: forgotpasswordController.text);
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(launchSnackbar(
                            "An email has been sent to: ${forgotpasswordController.text}",
                            Icons.check,
                            const Color.fromARGB(255, 255, 35, 35),
                            Colors.white,
                            const Color.fromARGB(255, 255, 35, 35)));
                        // Send here email from s4s to user
                        forgotpasswordController.clear();
                      } else {
                        setState(() {
                          message = "Please enter a valid Email address.";
                        });
                      }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).padding.top + 10),
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      iconSize: 25,
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed('/LoginSignupWithEmail');
                      },
                      icon: const Icon(Icons.arrow_back_ios_rounded),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 40,
                      child: Image.asset(
                        'assets/etc/splash-cropped.png',
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Column(
                children: [
                  SizedBox(
                    height: 40,
                    child: Text(
                      "Welcome B@ck",
                      style: robotoStyle(FontWeight.w900,
                          const Color.fromARGB(255, 49, 48, 54), 35, null),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      "Here you can register to enter in our world",
                      style: robotoStyle(FontWeight.w400,
                          const Color.fromARGB(255, 49, 48, 54), 12, null),
                    ),
                  ),
                  Container(
                    width: 280,
                    padding: const EdgeInsets.only(top: 50),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: buildTextField(
                              "Email",
                              const Icon(
                                Icons.account_circle_rounded,
                                color: Color.fromARGB(255, 255, 35, 35),
                                size: 25,
                              ),
                              const Color.fromARGB(255, 235, 235, 235),
                              TextInputType.emailAddress,
                              usernameemailController,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 280,
                    padding: const EdgeInsets.only(top: 20),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: buildTextField(
                              "Password",
                              const Icon(
                                Icons.password_rounded,
                                color: Color.fromARGB(255, 255, 35, 35),
                                size: 25,
                              ),
                              const Color.fromARGB(255, 235, 235, 235),
                              TextInputType.visiblePassword,
                              passwordController,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          "Forgot Password ?",
                          style: robotoStyle(
                              FontWeight.w400,
                              const Color.fromARGB(255, 49, 48, 54),
                              null,
                              TextDecoration.underline),
                        ),
                      ),
                    ),
                    onTap: () {
                      resetPasswordPopUp(context);
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 40),
                    child: buildSimpleButton(
                      "Submit",
                      () async {
                        if ((isAlphaNum(usernameemailController.text) ||
                                isEmail(usernameemailController.text)) &&
                            isPassword(passwordController.text)) {
                          // Check here in the database if the credentials match //

                          var result = await service.signInWithEmail(
                              email: usernameemailController.text,
                              password: passwordController.text);
                          // if (result == 'SUCCESS') {
                          //   var checkVerification = await service.checkVerify();
                          if (result == 'VERIFIED') {
                            // ignore: use_build_context_synchronously
                            prefs.getBool('savedProfile') == true
                                // ignore: use_build_context_synchronously
                                ? Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            HomePage(pages, 4, 1)),
                                    (route) => false)
                                // ignore: use_build_context_synchronously
                                : Navigator.pushNamedAndRemoveUntil(
                                    context, '/SaveProfile', (route) => false);
                          } else if (result == 'NOT_VERIFIED') {
                            // ignore: use_build_context_synchronously
                            showMessage(context,
                                'You are not verified yet. Please check your email.',
                                title: 'Info');
                          } else if (result == 'USER_NOT_FOUND') {
                            // ignore: use_build_context_synchronously
                            showMessage(
                                context, 'This user could not be found.',
                                title: 'Info');
                          } else if (result == 'WRONG_PASSWORD') {
                            // ignore: use_build_context_synchronously
                            showMessage(context, 'This password is wrong.',
                                title: 'Info');
                          } else if (result == 'USER_DISABLED') {
                            // ignore: use_build_context_synchronously
                            showMessage(context, 'This user is disabled.',
                                title: 'Info');
                          } else if (result == 'INVALID_EMAIL') {
                            // ignore: use_build_context_synchronously
                            showMessage(context, 'This email is invalid.',
                                title: 'Info');
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            launchSnackbar(
                                "Those credentials don't match.",
                                Icons.info,
                                Colors.white,
                                const Color.fromARGB(255, 255, 35, 35),
                                Colors.white),
                          );
                        }
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
