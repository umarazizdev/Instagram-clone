// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagramclone/main.dart';
import 'package:instagramclone/utils/colors.dart';

class LikeButton extends StatefulWidget {
  final String postID;

  LikeButton({required this.postID});

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    checkLikeStatus();
  }

  void checkLikeStatus() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return;
    }

    final snapshot = await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postID)
        .collection('likes')
        .doc(box.read('uid'))
        .get();

    setState(() {
      isLiked = snapshot.exists;
    });
  }

  Future<void> deleteLike() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return;
    }

    String postId = widget.postID;

    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(box.read('uid'))
        .delete()
        .then((value) => print("Like Deleted"))
        .catchError((error) => print("Failed to delete like: $error"));
  }

  Future<void> addLike() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return;
    }

    String postId = widget.postID;

    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(box.read('uid'))
        .set({
          'uid': box.read('uid'),
          'likedAt': DateTime.now(),
        })
        .then((value) => print("Like Added"))
        .catchError((error) => print("Failed to add like: $error"));
  }

  void toggleLike() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return;
    }

    setState(() {
      isLiked = !isLiked;
    });

    if (isLiked) {
      await addLike();
    } else {
      await deleteLike();
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isLiked ? Icons.favorite : Icons.favorite_border,
        color: isLiked
            ? redclr
            : Theme.of(context).brightness == Brightness.dark
                ? whiteclr
                : blackclr,
      ),
      onPressed: toggleLike,
    );
  }
}
