import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String postId;
  String userId;
  String username;
  String userAvatarUrl;
  String postImageUrl;
  String postDescription;
  List<CommentModel> postComments;
  List<LikeModel> postLikes;
  List<AwardModel> postAwards;
  Timestamp publishedAt;


  PostModel({
    this.postId,
    this.userId,
    this.username,
    this.userAvatarUrl,
    this.postImageUrl,
    this.postDescription,
    this.postComments,
    this.postLikes,
    this.postAwards,
    this.publishedAt,
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    this.postId = json['id'];
    this.userId = json['user_id'];
    this.username = json['username'];
    this.userAvatarUrl = json['user_avatar_url'];
    this.postImageUrl = json['post_image_url'];
    this.postDescription = json['post_description'];
    this.publishedAt = json['published_at'];

    // json['post_comments'].forEach((comment) {
    //   this.postComments.add(CommentModel.fromJson(comment.data()));
    // });
    this.postComments = [
      for (var comment in json['comments'] ?? []) CommentModel.fromJson(comment)
    ];
    // json['post_comments'].docs.forEach((comment) {
    //   this.postComments.add(CommentModel.fromJson(comment.data()));
    // });
    this.postLikes = [
      for (var like in json['likes'] ?? []) LikeModel.fromJson(like)
    ];

    this.postAwards = [
      for (var award in json['awards'] ?? []) AwardModel.fromJson(award)
    ];
  }

  Map<String, dynamic> toJson() => {
        'id': this.postId,
        'user_id': this.userId,
        'username': this.username,
        'user_avatar_url': this.userAvatarUrl,
        'post_image_url': this.postImageUrl,
        'post_description': this.postDescription,
        'published_at': this.publishedAt,
        'comments': this.postComments ?? [],
        'likes': this.postLikes ?? [],
        'awards': this.postAwards ?? [],
      };
}

class CommentModel {
  String id;
  String userId;
  String username;
  String userAvatarUrl;
  String description;
  Timestamp publishedAt;

  CommentModel({
    this.id,
    this.userId,
    this.username,
    this.userAvatarUrl,
    this.description,
    this.publishedAt,
  });

  CommentModel.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.userId = json['user_id'];
    this.username = json['username'];
    this.userAvatarUrl = json['user_avatar_url'];
    this.description = json['description'];
    this.publishedAt = json['published_at'];
  }

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'user_id': this.userId,
        'username': this.username,
        'user_avatar_url': this.userAvatarUrl,
        'description': this.description,
        'published_at': this.publishedAt,
      };
}

class LikeModel {
  String id;
  String userId;
  String username;
  String userAvatarUrl;
  Timestamp publishedAt;

  LikeModel({
    this.id,
    this.userId,
    this.username,
    this.userAvatarUrl,
    this.publishedAt,
  });

  LikeModel.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.userId = json['user_id'];
    this.username = json['username'];
    this.userAvatarUrl = json['user_avatar_url'];
    this.publishedAt = json['published_at'];
  }

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'user_id': this.userId,
        'username': this.username,
        'user_avatar_url': this.userAvatarUrl,
        'published_at': this.publishedAt,
      };
}

class AwardModel {
  String id;
  String userId;
  String username;
  String userAvatarUrl;
  String awardUrl;
  Timestamp publishedAt;

  AwardModel({
    this.id,
    this.userId,
    this.username,
    this.userAvatarUrl,
    this.awardUrl,
    this.publishedAt,
  });

  AwardModel.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.userId = json['user_id'];
    this.username = json['username'];
    this.userAvatarUrl = json['user_avatar_url'];
    this.awardUrl = json['award_url'];
    this.publishedAt = json['published_at'];
  }

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'user_id': this.userId,
        'username': this.username,
        'user_avatar_url': this.userAvatarUrl,
        'award_url': this.awardUrl,
        'published_at': this.publishedAt,
      };
}
