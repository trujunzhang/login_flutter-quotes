import 'package:flutter/material.dart';
import 'package:flutter_quotes/utils/color_utils.dart';

import 'login_view.dart';
import 'sign_up_view.dart';

class AuthPage extends StatefulWidget {
  static const routeName = "/auth-page";

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _buildAuthPage()),
    );
  }

  Widget _buildAuthPage() {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [authBGGradientStartColor, authBGGradientEndColor],
              stops: [0.6, 1.0],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
        ),
        PageView.builder(
          itemCount: 2,
          controller: _pageController,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return LoginView(
                pageController: _pageController,
              );
            } else {
              return SignUpView(
                pageController: _pageController,
              );
            }
          },
        ),
      ],
    );
  }
}
