import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socially/models/user_model.dart';
import 'package:socially/screens/chat/chat_screen.dart';
import 'package:socially/screens/feed/feed_screen.dart';
import 'package:socially/screens/profile/profile_screen.dart';
import 'package:socially/utils/firebase_utils.dart';
import 'package:uuid/uuid.dart';

import '../../../constants/constants.dart';
import '../../../models/post_model.dart';

class MainProvider extends ChangeNotifier {
  int _currentIndex = 0; //current index for the navigation bar and current page
  int get currentIndex => _currentIndex;

  List<Widget> _pagesList = [
    FeedScreen(),
    ChatScreen(),
    ProfileScreen(),
  ];
  List<Widget> get pagesList => _pagesList;

  UserModel _userModel;
  UserModel get userModel => _userModel;

  List<UserModel> _usersList = [];
  List<UserModel> get usersList => _usersList;

  List<PostModel> _postsList = [];
  List<PostModel> get postsList => _postsList;

  //change index for the current page index
  void changeIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  //get user data from database
  Future<void> getUserData({String userId}) async {
    await FirebaseUtils.getData(
            id: userId ?? Constants.userId, collection: 'users')
        .then((user) {
      _userModel = UserModel.fromJson(user.data());
      // print('username => ${userModel.username}');
    }).catchError(
      (error) => print(error.toString()),
    );
    notifyListeners();
  }

  //log out user from the app
  Future<void> logUserOut() async {
    _userModel = UserModel();
    await FirebaseUtils.logoutUser(googleLogout: false)
        .then(
      (_) => _userModel = UserModel(),
    )
        .catchError(
      (error) {
        print(error.toString());
      },
    );
    notifyListeners();
  }

