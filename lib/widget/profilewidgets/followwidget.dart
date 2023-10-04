// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/main.dart';

import '../../utils/colors.dart';

class FollowWidget extends StatefulWidget {
  final String followusername, followname, followpic;
  const FollowWidget({
    super.key,
    required this.followusername,
    required this.followname,
    required this.followpic,
  });

  @override
  State<FollowWidget> createState() => _FollowWidgetState();
}

class _FollowWidgetState extends State<FollowWidget> {
  bool isFollow = false;

  @override
  void initState() {
    super.initState();
    checkFollowStatus();
  }

  void checkFollowStatus() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return;
    }
    final snapshot = await FirebaseFirestore.instance
        .collection('following')
        .where('followusername', isEqualTo: widget.followusername)
        .where('uid', isEqualTo: box.read('uid'))
        .limit(1)
        .get();

    setState(() {
      isFollow = snapshot.docs.isNotEmpty;
    });
  }

  Future<void> unfollow() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return;
    }
    final snapshot = await FirebaseFirestore.instance
        .collection('following')
        .where('followusername', isEqualTo: widget.followusername)
        .where('uid', isEqualTo: box.read('uid'))
        .limit(1)
        .get();
    if (snapshot.docs.isNotEmpty) {
      final docId = snapshot.docs[0].id;

      await FirebaseFirestore.instance
          .collection('following')
          .doc(docId)
          .delete()
          .then((value) => print('deleted'))
          .catchError((error) => print('failed to delete: $error'));
    }
  }

  Future<void> follow() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return;
    }
    return FirebaseFirestore.instance
        .collection('following')
        .add({
          'followusername': widget.followusername,
          'followname': widget.followname,
          'followpic': widget.followpic,
          'uid': box.read('uid'),
          'name': box.read('name'),
          'username': box.read('username'),
          'profilepic': box.read('profilepic'),
        })
        .then((value) => print('following'))
        .catchError((error) {
          print('failed to follow $error');
        });
  }

  void toggleLike() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return;
    }

    setState(() {
      isFollow = !isFollow;
    });

    if (isFollow) {
      await follow();
    } else {
      await unfollow();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size sc = MediaQuery.of(context).size;
    return InkWell(
      onTap: toggleLike,
      child: Container(
        height: sc.height * 0.054,
        width: sc.width / 2.22,
        decoration: BoxDecoration(
          color: isFollow
              ? Theme.of(context).brightness == Brightness.dark
                  ? blackclr.withOpacity(0.8)
                  : lgreyclr
              : blueclr,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            isFollow == false ? "follow" : "following",
            style: TextStyle(
              fontSize: 14.5,
              color: isFollow
                  ? Theme.of(context).brightness == Brightness.dark
                      ? whiteclr
                      : blackclr.withOpacity(0.8)
                  : whiteclr,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
