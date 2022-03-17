import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:socially/constants/constant_colors.dart';
import 'package:socially/constants/constant_fonts.dart';
import 'package:socially/screens/home/home_screen.dart';
import 'package:socially/screens/splash_screen/splash_screen.dart';
import 'package:socially/services/providers/auth_provider/auth_provider.dart';
import 'package:socially/services/providers/socially_provider/main_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MainProvider()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: ConstantFonts.fontPoppins,
          canvasColor: ConstantColors.transperant,
          scaffoldBackgroundColor: ConstantColors.darkColor,
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(secondary: ConstantColors.blueColor),
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        // home: HomeScreen(),
      ),
    );
  }
}
