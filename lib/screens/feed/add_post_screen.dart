import 'dart:io';

import 'package:flutter/material.dart';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:socially/screens/home/home_screen.dart';
import 'package:socially/utils/shared_utils.dart';

import '../../constants/constant_colors.dart';
import '../../constants/constant_fonts.dart';
import '../../constants/constants.dart';
import '../../widgets/shared_widgets.dart';

class AddPostScreen extends StatefulWidget {
  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  TextEditingController _postController;

  File _imageFile;

  @override
  void initState() {
    super.initState();
    _postController = TextEditingController();
  }

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            EvaIcons.arrowBack,
            color: ConstantColors.whiteColor,
          ),
        ),
        title: defaultRichText(
          firstTitle: 'Add',
          firstTitleStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: ConstantFonts.fontPoppins,
          ),
          secondTitle: ' Post',
          secondTitleStyle: TextStyle(
            fontSize: 23,
            color: ConstantColors.blueColor,
            fontWeight: FontWeight.bold,
            fontFamily: ConstantFonts.fontPoppins,
          ),
        ),
        trailings: [
          IconButton(
            onPressed: () => defaultModalBottomSheet(
              context,
              height: 80,
              child: Column(
                children: [
                  defaultDivider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: defaultButton(
                            title: 'Camera',
                            btnColor: ConstantColors.blueColor,
                            btnFunction: () =>
                                pickImage(imageSource: 'Camera').then((file) {
                              setState(() {
                                _imageFile = file;
                              });
                              Navigator.pop(context);
                            }),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: defaultButton(
                            title: 'Gallery',
                            btnColor: ConstantColors.redColor,
                            btnFunction: () =>
                                pickImage(imageSource: 'Gallery').then((file) {
                              setState(() {
                                _imageFile = file;
                              });
                              Navigator.pop(context);
                            }),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            icon: Icon(
              EvaIcons.cameraOutline,
              color: ConstantColors.greenColor,
            ),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
        padding: const EdgeInsets.all(15),
        // height: Constants.getMobileHeight(context) * 0.6,
        height: Constants.getMobileHeight(context),
        width: Constants.getMobileWidth(context),
        decoration: BoxDecoration(
          color: ConstantColors.blueGreyColor.withOpacity(0.6),
          borderRadius: BorderRadius.circular(15),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (_imageFile != null)
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                content: Image.file(
                                  _imageFile,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                        },
                        child: Icon(
                          Icons.fit_screen_outlined,
                          color: ConstantColors.yellowColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          //TODO: Add crop functionality...
                        },
                        child: Icon(
                          Icons.aspect_ratio_outlined,
                          color: ConstantColors.greenColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      height: 250,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: ConstantColors.whiteColor,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: (_imageFile != null)
                          ? Image.file(
                              _imageFile,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              Constants.emptyImageUrl,
                              fit: BoxFit.contain,
                            ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    child: Image.asset('assets/icons/sunflower.png'),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    height: 80,
                    width: 3,
                    color: ConstantColors.blueColor,
                  ),
                  // const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _postController,
                      maxLines: 5,
                      maxLength: 300,
                      decoration: InputDecoration(
                        counterStyle: TextStyle(
                          color: ConstantColors.whiteColor.withOpacity(0.6),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                        hintText: 'What is in your mind?',
                        hintStyle: TextStyle(
                          color: ConstantColors.whiteColor.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                      style: TextStyle(
                        color: ConstantColors.whiteColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              defaultButton(
                title: 'Post',
                btnColor: ConstantColors.blueColor,
                btnFunction: () => Constants.getMainProvider(context)
                    .createPost(
                        imageFile: _imageFile,
                        postDescription: _postController.text)
                    .then(
                      (_) => navigateAndRemove(
                        context,
                        page: HomeScreen(),
                      ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
