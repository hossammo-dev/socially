import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:socially/constants/constants.dart';

import '../../../constants/constant_colors.dart';
import '../../../models/post_model.dart';
import '../../../widgets/shared_widgets.dart';

Column commentSheet(
  BuildContext context, {
  @required String postId,
  @required List<CommentModel> comments,
  @required TextEditingController commentController,
}) =>
    Column(
      children: [
        defaultDivider(),
        Container(
          height: 40,
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(
              color: ConstantColors.blueColor,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'COMMENTS',
            style: TextStyle(
              color: ConstantColors.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          child: Container(
            child: (comments.isEmpty)
                ? Center(
                    child: Image.asset(Constants.emptyImageUrl),
                  )
                : ListView.separated(
                    itemCount: comments.length,
                    physics: BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) => Container(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 15,
                                backgroundImage:
                                    NetworkImage(comments[index].userAvatarUrl),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                comments[index].username,
                                style: TextStyle(
                                  color: ConstantColors.whiteColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 20),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  FontAwesomeIcons.heart,
                                  color: ConstantColors.redColor,
                                  size: 14,
                                ),
                              ),
                              Text(
                                '0',
                                style: TextStyle(
                                  color: ConstantColors.whiteColor,
                                  fontSize: 12,
                                ),
                              ),
                              // const SizedBox(
                              //     width: 5),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  FontAwesomeIcons.reply,
                                  color: ConstantColors.yellowColor,
                                  size: 14,
                                ),
                              ),
                              // const SizedBox(
                              //     width: 5),
                              Text(
                                '0',
                                style: TextStyle(
                                  color: ConstantColors.whiteColor,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: ConstantColors.blueColor,
                                  size: 16,
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    comments[index].description,
                                    style: TextStyle(
                                      color: ConstantColors.whiteColor,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    separatorBuilder: (context, index) => Divider(
                      color: ConstantColors.greyColor,
                    ),
                  ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          // color:
          //     ConstantColors.yellowColor,
          height: 50,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextField(
                  controller: commentController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: 'Add comment...',
                    hintStyle: TextStyle(
                      fontSize: 12,
                      color: ConstantColors.greyColor,
                    ),
                  ),
                  style: TextStyle(
                    color: ConstantColors.whiteColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              FloatingActionButton(
                onPressed: () {
                  if (commentController.text.isNotEmpty) {
                    Constants.getMainProvider(context)
                        .commentPost(
                          postId: postId,
                          comment: commentController.text,
                        )
                        .whenComplete(() => commentController.clear());
                  }
                },
                backgroundColor: ConstantColors.greenColor,
                child: Icon(
                  Icons.send_outlined,
                  color: ConstantColors.whiteColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
