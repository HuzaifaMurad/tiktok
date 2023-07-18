// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok/controller/search_controller.dart';
import 'package:tiktok/modals/user.dart';
import 'package:tiktok/views/screen/profile_screen.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);
  SearchControllers searchController = Get.put(SearchControllers());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red[200],
          title: TextFormField(
            decoration: const InputDecoration(
              filled: false,
              hintText: 'Search',
              hintStyle: TextStyle(fontSize: 19, color: Colors.white),
            ),
            onFieldSubmitted: (value) => searchController.searchUsers(value),
          ),
        ),
        body: searchController.searchUser.isEmpty
            ? const Center(
                child: Text(
                  'Search for User',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: searchController.searchUser.length,
                itemBuilder: (context, index) {
                  User user = searchController.searchUser[index];
                  return InkWell(
                    onTap: () {
                      Get.to(ProfileScreen(userid: user.uid));
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user.profilePhoto),
                      ),
                      title: Text(
                        user.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  );
                },
              ),
      );
    });
  }
}
