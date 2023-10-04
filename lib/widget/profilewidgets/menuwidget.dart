import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:instagramclone/main.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:instagramclone/utils/utils.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size sc = MediaQuery.of(context).size;
    return DraggableScrollableSheet(
      initialChildSize: 1,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: const BoxDecoration(
            // color: whiteclr,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(5),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 4,
                      width: 35,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: sc.height * 0.025,
                ),
                TextButton(
                  onPressed: () {
                    context.push('/darktheme');
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.mode_night_outlined,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? whiteclr
                            : blackclr,
                      ),
                      12.pw,
                      Text(
                        "Dark Mode",
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? whiteclr
                              : blackclr,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    final auth = FirebaseAuth.instance.signOut();
                    box.write('islogin', false);
                    context.push('/login');
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? whiteclr
                            : blackclr,
                      ),
                      12.pw,
                      Text(
                        "Logout",
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? whiteclr
                              : blackclr,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.push('/savedview');
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.bookmark_border,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? whiteclr
                            : blackclr,
                      ),
                      12.pw,
                      Text(
                        "Saved",
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? whiteclr
                              : blackclr,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
