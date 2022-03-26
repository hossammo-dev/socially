import 'package:flutter/material.dart';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:socially/constants/constant_colors.dart';
import 'package:socially/constants/constant_fonts.dart';
import 'package:socially/constants/constants.dart';
import 'package:socially/models/user_model.dart';
import 'package:socially/screens/auth/auth_screen.dart';
import 'package:socially/utils/firebase_utils.dart';
import 'package:socially/widgets/shared_widgets.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({this.userId});
  final String userId;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel _userModel;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.userId != null) {
      Future.delayed(Duration(seconds: 1), () => fetchUserData());
    }
  }

  void fetchUserData() {
    FirebaseUtils.getData(
      collection: 'users',
      id: widget.userId,
    ).then((value) {
      _userModel = UserModel.fromJson(value.data());
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(
        leading: (widget.userId == null)
            ? IconButton(
                onPressed: () {},
                icon: Icon(
                  EvaIcons.settingsOutline,
                  color: ConstantColors.blueColor,
                ),
              )
            : IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  EvaIcons.arrowBackOutline,
                  color: ConstantColors.blueColor,
                ),
              ),
        title: defaultRichText(
          firstTitle: (widget.userId == null) ? 'My' : 'User',
          firstTitleStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: ConstantFonts.fontPoppins,
          ),
          secondTitle: 'Profile',
          secondTitleStyle: TextStyle(
            fontSize: 23,
            color: ConstantColors.blueColor,
            fontWeight: FontWeight.bold,
            fontFamily: ConstantFonts.fontPoppins,
          ),
        ),
        trailings: [
          (widget.userId == null)
              ? IconButton(
                  onPressed: () {
                    //TODO: Add logout function for both email and google.
                    Constants.getMainProvider(context)
                        .logUserOut()
                        .whenComplete(
                      () {
                        // Constants.getMainProvider(context).changeIndex(0);
                        navigateAndRemove(
                          context,
                          page: AuthScreen(),
                        );
                      },
                    );
                  },
                  icon: Icon(
                    EvaIcons.logOutOutline,
                    color: ConstantColors.greenColor,
                  ),
                )
              : IconButton(
                  onPressed: () {
                    //TODO: Add alt profile options
                  },
                  icon: Icon(
                    EvaIcons.moreVerticalOutline,
                    color: ConstantColors.greenColor,
                  ),
                ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(15),
          padding: const EdgeInsets.all(15),
          height: Constants.getMobileHeight(context),
          width: Constants.getMobileWidth(context),
          decoration: BoxDecoration(
            color: ConstantColors.blueGreyColor.withOpacity(0.6),
            borderRadius: BorderRadius.circular(15),
          ),
          child: (_isLoading && widget.userId != null)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundColor: ConstantColors.transperant,
                                backgroundImage: NetworkImage(
                                  (widget.userId == null)
                                      ? Constants.getMainProvider(context)
                                          .userModel
                                          .avatarUrl
                                      : _userModel.avatarUrl,
                                ),
                                // backgroundImage:
                                //     NetworkImage(Constants.dummyImageUrl),
                                radius: 50,
                              ),
                              const SizedBox(height: 3),
                              Text(
                                (widget.userId == null)
                                    ? Constants.getMainProvider(context)
                                        .userModel
                                        .username
                                    : _userModel.username,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: ConstantColors.whiteColor,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    EvaIcons.emailOutline,
                                    size: 13,
                                    color: ConstantColors.greenColor,
                                  ),
                                  const SizedBox(width: 3),
                                  Expanded(
                                    child: Text(
                                      (widget.userId == null)
                                          ? Constants.getMainProvider(context)
                                              .userModel
                                              .email
                                          : _userModel.email,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: ConstantColors.whiteColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          children: [
                            Row(
                              children: [
                                _buildProfileCard(
                                  (widget.userId == null)
                                      ? Constants.getMainProvider(context)
                                          .userModel
                                          .follwers
                                          .length
                                      : _userModel.follwers.length,
                                  'Followers',
                                ),
                                _buildProfileCard(
                                  (widget.userId == null)
                                      ? Constants.getMainProvider(context)
                                          .userModel
                                          .followings
                                          .length
                                      : _userModel.followings.length,
                                  'Following',
                                ),
                              ],
                            ),
                            _buildProfileCard(
                              (widget.userId == null)
                                  ? Constants.getMainProvider(context)
                                      .userModel
                                      .postsNumber
                                  : _userModel.postsNumber,
                              'Posts',
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Divider(
                      color: ConstantColors.whiteColor,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.users,
                          size: 20,
                          color: ConstantColors.yellowColor,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Recently Added',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: ConstantColors.whiteColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Container(
                      height: 46,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: ConstantColors.darkColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: ConstantColors.darkColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.asset(
                          '${Constants.emptyImageUrl}',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Container _buildProfileCard(int number, String title) {
    return Container(
      height: 70,
      width: 80,
      margin: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: ConstantColors.darkColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$number' ?? '0',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: ConstantColors.whiteColor,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              '$title',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: ConstantColors.whiteColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
