import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socially/constants/constant_colors.dart';
import 'package:socially/constants/constant_fonts.dart';
import 'package:socially/constants/constants.dart';
import 'package:socially/screens/auth/auth_widgets/email_auth_widget.dart';
import 'package:socially/screens/home/home_screen.dart';
import 'package:socially/services/providers/auth_provider/auth_provider.dart';
import 'package:socially/widgets/shared_widgets.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColors.whiteColor,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.6, 0.9],
                colors: [
                  ConstantColors.darkColor,
                  ConstantColors.blueGreyColor,
                ],
              ),
            ),
          ),
          //Page image
          Container(
            height: 600,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('${Constants.loginImageUrl}'),
              ),
            ),
          ),
          _buildPageTaglineText(),
          Positioned(
            // top: 530,
            // bottom: 120,
            // left: 20,
            child: Padding(
              padding: const EdgeInsets.only(top: 630.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // 1
                  _buildAuthButton(
                    EvaIcons.emailOutline,
                    ConstantColors.yellowColor,
                    onBtnPressed: () => defaultModalBottomSheet(
                      context,
                      child: EmailAuthWidget(),
                    ),
                  ),
                  // const SizedBox(width: 40),
                  // 2
                  _buildAuthButton(
                    EvaIcons.googleOutline,
                    ConstantColors.redColor,
                    onBtnPressed: () =>
                        Constants.getAuthProvider(context)
                            .logUserIn(
                              googleLogin: true,
                            )
                            .then(
                              (_) => navigateAndReplace(context,
                                  page: HomeScreen()),
                            ),
                  ),
                  // const SizedBox(width: 40),
                  // 3
                  _buildAuthButton(
                    EvaIcons.facebookOutline,
                    ConstantColors.blueColor,
                    onBtnPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            // top: 620,
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              child: Column(
                children: [
                  Text(
                    'By Continuing you agree socially\'s terms of',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    'Services and Privacy Policy',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector _buildAuthButton(IconData icon, Color color,
      {VoidCallback onBtnPressed}) {
    return GestureDetector(
      onTap: onBtnPressed,
      child: Container(
        width: 80,
        height: 46,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: color,
          ),
        ),
        child: Center(
          child: Icon(
            icon,
            color: color,
          ),
        ),
      ),
    );
  }

  Positioned _buildPageTaglineText() {
    return Positioned(
      top: 480,
      left: 20,
      child: Container(
        constraints: BoxConstraints(maxWidth: 210),
        child: Center(
          child: defaultRichText(
            firstTitle: 'Join Our',
            firstTitleStyle: TextStyle(
                fontSize: 30,
                color: ConstantColors.whiteColor,
                fontWeight: FontWeight.bold,
                fontFamily: ConstantFonts.fontPoppins),
            secondTitle: ' Community',
            secondTitleStyle: TextStyle(
                color: ConstantColors.blueColor,
                fontSize: 35,
                fontWeight: FontWeight.bold,
                fontFamily: ConstantFonts.fontPoppins),
          ),
        ),
      ),
    );
  }
}
