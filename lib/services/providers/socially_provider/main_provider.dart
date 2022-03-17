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
  void getUserData({String userId}) {
    FirebaseUtils.getData(id: userId ?? Constants.userId, collection: 'users')
        .then((user) {
      _userModel = UserModel.fromJson(user.data());
      // print('username => ${userModel.username}');
    }).catchError(
      (error) => print(error.toString()),
    );
    notifyListeners();
  }

  //log out user from the app
  void logUserOut() {
    _userModel = UserModel();
    FirebaseUtils.logoutUser(googleLogout: false)
        .then(
      (_) => _userModel = UserModel(),
    )
        .catchError(
      (error) {
        print(error.toString());
      },
    );
  }

  //create a new post
  Future<void> createPost(
      {@required imageFile, @required String postDescription}) async {
    final String _postId = Uuid().v4();
    final String _postImageUrl = await FirebaseUtils.uploadToStorage(
      imageFile: imageFile,
      path: 'userPostsImages/$_postId/${imageFile.path.substring(31)}',
    );

    // print('-- post image url => $_postImageUrl');

    PostModel _postModel = PostModel(
      postId: _postId,
      authorName: _userModel.username,
      // authorEmail: _userModel.email,
      authorAvatarUrl: _userModel.avatarUrl,
      postImageUrl: _postImageUrl,
      postDescription: postDescription,
      postAwardsNumber: 0,
      postLikesNumber: 0,
      postCommentsNumber: 0,
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
        print('--first post author => ${postsList[0].authorName}');
      });
    });
    notifyListeners();
  }

  //like post
  void likePost({@required String postId}) async {
    FirebaseUtils.updateData(
      collection: 'posts',
      id: postId,
      data: {
        'likes_number': FieldValue.increment(1),
      },
    ).whenComplete(
      () {
        print('Post liked successfully!');
        getPosts();
      },
    );
  }

  //get all users
  void getAllUsersData() async {
    _usersList = [];
    FirebaseUtils.getCollectionData(collection: 'users')
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
    FirebaseUtils.deleteUser(userId).whenComplete(() {
      // print('user deleted successfully!');
      getAllUsersData();
    });
  }
}
