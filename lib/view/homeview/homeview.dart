import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:instagramclone/widget/homewidgets/appbarwidget.dart';
import 'package:instagramclone/widget/homewidgets/postswidget.dart';
import 'package:instagramclone/widget/homewidgets/storywidget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  CollectionReference users = FirebaseFirestore.instance.collection('test');

  Future<void> addUser() {
    return users
        .add({
          'caption': ' caption',
        })
        // ignore: avoid_print
        .then((value) => print("User Added"))
        // ignore: avoid_print
        .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        offset = controller.position.pixels;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  ScrollController controller = ScrollController();
  double offset = 0;

  @override
  Widget build(BuildContext context) {
    Size sc = MediaQuery.of(context).size;

    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          SingleChildScrollView(
            controller: controller,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: sc.height * 0.09,
                ),
                StoryWidget(),
                const Divider(
                  thickness: 0.25,
                  color: greyclr,
                ),
                const PostsWidget(),
              ],
            ),
          ),
          appbarwidget(
            offset: offset,
          ),
        ],
      ),
    ));
  }
}
