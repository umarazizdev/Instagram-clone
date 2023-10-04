import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/main.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:instagramclone/view/chatview/inboxview/inbox.dart';

class appbarwidget extends StatelessWidget {
  final double offset;

  const appbarwidget({
    super.key,
    required this.offset,
  });
  Future<bool> checkUserExists(String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('profile')
        .doc(userId)
        .get();

    return snapshot.exists;
  }

  @override
  Widget build(BuildContext context) {
    Size sc = MediaQuery.of(context).size;
    return Positioned(
      top: -offset / 3,
      child: Container(
        color: Theme.of(context).brightness == Brightness.dark
            ? blackclr
            : whiteclr,
        height: sc.height * 0.09,
        width: sc.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          // padding: EdgeInsets.symmetric(horizontal: sc.width * 0.041),
          child: Row(
            children: [
              // Theme.of(context).brightness == Brightness.dark
              //     ? Image.network(
              //         'https://www.edigitalagency.com.au/wp-content/uploads/instagram-logo-white-text-black-background.png',
              //         height: 40,
              //       )
              //     : Image.asset(
              //         'assets/logo/iglogoappbar.png',
              //         height: 40,
              //         // height: sc.height * 0.062,
              //       ),
              Image.asset(
                Theme.of(context).brightness == Brightness.dark
                    ? "assets/logo/iglogoappbarwhiteclr.png"
                    : 'assets/logo/iglogoappbar.png',
                height: 40,
                // height: sc.height * 0.062,
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.favorite_outline,
                  size: 26,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Inbox(
                          currentUserID: box.read('uid'),
                        );
                      },
                    ),
                  );
                },
                icon: const Icon(
                  Icons.send_outlined,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
