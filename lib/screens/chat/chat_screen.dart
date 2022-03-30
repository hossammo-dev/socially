import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socially/constants/constant_fonts.dart';
import 'package:socially/utils/firebase_utils.dart';
import 'package:socially/widgets/shared_widgets.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../constants/constant_colors.dart';
import '../../constants/constants.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _nameController = TextEditingController();
  String _avatarUrl;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
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
        child: Column(
          children: [
            Container(
              height: 70,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'CHATROOMS',
                        style: TextStyle(
                          color: ConstantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          fontFamily: ConstantFonts.fontMonteserat,
                        ),
                      ),
                      IconButton(
                          onPressed: () => buildChatroomCreatingSheet(context),
                          icon: Icon(
                            EvaIcons.plus,
                            color: ConstantColors.greenColor,
                          )),
                    ],
                  ),
                  Divider(
                    color: ConstantColors.whiteColor,
                  ),
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseUtils.getStreamData(collection: 'chat_rooms'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  else
                    return Container(
                      child: Expanded(
                        child: ListView(
                          physics: BouncingScrollPhysics(),
                          children: snapshot.data.docs
                              .map(
                                (chatrooms) => ListTile(
                                  leading: CircleAvatar(
                                    // backgroundColor: Colors.grey,
                                    backgroundImage: CachedNetworkImageProvider(chatrooms['room_avatar_url']),
                                  ),
                                  title: Text(
                                    '${chatrooms['room_name']}',
                                    style: TextStyle(
                                      color: ConstantColors.whiteColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Last Message',
                                    style: TextStyle(
                                      color: ConstantColors.greenColor,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                  ),
                                  trailing: Text(
                                    // '2 hours ago',
                                    timeago.format(chatrooms['time'].toDate()),
                                    style: TextStyle(
                                      color: ConstantColors.greyColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    );
                }),
          ],
        ),
      ),
    );
  }

  buildChatroomCreatingSheet(BuildContext context) => defaultModalBottomSheet(
        context,
        height: Constants.getMobileHeight(context) * 0.17,
        isScrollControlled: true,
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          children: [
            defaultDivider(),
            const SizedBox(height: 10),
            Container(
              child: StreamBuilder(
                  stream: FirebaseUtils.getStreamData(collection: 'awards'),
                  // stream:
                  //     FirebaseFirestore.instance.collection('awards').snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    // return ListView.builder(
                    //   itemCount: snapshot.data.docs.length,
                    //   scrollDirection: Axis.horizontal,
                    //   itemBuilder: ((context, index) => Container(
                    //         height: 40,
                    //         width: 40,
                    //         margin: const EdgeInsets.symmetric(horizontal: 10),
                    //         child: CachedNetworkImage(
                    //           imageUrl: snapshot.data.docs[index].data(),
                    //         ),
                    //       )),
                    // );
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    else
                      return Column(
                        children: [
                          Container(
                            height: 40,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: snapshot.data.docs
                                  .map(
                                    (award) => GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _avatarUrl = award['award_url'];
                                          print(_avatarUrl);
                                        });
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        decoration: (_avatarUrl ==
                                                award['award_url'])
                                            ? BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color:
                                                      ConstantColors.whiteColor,
                                                ))
                                            : null,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        padding: const EdgeInsets.all(8),
                                        child: CachedNetworkImage(
                                            imageUrl: award['award_url']),
                                      ),
                                    ),
                                    //     SizedBox(
                                    //       height: 40,
                                    //       child: CircleAvatar(
                                    //   backgroundImage: NetworkImage(
                                    //       award['award_url'],
                                    //   ),
                                    // ),
                                    //     ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ],
                      );
                  }),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: 'Create a room...',
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
                    // onPressed: () => Constants.getMainProvider(context)
                    //     .commentPost(
                    //       postId: postId,
                    //       comment: commentController.text,
                    //     )
                    //     .whenComplete(() => commentController.clear()),
                    onPressed: () => Constants.getMainProvider(context)
                        .createChatRoom(
                      chatRoomName: _nameController.text,
                      roomAvatarUrl: _avatarUrl,
                    )
                        .whenComplete(() {
                      print('room created successfully!!');
                      setState(() {
                        _avatarUrl = '';
                      });
                      _nameController.clear();
                      Navigator.pop(context);
                    }),
                    mini: true,
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
        ),
      );
}
