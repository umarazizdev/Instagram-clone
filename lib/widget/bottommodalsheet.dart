import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagramclone/provider/searchprovider.dart';
import 'package:provider/provider.dart';

import '../utils/colors.dart';

class BottomModalSheetWidget extends StatelessWidget {
  const BottomModalSheetWidget({
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
    final searchProvider = Provider.of<SearchProvider>(context);
    return DraggableScrollableSheet(
      initialChildSize: 1,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? lblackclr
                : authbackgroundclr,
            borderRadius: const BorderRadius.vertical(
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
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(
                    "Select Your Language".tr,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      letterSpacing: 0.6,
                      wordSpacing: 0.3,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? whiteclr
                          : blackclr,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? lblackclr
                          : whiteclr,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          title: const Text('English (US)'),
                          onTap: () {
                            Get.updateLocale(const Locale('en', 'US'));
                            searchProvider.updateText("English (US)");
                          },
                        ),
                        ListTile(
                          title: const Text('Urdu (PK)'),
                          onTap: () {
                            Get.updateLocale(const Locale('ur', 'PK'));
                            searchProvider.updateText("Urdu (PK)");
                          },
                        ),
                      ],
                    ),
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
