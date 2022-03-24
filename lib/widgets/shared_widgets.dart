import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:socially/constants/constant_colors.dart';
import 'package:socially/constants/constant_fonts.dart';

import '../constants/constants.dart';

MaterialButton defaultButton({
  @required String title,
  @required Color btnColor,
  TextStyle textStyle,
  Function btnFunction,
  double radius,
  double elevation,
  double width,
}) =>
    MaterialButton(
      onPressed: btnFunction ?? () {},
      color: btnColor,
      minWidth: width ?? double.infinity,
      padding: const EdgeInsets.all(10),
      elevation: elevation ?? 5.4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius ?? 10),
      ),
      child: Text(
        title,
        style: textStyle ??
            TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ConstantColors.whiteColor,
            ),
      ),
    );

TextFormField defaultFormField({
  TextEditingController controller,
  @required String hint,
  @required String label,
  @required Function validate,
  Function changePasswordVisibilty,
  IconData prefixIcon,
  TextInputType keyboardType,
  bool isPassword = false,
  bool hidePassword,
}) =>
    TextFormField(
      controller: controller ?? null,
      obscureText: hidePassword ?? false,
      keyboardType: keyboardType ?? TextInputType.name,
      validator: validate,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: ConstantColors.blueColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: ConstantColors.whiteColor,
          ),
        ),
        labelText: label,
        labelStyle: TextStyle(
            color: ConstantColors.whiteColor,
            fontSize: 14,
            fontFamily: ConstantFonts.fontMonteserat),
        hintText: hint,
        hintStyle: TextStyle(
          color: ConstantColors.greyColor,
          fontSize: 14,
        ),
        prefix: Icon(
          prefixIcon,
          color: ConstantColors.whiteColor,
        ),
        suffix: (isPassword)
            ? IconButton(
                onPressed: changePasswordVisibilty,
                icon: Icon(
                  (hidePassword)
                      ? FontAwesomeIcons.eyeSlash
                      : FontAwesomeIcons.eye,
                  color: ConstantColors.whiteColor,
                ),
              )
            : null,
      ),
      style: TextStyle(
        color: ConstantColors.whiteColor,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    );

RichText defaultRichText({
  String firstTitle,
  String secondTitle,
  TextStyle firstTitleStyle,
  TextStyle secondTitleStyle,
}) =>
    RichText(
      text: TextSpan(
        text: firstTitle,
        style: firstTitleStyle,
        children: [
          TextSpan(
            text: secondTitle,
            style: secondTitleStyle,
          ),
        ],
      ),
    );

Future<Container> defaultModalBottomSheet(
  BuildContext context, {
  double height,
  double width,
  Color color,
  EdgeInsetsGeometry margin,
  @required Widget child,
}) =>
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: height ?? Constants.getMobileHeight(context) * 0.5,
        width: width ?? double.infinity,
        margin: margin,
        decoration: BoxDecoration(
          color: color ?? ConstantColors.blueGreyColor,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15),
            topLeft: Radius.circular(15),
          ),
        ),
        child: child,
      ),
    );

AppBar defaultAppBar({
  Widget leading,
  @required Widget title,
  List<Widget> trailings,
}) =>
    AppBar(
      backgroundColor: ConstantColors.blueGreyColor.withOpacity(0.4),
      centerTitle: true,
      leading: leading ?? null,
      title: title,
      actions: trailings ?? null,
    );

Divider defaultDivider() => Divider(
      color: ConstantColors.whiteColor,
      indent: 70,
      endIndent: 70,
      thickness: 3,
    );

//navigate to another page, but keep previous ones.
void navigateTo(
  BuildContext context, {
  @required Widget page,
  PageTransitionType type = PageTransitionType.leftToRight,
}) =>
    Navigator.of(context).push(
      PageTransition(child: page, type: type),
    );

//navigate to another page and get rid of previous ones.
void navigateAndReplace(
  BuildContext context, {
  @required Widget page,
  PageTransitionType type = PageTransitionType.bottomToTop,
}) =>
    Navigator.of(context).pushReplacement(
      PageTransition(child: page, type: type),
    );

void navigateAndRemove(
  BuildContext context, {
  @required Widget page,
  PageTransitionType type = PageTransitionType.bottomToTop,
}) =>
    Navigator.of(context).pushAndRemoveUntil(
        PageTransition(child: page, type: type), (route) => false);
