import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramclone/utils/utils.dart';
import 'package:instagramclone/widget/textformfieldwidget.dart';

import '../../main.dart';
import '../../utils/colors.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  Future<Map<String, dynamic>> fetchInitialValuesFromFirestore() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('profile')
          .doc(box.read('uid'))
          .get();
      if (snapshot.exists) {
        var data = snapshot.data();
        return {
          'name': data!['name'],
          'username': data['username'],
          'bio': data['bio'],
        };
      } else {
        return {
          'name': '',
          'username': '',
          'bio': '',
        };
      }
    } catch (e) {
      print('Error fetching initial values: $e');
      return {
        'name': '',
        'username': '',
        'bio': '',
      };
    }
  }

  nameupdate() {
    final DocumentReference documentRef =
        FirebaseFirestore.instance.collection("profile").doc(box.read('uid'));

    final Map<String, dynamic> newData = {
      'name': _textEditingController.text,
    };
    documentRef.set(
      newData,
      SetOptions(merge: true),
    );
  }

  usernameupdate() async {
    final CollectionReference postCollectionRef =
        FirebaseFirestore.instance.collection("posts");

    final QuerySnapshot querySnapshot =
        await postCollectionRef.where('uid', isEqualTo: box.read('uid')).get();

    final List<DocumentSnapshot> documents = querySnapshot.docs;
    if (documents.isNotEmpty) {
      final DocumentSnapshot document1 = documents.first;
      final DocumentReference documentRef1 = document1.reference;

      final Map<String, dynamic> newData1 = {
        'username': _username.text,
      };

      await documentRef1.set(
        newData1,
        SetOptions(merge: true),
      );
      box.write('username', _username.text);
    }

    final DocumentReference documentRef =
        FirebaseFirestore.instance.collection("profile").doc(box.read('uid'));
    final Map<String, dynamic> newData = {
      'username': _username.text,
    };
    documentRef.set(
      newData,
      SetOptions(merge: true),
    );
  }

  bioupdate() {
    final DocumentReference documentRef =
        FirebaseFirestore.instance.collection("profile").doc(box.read('uid'));

    final Map<String, dynamic> newData = {
      'bio': _bio.text,
    };
    documentRef.set(
      newData,
      SetOptions(merge: true),
    );
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
      final CollectionReference postCollectionRef =
          FirebaseFirestore.instance.collection("posts");

      final QuerySnapshot querySnapshot = await postCollectionRef
          .where('uid', isEqualTo: box.read('uid'))
          .get();

      final List<DocumentSnapshot> documents = querySnapshot.docs;
      if (documents.isNotEmpty) {
        final DocumentSnapshot document1 = documents.first;
        final DocumentReference documentRef1 = document1.reference;

        final Map<String, dynamic> newData1 = {
          'profilepic': value,
        };

        await documentRef1.set(
          newData1,
          SetOptions(merge: true),
        );
      }

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
          .then((value) {
        EasyLoading.showToast("Photo edited");
      }).whenComplete(() {
        context.pop();
      }).catchError((error) {
        EasyLoading.showToast("Failed $error");
      });

      return '';
    });
  }

  Stream<QuerySnapshot>? _stream;
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _bio = TextEditingController();
  @override
  void initState() {
    super.initState();
    fetchInitialValuesFromFirestore().then((value) {
      setState(() {
        _textEditingController.text = value['name'];
        _bio.text = value['bio'];
        _username.text = value['username'];
      });
    });
    // _startListening();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _bio.dispose();
    _username.dispose();
    super.dispose();
  }

  void _startListening() {
    _stream = FirebaseFirestore.instance
        .collection('profile')
        .where('uid', isEqualTo: box.read('uid'))
        .snapshots();
  }

  void _stopListening() {
    setState(() {
      _stream = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance
        .collection('profile')
        .where('uid', isEqualTo: box.read('uid'))
        .snapshots();

    Size sc = MediaQuery.of(context).size;
    return SafeArea(
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
                  "Edit profile",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    if (singleImage != null) {
                      uploadImage(singleImage!);
                    }
                    EasyLoading.show();
                    nameupdate();
                    usernameupdate();
                    bioupdate();
                  },
                  icon: const Icon(
                    Icons.check,
                    size: 28,
                    color: blueclr,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: usersStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox(
                          height: sc.height * 0.25,
                        );
                      }
                      return AlignedGridView.count(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        crossAxisCount: 1,
                        itemBuilder: (context, index) {
                          var data = snapshot.data!.docs[index];
                          return Column(
                            children: [
                              SizedBox(
                                height: sc.height * 0.03,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        singleImage = await chooseImage();
                                        if (singleImage != null &&
                                            singleImage!.path.isNotEmpty) {
                                          setState(() {});
                                        }
                                      },
                                      child: Container(
                                        height: sc.height * 0.18,
                                        width: sc.width * 0.325,
                                        decoration: BoxDecoration(
                                          // image: DecorationImage(
                                          //   fit: BoxFit.cover,
                                          //   image: NetworkImage(
                                          //     data['profilepic'],
                                          //   ),
                                          // ),
                                          border: Border.all(color: greyclr),
                                          color: whiteclr,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: singleImage != null
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          sc.height * 0.14),
                                                  child: Image.file(
                                                    File(singleImage!.path),
                                                    height: sc.height * 0.18,
                                                    width: sc.width * 0.325,
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                              : ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          sc.height * 0.14),
                                                  child: Image.network(
                                                    data['profilepic'],
                                                    fit: BoxFit.cover,
                                                    height: sc.height * 0.18,
                                                    width: sc.width * 0.325,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: sc.height * 0.015,
                                    ),
                                    const Text(
                                      "Edit picture",
                                      style: TextStyle(
                                        color: blueclr,
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  // StreamBuilder<QuerySnapshot>(
                  //   stream: _stream,
                  //   builder:
                  //       (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  //     if (snapshot.hasError) {
                  //       return Text('Something went wrong');
                  //     }
                  //     if (snapshot.connectionState == ConnectionState.waiting) {
                  //       return const Text('');
                  //     }
                  //     if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                  //       return Text('No data available');

                  //     }

                  //     return AlignedGridView.count(
                  //       shrinkWrap: true,
                  //       physics: const ScrollPhysics(),
                  //       itemCount: snapshot.data!.docs.length,
                  //       crossAxisCount: 1,
                  //       itemBuilder: (context, index) {
                  //         var data = snapshot.data!.docs[index];
                  //         return Column(
                  //           children: [
                  //             Row(
                  //               children: [
                  //                 IconButton(
                  //                   onPressed: () {
                  //                     context.pop();
                  //                   },
                  //                   icon: const Icon(
                  //                     Icons.close,
                  //                     size: 28,
                  //                     color: blackclr,
                  //                   ),
                  //                 ),
                  //                 30.pw,
                  //                 const Text(
                  //                   "Edit profile",
                  //                   style: TextStyle(
                  //                     fontSize: 20,
                  //                     fontWeight: FontWeight.bold,
                  //                   ),
                  //                 ),
                  //                 const Spacer(),
                  //                 IconButton(
                  //                   onPressed: () {
                  //                     if (singleImage != null) {
                  //                       uploadImage(singleImage!);
                  //                     }
                  //                     EasyLoading.show();
                  //                     nameupdate();
                  //                     usernameupdate();
                  //                     bioupdate();
                  //                   },
                  //                   icon: const Icon(
                  //                     Icons.check,
                  //                     size: 28,
                  //                     color: blueclr,
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //             SizedBox(
                  //               height: sc.height * 0.03,
                  //             ),
                  //             Padding(
                  //               padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  //               child: Column(
                  //                 crossAxisAlignment: CrossAxisAlignment.center,
                  //                 children: [
                  //                   InkWell(
                  //                     onTap: () async {
                  //                       singleImage = await chooseImage();
                  //                       if (singleImage != null &&
                  //                           singleImage!.path.isNotEmpty) {
                  //                         setState(() {});
                  //                       }
                  //                     },
                  //                     child: Container(
                  //                       height: sc.height * 0.18,
                  //                       width: sc.width * 0.325,
                  //                       decoration: BoxDecoration(
                  //                         // image: DecorationImage(
                  //                         //   fit: BoxFit.cover,
                  //                         //   image: NetworkImage(
                  //                         //     data['profilepic'],
                  //                         //   ),
                  //                         // ),
                  //                         border: Border.all(color: greyclr),
                  //                         color: whiteclr,
                  //                         shape: BoxShape.circle,
                  //                       ),
                  //                       child: Center(
                  //                         child: singleImage != null
                  //                             ? ClipRRect(
                  //                                 borderRadius: BorderRadius.circular(
                  //                                     sc.height * 0.14),
                  //                                 child: Image.file(
                  //                                   File(singleImage!.path),
                  //                                   height: sc.height * 0.18,
                  //                                   width: sc.width * 0.325,
                  //                                   fit: BoxFit.cover,
                  //                                 ),
                  //                               )
                  //                             : ClipRRect(
                  //                                 borderRadius: BorderRadius.circular(
                  //                                     sc.height * 0.14),
                  //                                 child: Image.network(
                  //                                   data['profilepic'],
                  //                                   fit: BoxFit.cover,
                  //                                   height: sc.height * 0.18,
                  //                                   width: sc.width * 0.325,
                  //                                 ),
                  //                               ),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                   SizedBox(
                  //                     height: sc.height * 0.015,
                  //                   ),
                  //                   const Text(
                  //                     "Edit picture",
                  //                     style: TextStyle(
                  //                       color: blueclr,
                  //                       fontSize: 13.5,
                  //                       fontWeight: FontWeight.w500,
                  //                     ),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //           ],
                  //         );
                  //       },
                  //     );
                  //   },
                  // ),

                  SizedBox(
                    height: sc.height * 0.02,
                  ),
                  TextFormField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      // hintText: data['name'],
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: greyclr.withOpacity(0.6)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: greyclr.withOpacity(0.6),
                        ),
                      ),
                    ),
                    onChanged: (value) {},
                  ),
                  SizedBox(
                    height: sc.height * 0.02,
                  ),
                  TextFormField(
                    controller: _username,
                    onTap: () {},
                    decoration: InputDecoration(
                      labelText: 'Username',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      // hintText: data['username'],
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: greyclr.withOpacity(0.6)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: greyclr.withOpacity(0.6),
                        ),
                      ),
                    ),
                    onChanged: (value) {},
                  ),
                  SizedBox(
                    height: sc.height * 0.02,
                  ),
                  TextFormField(
                    controller: _bio,
                    decoration: InputDecoration(
                      labelText: 'Bio',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      // hintText: data['bio'],
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: greyclr.withOpacity(0.6)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: greyclr.withOpacity(0.6),
                        ),
                      ),
                    ),
                    onChanged: (value) {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
