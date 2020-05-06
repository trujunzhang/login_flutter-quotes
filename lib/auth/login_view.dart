import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter_quotes/pages/quotes_dashboard.dart';
import 'package:flutter_quotes/providers/auth_provider.dart';
import 'package:flutter_quotes/utils/color_utils.dart';
import 'package:flutter_quotes/utils/network_utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  LoginView({Key key, this.pageController}) : super(key: key);

  final PageController pageController;

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _obscureTextLogin = true;

  GlobalKey<FormState> _loginFormKey = GlobalKey();

  final FocusNode myFocusNodeEmailLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();

  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();

  var isLoginAuthenticating = false;

  _submitLoginForm(BuildContext context) async {
    if (!_loginFormKey.currentState.validate()) {
      return;
    }

    NetworkCheck networkCheck = NetworkCheck();
    networkCheck.checkInternet((isNetworkPresent) async {
      if (!isNetworkPresent) {
        final snackBar =
            SnackBar(content: Text("Please check your internet connection !!"));

        Scaffold.of(context).showSnackBar(snackBar);
        return;
      } else {
        setState(() {
          isLoginAuthenticating = true;
        });

        try {
          await Provider.of<AuthProvider>(context, listen: false).firebaseLogin(
              loginEmailController.text, loginPasswordController.text);

          setState(() {
            isLoginAuthenticating = false;
          });

          Navigator.pushReplacementNamed(context, QuotesDashboard.routeName);
        } on PlatformException catch (error) {
          print("PlatformException error : ${error.toString()}");

          setState(() {
            isLoginAuthenticating = false;
          });

          final snackBar = SnackBar(content: Text(error.message));
          Scaffold.of(context).showSnackBar(snackBar);
        } catch (error) {
          print("error : ${error.toString()}");

          setState(() {
            isLoginAuthenticating = false;
          });

          final snackBar = SnackBar(
              content: Text("Something went wrong. Please try again!!"));
          Scaffold.of(context).showSnackBar(snackBar);
        }
      }
    });
  }

  Widget bg() {
    return Card(
      elevation: 2.0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        width: 300.0,
        height: 200.0,
        margin: EdgeInsets.only(bottom: 10.0),
        child: Form(
          key: _loginFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    top: 10.0, bottom: 20.0, left: 25.0, right: 25.0),
                child: TextFormField(
                  focusNode: myFocusNodeEmailLogin,
                  controller: loginEmailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                      color: Colors.black),
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.email,
                      color: Colors.black,
                      size: 22.0,
                    ),
                    hintText: "Email Address",
                    hintStyle:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 17.0),
                  ),
                  validator: (String email) {
                    if (email.isEmpty ||
                        !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                            .hasMatch(email)) {
                      return "valid email is required.";
                    }
                    return "";
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 0.0, bottom: 20.0, left: 25.0, right: 25.0),
                child: TextFormField(
                  focusNode: myFocusNodePasswordLogin,
                  controller: loginPasswordController,
                  obscureText: _obscureTextLogin,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                      color: Colors.black),
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.lock,
                      size: 22.0,
                      color: Colors.black,
                    ),
                    hintText: "Password",
                    hintStyle:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 17.0),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        _obscureTextLogin = !_obscureTextLogin;
                      },
                      child: Icon(
                        _obscureTextLogin
                            ? FontAwesomeIcons.eye
                            : FontAwesomeIcons.eyeSlash,
                        size: 20.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  validator: (String password) {
                    if (password.isEmpty && password.length < 4) {
                      return "valid password is required.";
                    }
                    return '';
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 100.0,
                child: Center(
                  child: Text(
                    "SIGN IN",
                    style: TextStyle(
                        fontSize: 30.0,
                        letterSpacing: 1.5,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  bg(),
                  Container(
                    margin: EdgeInsets.only(top: 190.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: authBGGradientStartColor,
                          offset: Offset(1.0, 6.0),
                          blurRadius: 20.0,
                        ),
                        BoxShadow(
                          color: authBGGradientEndColor,
                          offset: Offset(1.0, 6.0),
                          blurRadius: 20.0,
                        ),
                      ],
                      gradient: LinearGradient(
                          colors: [
                            authBGGradientStartColor,
                            authBGGradientEndColor
                          ],
                          begin: const FractionalOffset(0.2, 0.2),
                          end: const FractionalOffset(1.0, 1.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    child: MaterialButton(
                      highlightColor: authButtonHighlightColor,
                      splashColor: authButtonsplashColor,
                      child: isLoginAuthenticating
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 60.0),
                              child: CircularProgressIndicator())
                          : Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 42.0),
                              child: Text(
                                "SIGN IN",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                      onPressed: () {
                        if (!isLoginAuthenticating) {
                          _submitLoginForm(context);
                        }
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: FlatButton(
                  onPressed: () {
                    widget.pageController.animateToPage(1,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease);
                  },
                  child: Text(
                    "Wanna SignUp?",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500),
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
