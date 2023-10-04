import 'package:flutter/material.dart';
import 'package:instagramclone/utils/colors.dart';

class SenderBubble extends StatefulWidget {
  const SenderBubble(
      {super.key, required this.message, required this.date, required this.sc});
  final String message;
  final String date;
  final Size sc;
  @override
  State<SenderBubble> createState() => _SenderBubbleState();
}

class _SenderBubbleState extends State<SenderBubble> {
  @override
  Widget build(BuildContext context) {
    final Size sc = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: blueclr,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          widget.message,
          style: TextStyle(
            fontSize: sc.height * 0.02,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ),
    );
  }
}
