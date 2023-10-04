import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:instagramclone/widget/profilewidgets/postsdetailwidget.dart';

class PostDetailView extends StatefulWidget {
  final String usname;
  const PostDetailView({super.key, required this.usname});

  @override
  State<PostDetailView> createState() => _PostDetailViewState();
}

class _PostDetailViewState extends State<PostDetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).brightness == Brightness.dark
                  ? whiteclr
                  : blackclr,
            )),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? blackclr
            : whiteclr,
        elevation: 0,
        title: Text(
          "Posts",
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? whiteclr
                : blackclr,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            PostsDetailWidget(
              uname: widget.usname,
            ),
          ],
        ),
      ),
    );
  }
}
