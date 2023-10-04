import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/colors.dart';

class BirthdayModalSheetWidget extends StatelessWidget {
  const BirthdayModalSheetWidget({
    super.key,
    required this.sc,
  });

  final Size sc;

  @override
  Widget build(BuildContext context) {
    return BottomModalSheet(sc: sc);
  }
}

class BottomModalSheet extends StatelessWidget {
  const BottomModalSheet({
    super.key,
    required this.sc,
  });

  final Size sc;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 1,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: authbackgroundclr,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(5),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 4,
                      width: 35,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: sc.height * 0.025,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.close,
                          color: greyclr.withOpacity(0.6),
                          size: 30,
                        ),
                      ),
                      SizedBox(
                        height: sc.height * 0.015,
                      ),
                      Text(
                        "Birthdays".tr,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          letterSpacing: 0.6,
                          wordSpacing: 0.3,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: sc.height * 0.013,
                      ),
                      RichText(
                        text: TextSpan(
                          text:
                              "Providing your date of birth improves the features and ads you see in helps to keep the Instagram community safe. You can find your date of birth in your personal information account settings."
                                  .tr,
                          style: const TextStyle(
                            color: blackclr,
                            fontSize: 14.5,
                          ),
                          children: const [
                            TextSpan(
                              text: "",
                              style: TextStyle(
                                color: blueclr,
                                fontSize: 15.5,
                              ),
                            ),
                          ],
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
    );
  }
}
