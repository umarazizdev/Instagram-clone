import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagramclone/utils/utils.dart';
import 'package:instagramclone/widget/homewidgets/likebutton.dart';
import 'package:instagramclone/widget/savedwidgets/savewidget.dart';

import '../../utils/colors.dart';

class SavedDetailWidget extends StatefulWidget {
  final String hostId;
  const SavedDetailWidget({
    super.key,
    required this.hostId,
  });

  @override
  State<SavedDetailWidget> createState() => _SavedDetailWidgetState();
}

class _SavedDetailWidgetState extends State<SavedDetailWidget> {
  Stream<int> getLikeCountStream(String postId) {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .snapshots()
        .map((snapshot) => snapshot.size);
  }

  @override
  Widget build(BuildContext context) {
    Size sc = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('saved')
          .where('hostid', isEqualTo: widget.hostId)
          .snapshots(),
      builder: (context, innerSnapshot) {
        if (innerSnapshot.hasError) {}

        if (innerSnapshot.connectionState == ConnectionState.waiting) {}

        if (innerSnapshot.hasData) {
          return AlignedGridView.count(
            shrinkWrap: true,
            itemCount: innerSnapshot.data!.docs.length,
            physics: const ScrollPhysics(),
            crossAxisCount: 1,
            itemBuilder: (context, index) {
              var data = innerSnapshot.data!.docs[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: sc.height * 0.015,
                      bottom: sc.width * 0.0275,
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: sc.height * 0.051,
                          width: sc.width * 0.0935,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                data['profilepic'],
                              ),
                            ),
                            color: blueclr,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(
                          width: sc.width * 0.022,
                        ),
                        Text(
                          data['username'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            // color: whiteclr.withOpacity(0.7),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.more_vert,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? whiteclr
                                    : blackclr,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: sc.height * 0.65,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: greyclr,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          data['image'],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 2.0,
                    ),
                    child: Row(
                      children: [
                        LikeButton(
                          postID: data['postId'],
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.message_outlined,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? whiteclr
                                    : blackclr,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.send_outlined,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? whiteclr
                                    : blackclr,
                          ),
                        ),
                        const Spacer(),
                        SaveWidget(
                          username: data['username'],
                          uid: data['uid'],
                          profilepic: data['profilepic'],
                          postId: data['postId'],
                          image: data['image'],
                          caption: data['caption'],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: sc.width * 0.0275,
                      right: sc.width * 0.0275,
                      bottom: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StreamBuilder<int>(
                          stream: getLikeCountStream(data.id),
                          builder: (BuildContext context,
                              AsyncSnapshot<int> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Text('');
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              int likeCount = snapshot.data ?? 0;
                              return Text(
                                '$likeCount Likes',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                          },
                        ),

                        2.ph,
                        Container(
                          child: RichText(
                            text: TextSpan(
                              text: data['username'],
                              style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? whiteclr
                                    : blackclr,
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                if (data['caption'] != null &&
                                    data['caption'].isNotEmpty)
                                  TextSpan(
                                    text: '  ${data['caption']}',
                                    style: TextStyle(
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? whiteclr
                                          : blackclr,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),

                        // Row(
                        //   children: [
                        //     Text(
                        //       data['username'],
                        //       style: const TextStyle(
                        //         fontWeight: FontWeight.bold,
                        //       ),
                        //     ),
                        //     6.pw,
                        //     Flexible(
                        //       child: Text(
                        //         data['caption'],
                        //       ),
                        //     ),
                        //   ],
                        // ),

                        // 2.ph,
                        // const Text(
                        //   "View all comments",
                        //   style: TextStyle(color: greyclr),
                        // ),
                        // 8.ph,
                        // Row(
                        //   children: [
                        //     Container(
                        //       height: 34,
                        //       width: 34,
                        //       decoration: const BoxDecoration(
                        //         color: blueclr,
                        //         shape: BoxShape.circle,
                        //       ),
                        //     ),
                        //     8.pw,
                        //     Expanded(
                        //       child: TextFormField(
                        //         decoration: const InputDecoration(
                        //           hintText: "Add a comment...",
                        //           enabledBorder: InputBorder.none,
                        //           focusedBorder: InputBorder.none,
                        //           hintStyle: TextStyle(
                        //             color: greyclr,
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  )
                ],
              );
            },
          );
        }

        return Container();
      },
    );
  }
}