  //create a new post
  Future<void> createPost(
      {@required File imageFile, @required String postDescription}) async {
    final String _postId = Uuid().v4();
    final String _postImageUrl = await FirebaseUtils.uploadToStorage(
      imageFile: imageFile,
      path: 'userPostsImages/$_postId/${imageFile.path.substring(31)}',
    );

    // print('-- post image url => $_postImageUrl');

    PostModel _postModel = PostModel(
      postId: _postId,
      userId: _userModel.userId,
      username: _userModel.username,
      // authorEmail: _userModel.email,
      userAvatarUrl: _userModel.avatarUrl,
      postImageUrl: _postImageUrl,
      postDescription: postDescription,
      // postAwardsNumber: 0,
      // postLikesNumber: 0,
      // postCommentsNumber: 0,
      publishedAt: Timestamp.now(),
    );

    FirebaseUtils.saveData(
      collection: 'posts',
      id: _postId,
      data: _postModel.toJson(),
    ).then((_) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(_userModel.userId)
          .update({
        'posts_number': FieldValue.increment(1),
      }).then((_) {
        getUserData();
        getPosts();
      });
    });
  }

  //get all users posts
  void getPosts() async {
    // _postsList = [];
    // FirebaseUtils.getCollectionData(collection: 'posts')
    //     .then(
    //   (posts) => posts.docChanges.forEach(
    //     (post) {
    //       _postsList.add(PostModel.fromJson(post.doc.data()));
    //       // print('--first post author => ${postsList[0].authorName}');
    //     },
    //   ),
    // )
    //     .catchError((error) {
    //   print(error.toString());
    // });
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('published_at', descending: true)
        .snapshots()
        .listen((event) {
      _postsList = [];
      event.docs.forEach((post) {
        _postsList.add(PostModel.fromJson(post.data()));
        print('--first post author => ${postsList[0].username}');
      });
    });
    notifyListeners();
  }

  //like post
  void likePost({@required String postId}) async {
    final String _likeId = Uuid().v4();
    LikeModel _likeModel = LikeModel(
      id: _likeId,
      userId: _userModel.userId,
      username: _userModel.username,
      userAvatarUrl: _userModel.avatarUrl,
      publishedAt: Timestamp.now(),
    );
    FirebaseUtils.updateData(
      collection: 'posts',
      id: postId,
      data: {
        'likes': FieldValue.arrayUnion([_likeModel.toJson()]),
      },
    ).whenComplete(
      () {
        print('Post liked successfully!');
        getPosts();
      },
    );

    //TODO: Edit post likes and make them in a separate collection.

    // final String _likeId = Uuid().v4();
    // await FirebaseUtils.saveData(
    //   collection: 'posts',
    //   id: postId,
    //   secondCollection: 'likes',
    //   secondId: _likeId,
    //   data: {
    //     'id': _likeId,
    //     'user_id': userModel.userId,
    //   },
    // );
  }

  //comment psot
  Future<void> commentPost(
      {@required String postId, @required String comment}) async {
    final String _commentId = Uuid().v4();
    CommentModel _commentModel = CommentModel(
      id: _commentId,
      userId: _userModel.userId,
      username: _userModel.username,
      userAvatarUrl: _userModel.avatarUrl,
      description: comment,
      publishedAt: Timestamp.now(),
    );
    await FirebaseUtils.updateData(
      collection: 'posts',
      id: postId,
      data: {
        'comments': FieldValue.arrayUnion([_commentModel.toJson()])
      },
    ).whenComplete(
      () {
        debugPrint('Comment added successfully!');
        getPosts();
      },
    );
    notifyListeners();
  }

  //award post
  void awardPost({
    @required String postId,
    @required String awardUrl,
  }) async {
    final String _awardId = Uuid().v4();
    AwardModel _awardModel = AwardModel(
      id: _awardId,
      userId: _userModel.userId,
      username: _userModel.username,
      userAvatarUrl: _userModel.avatarUrl,
      awardUrl: awardUrl,
      publishedAt: Timestamp.now(),
    );
    await FirebaseUtils.updateData(
      collection: 'posts',
      id: postId,
      data: {
        'awards': FieldValue.arrayUnion([_awardModel.toJson()]),
      },
    ).whenComplete(
      () {
        print('post awarded successfully!');
        getPosts();
      },
    );
    notifyListeners();
  }

  //edit post
  Future<void> editPost({
    @required String postId,
    String postDescription,
    File imageFile,
    String postImageUrl,
  }) async {
    if (imageFile != null) {
      String _postImageUrl;
      await FirebaseUtils.deleteFromStorage(postImageUrl)
          .whenComplete(() async {
        print('---file deleted successfully!---');
        _postImageUrl = await FirebaseUtils.uploadToStorage(
            imageFile: imageFile,
            path: 'userPostsImages/$postId/${imageFile.path.substring(31)}');
      });
      await FirebaseUtils.updateData(
        collection: 'posts',
        id: postId,
        data: {
          'post_image_url': _postImageUrl,
          'post_description': postDescription,
        },
      ).whenComplete(
        () => getPosts(),
      );
    } else {
      await FirebaseUtils.updateData(
        collection: 'posts',
        id: postId,
        data: {
          'post_description': postDescription,
        },
      ).whenComplete(
        () => getPosts(),
      );
    }

    notifyListeners();
  }

  //delete post
  Future<void> deletePost(String postId) async {
    await FirebaseUtils.deleteData(collection: 'posts', id: postId)
        .whenComplete(
      () => getPosts(),
    );
    notifyListeners();
  }

  //remove like
  Future<void> removeLike({
    @required String postId,
    @required LikeModel like,
  }) async {
    FirebaseUtils.updateData(
      collection: 'posts',
      id: postId,
      data: {
        'likes': FieldValue.arrayRemove([like.toJson()]),
      },
    ).whenComplete(
      () {
        print('----like removed successfully!');
        getPosts();
      },
    );
  }

  //get all users
  void getAllUsersData() async {
    _usersList = [];
    await FirebaseUtils.getCollectionData(collection: 'users')
        .then(
          (users) => users.docs.forEach((user) {
            _usersList.add(UserModel.fromJson(user.data()));
            // print('--first username => ${_usersList[0].username}');
          }),
        )
        .catchError((error) => print(error.toString()));

    notifyListeners();
  }

  //delete user account
  Future<void> deleteUserAccount(String userId) async {
    await FirebaseUtils.deleteUser(userId).whenComplete(() {
      // print('user deleted successfully!');
      getAllUsersData();
    });
  }

  //follow user
  void followUser({
    @required String userId,
    @required String username,
    @required String avatarUrl,
  }) async {
    final FollowModel _followerModel = FollowModel(
      id: userId,
      username: username,
      avatarUrl: avatarUrl,
    );

    final FollowModel _followingModel = FollowModel(
      id: userModel.userId,
      username: userModel.username,
      avatarUrl: userModel.avatarUrl,
    );

    await FirebaseUtils.updateData(
      collection: 'users',
      id: userModel.userId,
      data: {
        'followings': FieldValue.arrayUnion([_followerModel.toJson()]),
      },
    );

    await FirebaseUtils.updateData(
      collection: 'users',
      id: userId,
      data: {
        'followers': FieldValue.arrayUnion([_followingModel.toJson()]),
      },
    ).whenComplete(() {
      print('---Your are now a follower for: $username');
       getUserData(userId: _userModel.userId);
    });
  }
}
