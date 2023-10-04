import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:instagramclone/main.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:instagramclone/utils/utils.dart';
import 'package:instagramclone/widget/profilewidgets/menuwidget.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key, required this.uname});
  final String uname;
  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  Stream<int> getFollowerCount(String followusername) {
    return FirebaseFirestore.instance
        .collection('following')
        .where('followusername', isEqualTo: followusername)
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('profile')
                  .where(
                    "username",
                    isEqualTo: box.read('username'),
                  )
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {}
                if (snapshot.connectionState == ConnectionState.waiting) {}
                if (snapshot.hasData) {
                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .where('username', isEqualTo: box.read('username'))
                        .snapshots(),
                    builder: (context, innerSnapshot) {
                      if (innerSnapshot.hasError) {}

                      if (innerSnapshot.connectionState ==
                          ConnectionState.waiting) {}

                      if (innerSnapshot.hasData) {
                        return AlignedGridView.count(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemCount: 1,
                          crossAxisCount: 1,
                          itemBuilder: (context, index) {
                            var postCount = innerSnapshot.data!.size;
                            var data = snapshot.data!.docs[index];

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 15,
                                    right: 8,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        data['username'],
                                        style: const TextStyle(
                                          fontSize: 21.5,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        onPressed: () {
                                          context.push('/adddataview');
                                        },
                                        icon: Container(
                                          height: sc.height * 0.033,
                                          width: sc.width * 0.0605,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            border: Border.all(
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? whiteclr
                                                    : blackclr,
                                                width: 1.4),
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Icons.add,
                                              size: 18,
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? whiteclr
                                                  : blackclr,
                                            ),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          showModalBottomSheet(
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(35)),
                                            ),
                                            context: context,
                                            builder: (BuildContext context) {
                                              return const MenuWidget();
                                            },
                                          );
                                        },
                                        icon: Icon(
                                          Icons.menu,
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                      Column(
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
                                      ),
                                      InkWell(
                                        onTap: () {
                                          var dat = data['username'];
                                          context.push('/followerswidget',
                                              extra: dat);
                                        },
                                        child: Column(
                                          children: [
                                            StreamBuilder<int>(
                                              stream: getFollowerCount(
                                                  data['username']),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<int> snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const Text('');
                                                } else if (snapshot.hasError) {
                                                  return Text(
                                                      'Error: ${snapshot.error}');
                                                } else {
                                                  int followersCount =
                                                      snapshot.data ?? 0;
                                                  return Text(
                                                    '$followersCount',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                      // 18.pw,
                                      InkWell(
                                        onTap: () {
                                          var usname = data['username'];
                                          context.push('/followingwidget',
                                              extra: usname);
                                        },
                                        child: Column(
                                          children: [
                                            StreamBuilder<int>(
                                              stream: getFollowingCount(
                                                  data['username']),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<int> snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const Text('');
                                                } else if (snapshot.hasError) {
                                                  return Text(
                                                      'Error: ${snapshot.error}');
                                                } else {
                                                  int followingCount =
                                                      snapshot.data ?? 0;
                                                  return Text(
                                                    '$followingCount',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                  padding: const EdgeInsets.only(
                                      bottom: 8.0, left: 17, right: 17),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data['name'],
                                        style: const TextStyle(
                                            fontSize: 14.5,
                                            fontWeight: FontWeight.w500),
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
                              ],
                            );
                          },
                        );
                      }

                      return Container();
                    },
                  );
                }

                return Container();
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      context.push('/editprofileview');
                    },
                    child: InkWell(
                      onTap: () {
                        context.push('/editprofileview');
                      },
                      child: Container(
                        height: sc.height * 0.054,
                        width: sc.width / 2.22,
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? blackclr.withOpacity(0.8)
                              : lgreyclr,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            "Edit Profile",
                            style: TextStyle(
                                fontSize: 14.5, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: sc.height * 0.054,
                    width: sc.width / 2.22,
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? blackclr.withOpacity(0.8)
                          : lgreyclr,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        "Share Profile",
                        style: TextStyle(
                            fontSize: 14.5, fontWeight: FontWeight.w500),
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
                    isEqualTo: box.read('uid'),
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
                return AlignedGridView.count(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  crossAxisCount: 3,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var data = snapshot.data!.docs[index];
                    return InkWell(
                      onTap: () {
                        var usname = data['uid'];
                        context.push('/postdetailview', extra: usname);
                      },
                      child: Container(
                        height: sc.height * 0.19,
                        width: sc.width * 0.343,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              data['image'],
                            ),
                          ),
                          border: Border.all(
                            color: whiteclr,
                            width: 0.8,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
