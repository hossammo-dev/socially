import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socially/constants/constant_fonts.dart';
import 'package:socially/models/chat_room_model.dart';
import 'package:socially/screens/chat_room/messages/messages_screen.dart';
import 'package:socially/utils/firebase_utils.dart';
import 'package:socially/widgets/shared_widgets.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../constants/constant_colors.dart';
import '../../constants/constants.dart';
import 'messages/message_test_screen.dart';

class ChatRoomsScreen extends StatefulWidget {
  @override
  State<ChatRoomsScreen> createState() => _ChatRoomsScreenState();
}

class _ChatRoomsScreenState extends State<ChatRoomsScreen> {
  //TODO: don't forget to modify this page and make it more clean and readable.

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
                        'chatrooms',
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
                          children: snapshot.data.docs.map(
                            (chatroom) {
                              final ChatRoomModel _roomModel =
                                  ChatRoomModel.fromJson(chatroom.data());
                              return ListTile(
                                onTap: () {
                                  // debugPrint('----RoomId => ${chatroom['id']}');
                                  for (var member in _roomModel.members) {
                                    if (Constants.userId == member.userId)
                                      return navigateAndReplace(
                                        context,
                                        page: MessagesScreen(
                                          roomName: _roomModel.roomName,
                                          roomAvatarUrl:
                                              _roomModel.roomAvatarUrl,
                                          roomId: _roomModel.id,
                                          membersNumber:
                                              _roomModel.members.length,
                                          adminId: _roomModel.admin.userId,
                                        ),
                                      );
                                    else
                                      defaultModalBottomSheet(
                                        context,
                                        height:
                                            Constants.getMobileHeight(context) *
                                                0.2,
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            children: [
                                              defaultDivider(),
                                              Text(
                                                'Join Chat Room',
                                                style: TextStyle(
                                                  color:
                                                      ConstantColors.greenColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Text(
                                                'Your are not a member in this chat room, do you want to join?',
                                                style: TextStyle(
                                                  color:
                                                      ConstantColors.whiteColor,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: defaultButton(
                                                        title: 'No',
                                                        btnColor: ConstantColors
                                                            .redColor,
                                                        btnFunction: () =>
                                                            Navigator.pop(
                                                                context)),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: defaultButton(
                                                      title: 'Yes',
                                                      btnColor: ConstantColors
                                                          .greenColor,
                                                      btnFunction: () => Constants
                                                              .getMainProvider(
                                                                  context)
                                                          .joinRoom(
                                                              roomId:
                                                                  _roomModel.id)
                                                          .whenComplete(
                                                            () =>
                                                                navigateAndReplace(
                                                              context,
                                                              page:
                                                                  MessagesScreen(
                                                                roomName:
                                                                    _roomModel
                                                                        .roomName,
                                                                roomAvatarUrl:
                                                                    _roomModel
                                                                        .roomAvatarUrl,
                                                                roomId:
                                                                    _roomModel
                                                                        .id,
                                                                membersNumber:
                                                                    _roomModel
                                                                        .members
                                                                        .length,
                                                                adminId:
                                                                    _roomModel
                                                                        .admin
                                                                        .userId,
                                                              ),
                                                            ),
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                  }
                                },
                                leading: CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(
                                    _roomModel.roomAvatarUrl,
                                  ),
                                ),
                                title: Text(
                                  _roomModel.roomName,
                                  style: TextStyle(
                                    color: ConstantColors.whiteColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                //TODO: Change last message and start getting it from firestore.
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
                                  timeago.format(_roomModel.time.toDate()),
                                  style: TextStyle(
                                    color: ConstantColors.greyColor,
                                    fontSize: 12,
                                  ),
                                ),
                              );
                            },
                          ).toList(),
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
        child: Column(
          children: [
            defaultDivider(),
            const SizedBox(height: 10),
            Container(
              child: StreamBuilder(
                  stream: FirebaseUtils.getStreamData(collection: 'awards'),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                    onPressed: () {
                      if (_nameController.text.isNotEmpty) {
                        Constants.getMainProvider(context)
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
                        });
                      }
                    },
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