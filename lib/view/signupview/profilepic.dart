// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramclone/main.dart';
import 'package:instagramclone/widget/elevatedbtnwidget.dart';
import 'package:provider/provider.dart';

import '../../provider/searchprovider.dart';
import '../../utils/colors.dart';

class ProfilePicView extends StatefulWidget {
  const ProfilePicView({super.key});

  @override
  State<ProfilePicView> createState() => _ProfilePicViewState();
}

class _ProfilePicViewState extends State<ProfilePicView> {
  addData() {
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);

    searchProvider.setLoading(true);

    final DocumentReference documentRef =
        FirebaseFirestore.instance.collection("profile").doc(box.read('uid'));

    final Map<String, dynamic> newData = {
      'profilepic':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSghbtOf5kSt0wOk_5hB_9yYP732amHhuYDhAZisEhSaTR-5dQez3eOF3Sqga_Mu23BSVM&usqp=CAU',
    };
    documentRef.set(
      newData,
      SetOptions(merge: true),
    );
    box.write('profilepic',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSghbtOf5kSt0wOk_5hB_9yYP732amHhuYDhAZisEhSaTR-5dQez3eOF3Sqga_Mu23BSVM&usqp=CAU');

    searchProvider.setLoading(false);
  }

  XFile? singleImage;
  chooseImage() async {
    return await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  String getImageName(XFile image) {
    return image.path.split("/").last;
  }

  Future<String> uploadImage(XFile image) async {
    Reference db = FirebaseStorage.instance.ref("image/${getImageName(image)}");

    await db.putFile(File(image.path));
    return await db.getDownloadURL().then((value) async {
      final DocumentReference documentRef =
          FirebaseFirestore.instance.collection("profile").doc(box.read('uid'));

      final Map<String, dynamic> newData = {
        'profilepic': value,
      };
      box.write('profilepic', value);
      documentRef
          .set(
            newData,
            SetOptions(merge: true),
          )
          .then((value) => print('Product Edited'))
          .whenComplete(() {
        GoRouter.of(context).go('/mainview');
        print('Successfully Added');
      }).catchError((error) => print("failedtoadduser: $error"));

      return '';
    });
  }

  @override
  Widget build(BuildContext context) {
    Size sc = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? lblackclr
          : authbackgroundclr,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: sc.height * 0.15,
                ),
                Text(
                  "Add a profile picture".tr,
                  style: const TextStyle(
                      letterSpacing: 1,
                      wordSpacing: 1,
                      fontSize: 23,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: sc.height * 0.018,
                ),
                Text(
                  "Add a profile picture so that your friend know it's you. Everyone will be able to see your picture."
                      .tr,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
                SizedBox(
                  height: sc.height * 0.05,
                ),
                InkWell(
                  onTap: () async {
                    singleImage = await chooseImage();
                    if (singleImage != null && singleImage!.path.isNotEmpty) {
                      setState(() {});
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: whiteclr,
                      shape: BoxShape.circle,
                      border: Border.all(color: greyclr.withOpacity(0.4)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 0.05,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.none,
                    child: Container(
                      height: sc.height * 0.25,
                      decoration: const BoxDecoration(
                        color: greyclr,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: singleImage != null
                            ? ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(sc.height * 0.14),
                                child: Image.file(
                                  File(singleImage!.path),
                                  height: sc.height * 0.25,
                                  width: sc.height * 0.25,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(sc.height * 0.14),
                                child: Image.asset(
                                  'assets/profilepic.webp',
                                  fit: BoxFit.cover,
                                  height: sc.height * 0.25,
                                  width: sc.height * 0.25,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: sc.height * 0.14,
          ),
          const Divider(
            thickness: 0.2,
            color: greyclr,
          ),
          SizedBox(
            height: sc.height * 0.01,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ElevatedButtonWidget(
                isLoading: false,
                onPressed: () {
                  uploadImage(singleImage!);
                },
                title: "Add picture".tr,
                border: false,
                color: buttonblueclr,
                textcolor: whiteclr),
          ),
          SizedBox(
            height: sc.height * 0.02,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: ElevatedButtonWidget(
                isLoading: false,
                onPressed: () {
                  addData();
                  context.push('/mainview');
                },
                title: "Skip",
                border: true,
                color: authbackgroundclr,
                textcolor: blackclr),
          ),
        ],
      ),
    );
  }
}
