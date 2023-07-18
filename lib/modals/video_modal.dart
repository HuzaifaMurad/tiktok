import 'package:cloud_firestore/cloud_firestore.dart';

class Video {
  String username;
  String uid;
  String id;
  List likes;
  int commentCount;
  int shareCount;
  String songName;
  String captionName;
  String thumbnail;
  String videoUrl;
  String profilePhoto;

  Video(
      {required this.id,
      required this.username,
      required this.uid,
      required this.likes,
      required this.commentCount,
      required this.shareCount,
      required this.songName,
      required this.captionName,
      required this.thumbnail,
      required this.videoUrl,
      required this.profilePhoto});

  Map<String, dynamic> toJason() => {
        'id': id,
        'username': username,
        'uid': uid,
        'likes': likes,
        'commentCount': commentCount,
        'shareCount': shareCount,
        'songName': songName,
        'captionName': captionName,
        'thumbnail': thumbnail,
        'videoUrl': videoUrl,
        'profilePhoto': profilePhoto,
      };

  static fromSnap(DocumentSnapshot snap) {
    var snapShot = snap.data() as Map<String, dynamic>;
    return Video(
        id: snapShot['id'],
        username: snapShot['username'],
        uid: snapShot['uid'],
        likes: snapShot['likes'],
        commentCount: snapShot['commentCount'],
        shareCount: snapShot['shareCount'],
        songName: snapShot['songName'],
        captionName: snapShot['captionName'],
        thumbnail: snapShot['thumbnail'],
        videoUrl: snapShot['videoUrl'],
        profilePhoto: snapShot['profilePhoto']);
  }
}
