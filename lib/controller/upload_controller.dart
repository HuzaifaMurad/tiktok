import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:tiktok/constaints.dart';
import 'package:tiktok/modals/video_modal.dart';
import 'package:video_compress/video_compress.dart';

class UploadVideoController extends GetxController {
  _compressedVideo(String videoPath) async {
    final compressVideo = await VideoCompress.compressVideo(videoPath,
        quality: VideoQuality.MediumQuality);

    return compressVideo!.file;
  }

  _uploadVideoToStorage(String id, String videoPath) async {
    Reference ref = firebaeStorage.ref().child('videos').child(id);
    var uploadTask = ref.putFile(await _compressedVideo(videoPath));
    var snap = await uploadTask;
    String downlaodUrl = await ref.getDownloadURL();
    return downlaodUrl;
  }

  _getThumbNail(String videoPath) async {
    final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
    return thumbnail;
  }

  _uploadImageToStorage(String id, String videoPath) async {
    Reference refs = firebaeStorage.ref().child('thumbnails').child(id);
    var uploadTask = refs.putFile(await _getThumbNail(videoPath));
    var snap = uploadTask;
    String downlaodUrl = await refs.getDownloadURL();
    return downlaodUrl;
  }

  uploadVideo(String videoPath, String songname, String captionName) async {
    try {
      String uid = firebaseAuth.currentUser!.uid;
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(uid).get();
      var allDoc = await firestore.collection('videos').get();
      int len = allDoc.docs.length;
      String videoUrl = await _uploadVideoToStorage("video $len", videoPath);
      String thumbnail = await _uploadImageToStorage("video $len", videoPath);
      Video video = Video(
        id: 'videos $len',
        username: (userDoc.data()! as Map<String, dynamic>)['name'],
        uid: uid,
        likes: [],
        commentCount: 0,
        shareCount: 0,
        songName: songname,
        captionName: captionName,
        thumbnail: thumbnail,
        videoUrl: videoUrl,
        profilePhoto: (userDoc.data()! as Map<String, dynamic>)['profilePhoto'],
      );
      await firestore
          .collection('videos')
          .doc('videos $len')
          .set(video.toJason());
      Get.back();
    } catch (e) {
      Get.snackbar('error uploading', e.toString());
    }
  }
}
