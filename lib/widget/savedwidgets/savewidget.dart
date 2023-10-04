// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/main.dart';

class SaveWidget extends StatefulWidget {
  final String username, uid, profilepic, postId, image, caption;
  const SaveWidget(
      {super.key,
      required this.username,
      required this.uid,
      required this.profilepic,
      required this.postId,
      required this.image,
      required this.caption});

  @override
  State<SaveWidget> createState() => _SaveWidgetState();
}

class _SaveWidgetState extends State<SaveWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkSaveStatus();
  }

  bool isSave = false;
  // Future<void> deletesave() async {
  //   final currentUser = FirebaseAuth.instance.currentUser;
  //   if (currentUser == null) {
  //     return;
  //   }
  //   return FirebaseFirestore.instance
  //       .collection('saved')
  //       .doc(widget.postId)
  //       .delete()
  //       .then((value) => print('deleted'))
  //       .catchError(
  //     (error) {
  //       print('failed to delete $error');
  //     },
  //   );
  // }
  Future<void> deletesave() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return;
    }

    final snapshot = await FirebaseFirestore.instance
        .collection('saved')
        .where('postId', isEqualTo: widget.postId)
        .where('hostid', isEqualTo: box.read('uid'))
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final docId = snapshot.docs[0].id;

      await FirebaseFirestore.instance
          .collection('saved')
          .doc(docId)
          .delete()
          .then((value) => print('deleted'))
          .catchError((error) => print('failed to delete: $error'));
    }
  }

  void checkSaveStatus() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return;
    }

    final snapshot = await FirebaseFirestore.instance
        .collection('saved')
        .where('postId', isEqualTo: widget.postId)
        .where('hostid', isEqualTo: box.read('uid'))
        .limit(1)
        .get();

    setState(() {
      isSave = snapshot.docs.isNotEmpty;
    });
  }

  // void checkSaveStatus() async {
  //   final currentUser = FirebaseAuth.instance.currentUser;
  //   if (currentUser == null) {
  //     return;
  //   }
  //   final snapshot = await FirebaseFirestore.instance
  //       .collection('saved')
  //       .doc(widget.postId)
  //       .get();
  //   setState(() {
  //     isSave = snapshot.exists;
  //   });
  // }

  void toggleSave() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return;
    }
    setState(() {
      isSave = !isSave;
    });
    if (isSave) {
      await adsave();
    } else {
      await deletesave();
    }
    checkSaveStatus();
  }

  Future<void> adsave() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return;
    }

    final saveDocRef = FirebaseFirestore.instance.collection('saved');

    await saveDocRef
        .add({
          'caption': widget.caption,
          'image': widget.image,
          'postId': widget.postId,
          'profilepic': widget.profilepic,
          'uid': widget.uid,
          'username': widget.username,
          'hostid': box.read('uid'),
        })
        .then((value) => print('saved'))
        .catchError((error) => print("Failed to save: $error"));
  }

  // Future<void> adsave() async {
  //   final currentUser = FirebaseAuth.instance.currentUser;
  //   if (currentUser == null) {
  //     return;
  //   }
  //   await FirebaseFirestore.instance
  //       .collection('saved')
  //       .doc(widget.postId)
  //       .set({
  //         'caption': widget.caption,
  //         'image': widget.image,
  //         'postId': widget.postId,
  //         'profilepic': widget.profilepic,
  //         'uid': widget.uid,
  //         'username': widget.username,
  //         'hostid': box.read('uid'),
  //       })
  //       .then((value) => print('saved'))
  //       .catchError((error) => print("Failed to save: $error"));
  // }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: toggleSave,
      icon: Icon(
        isSave ? Icons.bookmark : Icons.bookmark_border,
        size: 26,
      ),
    );
  }
}
