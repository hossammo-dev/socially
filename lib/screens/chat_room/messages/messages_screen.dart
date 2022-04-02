import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:socially/screens/home/home_screen.dart';
import 'package:socially/widgets/shared_widgets.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../constants/constant_colors.dart';
import '../../../constants/constants.dart';
import '../../../utils/firebase_utils.dart';

class MessagesScreen extends StatelessWidget {
  MessagesScreen(
      {this.roomAvatarUrl,
      this.roomName,
      this.roomId,
      this.membersNumber,
      this.adminId});

  final String roomAvatarUrl;
  final String roomName;
  final String roomId;
  final String adminId;
  final int membersNumber;

  final TextEditingController _messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(
        leading: IconButton(
            onPressed: () => navigateAndReplace(context,
                page: HomeScreen(), type: PageTransitionType.leftToRight),
            icon: Icon(
              EvaIcons.arrowBackOutline,
              color: ConstantColors.blueColor,
            )),
        title: Container(
          // color: Colors.red,
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(roomAvatarUrl),
                radius: 15,
              ),
              const SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    roomName,
                    style: TextStyle(
                      color: ConstantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '$membersNumber Members',
                    style: TextStyle(
                      color: ConstantColors.greenColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        trailings: [
          IconButton(
            onPressed: () {
              if (membersNumber == 1 && Constants.userId == adminId) {
                //TODO: show a warning message that there are no members except admin so that he can not leave.
                return;
              } else if (membersNumber > 1 && Constants.userId == adminId) {
                //TODO: change admin and then delete user from members.
                return;
              } else {
                Constants.getMainProvider(context)
                    .leaveRoom(roomId)
                    .whenComplete(() => Navigator.pop(context));
              }
            },
            icon: Icon(
              EvaIcons.logOutOutline,
              color: ConstantColors.redColor,
            ),
          ),
          //TODO: Admin Options Icon
        ],
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseUtils.getStreamData(
                collection: 'chat_rooms',
                id: roomId,
                secondCollection: 'messages', descending: true),
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(
                  child: CircularProgressIndicator(),
                );
              else
                return Expanded(
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(10),
                    reverse: true,
                    children: snapshot.data.docs
                        .map(
                          (message) => Stack(
                            alignment: AlignmentDirectional.topStart,
                            children: [
                              Align(
                                alignment:
                                    (Constants.userId == message['user_id'])
                                        ? AlignmentDirectional.centerEnd
                                        : AlignmentDirectional.centerStart,
                                child: Container(
                                  padding:
                                      (Constants.userId != message['user_id'])
                                          ? const EdgeInsets.symmetric(
                                              horizontal: 15,
                                              vertical: 10,
                                            )
                                          : const EdgeInsets.all(8),
                                  margin:
                                      (Constants.userId != message['user_id'])
                                          ? const EdgeInsets.only(
                                              top: 10,
                                              left: 15,
                                              right: 4,
                                              bottom: 10)
                                          : const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color:
                                        (Constants.userId == message['user_id'])
                                            ? ConstantColors.blueColor
                                            : ConstantColors.blueGreyColor,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (Constants.userId !=
                                          message['user_id'])
                                        Text(
                                          '${message['username']}',
                                          style: TextStyle(
                                            color: ConstantColors.greenColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      Text(
                                        '${message['message']}',
                                        style: TextStyle(
                                          color: ConstantColors.whiteColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        timeago.format(message['time'].toDate()),
                                        style: TextStyle(
                                          color: ConstantColors.greyColor,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              //User Avatar
                              if (Constants.userId != message['user_id'])
                                CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(
                                      message['user_avatar_url']),
                                  radius: 15,
                                ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: 'Send Hi!...',
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
                    // debugPrint('----RoomId => $roomId');
                    if (_messageController.text.isNotEmpty) {
                      Constants.getMainProvider(context)
                          .sendMessage(
                              message: _messageController.text, roomId: roomId)
                          .whenComplete(() => _messageController.clear());
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
}
