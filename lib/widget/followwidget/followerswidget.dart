// ignore_for_file: avoid_print, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:instagramclone/utils/utils.dart';

import '../../utils/colors.dart';
import '../../view/searchview.dart/followwidget.dart';

class FollowersWidget extends StatefulWidget {
  final String dat;
  const FollowersWidget({
    super.key,
    required this.dat,
  });

  @override
  State<FollowersWidget> createState() => _FollowersWidgetState();
}

class _FollowersWidgetState extends State<FollowersWidget> {
  String activecat = '';
  final searchCon = TextEditingController();

  List<DocumentSnapshot> searchRes = [];

  void performSear() {
    final query = searchCon.text.trim();
    FirebaseFirestore.instance
        .collection('following')
        .where('username', isEqualTo: widget.dat)
        .orderBy('followusername')
        .startAt([query])
        .endAt([query + '\uf8ff'])
        .limit(10)
        .get()
        .then((QuerySnapshot querySnapshot) {
          setState(() {
            searchRes = querySnapshot.docs;
          });
        })
        .catchError((error) {
          print('Error performing search: $error');
        });
  }

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

  final searchController = TextEditingController();

  List<DocumentSnapshot> searchResults = [];

  @override
  void dispose() {
    searchController.dispose();
    searchCon.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    activecat = 'followers';
  }

  void performSearch() {
    final query = searchController.text.trim();
    FirebaseFirestore.instance
        .collection('following')
        .where('followusername', isEqualTo: widget.dat)
        .orderBy('username')
        .startAt([query])
        .endAt([query + '\uf8ff'])
        .limit(10)
        .get()
        .then((QuerySnapshot querySnapshot) {
          setState(() {
            searchResults = querySnapshot.docs;
          });
        })
        .catchError((error) {
          print('Error performing search: $error');
        });
  }

