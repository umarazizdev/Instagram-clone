import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:instagramclone/main.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:instagramclone/view/chatview/chatsview.dart';
import 'dart:async';

import 'package:intl/intl.dart';

class Inbox extends StatefulWidget {
  final String currentUserID;
  const Inbox({
    super.key,
    required this.currentUserID,
  });

  @override
  State<Inbox> createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
  final Stream<QuerySnapshot> messageStream = FirebaseFirestore.instance
      .collection('profile')
      .doc(box.read('uid'))
      .collection('messages')
      .snapshots();

  final searchController = TextEditingController();
  List<DocumentSnapshot> searchResults = [];
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void performSearch() {
    final query = searchController.text.trim();
    FirebaseFirestore.instance
        .collection('profile')
        .where('username', isGreaterThanOrEqualTo: query)
        .orderBy('username')
        .limit(10)
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        searchResults = querySnapshot.docs;
      });
    }).catchError((error) {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (ModalRoute.of(context)!.isCurrent) {
      searchController.clear();
      setState(() {
        searchResults.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          box.read('username'),
          style: const TextStyle(color: blackclr),
        ),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).brightness == Brightness.dark
                ? whiteclr
                : blackclr,
          ),
        ),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? lblackclr
            : whiteclr,
        elevation: 0,
      ),
      backgroundColor:
          Theme.of(context).brightness == Brightness.dark ? blackclr : whiteclr,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12),
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
                    fillColor: Theme.of(context).brightness == Brightness.dark
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
              if (searchResults.isEmpty && searchController.text.isEmpty) ...[
                StreamBuilder<QuerySnapshot>(
                  stream: messageStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                          color: blueclr,
                        ),
                      );
                    }
                    if (snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text("No Chats Available !"));
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemBuilder: (context, index) {
                        var vendorid = snapshot.data!.docs[index].id;
                        var lastmessage =
                            snapshot.data!.docs[index]['lastmessage'];
                        Timestamp timestamp =
                            snapshot.data!.docs[index]['time'];
                        DateTime dateTime = timestamp.toDate();
                        String formattedTime =
                            DateFormat('HH:mm').format(dateTime);
                        return FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('profile')
                              .doc(vendorid)
                              .get(),
                          builder: (BuildContext context,
                              AsyncSnapshot asyncsnapshot) {
                            if (asyncsnapshot.hasError) {
                              return const Text("Something went wrong");
                            }
                            if (asyncsnapshot.hasData) {
                              var friend = asyncsnapshot.data;
                              return ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ChatScreen(vendorid: vendorid)),
                                  );
                                },
                                trailing: Text(formattedTime),
                                leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                  friend['profilepic'],
                                )),
                                title: Text(
                                  friend['name'],
                                ),
                                subtitle: Text(
                                  lastmessage,
                                ),
                              );
                            }

                            return const LinearProgressIndicator();
                          },
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ChatScreen(vendorid: resultData['uid'])),
                        );
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          foregroundImage:
                              NetworkImage(resultData['profilepic']),
                        ),
                        title: Text(resultData['username']),
                        subtitle: Text(resultData['name']),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
