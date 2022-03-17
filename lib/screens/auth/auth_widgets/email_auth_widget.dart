import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:socially/constants/constants.dart';
import 'package:socially/screens/home/home_screen.dart';

import '../../../constants/constant_colors.dart';
import '../../../widgets/shared_widgets.dart';
import 'login_or_register_widget.dart';

class EmailAuthWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        defaultDivider(),
        Expanded(
          child: ConditionalBuilder(
            condition: Constants.getMainProvider(context).usersList.isNotEmpty,
            builder: (context) => ListView.builder(
              itemCount: Constants.getMainProvider(context).usersList.length,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final _user =
                    Constants.getMainProvider(context).usersList[index];
                return Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: ConstantColors.darkColor,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: ConstantColors.greyColor,
                      backgroundImage: NetworkImage('${_user.avatarUrl}'),
                    ),
                    title: Text(
                      '${_user.username}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ConstantColors.greenColor),
                    ),
                    subtitle: Text(
                      '${_user.email}',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: ConstantColors.whiteColor),
                    ),
                    trailing: IconButton(
                      onPressed: () => Constants.getAuthProvider(context)
                          .logUserIn(
                              googleLogin: false,
                              email: _user.email,
                              password: _user.password)
                          .whenComplete(() {
                        Constants.getMainProvider(context).getUserData(userId: _user.userId);
                        navigateAndRemove(context, page: HomeScreen());
                      }),
                      icon: Icon(
                        FontAwesomeIcons.check,
                        size: 20,
                        color: ConstantColors.yellowColor,
                      ),
                    ),
                  ),
                );
              },
            ),
            fallback: (context) => Center(
              child: Image.asset(Constants.emptyImageUrl),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Expanded(
                child: defaultButton(
                  title: 'Login',
                  btnColor: ConstantColors.redColor,
                  btnFunction: () => navigateTo(
                    context,
                    page: LoginOrRegisterWidget(
                      title: 'Login',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: defaultButton(
                  title: 'Register',
                  btnColor: ConstantColors.blueColor,
                  btnFunction: () => navigateTo(
                    context,
                    page: LoginOrRegisterWidget(
                      title: 'Register',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
