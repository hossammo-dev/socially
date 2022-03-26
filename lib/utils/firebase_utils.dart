import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:socially/constants/constants.dart';

class FirebaseUtils {
  static final FirebaseFirestore _firestoreDb = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _gSignIn = GoogleSignIn();

  /// Firebase Auth Methods ///

  //log user  in with either email and password or google account
  static Future<UserCredential> login(
      String email, String password, bool googleLogin) async {
    if (!googleLogin) {
      // print('Login with Email and Password.......!');
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } else {
      // print('Login with Google.......!');
      final GoogleSignInAccount _gAccount = await _gSignIn.signIn();
      final GoogleSignInAuthentication _gAuth = await _gAccount.authentication;
      final GoogleAuthCredential _gAuthCredential =
          GoogleAuthProvider.credential(
              accessToken: _gAuth.accessToken, idToken: _gAuth.idToken);

      final UserCredential _credential =
          await _auth.signInWithCredential(_gAuthCredential);
      return _credential;
    }
  }

  //create new user account using email and password
  static Future<UserCredential> createAccount(
          String email, String password) async =>
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

  //log user out from either email and password or google account
  static Future<void> logoutUser({bool googleLogout}) {
    if (googleLogout) {
      _gSignIn.disconnect();
      return _gSignIn.signOut();
    }
    return _auth.signOut();
  }

  //delete user account
  static Future<void> deleteUser(String userId) async {
    await _auth.currentUser.delete();
    await _firestoreDb.collection('users').doc(userId).delete();
  }

  // // logout google account
  // Future<void> logoutGoogleAccount() async {
  //   _gSignIn.disconnect();
  //   return await _gSignIn.signOut();
  // }

  // //logout user account
  // Future<void> logoutUserAccount() async => _auth.signOut();

  /// Firebase Firestore Methods ///

  //save data to the database
  static Future<void> saveData(
      {@required String collection,
      String secondCollection,
      @required String id,
      String secondId,
      @required Map<String, dynamic> data}) async {
    print('--start saving--');
    if (secondCollection == null)
      await _firestoreDb.collection(collection).doc(id).set(data);
    else
      await _firestoreDb
          .collection(collection)
          .doc(id)
          .collection(secondCollection)
          .doc(secondId)
          .set(data);
    print('--end saving--');
  }

  //update data
  static Future<void> updateData(
      {@required String collection,
      String secondCollection,
      @required String id,
      String secondId,
      @required Map<String, dynamic> data}) async {
    if (secondCollection == null)
      await _firestoreDb.collection(collection).doc(id).update(data);
    else
      await _firestoreDb
          .collection(collection)
          .doc(id)
          .collection(secondCollection)
          .doc(secondId)
          .update(data);
  }

  static Future<void> deleteData({
    @required String collection,
    String secondCollection,
    @required String id,
    String secondId,
  }) async {
    if (secondCollection == null)
      return await _firestoreDb.collection(collection).doc(id).delete();
    else
      return await _firestoreDb
          .collection(collection)
          .doc(id)
          .collection(secondCollection)
          .doc(secondId)
          .delete();
  }

  //get a specific data from database
  static Future<DocumentSnapshot<Map<String, dynamic>>> getData(
          {@required String id, @required String collection}) async =>
      await _firestoreDb.collection(collection).doc(id).get();

  //get all collection data from database
  static Future<QuerySnapshot<Map<String, dynamic>>> getCollectionData(
          {@required String collection}) async =>
      await _firestoreDb.collection(collection).get();

  /// Firebase Storage Methods ///

  static Future<String> uploadToStorage(
      {@required File imageFile, @required String path}) async {
    print('--start uploading--');
    // print('image File => ${imageFile.toString()}');
    // print('path => $path');
    String _imageUrl;
    // if (imageFile != null) {
    // Reference _imageReference = FirebaseStorage.instance.ref().child(path);

    // await _imageReference
    //     .putFile(imageFile)
    //     .whenComplete(() => print('Image Uploaded successfully!'));

    // await _imageReference.getDownloadURL().then((imageUrl) {
    //   print('--image url => $imageUrl--');
    //   print('--end uploading--');
    //   _imageUrl = imageUrl;
    // });
    // return _imageUrl;
    // }

    ///another way to upload image to firebase storage.

    if (imageFile != null && path != null) {
      await FirebaseStorage.instance
          .ref()
          .child(path)
          .putFile(imageFile)
          .then(
            (value) => value.ref.getDownloadURL().then((imageUrl) {
              _imageUrl = imageUrl;
            }).catchError(
              (error) {
                print(error.toString());
              },
            ),
          )
          .catchError((error) {
        print(error.toString());
      });
      // print('--image url => $_imageUrl--');
      return _imageUrl;
    }
    return Constants.dummyImageUrl;
  }

  static Future<void> deleteFromStorage(String url) async =>
      FirebaseStorage.instance.refFromURL(url).delete();
}
