import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:instagramclone/utils/utils.dart';
import 'package:instagramclone/widget/profilewidgets/followwidget.dart';

class UsersDetailView extends StatefulWidget {
  final String documentId;
  const UsersDetailView({super.key, required this.documentId});

  @override
  State<UsersDetailView> createState() => _UsersDetailViewState();
}

class _UsersDetailViewState extends State<UsersDetailView> {
  CollectionReference users = FirebaseFirestore.instance.collection('profile');
  Stream<int> getFollowerCount(String followid) {
    return FirebaseFirestore.instance
        .collection('following')
        .where('followusername', isEqualTo: followid)
        .snapshots()
        .map((snapshot) => snapshot.size);
  }

  Stream<int> getFollowingCount(String followid) {
    return FirebaseFirestore.instance
        .collection('following')
        .where('username', isEqualTo: followid)
        .snapshots()
        .map((snapshot) => snapshot.size);
  }

  @override
  Widget build(BuildContext context) {
    Size sc = MediaQuery.of(context).size;
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(widget.documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
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
                          data['username'],
                          style: const TextStyle(
                            fontSize: 21.5,
                            fontWeight: FontWeight.bold,
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
                            size: 27,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: sc.height * 0.125,
                          width: sc.width * 0.206,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                data['profilepic'],
                              ),
                            ),
                            border: Border.all(color: greyclr),
                            color: whiteclr,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Expanded(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('posts')
                                .where('uid', isEqualTo: data['uid'])
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> innerSnapshot) {
                              if (snapshot.hasError) {
                                return const Text('Something went wrong');
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Text("");
                              }
                              var postCount = innerSnapshot.data?.size ?? 0;

                              return Column(
                                children: [
                                  Text(
                                    postCount.toString(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  4.ph,
                                  const Text(
                                    "Posts",
                                    style: TextStyle(
                                      fontSize: 14.5,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            var dat = data['username'];
                            context.push('/followerswidget', extra: dat);
                          },
                          child: Column(
                            children: [
                              StreamBuilder<int>(
                                stream: getFollowerCount(data['username']),
                                builder: (BuildContext context,
                                    AsyncSnapshot<int> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Text('');
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    int followersCount = snapshot.data ?? 0;
                                    return Text(
                                      '$followersCount',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    );
                                  }
                                },
                              ),
                              4.ph,
                              const Text(
                                "Followers",
                                style: TextStyle(
                                  fontSize: 14.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        18.pw,
                        InkWell(
                          onTap: () {
                            var usname = data['username'];
                            context.push('/followingwidget', extra: usname);
                          },
                          child: Column(
                            children: [
                              StreamBuilder<int>(
                                stream: getFollowingCount(data['username']),
                                builder: (BuildContext context,
                                    AsyncSnapshot<int> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Text('');
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    int followingCount = snapshot.data ?? 0;
                                    return Text(
                                      '$followingCount',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    );
                                  }
                                },
                              ),
                              4.ph,
                              const Text(
                                "Following",
                                style: TextStyle(
                                  fontSize: 14.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 8.0, left: 17, right: 17),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['name'],
                          style: const TextStyle(
                              fontSize: 14.5, fontWeight: FontWeight.w500),
                        ),
                        2.ph,
                        Text(
                          data['bio'],
                          style: const TextStyle(
                            fontSize: 14.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FollowWidget(
                          followusername: data['username'],
                          followname: data['name'],
                          followpic: data['profilepic'],
                        ),
                        Container(
                          height: sc.height * 0.054,
                          width: sc.width / 2.22,
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? blackclr
                                    : lgreyclr,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              "Message",
                              style: TextStyle(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? whiteclr
                                      : blackclr,
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .where(
                          "uid",
                          isEqualTo: data['uid'],
                        )
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return InkWell(
                        onTap: () {
                          var uname = data['uid'];
                          context.push('/postdetailview', extra: uname);
                        },
                        child: AlignedGridView.count(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          crossAxisCount: 3,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var data2 = snapshot.data!.docs[index];
                            return Container(
                              height: sc.height * 0.19,
                              width: sc.width * 0.343,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    data2['image'],
                                  ),
                                ),
                                border: Border.all(
                                  color: whiteclr,
                                  width: 0.8,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
