import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:instagramclone/utils/utils.dart';
import 'package:instagramclone/widget/homewidgets/likebutton.dart';
import 'package:instagramclone/widget/savedwidgets/savewidget.dart';

import 'commentswidget.dart';

class PostsWidget extends StatelessWidget {
  const PostsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Stream<int> getLikeCountStream(String postId) {
      return FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('likes')
          .snapshots()
          .map((snapshot) => snapshot.size);
    }

    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .snapshots();

    Size sc = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("");
        }

        final data1 = snapshot.data!.docs;

        return AlignedGridView.count(
          shrinkWrap: true,
          itemCount: data1.length,
          physics: const ScrollPhysics(),
          crossAxisCount: 1,
          itemBuilder: (context, index) {
            var data = data1[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    var username = data['uid'];
                    context.push('/usersdetailview', extra: username);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: sc.height * 0.015,
                      bottom: sc.width * 0.01,
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
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.more_vert,
                            // color: whiteclr.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommentsWidget(
                                postid: data['postId'],
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.message_outlined,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.send_outlined,
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
                      SizedBox(
                        child: RichText(
                          text: TextSpan(
                            text: data['username'],
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            children: [
                              if (data['caption'] != null &&
                                  data['caption'].isNotEmpty)
                                TextSpan(
                                    text: '  ${data['caption']}',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }
}
