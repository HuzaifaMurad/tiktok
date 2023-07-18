import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok/constaints.dart';

import '../modals/user.dart';

class SearchControllers extends GetxController {
  final Rx<List<User>> _searchUsers = Rx<List<User>>([]);

  List<User> get searchUser {
    return _searchUsers.value;
  }

  searchUsers(String typedUser) async {
    _searchUsers.bindStream(
      firestore
          .collection('users')
          .where('name', isEqualTo: typedUser)
          .snapshots()
          .map(
        (QuerySnapshot querySnapshot) {
          List<User> retVal = [];
          for (var element in querySnapshot.docs) {
            retVal.add(User.fromSnap(element));
          }
          return retVal;
        },
      ),
    );
  }
}
