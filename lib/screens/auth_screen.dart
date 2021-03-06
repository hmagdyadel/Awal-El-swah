import 'dart:math';
import 'package:flutter/services.dart';

import '../providers/auth.dart';
import '../models/http_exception.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth-screen';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        SystemNavigator.pop();
        return new Future(() => true);
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                      Color.fromRGBO(215, 188, 117, 1).withOpacity(0.9),
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
                    children: [
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 20),
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 66),
                          transform: Matrix4.rotationZ(-12 * pi / 180)
                            ..translate(-10.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.deepOrange.shade800,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 8,
                                  color: Colors.black26,
                                  offset: Offset(0, 2),
                                )
                              ]),
                          child: Text(
                            '?????? ????????????',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'RobotoCondensed'),
                          ),
                        ),
                      ),
                      Flexible(
                        child: AuthCard(),
                        flex: deviceSize.width > 600 ? 2 : 2,
                      ),
                      // SizedBox(
                      //   height: 30,
                      // ),
                      // Flexible(
                      //   child: SafeArea(
                      //     child: Padding(
                      //       padding: const EdgeInsets.only(
                      //         left: 16,
                      //         right: 16,
                      //         bottom: 20,
                      //       ),
                      //       child: FutureBuilder(
                      //         future: Authentication.initializeFirebase(
                      //             context: context),
                      //         builder: (context, snapshot) {
                      //           if (snapshot.hasError) {
                      //             return Text('Error initializing Firebase');
                      //           } else if (snapshot.connectionState ==
                      //               ConnectionState.done) {
                      //             return GoogleSignInButton();
                      //           }
                      //           return CircularProgressIndicator(
                      //             valueColor: AlwaysStoppedAnimation<Color>(
                      //                 Colors.orange),
                      //           );
                      //         },
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

enum AuthMode { Login, Signup }

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _slideAnimation =
        Tween<Offset>(begin: Offset(0, -0.15), end: Offset(0, 0)).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
      ),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false).login(
          _authData['email'].toString(),
          _authData['password'].toString(),
        );
      } else {
        await Provider.of<Auth>(context, listen: false).signUp(
          _authData['email'].toString(),
          _authData['password'].toString(),
        );
      }
    } on HttpException catch (error) {
      var errorMessage = '?????? ??????????????';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = '?????? ?????????????? ?????????? ????????????';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = '?????????? ?????? ????????';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = '?????????? ?????????? ???????? ????????????';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = '???? ???????? ?????????? ?????? ??????????????';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = '?????????? ?????????? ?????? ????????';
      }
      _showErrorDialog(errorMessage);
    } catch (e) {
      const errorMessage = '?????? ???????? ?????? ???????????????? ???? ???????? ???????? ?????? ????????.';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller.reverse();
    }
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An error occurred'),
        content: Text(errorMessage),
        actions: [
          OutlinedButton(
              onPressed: () => Navigator.of(context).pop(), child: Text('????'))
        ],
      ),
    );
  }

  bool _obscureText = false;
  bool _obscureTextConfirm = false;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 8,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
        height: _authMode == AuthMode.Signup ? 320 : 260,
        constraints: BoxConstraints(
          minHeight: _authMode == AuthMode.Signup ? 320 : 310,
        ),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  textDirection: TextDirection.ltr,
                  decoration: InputDecoration(labelText: '??????????????'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val!.isEmpty || !val.contains('@')) {
                      return '?????????? ?????? ????????';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    _authData['email'] = val!;
                  },
                ),
                TextFormField(
                  textDirection: TextDirection.ltr,
                  decoration: InputDecoration(
                    labelText: '?????????? ??????????',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Colors.purple,
                      ),
                    ),
                  ),
                  obscureText: !_obscureText,
                  controller: _passwordController,
                  validator: (val) {
                    if (val!.isEmpty || val.length < 6) {
                      return '?????????? ?????????? ?????? ???? 6 ??????????';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    _authData['password'] = val!;
                  },
                ),
                AnimatedContainer(
                  constraints: BoxConstraints(
                    minHeight: _authMode == AuthMode.Signup ? 60 : 0,
                    minWidth: _authMode == AuthMode.Signup ? 120 : 0,
                  ),
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: TextFormField(
                        textDirection: TextDirection.ltr,
                        decoration: InputDecoration(
                          labelText: '?????????? ?????????? ??????????',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureTextConfirm = !_obscureTextConfirm;
                              });
                            },
                            icon: Icon(
                              _obscureTextConfirm
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.purple,
                            ),
                          ),
                        ),
                        obscureText: !_obscureTextConfirm,
                        enabled: _authMode == AuthMode.Signup,
                        validator: _authMode == AuthMode.Signup
                            ? (val) {
                                if (val != _passwordController.text) {
                                  return '?????????? ?????????? ?????? ????????????';
                                }
                                return null;
                              }
                            : null,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  ElevatedButton(
                    child: Text(_authMode == AuthMode.Login
                        ? '?????????? ????????????'
                        : '?????????? ????????'),
                    onPressed: () {
                      _submit();
                    },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(horizontal: 30, vertical: 8)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                TextButton(
                  onPressed: _switchAuthMode,
                  child: Text(
                    '${_authMode == AuthMode.Signup ? '?????????? ????????????' : '?????????? ????????'}',
                  ),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(horizontal: 30, vertical: 8)),
                    textStyle: MaterialStateProperty.all<TextStyle>(
                      TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
