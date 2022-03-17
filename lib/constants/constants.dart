import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:socially/services/providers/auth_provider/auth_provider.dart';
import 'package:socially/services/providers/socially_provider/main_provider.dart';

class Constants {
  static final String loginImageUrl = 'assets/images/login.png';
  static final String emptyImageUrl = 'assets/images/empty.png';
  static final String dummyImageUrl =
      'https://img.freepik.com/free-photo/young-handsome-man-with-beard-isolated-keeping-arms-crossed-frontal-position_1368-132662.jpg?w=1060';

  static String userId = '';

  static double getMobileHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
  static double getMobileWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  //constant providers

  static AuthProvider getAuthProvider(BuildContext context,
          {bool listen = false}) =>
      Provider.of<AuthProvider>(context, listen: listen);

  static MainProvider getMainProvider(BuildContext context,
          {bool listen = false}) =>
      Provider.of<MainProvider>(context, listen: listen);
}
