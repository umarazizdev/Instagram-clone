import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/view/chatview/receiverbubble.dart';

import '../../main.dart';
import 'senderbubble.dart';
import '../../utils/colors.dart';

class Messages extends StatefulWidget {
  final String id;

  const Messages({super.key, required this.id});
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  Stream<QuerySnapshot>? messageStream;
  @override
  void initState() {
    messageStream = FirebaseFirestore.instance
        .collection('profile')
        .doc(box.read('uid'))
        .collection('messages')
        .doc(widget.id)
        .collection('chats')
        .orderBy('createdAt', descending: true)
        .snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size sc = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: messageStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
            reverse: true,
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final data = snapshot.data!.docs;
              Timestamp t = data[index]['time'];
              DateTime d = t.toDate();
              return data[index]['customerid'] == box.read('uid')
                  ? SenderBubble(
                      message: data[index]['message'],
                      date: d.hour.toString() + ":" + d.minute.toString(),
                      sc: sc)
                  : ReceiveMsg(
                      message: data[index]['message'],
                      date: d.hour.toString() + ':' + d.minute.toString(),
                      sc: sc);
            },
          ),
        );
      },
    );
  }
}
