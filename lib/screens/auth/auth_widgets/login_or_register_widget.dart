import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:socially/constants/constant_colors.dart';
import 'package:socially/constants/constants.dart';
import 'package:socially/screens/home/home_screen.dart';
import 'package:socially/services/providers/auth_provider/auth_provider.dart';
import 'package:socially/widgets/shared_widgets.dart';

import '../../../constants/constant_fonts.dart';

class LoginOrRegisterWidget extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  LoginOrRegisterWidget({this.title});

  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ConstantColors.transperant,
        elevation: 0.0,
        title: Text(
          '$title',
          style: TextStyle(
            color: ConstantColors.greyColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              children: [
                (title == 'Register')
                    ? CircleAvatar(
                        backgroundColor: ConstantColors.greyColor,
                        backgroundImage: (Provider.of<AuthProvider>(context,
                                        listen: true)
                                    .avatarImageFile !=
                                null)
                            ? FileImage(
                                Constants.getAuthProvider(context, listen: true)
                                    .avatarImageFile)
                            : NetworkImage(Constants.dummyImageUrl),
                        radius: 100,
                        child: IconButton(
                          onPressed: () =>
                              Constants.getAuthProvider(context).pickAvatar(),
                          icon: Icon(
                            FontAwesomeIcons.camera,
                            size: 35,
                            color: ConstantColors.whiteColor.withOpacity(0.3),
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 200,
                        child: Center(
                          child: defaultRichText(
                            firstTitle: 'Social',
                            firstTitleStyle: TextStyle(
                                fontSize: 75,
                                color: ConstantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontFamily: ConstantFonts.fontPoppins),
                            secondTitle: 'ly',
                            secondTitleStyle: TextStyle(
                                fontSize: 65,
                                color: ConstantColors.blueColor,
                                fontWeight: FontWeight.bold,
                                fontFamily: ConstantFonts.fontPoppins),
                          ),
                        ),
                      ),
                const SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      if (title == 'Register')
                        _buildRegisterField(
                          icon: EvaIcons.personOutline,
                          hint: 'Jhon Doe',
                          label: 'Username',
                          // errorMsg: 'This field shouldn\'t be empty!',
                          validate: (String name) {
                            if (name.isEmpty) return 'Name mustn\'t be empty!';
                          },
                          controller: _nameController,
                        ),
                      const SizedBox(height: 30),
                      _buildRegisterField(
                        icon: EvaIcons.emailOutline,
                        hint: 'jhonDoe@example.com',
                        label: 'Email',
                        validate: (String email) {
                          if (email.isEmpty) return 'Email mustn\'t be empty!';
                        },
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 30),
                      _buildRegisterField(
                        icon: EvaIcons.lockOutline,
                        hint: '***************',
                        label: 'Password',
                        validate: (String password) {
                          if (password.isEmpty)
                            return 'Password mustn\'t be empty!';
                          else if (title == 'Register') {
                            if (password.length < 8)
                              return 'Password must be at least 8 characters';
                          }
                        },
                        controller: _passController,
                        isPassword: true,
                        hidePassword:
                            Constants.getAuthProvider(context, listen: true)
                                .hidePassword,
                        keyboardType: TextInputType.numberWithOptions(),
                        changePasswordVisibilty: () =>
                            Constants.getAuthProvider(context)
                                .makePasswordVisible(),
                      ),
                      const SizedBox(height: 30),
                      defaultButton(
                        title: '${title.toUpperCase()}',
                        btnColor: ConstantColors.blueColor,
                        btnFunction: () {
                          if (_formKey.currentState.validate()) {
                            if (title == 'Login')
                              Constants.getAuthProvider(context)
                                  .logUserIn(
                                      email: _emailController.text,
                                      password: _passController.text,
                                      googleLogin: false)
                                  .whenComplete(
                                () {
                                  Constants.getMainProvider(context)
                                      .getUserData()
                                      .whenComplete(
                                        () => navigateAndReplace(
                                          context,
                                          page: HomeScreen(),
                                        ),
                                      );
                                },
                              );
                            else
                              Constants.getAuthProvider(context)
                                  .createAccount(
                                _nameController.text,
                                _emailController.text,
                                _passController.text,
                              )
                                  .then(
                                (_) {
                                  Constants.getMainProvider(context)
                                      .getUserData();
                                  navigateAndReplace(
                                    context,
                                    page: HomeScreen(),
                                  );
                                },
                              );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _buildRegisterField({
    @required String hint,
    @required String label,
    @required IconData icon,
    @required TextEditingController controller,
    @required Function validate,
    Function changePasswordVisibilty,
    bool isPassword,
    bool hidePassword,
    TextInputType keyboardType,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 40,
          color: ConstantColors.whiteColor,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: defaultFormField(
            hint: hint,
            label: label,
            controller: controller,
            isPassword: isPassword ?? false,
            hidePassword: hidePassword ?? false,
            keyboardType: keyboardType,
            validate: validate,
            changePasswordVisibilty: changePasswordVisibilty,
          ),
        ),
      ],
    );
  }
}
