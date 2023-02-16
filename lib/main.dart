import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:s4s_mobileapp/account/page_account.dart';
import 'package:s4s_mobileapp/calendar/page_calendar.dart';
import 'package:s4s_mobileapp/calendar/page_size_guide.dart';
import 'package:s4s_mobileapp/login/page_informations_after_register.dart';
import 'package:s4s_mobileapp/login/page_login.dart';
import 'package:s4s_mobileapp/login/page_login_signup_with_email.dart';
import 'package:s4s_mobileapp/home/page_home.dart';
import 'package:s4s_mobileapp/restock/page_restock.dart';
import 'package:s4s_mobileapp/search/page_search.dart';
import 'package:s4s_mobileapp/tools/functions.dart';
import 'package:s4s_mobileapp/trend/page_trend.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:s4s_mobileapp/tools/firebase_service.dart';
import 'package:s4s_mobileapp/firebase_options.dart';
import 'package:s4s_mobileapp/product/product_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:s4s_mobileapp/account/save_profile.dart';

List<Map> heats = [];
List<Map> recently = [];
List<String> news = [];
List<Map> tops = [];
List upcoming = [];
List past = [];
List<Map> restocks = [];

List<Widget> pages = [
  const TrendPage(),
  const CalendarPage(),
  const SearchPage(),
  const RestockPage(),
  const AccountPage(),
  const ProductDetailPage(),
];

late final SharedPreferences prefs;

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  prefs = await SharedPreferences.getInstance();
  heats = await getListHeats();
  recently = await getListRecently();
  news = await getListNews();
  tops = await getListTops();
  upcoming = await getUpcomings();
  past = await getPasts();
  restocks = await getRestock();
  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sneaks4Sure',
      debugShowCheckedModeBanner: false,
      initialRoute: prefs.getBool('loggedin') != true
          ? '/Landing'
          : prefs.getBool('savedProfile') == true
              ? '/Home'
              : '/SaveProfile',
      // initialRoute: '/' ,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color.fromARGB(255, 255, 35, 35),
        ),
        fontFamily: 'Roboto',
      ),
      routes: {
        '/Landing': (context) => const LandingPage(),
        '/LoginSignupWithEmail': (context) => const LoginSignupWithEmailPage(),
        '/Login': (context) => const LoginPage(),
        '/Home': (context) => HomePage(pages, null, null),
        '/InformationsAfterRegister': (context) =>
            const InformationsAfterRegister(),
        '/SizeGuide': (context) => const SizeGuidePage(),
        '/Account': (context) => const AccountPage(),
        '/SaveProfile': (context) => const SaveProfile(),
      },
    );
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  FirebaseService service = FirebaseService();

  @override
  void initState() {
    FlutterNativeSplash.remove();
    super.initState();
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
              SizedBox(
                height: 250,
                child: Image.asset(
                  'assets/etc/aj1.png',
                  fit: BoxFit.fitHeight,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                  top: 20,
                  bottom: 30,
                  left: 65,
                  right: 65,
                ),
                child: Image.asset(
                  'assets/etc/splash-cropped.png',
                  fit: BoxFit.fitWidth,
                ),
              ),
              buildImageButton(
                "assets/icons/google.png",
                25,
                "  Sign in with Google",
                15,
                () async {
                  try {
                    String result = await service.signInWithGoogle();
                    if (result == 'SUCCESS') {
                      if (mounted)
                        // ignore: curly_braces_in_flow_control_structures
                        prefs.getBool('savedProfile') == true
                            ? Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        HomePage(pages, 4, 1)),
                                (route) => false)
                            : Navigator.pushNamedAndRemoveUntil(
                                context, '/SaveProfile', (route) => false);
                    } else {
                      // ignore: use_build_context_synchronously
                      showMessage(context, result);
                    }
                  } catch (e) {
                    if (e is FirebaseAuthException) {
                      showMessage(context, e.message!);
                    }
                  }
                },
              ),
              buildImageButton(
                "assets/icons/facebook.png",
                25,
                "  Sign in with Facebook",
                15,
                () async {
                  try {
                    // Giantbrain212!
                    String result = await service.signInWithFacebook();
                    if (result == 'SUCCESS') {
                      prefs.getBool('savedProfile') == true
                          // ignore: use_build_context_synchronously
                          ? Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => HomePage(pages, 4, 1)),
                              (route) => false)
                          // ignore: use_build_context_synchronously
                          : Navigator.pushNamedAndRemoveUntil(
                              context, '/SaveProfile', (route) => false);
                    } else {
                      // ignore: use_build_context_synchronously
                      showMessage(context, result);
                    }
                  } catch (e) {
                    if (e is FirebaseAuthException) {
                      showMessage(context, e.message!);
                    }
                  }
                },
              ),
              buildImageButton(
                "assets/icons/twitter.png",
                25,
                "  Sign in with Twitter",
                15,
                () async {
                  try {
                    String result = await service.signInWithTwitter();
                    if (result == 'SUCCESS') {
                      prefs.getBool('savedProfile') == true
                          // ignore: use_build_context_synchronously
                          ? Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => HomePage(pages, 4, 1)),
                              (route) => false)
                          // ignore: use_build_context_synchronously
                          : Navigator.pushNamedAndRemoveUntil(
                              context, '/SaveProfile', (route) => false);
                    } else {
                      // ignore: use_build_context_synchronously
                      showMessage(context, result);
                    }
                  } catch (e) {
                    if (e is FirebaseAuthException) {
                      showMessage(context, e.message!);
                    }
                  }
                },
              ),
              buildImageButton(
                "assets/icons/mail.png",
                25,
                "  Sign in with your eMail",
                15,
                () {
                  Navigator.pushNamed(context, '/LoginSignupWithEmail');
                },
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.only(bottom: 15),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Do you have any problem ?',
                        style: robotoStyle(
                            FontWeight.w500, Colors.grey[700], null, null),
                      ),
                      GestureDetector(
                        onTap: () {
                          urlLauncher("mailto:contact@sneaks4sure.com");
                        },
                        child: Text(
                          '  Contact Us',
                          style: robotoStyle(
                              FontWeight.w500,
                              const Color.fromARGB(255, 255, 35, 35),
                              null,
                              null),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
