import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok/constaints.dart';

class ProfileController extends GetxController {
  final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});
  var _uid = "".obs;

  Map<String, dynamic> get user {
    return _user.value;
  }

  updateUserId(String uid) {
    _uid.value = uid;
  }

  getUserData() async {
    List<String> thumbnails = [];
    var myVideo = await firestore
        .collection('videos')
        .where('uid', isEqualTo: _uid.value)
        .get();
    for (var element in myVideo.docs) {
      thumbnails.add((element.data() as dynamic)['thumbnail']);
    }
    DocumentSnapshot userDoc =
        await firestore.collection('users').doc(_uid.value).get();
    final userData = userDoc.data() as dynamic;
    log("data from user : ${userDoc['uid']}");
    String name = userDoc['name'];
    String profilePhoto = userDoc['profilePhoto'];
    int likes = 0;
    int followers = 0;
    int following = 0;
    bool isFollow = false;

    for (var item in myVideo.docs) {
      likes += (item.data()['likes'] as List).length;
    }

    var followDoc = await firestore
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .get();

    var followingDoc = await firestore
        .collection('users')
        .doc(_uid.value)
        .collection('following')
        .get();

    followers = followDoc.docs.length;
    following = followingDoc.docs.length;
    firestore
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .doc(authController.user!.uid)
        .get()
        .then((value) {
      if (value.exists) {
        isFollow = true;
      } else {
        isFollow = false;
      }
    });

    _user.value = {
      'followers': followers.toString(),
      'following': following.toString(),
      'isFollow': isFollow,
      'likes': likes.toString(),
      'profilePhoto': profilePhoto,
      'name': name,
      'thumbnails': thumbnails
    };
    update();
  }

  followUser() async {
    var doc = await firestore
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .doc(authController.user!.uid)
        .get();

    if (!doc.exists) {
      await firestore
          .collection('users')
          .doc(_uid.value)
          .collection('followers')
          .doc(authController.user!.uid)
          .set({});
      await firestore
          .collection('users')
          .doc(authController.user!.uid)
          .collection('following')
          .doc(_uid.value)
          .set({});
      _user.value.update(
        'followers',
        (value) => (int.parse(value) + 1).toString(),
      );
    } else {
      await firestore
          .collection('users')
          .doc(_uid.value)
          .collection('followers')
          .doc(authController.user!.uid)
          .delete();
      await firestore
          .collection('users')
          .doc(authController.user!.uid)
          .collection('following')
          .doc(_uid.value)
          .delete();
      _user.value.update(
        'followers',
        (value) => (int.parse(value) - 1).toString(),
      );
    }
    _user.value.update('isFollow', (value) => !value);
    update();
  }
}
