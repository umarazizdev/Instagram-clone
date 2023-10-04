import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:instagramclone/main.dart';
import 'package:instagramclone/utils/utils.dart';

import '../../utils/colors.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class CommentsWidget extends StatelessWidget {
  final String postid;
  CommentsWidget({super.key, required this.postid});
  var message = TextEditingController();
  CollectionReference messageStream =
      FirebaseFirestore.instance.collection('posts');
  CollectionReference chatStream =
      FirebaseFirestore.instance.collection('posts');

  users() {
    messageStream.doc(postid).collection('comments').doc().set(
      {
        'message': message.text,
        'time': DateTime.now(),
        'id': box.read('uid'),
        'profilepic': box.read('profilepic'),
        'username': box.read('username'),
        'createdAt': Timestamp.now(),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String formatTimeAgo(DateTime messageTime) {
      Duration difference = DateTime.now().difference(messageTime);
      if (difference.inSeconds < 60) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
      } else {
        return DateFormat('dd MMM').format(messageTime);
      }
    }

    Size sc = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor:
          Theme.of(context).brightness == Brightness.dark ? blackclr : whiteclr,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: sc.height * 0.045,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 4, left: 2),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    context.pop();
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                Text(
                  "Comments",
                  style: TextStyle(
                    fontSize: 21.5,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? whiteclr
                        : blackclr,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // const Spacer(),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .doc(postid)
                .collection('comments')
                .orderBy('createdAt', descending: false)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text("something is wrong");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 1,
                    color: blueclr,
                  ),
                );
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  // reverse: true,
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final data = snapshot.data!.docs;

                    Timestamp t = data[index]['time'];
                    DateTime messageTime = t.toDate();

                    String timeAgo = formatTimeAgo(messageTime);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        child: Row(
                          children: [
                            SizedBox(
                              width:
                                  box.read('uid') == data[index]['id'] ? 30 : 0,
                            ),
                            CircleAvatar(
                              foregroundImage: NetworkImage(
                                data[index]['profilepic'],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      var username = data[index]['id'];
                                      context.push('/usersdetailview',
                                          extra: username);
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          data[index]['username'],
                                          style: const TextStyle(
                                              fontSize: 14.5,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        5.pw,
                                        Text(
                                          // d.hour.toString() +
                                          //     ":" +
                                          //     d.minute.toString(),
                                          timeAgo,
                                          style: const TextStyle(
                                              fontSize: 12, color: greyclr),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    data[index]['message'],
                                    style: const TextStyle(
                                      fontSize: 14.5,
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
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? whiteclr
                          : greyclr.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextFormField(
                      controller: message,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            if (message.text.isNotEmpty) {
                              users();
                              message.clear();
                            }
                          },
                          icon: const Icon(
                            Icons.send_sharp,
                            color: blueclr,
                          ),
                        ),
                        labelText: 'Enter message',
                        labelStyle: const TextStyle(fontSize: 13.5),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        hintStyle: const TextStyle(fontSize: 13.5),
                        contentPadding: const EdgeInsets.only(
                            left: 14.0, bottom: 8.0, top: 8.0),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {},
                      onSaved: (value) {
                        message.text = value!;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