  @override
  Widget build(BuildContext context) {
    Size sc = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor:
          Theme.of(context).brightness == Brightness.dark ? blackclr : whiteclr,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 4, left: 2, bottom: 10),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        context.pop();
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                    Text(
                      widget.dat,
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
                        color: Theme.of(context).brightness == Brightness.dark
                            ? whiteclr
                            : blackclr,
                        size: 27,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        30.pw,
                        InkWell(
                          onTap: (() {
                            setState(() {
                              activecat = 'followers';
                            });
                          }),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  StreamBuilder<int>(
                                    stream: getFollowerCount(widget.dat),
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
                                  4.pw,
                                  const Text(
                                    "Followers",
                                    style: TextStyle(
                                      fontSize: 14.5,
                                    ),
                                  ),
                                ],
                              ),
                              Center(
                                child: Container(
                                  height: sc.height * 0.0038,
                                  width: sc.width * 0.2,
                                  decoration: BoxDecoration(
                                      color: activecat == 'followers'
                                          ? Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? whiteclr
                                              : blackclr
                                          : Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? blackclr
                                              : whiteclr,
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: (() {
                            setState(() {
                              activecat = 'following';
                            });
                          }),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  StreamBuilder<int>(
                                    stream: getFollowingCount(widget.dat),
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
                                  4.pw,
                                  const Text(
                                    "Following",
                                    style: TextStyle(
                                      fontSize: 14.5,
                                    ),
                                  ),
                                ],
                              ),
                              Center(
                                child: Container(
                                  height: sc.height * 0.0038,
                                  width: sc.width * 0.2,
                                  decoration: BoxDecoration(
                                      color: activecat == 'following'
                                          ? Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? whiteclr
                                              : blackclr
                                          : Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? blackclr
                                              : whiteclr,
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        30.pw,
                      ],
                    ),
                  ),
                  const Divider(
                    color: greyclr,
                    thickness: 0.8,
                  )
                ],
              ),
              Visibility(
                visible: activecat == 'followers',
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 12),
                      child: SizedBox(
                        height: 35,
                        child: TextFormField(
                          controller: searchController,
                          cursorColor: greyclr,
                          onChanged: (value) => performSearch(),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(0),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            hintText: "Search",
                            filled: true,
                            fillColor:
                                Theme.of(context).brightness == Brightness.dark
                                    ? const Color.fromARGB(255, 45, 43, 43)
                                    : lgreyclr,
                            hintStyle: const TextStyle(
                              fontSize: 14.5,
                              color: greyclr,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: blackclr.withOpacity(0.6),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (searchResults.isEmpty &&
                        searchController.text.isEmpty) ...[
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('following')
                            .where('followusername', isEqualTo: widget.dat)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Something went wrong');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return AlignedGridView.count(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemCount: snapshot.data!.docs.length,
                            crossAxisCount: 1,
                            itemBuilder: (context, index) {
                              var Data = snapshot.data!.docs[index];

                              return InkWell(
                                onTap: () {
                                  var username = Data['uid'];
                                  context.push('/usersdetailview',
                                      extra: username);
                                },
                                child: ListTile(
                                  leading: CircleAvatar(
                                    foregroundImage:
                                        NetworkImage(Data['profilepic']),
                                  ),
                                  title: Text(Data['username']),
                                  subtitle: Text(Data['name']),
                                  trailing: FollowSearchWidget(
                                    followid: Data['username'],
                                    followname: Data['name'],
                                    followpic: Data['profilepic'],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ] else if (searchResults.isEmpty) ...[
                      const Center(child: Text('No search results found')),
                    ] else ...[
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: searchResults.length,
                        itemBuilder: (BuildContext context, int index) {
                          final resultData = searchResults[index];
                          return InkWell(
                            onTap: () {
                              var username = resultData['uid'];
                              context.push('/usersdetailview', extra: username);
                            },
                            child: ListTile(
                              leading: CircleAvatar(
                                foregroundImage:
                                    NetworkImage(resultData['profilepic']),
                              ),
                              title: Text(resultData['username']),
                              subtitle: Text(resultData['name']),
                              trailing: FollowSearchWidget(
                                followid: resultData['username'],
                                followname: resultData['name'],
                                followpic: resultData['profilepic'],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
              Visibility(
                visible: activecat == 'following',
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 12),
                      child: SizedBox(
                        height: 35,
                        child: TextFormField(
                          controller: searchCon,
                          cursorColor: greyclr,
                          onChanged: (value) => performSear(),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(0),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            hintText: "Search",
                            filled: true,
                            fillColor:
                                Theme.of(context).brightness == Brightness.dark
                                    ? const Color.fromARGB(255, 45, 43, 43)
                                    : lgreyclr,
                            hintStyle: const TextStyle(
                              fontSize: 14.5,
                              color: greyclr,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: blackclr.withOpacity(0.6),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (searchRes.isEmpty && searchCon.text.isEmpty) ...[
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('following')
                            .where('username', isEqualTo: widget.dat)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Something went wrong');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return AlignedGridView.count(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemCount: snapshot.data!.docs.length,
                            crossAxisCount: 1,
                            itemBuilder: (context, index) {
                              var Data = snapshot.data!.docs[index];

                              return InkWell(
                                onTap: () {
                                  var username = Data['uid'];
                                  context.push('/usersdetailview',
                                      extra: username);
                                },
                                child: ListTile(
                                  leading: CircleAvatar(
                                    foregroundImage:
                                        NetworkImage(Data['followpic']),
                                  ),
                                  title: Text(Data['followusername']),
                                  subtitle: Text(Data['followname']),
                                  trailing: FollowSearchWidget(
                                    followid: Data['username'],
                                    followname: Data['name'],
                                    followpic: Data['profilepic'],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ] else if (searchRes.isEmpty) ...[
                      const Center(child: Text('No search results found')),
                    ] else ...[
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: searchRes.length,
                        itemBuilder: (BuildContext context, int index) {
                          final resultData = searchRes[index];
                          return InkWell(
                            onTap: () {
                              var username = resultData['uid'];
                              context.push('/usersdetailview', extra: username);
                            },
                            child: ListTile(
                              leading: CircleAvatar(
                                foregroundImage:
                                    NetworkImage(resultData['followpic']),
                              ),
                              title: Text(resultData['followusername']),
                              subtitle: Text(resultData['followname']),
                              trailing: FollowSearchWidget(
                                followid: resultData['username'],
                                followname: resultData['name'],
                                followpic: resultData['profilepic'],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
