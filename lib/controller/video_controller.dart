import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok/constaints.dart';

import '../modals/video_modal.dart';

class VideoController extends GetxController {
  //
  final Rx<List<Video>> _videoList = Rx<List<Video>>([]);
  List<Video> get videoList {
    return _videoList.value;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _videoList.bindStream(
      firestore.collection('videos').snapshots().map(
        (QuerySnapshot snapshot) {
          List<Video> retval = [];

          for (var element in snapshot.docs) {
            log(element.id);
            retval.add(Video.fromSnap(element));
          }
          return retval;
        },
      ),
    );
  }

  likeVideo(String id) async {
    DocumentSnapshot doc = await firestore.collection('videos').doc(id).get();
    var uid = authController.user!.uid;
    if ((doc.data()! as dynamic)['likes'].contains(uid)) {
      await firestore.collection('videos').doc(id).update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await firestore.collection('videos').doc(id).update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }
}
