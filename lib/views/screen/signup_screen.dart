import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok/views/screen/login_screen.dart';

import '../../constaints.dart';
import '../widgets/text_input.dart';

class SignUp extends StatelessWidget {
  SignUp({Key? key}) : super(key: key);
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black87,
                    Colors.black45,
                    Colors.transparent,
                  ],
                  stops: [0, 0.25, 1],
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/background.jpg'),
                    fit: BoxFit.cover),
              ),
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    color: Colors.grey.withOpacity(0.1),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'E X P L O R E',
                          style: TextStyle(
                              color: kButtonColor!,
                              fontSize: 35,
                              fontWeight: FontWeight.w900),
                        ),
                        const Text(
                          'Signup',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Stack(
                          children: [
                            const CircleAvatar(
                              backgroundImage: NetworkImage(
                                  'https://cdn-icons-png.flaticon.com/512/206/206881.png'),
                              backgroundColor: Colors.transparent,
                              radius: 45,
                            ),
                            Positioned(
                              bottom: -10,
                              left: 50,
                              child: IconButton(
                                onPressed: () {
                                  log('picking..');
                                  authController.pickImage();
                                },
                                icon: Icon(
                                  Icons.add_a_photo,
                                  color: Colors.teal[50],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextInputField(
                            controller: _usernameController,
                            title: 'Username',
                            icon: Icons.email,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextInputField(
                            controller: _emailController,
                            title: 'Email',
                            icon: Icons.email,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextInputField(
                            controller: _passwordController,
                            title: 'Password',
                            icon: Icons.lock,
                            isObsecure: true,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 40,
                          height: 50,
                          decoration: BoxDecoration(
                            color: kButtonColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: InkWell(
                            onTap: () => authController.registerUser(
                              username: _usernameController.text,
                              password: _passwordController.text,
                              email: _emailController.text,
                              image: authController.profilePhoto,
                            ),
                            child: const Center(
                              child: Text(
                                'Signup',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an account? ",
                              style: TextStyle(fontSize: 20),
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(LoginScreen());
                              },
                              child: Text(
                                "Login. ",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: kButtonColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
