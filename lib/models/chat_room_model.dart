import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel {
  String id;
  String roomName;
  String roomAvatarUrl;
  List<MemberModel> members;
  MemberModel admin;
  Timestamp time;

  ChatRoomModel({
    this.id,
    this.roomName,
    this.roomAvatarUrl,
    this.members,
    this.admin,
    this.time,
  });

  ChatRoomModel.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.roomName = json['room_name'];
    this.roomAvatarUrl = json['room_avatar_url'];
    this.admin = MemberModel.fromJson(json['admin_data']);
    this.members = [
      for (var member in json['members'] ?? []) MemberModel.fromJson(member)
    ];
    this.time = json['time'];
  }

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'room_name': this.roomName,
        'room_avatar_url': this.roomAvatarUrl,
        // 'admin_data': this.admin.toJson(),
        'admin_data': {
          'user_id': this.admin.userId,
          'username': this.admin.username,
          'user_avatar_url': this.admin.userAvatarUrl,
        },
        'members': FieldValue.arrayUnion([
          this.admin.toJson(),
        ]),
        'time': this.time ?? Timestamp.now(),
      };
}

class MemberModel {
  String userId;
  String username;
  String userAvatarUrl;

  MemberModel({
    this.userId,
    this.username,
    this.userAvatarUrl,
  });

  MemberModel.fromJson(Map<String, dynamic> json) {
    this.userId = json['user_id'];
    this.username = json['username'];
    this.userAvatarUrl = json['user_avatar_url'];
  }

  Map<String, dynamic> toJson() => {
        'user_id': this.userId,
        'username': this.username,
        'user_avatar_url': this.userAvatarUrl,
      };
}
