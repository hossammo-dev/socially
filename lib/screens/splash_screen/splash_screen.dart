import 'dart:async';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:socially/constants/constant_colors.dart';
import 'package:socially/constants/constant_fonts.dart';
import 'package:socially/constants/constants.dart';
import 'package:socially/screens/auth/auth_screen.dart';
import 'package:socially/widgets/shared_widgets.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 5),
      () {
        Constants.getMainProvider(context).getAllUsersData();
        Constants.getMainProvider(context).getPosts();
        navigateAndRemove(
          context,
          page: AuthScreen(),
          type: PageTransitionType.bottomToTop,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColors.darkColor,
      body: Center(
        child: defaultRichText(
          firstTitle: 'Social',
          firstTitleStyle: TextStyle(
              fontSize: 34,
              color: ConstantColors.whiteColor,
              fontWeight: FontWeight.bold,
              fontFamily: ConstantFonts.fontPoppins),
          secondTitle: 'ly',
          secondTitleStyle: TextStyle(
              fontSize: 30,
              color: ConstantColors.blueColor,
              fontWeight: FontWeight.bold,
              fontFamily: ConstantFonts.fontPoppins),
        ),
      ),
    );
  }
}
