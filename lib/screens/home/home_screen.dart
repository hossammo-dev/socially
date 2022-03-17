import 'package:flutter/material.dart';

import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:socially/constants/constant_colors.dart';
import 'package:socially/constants/constants.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomNavigationBar(
        // backgroundColor: Color(0xff040307),
        backgroundColor: ConstantColors.darkColor.withBlue(60),
        elevation: 30.5,
        currentIndex:
            Constants.getMainProvider(context, listen: true).currentIndex,
        bubbleCurve: Curves.bounceInOut,
        scaleCurve: Curves.ease,
        scaleFactor: 0.5,
        selectedColor: ConstantColors.blueColor,
        unSelectedColor: ConstantColors.whiteColor,
        strokeColor: ConstantColors.blueColor,
        iconSize: 30,
        items: [
          CustomNavigationBarItem(icon: Icon(EvaIcons.homeOutline)),
          CustomNavigationBarItem(icon: Icon(EvaIcons.messageCircleOutline)),
          CustomNavigationBarItem(icon: Icon(EvaIcons.personOutline)),
        ],
        onTap: (index) => Constants.getMainProvider(context).changeIndex(index),
      ),
      body: Constants.getMainProvider(context)
          .pagesList[Constants.getMainProvider(context).currentIndex],
    );
  }
}
