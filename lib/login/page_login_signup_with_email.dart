import 'package:flutter/material.dart';
// import 'package:s4s_mobileapp/account/page_account.dart';
import 'package:s4s_mobileapp/tools/functions.dart';
import 'package:s4s_mobileapp/tools/firebase_service.dart';

class LoginSignupWithEmailPage extends StatefulWidget {
  const LoginSignupWithEmailPage({Key? key}) : super(key: key);

  @override
  State<LoginSignupWithEmailPage> createState() =>
      _LoginSignupWithEmailPageState();
}

class _LoginSignupWithEmailPageState extends State<LoginSignupWithEmailPage> {
  FirebaseService service = FirebaseService();
  final emailController = TextEditingController();
  final emailconfController = TextEditingController();
  final passController = TextEditingController();
  final passconfController = TextEditingController();

  List emailslist = ["", ""];
  List passwordslist = ["", ""];
  bool isObscure = true;
  var checkEmailField = [0, 0];
  var checkEmail2Field = [0, 0];
  var checkPasswordField = [0, 0];
  var checkPassword2Field = [0, 0];

  void checkEmail(String value) {
    if (isEmail(value)) {
      setState(() {
        //isEmailOK = true;
        checkEmailField[0] = 0;
        checkEmailField[1] = 1;
      });
      if (emailslist[0] == emailslist[1]) {
        setState(() {
          //isConfirmEmailOK = true;
          checkEmail2Field[0] = 0;
          checkEmail2Field[1] = 1;
        });
      } else {
        setState(() {
          //isConfirmEmailOK = false;
          checkEmail2Field[0] = 1;
          checkEmail2Field[1] = 0;
        });
      }
    } else {
      setState(() {
        //isEmailOK = false;
        checkEmailField[0] = 1;
        checkEmailField[1] = 0;
      });
    }
  }

  void checkEmailconf(String value) {
    if (isEmail(value) && emailslist[0] == emailslist[1]) {
      setState(() {
        //isConfirmEmailOK = true;
        checkEmail2Field[0] = 0;
        checkEmail2Field[1] = 1;
      });
    } else {
      setState(() {
        //isConfirmEmailOK = false;
        checkEmail2Field[0] = 1;
        checkEmail2Field[1] = 0;
      });
    }
  }

  void checkPassword(String value) {
    if (isPassword(value)) {
      setState(() {
        //isPassOK = true;
        checkPasswordField[0] = 0;
        checkPasswordField[1] = 1;
      });
      if (passwordslist[0] == passwordslist[1]) {
        setState(() {
          //isConfirmPassOK = true;
          checkPassword2Field[0] = 0;
          checkPassword2Field[1] = 1;
        });
      } else {
        setState(() {
          //isConfirmPassOK = false;
          checkPassword2Field[0] = 1;
          checkPassword2Field[1] = 0;
        });
      }
    } else {
      setState(() {
        //isPassOK = false;
        checkPasswordField[0] = 1;
        checkPasswordField[1] = 0;
      });
    }
  }

  void checkPasswordconf(String value) {
    if (isPassword(value) && passwordslist[0] == passwordslist[1]) {
      setState(() {
        //isConfirmPassOK = true;
        checkPassword2Field[0] = 0;
        checkPassword2Field[1] = 1;
      });
    } else {
      setState(() {
        //isConfirmPassOK = false;
        checkPassword2Field[0] = 1;
        checkPassword2Field[1] = 0;
      });
    }
  }

