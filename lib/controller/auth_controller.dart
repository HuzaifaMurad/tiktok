import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:tiktok/constaints.dart';
import 'package:tiktok/modals/user.dart' as modal;
import 'package:tiktok/views/screen/login_screen.dart';

import '../views/screen/Home_screen.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
//rx is observant it keep track if the value of pickImaged is change or not;
  late Rx<File?> _pickImage;
  late Rx<User?> _user;

  User? get user => _user.value;

  File? get profilePhoto => _pickImage.value;
// when the app start for the first time
  @override
  void onReady() {
    // TODO: implement onReady

    super.onReady();
    _user = Rx<User?>(firebaseAuth.currentUser);
    _user.bindStream(firebaseAuth.authStateChanges());
    // this mean when ever there is a change in user
    ever(_user, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => LoginScreen());
    } else {
      Get.offAll(() => const HomeScreen());
    }
  }

  void pickImage() async {
    final pickImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickImage != null) {
      Get.snackbar('profile picture',
          'You have successfull selected your profile picute');
    }
    _pickImage = Rx<File?>(File(pickImage!.path));
  }

  _uploadToStorage(File image) async {
    Reference ref = firebaeStorage
        .ref()
        .child('profilepictures')
        .child(firebaseAuth.currentUser!.uid);
    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snapshot = (await uploadTask) as TaskSnapshot;
    String downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  void changeTheme() {
    Get.changeTheme(ThemeData.light());
  }

  void registerUser(
      {required String username,
      required String password,
      required String email,
      required File? image}) async {
    try {
      if (username.isNotEmpty &&
          password.isNotEmpty &&
          email.isNotEmpty &&
          image != null) {
        UserCredential userCredential = await firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password);
        String downloadUrl = await _uploadToStorage(image);
        modal.User user = modal.User(
            name: username,
            profilePhoto: downloadUrl,
            email: email,
            uid: userCredential.user!.uid);
        firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(user.toJson());
      } else {
        Get.snackbar('Error creating account', 'please enter all fields');
      }
    } catch (e) {
      Get.snackbar('Error creating account', e.toString());
    }
  }

  void loginUser(String email, String password) async {
    try {
      if (password.isNotEmpty && email.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        log('login');
      } else {
        Get.snackbar('Error loggin in', 'please enter right credentials');
      }
    } catch (e) {
      Get.snackbar('Error logging account', e.toString());
    }
  }

  void signOut() async {
    await firebaseAuth.signOut();
  }
}
