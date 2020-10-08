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

  Future _authenticateFacebook() async {
    var msg = 'successfully authenticated';
    try {
      await fb.logIn(permissions: [
        FacebookPermission.publicProfile,
        FacebookPermission.email
      ]).then((res) async {
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

            await authService
                .signInWithCredential(credential)
                .then((result) async {
              final User user = result.user;

              assert(!user.isAnonymous);
              assert(await user.getIdToken() != null);

              _token = (await user.getIdToken());
              authService.currentUser.listen((currentUser) {
                if (currentUser != null) {
                  _userId = currentUser.uid;
                  print(
                      '${result.user.displayName} is now logged in. user id: $_userId');
                }
              });
            });

            break;
          case FacebookLoginStatus.Cancel:
            msg = 'login canceled';
            print('login canceled');
            break;
          case FacebookLoginStatus.Error:
            msg = 'there was an error';
            print('there was an error');
            break;
        }
      });
      //_token = responseData['idToken'];
      //_userId =

      //_autoLogout();
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (error) {
      return error.toString();
    }
    return msg;
  }

  Future _authenticateGoogle() async {
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
        await authService.signInWithCredential(credential).then((result) async {
          //_token = googleSignInAuthentication.idToken;

          final User user = result.user;

          assert(!user.isAnonymous);
          assert(await user.getIdToken() != null);

          _token = (await user.getIdToken());
          authService.currentUser.listen((currentUser) {
            if (currentUser != null) {
              _userId = currentUser.uid;
              print(
                  '${result.user.displayName} is now logged in. user id: $_userId');
            }
          });

          //final User currentUser = authService.currentUser as User;

          //await DatabaseServices(uid: currentUser.uid).updateUserBio(bio);
          //assert(user.uid == currentUser.uid);

          // email = currentUser.email;
          // name = currentUser.displayName;
          // photo = currentUser.photoUrl;

          //final user = FirebaseAuth.instance.currentUser;
          //final loggedInIdToken = await user.getIdToken();
          //user.uid;
          // _userId = user.uid;
          //loggedInIdToken;

          //final idToken = await user.getIdToken();
          //final token = idToken.token;

          // _userId = result.user.uid;
        });
      }

      //_token = responseData['idToken'];
      //_userId =

      //_autoLogout();
      notifyListeners();
    } catch (error) {
      return error;
    }
  }

  Future<void> loginFb() async {
    await _authenticateFacebook();
  }

  Future<void> loginGoogle() async {
    await _authenticateGoogle();
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    notifyListeners();
    authService.logout();
  }
}
