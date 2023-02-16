import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:twitter_login/twitter_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:s4s_mobileapp/account/page_account.dart';
// import 'dart:convert';
// import 'dart:developer';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<String> signInWithGoogle() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      UserCredential userCredit = await _auth.signInWithCredential(credential);
      if (userCredit.user?.displayName != null) {
        if (userCredit.additionalUserInfo?.profile?['email'] != null &&
            userCredit.additionalUserInfo?.profile != null &&
            userCredit.additionalUserInfo != null) {
          await prefs.setString(
              'email', userCredit.additionalUserInfo?.profile?['email'] ?? '');
          await prefs.setString(
              'username', userCredit.additionalUserInfo?.username ?? '');
          await prefs.setString('firstname',
              userCredit.additionalUserInfo?.profile?['given_name'] ?? '');
          await prefs.setString('lastname',
              userCredit.additionalUserInfo?.profile?['family_name'] ?? '');
          await prefs.setString('photo',
              userCredit.additionalUserInfo?.profile?['picture'] ?? '');
          await prefs.setString('phone', userCredit.user?.phoneNumber ?? '');
          await prefs.setBool('loggedin', true);
          return 'SUCCESS';
        }
        return 'UNKOWN_ACCOUNT';
      } else {
        return 'FAILED';
      }
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<String> signInWithFacebook() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      switch (result.status) {
        case LoginStatus.success:
          final AuthCredential facebookCredential =
              FacebookAuthProvider.credential(result.accessToken!.token);
          UserCredential userCredit =
              await _auth.signInWithCredential(facebookCredential);
          // userCredit.additionalUserInfo!.profile!['email'];
          // if (userCredit.additionalUserInfo?.profile?['email'] != null &&
          //     userCredit.additionalUserInfo?.profile != null &&
          //     userCredit.additionalUserInfo != null) {
          await prefs.setString(
              'email', userCredit.additionalUserInfo?.profile?['email'] ?? '');
          await prefs.setString(
              'username', userCredit.additionalUserInfo?.username ?? '');
          await prefs.setString('firstname',
              userCredit.additionalUserInfo?.profile?['first_name'] ?? '');
          await prefs.setString('lastname',
              userCredit.additionalUserInfo?.profile?['last_name'] ?? '');
          await prefs.setString('photo', userCredit.user?.photoURL ?? '');
          await prefs.setString('phone', userCredit.user?.phoneNumber ?? '');
          await prefs.setBool('loggedin', true);
          // }
          return 'SUCCESS';
        case LoginStatus.cancelled:
          return 'CANCELLED';
        case LoginStatus.failed:
          return 'FAILED';
        default:
          return 'null';
      }
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<String> signInWithTwitter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final twitterLogin = TwitterLogin(
        apiKey: "SoRReYOfja7SzqnU3lCR0qM40",
        apiSecretKey: "nkis7WSaYH9GeBdfCyuCQAJM9U57C5QU9uunR4Ug4K0OAI89U1",
        redirectURI: "s4smobile://",
      );
      var authResult = await twitterLogin.loginV2();
      switch (authResult.status) {
        case TwitterLoginStatus.loggedIn:
          final AuthCredential twitterAuthCredential =
              TwitterAuthProvider.credential(
                  accessToken: authResult.authToken!,
                  secret: authResult.authTokenSecret!);
          UserCredential userCredit =
              await _auth.signInWithCredential(twitterAuthCredential);
          await prefs.setString('email', userCredit.user?.email ?? '');
          await prefs.setString(
              'username', userCredit.additionalUserInfo?.username ?? '');
          await prefs.setString('firstname', '');
          await prefs.setString('lastname', '');
          await prefs.setString('photo', userCredit.user?.photoURL ?? '');
          await prefs.setString('phone', userCredit.user?.phoneNumber ?? '');
          await prefs.setBool('loggedin', true);
          return 'SUCCESS';
        case TwitterLoginStatus.cancelledByUser:
          return 'CANCELLED_BY_USER';
        case TwitterLoginStatus.error:
          return 'ERROR';
        default:
          return 'null';
      }
    } on FirebaseAuthException {
      rethrow;
    }
  }

  // "UserCredential(
  //     additionalUserInfo: AdditionalUserInfo(
  //        isNewUser: true,
  //        profile: {
  //           entities: {
  //               description: {
  //                  urls: []
  //               }
  //           },
  //           verified: false,
  //           listed_count: 0,
  //           statuses_count: 0,
  //           profile_text_color: 333333,
  //           description: ,
  //           friends_count: 3,
  //           suspended: false,
  //           profile_sidebar_border_color: C0DEED,
  //           id_str: 1576141150465003522,
  //           profile_background_image_url: null,
  //           geo_enabled: false,
  //           profile_image_url_https: https://abs.twimg.com/sticky/default_profile_images/default_profile_normal.png,
  //           protected: false,
  //           translator_type: none,
  //           followers_count: 0,
  //           default_profile: true,
  //           profile_image_url: http://abs.twimg.com/sticky/default_profile_images/default_profile_normal.png,
  //           profile_use_background_image: true,
  //           screen_name: giantbrain0216,
  //           id: 1576141150465003522,
  //           url: null,
  //           lang: null,
  //           name: giantbrain,
  //           time_zone: null,
  //           favourites_count: 0,
  //           has_extended_profile: true,
  //           profile_sidebar_fill_color: DDEEF6,
  //           default_profile_image: true,
  //           is_translator: false,
  //           follow_request_sent: false,
  //           profile_background_image_url_https: null,
  //           contributors_enabled: false,
  //           following: false,
  //           profile_background_tile: false,
  //           notifications: false,
  //           created_at: Sat Oct 01 09:25:24 +0000 2022,
  //           profile_link_color: 1DA1F2,
  //           profile_background_color: F5F8FA,
  //           needs_phone_verification: false,
  //           is_translation_enabled: false,
  //           utc_offset: null,
  //           withheld_in_countries: [],
  //           location:
  //        },
  //        providerId: twitter.com,
  //        username: giantbrain0216
  //    ),
  //    credential: AuthCredential(
  //        providerId: twitter.com,
  //        signInMethod: twitter.com,
  //        token: 84296957,
  //        accessToken: 1576141150465003522-e3gsW0FjJaGB22FUZNdzg11lczNPJk
  //    ),
  //    user: User(
  //        displayName: giantbrain,
  //        email: null,
  //        emailVerified: false,
  //        isAnonymous: false,
  //        metadata: UserMetadata(
  //            creationTime: 2022-10-14 06:05:37.128Z,
  //            lastSignInTime: 2022-10-14 06:05:37.129Z
  //        ),
  //        phoneNumber: null,
  //        photoURL: https://abs.twimg.com/sticky/default_profile_images/default_profile_normal.png,
  //        providerData,
  //        [
  //           UserInfo(
  //              displayName: giantbrain,
  //              email: null,
  //              phoneNumber: null,
  //              photoURL: https://abs.twimg.com/sticky/default_profile_images/default_profile_normal.png,
  //              providerId: twitter.com,
  //              uid: 1576141150465003522
  //           )
  //        ],
  //        refreshToken: ,
  //        tenantId: null,
  //        uid: ioHN964fKGVPKLFgcHOI9EyhwhY2
  //    )
  // )"

  Future<String> registerWithEmail(params) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: params['email'], password: params['password']);
      return 'NEED_EMAIL_VERIFY';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'WEAK';
      } else if (e.code == 'email-already-in-use') {
        return 'DUPLICATED';
      }
      return 'FAILED';
    } catch (e) {
      rethrow;
    }
  }

  emailVerify() async {
    User? user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      return 'SENT_VERIFY';
    } else {
      return null;
    }
  }

  Future<void> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', '');
    await prefs.setString('username', '');
    await prefs.setString('firstname', '');
    await prefs.setString('lastname', '');
    await prefs.setString('photo', '');
    await prefs.setString('phone', '');
    await prefs.setBool('loggedin', false);
    await _auth.signOut();
  }

  // Future<void> signOutFromFacebook() async {
  //   await _facebookLogin.logOut();
  //   await _auth.signOut();
  // }

  // User getCurrentUser() {
  //   User _user = FirebaseAuth.instance.currentUser!;
  //   return _user;
  // }

  Future<String> signInWithEmail(
      {required String email, required String password}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await _auth.currentUser?.reload();
      if (_auth.currentUser?.emailVerified == true) {
        await prefs.setString('email', email);
        await prefs.setBool('loggedin', true);
        return 'VERIFIED';
      } else {
        return 'NOT_VERIFIED';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'USER_NOT_FOUND';
      } else if (e.code == 'wrong-password') {
        return 'WRONG_PASSWORD';
      } else if (e.code == 'invalid-email') {
        return 'INVALID_EMAIL';
      } else if (e.code == 'user-disabled') {
        return 'USER_DISABLED';
      } else {
        return 'FAILED';
      }
    }
    // return null;
  }

  Future<String> resetPassword({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email);
    return 'EMAIL_SENT';
  }

  // Future<String> checkVerify() async {
  //   await _auth.currentUser?.reload();
  //   if (_auth.currentUser?.emailVerified == true) {
  //     return 'VERIFIED';
  //   } else {
  //     return 'NOT_VERIFIED';
  //   }
  // }
  //
  // checkUser() async {
  //   try {
  //     await _auth.currentUser?.reload();
  //     return _auth.currentUser;
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'user-not-found') {
  //       return 'USER_NOT_FOUND';
  //     } else if (e.code == 'wrong-password') {
  //       return 'WRONG_PASSWORD';
  //     } else if (e.code == 'invalid-email') {
  //       return 'INVALID_EMAIL';
  //     } else if (e.code == 'user-disabled') {
  //       return 'USER_DISABLED';
  //     }
  //   }
  // }
}
