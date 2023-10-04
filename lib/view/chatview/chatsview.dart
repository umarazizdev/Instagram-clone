import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import 'bottommessagebar.dart';
import 'messages.dart';

class ChatScreen extends StatefulWidget {
  final String vendorid;
  const ChatScreen({
    super.key,
    required this.vendorid,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('profile')
        .where('uid', isEqualTo: widget.vendorid)
        .snapshots();
    Size sc = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? lblackclr
          : whiteclr,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: blueclr),
        backgroundColor: whiteclr.withOpacity(0.6),
        elevation: 0,
        title: StreamBuilder<QuerySnapshot>(
          stream: _usersStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading...");
            }

            return ListView.builder(
              padding: const EdgeInsets.all(0),
              shrinkWrap: true,
              itemCount: 1,
              itemBuilder: (context, index) {
                final data = snapshot.data!.docs[index];
                return Row(
                  children: [
                    CircleAvatar(
                        backgroundImage: NetworkImage(
                      data['profilepic'],
                    )),
                    SizedBox(
                      width: sc.width * 0.013,
                    ),
                    SizedBox(
                      width: sc.width * 0.29,
                      child: Text(
                        data['username'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                            fontSize: 13,
                            color: blackclr,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.video_call)),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Messages(
            id: widget.vendorid,
          ),
          BottomMeassageBar(
            id: widget.vendorid,
          ),
        ],
      ),
    );
  }
}
