import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tiktok/controller/auth_controller.dart';
import 'package:tiktok/views/screen/add_video_screen.dart';
import 'package:tiktok/views/screen/profile_screen.dart';
import 'package:tiktok/views/screen/search_screen.dart';
import 'package:tiktok/views/screen/video_screen.dart';

List pages = [
  VideoScreen(),
  SearchScreen(),
  const AddVideoScreen(),
  Text('Message Screen'),
  ProfileScreen(userid: authController.user!.uid),
];

const kBackgroundColor = Colors.black;
var kButtonColor = Colors.red[400];
const kBorderColor = Colors.grey;

var firebaseAuth = FirebaseAuth.instance;
var firebaeStorage = FirebaseStorage.instance;
var firestore = FirebaseFirestore.instance;

var authController = AuthController.instance;