  Widget buildTextField(String title, Icon icon, Color color,
      TextInputType keybardType, TextEditingController controller) {
    return TextField(
      keyboardType: keybardType,
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
      onChanged: (value) {
        if (controller == emailController ||
            controller == emailconfController) {
          if (controller == emailController) {
            emailslist[0] = value;
          } else {
            emailslist[1] = value;
          }
        }
        if (controller == passController || controller == passconfController) {
          if (controller == passController) {
            passwordslist[0] = value;
          } else {
            passwordslist[1] = value;
          }
        }

        if (controller == emailController) checkEmail(value);
        if (controller == emailconfController) checkEmailconf(value);
        if (controller == passController) checkPassword(value);
        if (controller == passconfController) checkPasswordconf(value);
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
              SizedBox(
                height: MediaQuery.of(context).padding.top,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      iconSize: 25,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_rounded,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 0,
                        top: 0,
                      ),
                      child: Image.asset(
                        'assets/etc/splash-cropped.png',
                        height: 35.0,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Column(
                children: [
                  SizedBox(
                    height: 38,
                    child: Text(
                      "Already have",
                      style: robotoStyle(
                        FontWeight.w900,
                        const Color.fromARGB(255, 49, 48, 54),
                        30,
                        null,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 35,
                    child: Text(
                      "an account !",
                      style: robotoStyle(
                        FontWeight.w900,
                        const Color.fromARGB(255, 49, 48, 54),
                        30,
                        null,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      "Please login just below",
                      style: robotoStyle(
                        FontWeight.w400,
                        const Color.fromARGB(255, 49, 48, 54),
                        12,
                        null,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 20),
                    child: buildSimpleButton(
                      "Login",
                      () {
                        Navigator.pushNamed(context, '/Login');
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      "Sign Up",
                      style: robotoStyle(FontWeight.w900,
                          const Color.fromARGB(255, 49, 48, 54), 30, null),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Here you can ",
                            style: robotoStyle(
                                FontWeight.w400,
                                const Color.fromARGB(255, 49, 48, 54),
                                12,
                                null),
                          ),
                          Text(
                            "Register for Free",
                            style: robotoStyle(
                                FontWeight.w400,
                                const Color.fromARGB(255, 49, 48, 54),
                                12,
                                TextDecoration.underline),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Align(
                        child: Container(
                          padding: const EdgeInsets.only(top: 20),
                          alignment: Alignment.center,
                          width: 250,
                          child: buildTextField(
                            "Email",
                            const Icon(
                              Icons.alternate_email_rounded,
                              color: Color.fromARGB(255, 255, 35, 35),
                              size: 25,
                            ),
                            const Color.fromARGB(255, 235, 235, 235),
                            TextInputType.emailAddress,
                            emailController,
                          ),
                        ),
                      ),
                      Align(
                          alignment: const Alignment(0.85, 0),
                          child: returnCheckingIcon(checkEmailField)),
                    ],
                  ),
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Align(
                        child: Container(
                          padding: const EdgeInsets.only(top: 15),
                          alignment: Alignment.center,
                          width: 250,
                          child: buildTextField(
                            "Confirm Email",
                            const Icon(
                              Icons.alternate_email_rounded,
                              color: Color.fromARGB(255, 255, 35, 35),
                              size: 25,
                            ),
                            const Color.fromARGB(255, 235, 235, 235),
                            TextInputType.emailAddress,
                            emailconfController,
                          ),
                        ),
                      ),
                      Align(
                          alignment: const Alignment(0.85, 0),
                          child: returnCheckingIcon(checkEmail2Field)),
                    ],
                  ),
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Align(
                        child: Container(
                          padding: const EdgeInsets.only(top: 15),
                          alignment: Alignment.center,
                          width: 250,
                          child: buildTextField(
                            "Password",
                            const Icon(
                              Icons.password_rounded,
                              color: Color.fromARGB(255, 255, 35, 35),
                              size: 25,
                            ),
                            const Color.fromARGB(255, 235, 235, 235),
                            TextInputType.visiblePassword,
                            passController,
                          ),
                        ),
                      ),
                      Align(
                          alignment: const Alignment(0.85, 0),
                          child: returnCheckingIcon(checkPasswordField)),
                    ],
                  ),
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Align(
                        child: Container(
                          padding: const EdgeInsets.only(top: 15),
                          alignment: Alignment.center,
                          width: 250,
                          child: buildTextField(
                            "Confirm Password",
                            const Icon(
                              Icons.password_rounded,
                              color: Color.fromARGB(255, 255, 35, 35),
                              size: 25,
                            ),
                            const Color.fromARGB(255, 235, 235, 235),
                            TextInputType.visiblePassword,
                            passconfController,
                          ),
                        ),
                      ),
                      Align(
                          alignment: const Alignment(0.85, 0),
                          child: returnCheckingIcon(checkPassword2Field)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 20),
                    child: buildSimpleButton(
                      "Register",
                      () async {
                        if (checkEmailField[1] == 1 &&
                            checkEmail2Field[1] == 1 &&
                            checkPasswordField[1] == 1 &&
                            checkPassword2Field[1] == 1) {
                          // Check here in the database if the email is not already used
                          // If it's not, continue
                          /* Infos: from APP ==> to DB*/
                          // First Connexion of the new user//
                          String result = await service.registerWithEmail({
                            'email': emailController.text,
                            'password': passController.text,
                          });
                          if (result == 'NEED_EMAIL_VERIFY') {
                            result = await service.emailVerify();
                            if (result == 'SENT_VERIFY') {
                              // ignore: use_build_context_synchronously
                              // Navigator.pushNamed(
                              //     context, '/InformationsAfterRegister');

                              // showMessage(context,
                              //     "Sent email to verify. Please check your inbox.",
                              //     title: 'Info');

                              // ignore: use_build_context_synchronously
                              showConfirmDialog(context, 'Info',
                                  'Sent email to verify. Please check your inbox.',
                                  () {
                                Navigator.pushNamed(context, '/Login');
                              });
                            } else {
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                  launchSnackbar(
                                      "VERIFY ERROR",
                                      Icons.info,
                                      Colors.white,
                                      const Color.fromARGB(255, 255, 35, 35),
                                      Colors.white));
                            }
                          } else if (result == 'WEAK') {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                                launchSnackbar(
                                    "Password strength is too weak. it must be at least 8 in length and contain at least one number.",
                                    Icons.info,
                                    Colors.white,
                                    const Color.fromARGB(255, 255, 35, 35),
                                    Colors.white));
                          } else if (result == 'DUPLICATED') {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                                launchSnackbar(
                                    "This email address has already been used.",
                                    Icons.info,
                                    Colors.white,
                                    const Color.fromARGB(255, 255, 35, 35),
                                    Colors.white));
                          } else {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                                launchSnackbar(
                                    result,
                                    Icons.info,
                                    Colors.white,
                                    const Color.fromARGB(255, 255, 35, 35),
                                    Colors.white));
                          }
                        } else {
                          if (checkEmailField[1] != 1) {
                            setState(() {
                              checkEmailField[0] = 1;
                            });
                          }
                          if (checkEmail2Field[1] != 1) {
                            setState(() {
                              checkEmail2Field[0] = 1;
                            });
                          }
                          if (checkPasswordField[1] != 1) {
                            setState(() {
                              checkPasswordField[0] = 1;
                            });
                          }
                          if (checkPassword2Field[1] != 1) {
                            setState(() {
                              checkPassword2Field[0] = 1;
                            });
                          }
                          ScaffoldMessenger.of(context).showSnackBar(launchSnackbar(
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
