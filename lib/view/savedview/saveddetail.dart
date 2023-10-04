import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:instagramclone/main.dart';
import 'package:instagramclone/utils/colors.dart';

import '../../widget/savedwidgets/saveddetailwidget.dart';

class SavedDetailView extends StatefulWidget {
  const SavedDetailView({super.key});

  @override
  State<SavedDetailView> createState() => _SavedDetailViewState();
}

class _SavedDetailViewState extends State<SavedDetailView> {
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
          "All Posts",
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
            SavedDetailWidget(
              hostId: box.read('uid'),
            ),
          ],
        ),
      ),
    );
  }
}
