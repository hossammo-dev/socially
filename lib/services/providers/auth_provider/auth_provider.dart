import 'dart:io';

import 'package:flutter/material.dart';
import 'package:socially/constants/constants.dart';
import 'package:socially/models/user_model.dart';
import 'package:socially/utils/firebase_utils.dart';
import 'package:socially/utils/shared_utils.dart';

class AuthProvider with ChangeNotifier {
  // String _userId;
  // String get userId => _userId;

  File _avatarImageFile;
  File get avatarImageFile => _avatarImageFile;

  // String _avatarImageUrl;
  // String get avatarImageUrl => _avatarImageUrl;

  bool _hidePassword = true;
  bool get hidePassword => _hidePassword;

  //login using email and password
  Future<String> logUserIn({
    @required bool googleLogin,
    String email,
    String password,
  }) async {
    // String _userId = '';
    await FirebaseUtils.login(email, password, googleLogin).then(
      (user) {
        assert(user.user.uid !=
            null); //make sure userId has a value and not [null].
        final _user = user.user;
        Constants.userId = _user.uid;
        // _userId = _user.uid;
        if (googleLogin) {
          UserModel _userModel = UserModel(
            userId: Constants.userId,
            username: _user.displayName,
            email: _user.email,
            avatarUrl: _user.photoURL,
          );
          FirebaseUtils.saveData(
              collection: 'users',
              id: Constants.userId,
              data: _userModel.toJson());
        }
        print('user Id => ${Constants.userId}');
      },
    );
    notifyListeners();
    return Constants.userId;
  }

  //create new account
  Future<void> createAccount(
      String username, String email, String password) async {
    await FirebaseUtils.createAccount(email, password).then(
      (user) async {
        assert(user.user.uid != null);
        Constants.userId = user.user.uid;

        String _avatarImageUrl;
        if (avatarImageFile == null) {
          _avatarImageUrl = await FirebaseUtils.uploadToStorage(
            imageFile: avatarImageFile,
            path: null,
          );
        } else {
          _avatarImageUrl = await FirebaseUtils.uploadToStorage(
            imageFile: avatarImageFile,
            path:
                'usersAvatars/${Constants.userId}/${avatarImageFile.path.substring(31)}',
          );
        }

        // final String _avatarImageUrl = await FirebaseUtils.uploadToStorage(
        //   imageFile: avatarImageFile,
        //   path:
        //       'usersAvatars/${Constants.userId}/${avatarImageFile.path.substring(31)}',
        // );

        // print('--avatar url => $_avatarImageUrl');

        UserModel _userModel = UserModel(
          userId: Constants.userId,
          username: username,
          email: email,
          avatarUrl: _avatarImageUrl,
        );
        await FirebaseUtils.saveData(
            collection: 'users',
            id: Constants.userId,
            data: _userModel.toJson());
        print('user Id => ${Constants.userId}');
      },
    );
    notifyListeners();
  }

  //pick user image from gallery or camera
  void pickAvatar() async {
    _avatarImageFile = await pickImage(imageSource: 'Gallery');
    notifyListeners();
  }

  //make password visible
  void makePasswordVisible() {
    _hidePassword = !hidePassword;
    notifyListeners();
  }
}
