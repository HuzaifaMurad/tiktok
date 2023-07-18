import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok/constaints.dart';
import 'package:tiktok/controller/profile_controller.dart';

class ProfileScreen extends StatefulWidget {
  final String userid;
  const ProfileScreen({Key? key, required this.userid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController profileController = Get.put(ProfileController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileController.updateUserId(widget.userid);
    profileController.getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
        init: ProfileController(),
        builder: (controller) {
          if (controller.user.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.black12,
                leading: const Icon(
                  Icons.person_add_alt_outlined,
                ),
                actions: [const Icon(Icons.more_horiz)],
                title: Text(
                  controller.user['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipOval(
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: controller.user['profilePhoto'],
                                  height: 100,
                                  width: 100,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              socialInfo(
                                  controller.user['following'], 'following'),
                              customDivider(),
                              socialInfo(
                                  controller.user['followers'], 'follower'),
                              customDivider(),
                              socialInfo(controller.user['likes'], 'likes'),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: 140,
                            height: 47,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12),
                            ),
                            child: Center(
                              child: InkWell(
                                onTap: () {
                                  if (widget.userid ==
                                      authController.user!.uid) {
                                    authController.signOut();
                                  } else {
                                    controller.followUser();
                                  }
                                },
                                child: Text(
                                  widget.userid == authController.user!.uid
                                      ? 'Sign out'
                                      : controller.user['isFollow']
                                          ? 'UnFollow'
                                          : 'Follow',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // video list
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.user['thumbnails'].length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 1,
                                    crossAxisSpacing: 5),
                            itemBuilder: (context, index) {
                              var thumbnails =
                                  controller.user['thumbnails'][index];
                              return CachedNetworkImage(
                                imageUrl: thumbnails,
                                fit: BoxFit.cover,
                              );
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ));
        });
  }

  Container customDivider() {
    return Container(
      color: Colors.black54,
      width: 1,
      height: 15,
      margin: const EdgeInsets.symmetric(horizontal: 15),
    );
  }

  Column socialInfo(String count, String title) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
