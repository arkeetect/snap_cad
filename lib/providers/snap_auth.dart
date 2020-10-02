import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:snap_cad/providers/auth_service.dart';
import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter/widgets.dart';

class SnapAuth with ChangeNotifier {
  String _token;
  //DateTime _expiryDate;
  String _userId;
  final authService = AuthService();
  final fb = FacebookLogin();
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  Stream<User> get currentUser => authService.currentUser;

  bool get isAuth {
    return token != null;
    //return true;
  }

  String get token {
    if (_token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticateFacebook() async {
    try {
      final res = await fb.logIn(permissions: [
        FacebookPermission.publicProfile,
        FacebookPermission.email
      ]);
      // final responseData = json.decode(response.body);
      // if (responseData['error'] != null) {
      //   throw HttpException(responseData['error']['message']);
      // }

      switch (res.status) {
        case FacebookLoginStatus.Success:
          print('it worked!');
          // get the token
          final FacebookAccessToken fbToken = res.accessToken;

          // Convert to Auth Credential
          final AuthCredential credential =
              FacebookAuthProvider.credential(fbToken.token);
          // User Credential to Sign in with Firebase
          final result = await authService.signInWithCredential(credential);
          _token = fbToken.token;
          _userId = fbToken.userId;
          print(
              '${result.user.displayName} is now logged in. user id: ${fbToken.userId}');

          break;
        case FacebookLoginStatus.Cancel:
          print('login canceled');
          break;
        case FacebookLoginStatus.Error:
          print('there was an error');
          break;
      }
      //_token = responseData['idToken'];
      //_userId =

      //_autoLogout();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> _authenticateGoogle() async {
    try {
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();

      if (googleSignInAccount == null) {
        throw Error();
      }
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      if (credential != null) {
        final result = await authService.signInWithCredential(credential);
        _token = googleSignInAuthentication.idToken;
        _userId = googleSignInAccount.id;
        print('${result.user.displayName} is now logged in. user id: $_userId');
      }

      //_token = responseData['idToken'];
      //_userId =

      //_autoLogout();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> loginFb() async {
    _authenticateFacebook();
  }

  Future<void> loginGoogle() async {
    _authenticateGoogle();
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    notifyListeners();
    authService.logout();
  }
}
