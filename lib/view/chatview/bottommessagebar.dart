import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/utils/utils.dart';

import '../../main.dart';
import '../../utils/colors.dart';

class BottomMeassageBar extends StatefulWidget {
  final String id;
  const BottomMeassageBar({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<BottomMeassageBar> createState() => _BottomMeassageBarState();
}

class _BottomMeassageBarState extends State<BottomMeassageBar> {
  var message = TextEditingController();

  users() async {}

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: whiteclr,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextFormField(
                  controller: message,
                  decoration: InputDecoration(
                      fillColor: Colors.grey[200],
                      filled: true,
                      hintText: 'Enter message',
                      hintStyle: const TextStyle(color: blackclr),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      border: OutlineInputBorder(
                        gapPadding: 10,
                        borderSide: const BorderSide(
                          width: 0,
                        ),
                        borderRadius: BorderRadius.circular(25),
                      )),
                  validator: (value) {},
                  onSaved: (value) {
                    message.text = value!;
                  },
                ),
              ),
            ),
            8.pw,
            Container(
              decoration:
                  const BoxDecoration(color: blueclr, shape: BoxShape.circle),
              child: IconButton(
                onPressed: () async {
                  if (message.text.isNotEmpty) {
                    String messageText = message.text;
                    message.clear();
                    await FirebaseFirestore.instance
                        .collection('profile')
                        .doc(box.read('uid'))
                        .collection('messages')
                        .doc(widget.id)
                        .collection('chats')
                        .add(
                      {
                        'message': messageText,
                        'time': DateTime.now(),
                        'customerid': box.read('uid'),
                        'vendorid': widget.id,
                        'createdAt': Timestamp.now(),
                      },
                    ).then((value) => FirebaseFirestore.instance
                                .collection('profile')
                                .doc(box.read('uid'))
                                .collection('messages')
                                .doc(widget.id)
                                .set(
                              {
                                'lastmessage': messageText,
                                'time': DateTime.now(),
                              },
                            ));
                    await FirebaseFirestore.instance
                        .collection('profile')
                        .doc(widget.id)
                        .collection('messages')
                        .doc(box.read('uid'))
                        .collection('chats')
                        .add(
                      {
                        'message': messageText,
                        'time': DateTime.now(),
                        'customerid': box.read('uid'),
                        'vendorid': widget.id,
                        'createdAt': Timestamp.now(),
                      },
                    ).then((value) => FirebaseFirestore.instance
                                .collection('profile')
                                .doc(widget.id)
                                .collection('messages')
                                .doc(box.read('uid'))
                                .set(
                              {
                                'lastmessage': messageText,
                                'time': DateTime.now(),
                              },
                            ));
                  }
                },
                icon: const Icon(
                  Icons.send_sharp,
                  size: 18,
                  color: whiteclr,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
