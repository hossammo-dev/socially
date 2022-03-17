// import 'package:socially/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String postId;
  String authorName;
  // String authorEmail;
  String authorAvatarUrl;
  String postImageUrl;
  String postDescription;
  // UserModel postAuthor;
  // List<CommentModel> postComments;
  Timestamp publishedAt;
  int postLikesNumber;
  int postCommentsNumber;
  int postAwardsNumber;

  PostModel({
    this.postId,
    this.authorName,
    // this.authorEmail,
    this.authorAvatarUrl,
    this.postImageUrl,
    this.postDescription,
    // this.postAuthor,
    // this.postComments,
    this.publishedAt,
    this.postLikesNumber,
    this.postAwardsNumber,
    this.postCommentsNumber,
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    this.postId = json['id'];
    // this.postAuthor = UserModel.fromJson(json['post_author']);
    this.authorName = json['author_name'];
    // this.authorEmail = json['author_email'];
    this.authorAvatarUrl = json['author_avatar_url'];
    this.postImageUrl = json['post_image_url'];
    this.postDescription = json['post_description'];
    this.publishedAt = json['published_at'];
    // json['post_comments'].forEach((comment) {
    //   this.postComments.add(CommentModel.fromJson(comment));
    // });
    this.postLikesNumber = json['likes_number'];
    this.postAwardsNumber = json['awards_number'];
    this.postCommentsNumber = json['comments_number'];
  }

  Map<String, dynamic> toJson() => {
        'id': this.postId,
        // 'post_author': this.postAuthor,
        'author_name': this.authorName,
        // 'author_email': this.authorEmail,
        'author_avatar_url': this.authorAvatarUrl,
        'post_image_url': this.postImageUrl,
        'post_description': this.postDescription,
        'published_at': this.publishedAt,
        'likes_number': this.postLikesNumber,
        'awards_number': this.postAwardsNumber,
        'comments_number': this.postCommentsNumber,
        // 'comments':
      };
}

class CommentModel {
  String commentId;
  String commentOwnerName;
  String commentOwnerAvatarUrl;
  String commentDescription;
  Timestamp publishedAt;

  CommentModel({
    this.commentId,
    this.commentOwnerName,
    this.commentOwnerAvatarUrl,
    this.commentDescription,
    this.publishedAt,
  });

  CommentModel.fromJson(Map<String, dynamic> json) {
    this.commentId = json['id'];
    this.commentOwnerName = json['owner_name'];
    this.commentOwnerAvatarUrl = json['owner_avatar_url'];
    this.commentDescription = json['description'];
    this.publishedAt = json['published_at'];
  }

  Map<String, dynamic> toJson() => {
        'id': this.commentId,
        'owner_name': this.commentOwnerName,
        'owner_avatar_url': this.commentOwnerAvatarUrl,
        'description': this.commentDescription,
        'published_at': this.publishedAt,
      };
}
