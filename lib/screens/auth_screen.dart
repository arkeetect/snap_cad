import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:provider/provider.dart';

import '../providers/snap_auth.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                      transform: Matrix4.rotationZ(-20 * pi / 180)
                        ..translate(-10.0),
                      // ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'SnapCAD',
                        style: TextStyle(
                          color:
                              Theme.of(context).accentTextTheme.headline6.color,
                          fontSize: 40,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  //var _isLoading = false;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 300,
      ),
    );
    // _heightAnimation.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit(Buttons type) async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    //_formKey.currentState.save();
    //setState(() {
    //_isLoading = true;
    //});
    try {
      // Log user in
      switch (type) {
        case Buttons.Facebook:
          await Provider.of<SnapAuth>(context, listen: false).loginFb();
          break;
        case Buttons.GoogleDark:
          await Provider.of<SnapAuth>(context, listen: false).loginGoogle();
          break;
        default:
          break;
      }
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }

    //setState(() {
    // _isLoading = false;
    //});
  }

  // void _switchAuthMode() {
  //   if (_authMode == AuthMode.Login) {
  //     setState(() {
  //       _authMode = AuthMode.Signup;
  //     });
  //     _controller.forward();
  //   } else {
  //     setState(() {
  //       _authMode = AuthMode.Login;
  //     });
  //     _controller.reverse();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: AnimatedContainer(
        //color: Color.fromRGBO(r, g, b, opacity),
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
          //gradient: Gradient.lerp(Gradient(), b, t)
          image: DecorationImage(
              //padding:
              image: AssetImage("assets/images/lamp.jpg"),
              scale: 5.5,
              fit: BoxFit.none,
              alignment: Alignment.topLeft),
        ),
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
        height: _authMode == AuthMode.Signup ? 320 : 110,
        // height: _heightAnimation.value.height,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 100),
        width: deviceSize.width * 0.77,
        padding: EdgeInsets.zero,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // SizedBox(
              //   height: 9,
              // ),
              // if (_isLoading)
              //   CircularProgressIndicator()
              // else
              Container(
                  alignment: Alignment.topRight,
                  margin: EdgeInsets.only(right: 6.0, top: 3.0),
                  padding: EdgeInsets.zero,
                  child: SignInButton(
                    Buttons.Facebook,
                    //mini: true,
                    //padding: const EdgeInsets.only(left: 40),
                    onPressed: () => {_submit(Buttons.Facebook)},
                  )),
              Container(
                  alignment: Alignment.topRight,
                  margin: EdgeInsets.only(right: 6.0),
                  padding: EdgeInsets.zero,
                  child: SignInButton(
                    Buttons.GoogleDark,
                    //mini: true,
                    //padding: const EdgeInsets.only(left: 40),
                    onPressed: () => {_submit(Buttons.GoogleDark)},
                  )),
            ],
          ),
          //),
        ),
      ),
    );
  }
}
