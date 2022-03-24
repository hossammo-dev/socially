import 'package:flutter/material.dart';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:socially/screens/feed/add_or_edit_post_screen.dart';
import 'package:socially/widgets/shared_widgets.dart';

import '../../constants/constant_colors.dart';
import '../../constants/constant_fonts.dart';
import '../../constants/constants.dart';

class FeedScreen extends StatelessWidget {
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: ConstantColors.darkColor,
      ),
      appBar: defaultAppBar(
        title: defaultRichText(
          firstTitle: 'Social',
          firstTitleStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: ConstantFonts.fontPoppins,
          ),
          secondTitle: ' Feeds',
          secondTitleStyle: TextStyle(
            fontSize: 23,
            color: ConstantColors.blueColor,
            fontWeight: FontWeight.bold,
            fontFamily: ConstantFonts.fontPoppins,
          ),
        ),
        trailings: [
          IconButton(
            onPressed: () => navigateTo(
              context,
              page: AddOrEditPostScreen(
                addPost: true,
              ),
            ),
            icon: Icon(
              EvaIcons.plus,
              color: ConstantColors.greenColor,
            ),
          ),
        ],
      ),
      body: Container(
        // margin: const EdgeInsets.all(15),
        margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
        padding: const EdgeInsets.all(15),
        height: Constants.getMobileHeight(context),
        width: Constants.getMobileWidth(context),
        decoration: BoxDecoration(
          color: ConstantColors.blueGreyColor.withOpacity(0.6),
          // borderRadius: BorderRadius.circular(15),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15),
            topLeft: Radius.circular(15),
          ),
        ),
        //TODO: loading functionality
        //TODO: add pull to refresh
        child: (Constants.getMainProvider(context).postsList.isEmpty)
            ? Center(
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Lottie.asset('assets/animations/loading.json'),
                ),
              )
            : ListView.separated(
                itemCount: Constants.getMainProvider(context).postsList.length,
                physics: BouncingScrollPhysics(),
                separatorBuilder: (context, index) => defaultDivider(),
                itemBuilder: (context, index) {
                  final _post =
                      Constants.getMainProvider(context).postsList[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: ConstantColors.transperant,
                                  backgroundImage:
                                      NetworkImage(_post.authorAvatarUrl),
                                  radius: 20,
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${_post.authorName}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: ConstantColors.greenColor,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Location',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: ConstantColors.whiteColor,
                                          ),
                                        ),
                                        Text(
                                          ' , ${timeago.format(_post.publishedAt.toDate())}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: ConstantColors.greyColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              height: 50,
                              width: 50,
                              // color: ConstantColors.yellowColor,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  Icon(
                                    EvaIcons.award,
                                    color: ConstantColors.redColor,
                                  ),
                                  Icon(
                                    EvaIcons.award,
                                    color: ConstantColors.whiteColor,
                                  ),
                                  Icon(
                                    EvaIcons.award,
                                    color: ConstantColors.darkColor,
                                  ),
                                  Icon(
                                    EvaIcons.award,
                                    color: ConstantColors.redColor,
                                  ),
                                  Icon(
                                    EvaIcons.award,
                                    color: ConstantColors.whiteColor,
                                  ),
                                  Icon(
                                    EvaIcons.award,
                                    color: ConstantColors.darkColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: Constants.getMobileHeight(context) * 0.36,
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 10.0),
                          child: Image.network(
                            // 'https://img.freepik.com/free-photo/blurred-traffic-light-trails-road_1359-1009.jpg?t=st=1647366701~exp=1647367301~hmac=2f253f9d60fe219428f590bceb653dbcf374bc6d91a36a74ff962ed1698ac5fa&w=1060',
                            _post.postImageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // const SizedBox(height: 10),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Text(
                            _post.postDescription,
                            style: TextStyle(
                              color: ConstantColors.whiteColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                        // onPressed: () =>
                                        //     Constants.getMainProvider(context)
                                        //         .likePost(postId: _post.postId),
                                        onPressed: () {},
                                        icon: Icon(FontAwesomeIcons.heart,
                                            size: 20,
                                            color: ConstantColors.redColor)),
                                    const SizedBox(width: 3),
                                    Text(
                                      '${_post.postLikesNumber}',
                                      style: TextStyle(
                                        color: ConstantColors.whiteColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                        // onPressed: () => defaultModalBottomSheet(
                                        //       context,
                                        //       margin: EdgeInsets.only(
                                        //           bottom: MediaQuery.of(context)
                                        //               .viewInsets
                                        //               .bottom),
                                        //       child: commentSheet(
                                        //         context,
                                        //         comments: _post.postComments,
                                        //         postId: _post.postId,
                                        //         commentController:
                                        //             _commentController,
                                        //       ),
                                        //     ),
                                        onPressed: () {},
                                        icon: Icon(FontAwesomeIcons.comment,
                                            size: 20,
                                            color: ConstantColors.blueColor)),
                                    const SizedBox(width: 3),
                                    Text(
                                      '${_post.postCommentsNumber}',
                                      style: TextStyle(
                                        color: ConstantColors.whiteColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {},
                                        icon: Icon(FontAwesomeIcons.award,
                                            size: 20,
                                            color: ConstantColors.yellowColor)),
                                    const SizedBox(width: 3),
                                    Text(
                                      '${_post.postAwardsNumber}',
                                      style: TextStyle(
                                        color: ConstantColors.whiteColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            IconButton(
                                onPressed: () => defaultModalBottomSheet(
                                      context,
                                      height:
                                          Constants.getMobileHeight(context) *
                                              0.14,
                                      child: Column(
                                        children: [
                                          defaultDivider(),
                                          Container(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () => navigateTo(
                                                    context,
                                                    page: AddOrEditPostScreen(
                                                      addPost: false,
                                                      postModel: _post,
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'Edit',
                                                        style: TextStyle(
                                                          color: ConstantColors
                                                              .whiteColor,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Icon(
                                                        EvaIcons.editOutline,
                                                        color: ConstantColors
                                                            .blueColor,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Divider(
                                                  color:
                                                      ConstantColors.greyColor,
                                                ),
                                                GestureDetector(
                                                  onTap: () => showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      backgroundColor:
                                                          ConstantColors
                                                              .darkColor,
                                                      title: Text(
                                                        'DELETE POST!',
                                                        style: TextStyle(
                                                          color: ConstantColors
                                                              .redColor,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      content: Text(
                                                        'Are you sure, you want to delete this post?',
                                                        style: TextStyle(
                                                          color: ConstantColors
                                                              .whiteColor,
                                                        ),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context),
                                                          child: Text(
                                                            'No',
                                                            style: TextStyle(
                                                              color:
                                                                  ConstantColors
                                                                      .whiteColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 16,
                                                              decoration:
                                                                  TextDecoration
                                                                      .underline,
                                                              decorationColor:
                                                                  ConstantColors
                                                                      .whiteColor,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: defaultButton(
                                                            width: 70,
                                                            title: 'Yes',
                                                            btnColor:
                                                                ConstantColors
                                                                    .redColor,
                                                            btnFunction: () => Constants
                                                                    .getMainProvider(
                                                                        context)
                                                                .deletePost(
                                                                    _post
                                                                        .postId)
                                                                .whenComplete(
                                                                  () => Navigator
                                                                      .pop(
                                                                          context),
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ).whenComplete(() =>
                                                      Navigator.pop(context)),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'Delete',
                                                        style: TextStyle(
                                                          color: ConstantColors
                                                              .whiteColor,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Icon(
                                                        EvaIcons.trash2Outline,
                                                        color: ConstantColors
                                                            .redColor,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                icon: Icon(
                                  EvaIcons.moreVertical,
                                  color: ConstantColors.whiteColor,
                                  size: 20,
                                ))
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
