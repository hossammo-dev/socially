import 'package:socially/models/post_model.dart';

class UserModel {
  String userId;
  String username;
  String email;
  String avatarUrl;
  String bio;
  String password;
  List<PostModel> posts;
  List<FollowModel> follwers;
  List<FollowModel> followings;

  UserModel({
    this.userId,
    this.username,
    this.email,
    this.avatarUrl,
    this.bio,
    this.password,
    this.posts,
    this.follwers,
    this.followings,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    this.userId = json['id'];
    this.username = json['username'] ?? 'Failed to get the username';
    this.email = json['email'] ?? 'Failed to get the emial';
    this.avatarUrl = json['avatar_url'] ?? 'Failed to get the image url';
    this.bio = json['bio'] ?? 'Failed to get the biography';
    this.password = json['password'];
    this.posts = [
      for (final post in json['user_posts'] ?? []) PostModel.fromJson(post),
    ];
    this.follwers = [
      for (final follower in json['followers'] ?? [])
        FollowModel.fromJson(follower)
    ];
    // json['followings'].forEach((following) {
    //   this.follwers.add(FollowModel.fromJson(following));
    // });

    this.followings = [
      for (var following in json['followings'] ?? [])
        FollowModel.fromJson(following)
    ];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.userId,
      'username': this.username,
      'email': this.email,
      'avatar_url': this.avatarUrl,
      'bio': this.bio ?? 'Hello, I am using socially!',
      'password': this.password ?? '',
      // 'followers_number': this.followersNumber ?? 0,
      // 'following_number': this.followingNumber ?? 0,
      'user_posts': this.posts ?? [],
      'followers': this.follwers ?? [],
      'followings': this.followings ?? [],
    };
  }
}

class FollowModel {
  String id;
  String username;
  String avatarUrl;

  FollowModel({
    this.id,
    this.username,
    this.avatarUrl,
  });

  FollowModel.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.username = json['username'];
    this.avatarUrl = json['avatar_url'];
  }

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'username': this.username,
        'avatar_url': this.avatarUrl,
      };
}

// List<Map<String, dynamic>> _list = [
//   {
//     'id': 4642,
//     'username': 'fafasfa',
//     'avatar_url': 'dasdfa',
//   },
//   {
//     'id': 4642,
//     'username': 'fafasfa',
//     'avatar_url': 'dasdfa',
//   },
//   {
//     'id': 4642,
//     'username': 'fafasfa',
//     'avatar_url': 'dasdfa',
//   },
// ];
