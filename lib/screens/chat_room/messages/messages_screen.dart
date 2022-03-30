import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:socially/screens/home/home_screen.dart';
import 'package:socially/widgets/shared_widgets.dart';

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
          //TODO: Admin Icon
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseUtils.getStreamData(
                    collection: 'chat_rooms',
                    id: roomId,
                    secondCollection: 'messages'),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  else
                    return ListView(
                      physics: BouncingScrollPhysics(),
                      children: snapshot.data.docs
                          .map(
                            (message) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: (Constants.userId == message['user_id'])
                                    ? ConstantColors.blueColor
                                    : ConstantColors.blueGreyColor,
                              ),
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.all(8),
                              child: Text(
                                '${message['message']}',
                                style: TextStyle(
                                  color: ConstantColors.whiteColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                textDirection:
                                    (Constants.userId == message['user_id'])
                                        ? TextDirection.rtl
                                        : TextDirection.ltr,
                              ),
                            ),
                          )
                          .toList(),
                    );
                },
              ),
              // child: ListView.builder(
              //   itemCount: 100,
              //   physics: BouncingScrollPhysics(),
              //   itemBuilder: (context, index) => Container(
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(8),
              //       color: ConstantColors.greyColor,
              //     ),
              //     padding: const EdgeInsets.all(8),
              //     margin: const EdgeInsets.all(8),
              //     child: Text(
              //       'Hello 😃',
              //       style: TextStyle(
              //         color: ConstantColors.whiteColor,
              //         fontSize: 14,
              //         fontWeight: FontWeight.w600,
              //       ),
              //     ),
              //   ),
              // ),
            ),
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
