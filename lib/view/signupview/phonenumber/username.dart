import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:instagramclone/utils/utils.dart';
import 'package:instagramclone/widget/elevatedbtnwidget.dart';
import 'package:instagramclone/widget/textformfieldwidget.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';
import '../../../provider/searchprovider.dart';

class UserNameView extends StatefulWidget {
  const UserNameView({super.key});

  @override
  State<UserNameView> createState() => _UserNameViewState();
}

class _UserNameViewState extends State<UserNameView> {
  addData() {
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);

    searchProvider.setLoading(true);
    final DocumentReference documentRef =
        FirebaseFirestore.instance.collection("profile").doc(box.read('uid'));

    final Map<String, dynamic> newData = {
      'username': usernamecontroler.text,
    };
    documentRef.set(
      newData,
      SetOptions(merge: true),
    );
    box.write(
      'username',
      usernamecontroler.text,
    );
    searchProvider.setLoading(false);
  }

  final _formKey = GlobalKey<FormState>();

  TextEditingController usernamecontroler = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    usernamecontroler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size sc = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
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
            : authbackgroundclr,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? lblackclr
          : authbackgroundclr,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: sc.height * 0.001,
                ),
                Text(
                  "Create a username".tr,
                  style: const TextStyle(
                      letterSpacing: 1,
                      wordSpacing: 1,
                      fontSize: 23,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: sc.height * 0.02,
                ),
                Text(
                  "Add a username. You can change this at any time.".tr,
                  style: const TextStyle(
                    fontSize: 14.5,
                  ),
                ),
                SizedBox(
                  height: sc.height * 0.035,
                ),
                TextFormFieldWidget(
                  controler: usernamecontroler,
                  hintTxt: 'Username'.tr,
                  labelTxt: 'Username'.tr,
                ),
                SizedBox(
                  height: sc.height * 0.035,
                ),
                Consumer<SearchProvider>(
                  builder: (context, value, child) {
                    return ElevatedButtonWidget(
                      isLoading: value.loading,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (usernamecontroler.text.length < 6) {
                            Utils.flushBarErrorMessage(
                                'Username must be at least 6 characters long'
                                    .tr,
                                context);
                          }
                          // else if (RegExp(r'[^\w@#$]')
                          //     .hasMatch(usernamecontroler.text.)) {
                          //   Utils.flushBarErrorMessage(
                          //       'Username must contain at least one special character.',
                          //       context);
                          // }
                          else {
                            addData();
                            context.push('/profilepic');
                          }
                        }
                        // context.go("/phonecode",);
                      },
                      title: "Next".tr,
                      color: buttonblueclr,
                      textcolor: whiteclr,
                      border: false,
                    );
                  },
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    GoRouter.of(context).go('/login');
                  },
                  child: Center(
                    child: Text(
                      "Already have an account?".tr,
                      style: const TextStyle(
                          color: buttonblueclr,
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
