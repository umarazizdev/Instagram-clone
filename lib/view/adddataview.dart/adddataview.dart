import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:instagramclone/utils/utils.dart';

import '../../main.dart';

class AddDataView extends StatefulWidget {
  const AddDataView({super.key});

  @override
  State<AddDataView> createState() => _AddDataViewState();
}

class _AddDataViewState extends State<AddDataView> {
  TextEditingController captioncontroller = TextEditingController();

  CollectionReference users = FirebaseFirestore.instance.collection('posts');
  XFile? singleImage;

  chooseImage() async {
    return await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  String getImageName(XFile image) {
    return image.path.split("/").last;
  }

  Future<String> uploadImage(XFile image) async {
    Reference storageRef =
        FirebaseStorage.instance.ref("image/${getImageName(image)}");

    await storageRef.putFile(File(image.path));
    String imageUrl = await storageRef.getDownloadURL();

    DocumentReference newPostRef = users.doc();

    String postId = newPostRef.id;

    await newPostRef.set({
      'postId': postId,
      'image': imageUrl,
      'username': box.read('username'),
      'profilepic': box.read('profilepic'),
      'caption': captioncontroller.text,
      'likes': "",
      'timestamp': FieldValue.serverTimestamp(),
      'star1': 0,
      'star2': 0,
      'star3': 0,
      'star4': 0,
      'star5': 0,
      'publish': false,
      'uid': box.read('uid')
    });

    box.write('postId', postId);
    EasyLoading.showSuccess("Post Added");
    // context.push('/home');
    return postId;
  }

  @override
  Widget build(BuildContext context) {
    Size sc = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      context.pop();
                    },
                    icon: const Icon(
                      Icons.close,
                      size: 28,
                      color: blackclr,
                    ),
                  ),
                  30.pw,
                  const Text(
                    "New post",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      uploadImage(singleImage!);
                      EasyLoading.show();
                    },
                    icon: const Icon(
                      Icons.arrow_forward,
                      size: 28,
                      color: blueclr,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () async {
                  singleImage = await chooseImage();
                  if (singleImage != null && singleImage!.path.isNotEmpty) {
                    setState(() {});
                  }
                },
                child: SizedBox(
                  height: sc.height / 1.7,
                  width: sc.width,
                  child: Center(
                    child: singleImage != null
                        ? ClipRRect(
                            child: Image.file(
                              File(singleImage!.path),
                              height: sc.height / 1.7,
                              width: sc.width,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Image.asset(
                            'assets/profilepic.webp',
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  controller: captioncontroller,
                  cursorColor: greyclr,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: "Add Caption....",
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
