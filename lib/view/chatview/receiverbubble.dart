import 'package:flutter/material.dart';

class ReceiveMsg extends StatefulWidget {
  const ReceiveMsg(
      {super.key, required this.message, required this.date, required this.sc});
  final String message;
  final String date;
  final Size sc;

  @override
  State<ReceiveMsg> createState() => _ReceiveMsgState();
}

class _ReceiveMsgState extends State<ReceiveMsg> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          widget.message,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
