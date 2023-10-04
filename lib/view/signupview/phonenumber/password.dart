import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:instagramclone/main.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:instagramclone/utils/utils.dart';
import 'package:instagramclone/widget/elevatedbtnwidget.dart';
import 'package:instagramclone/widget/textformfieldwidget.dart';
import 'package:provider/provider.dart';

import '../../../provider/searchprovider.dart';

class PasswordView extends StatefulWidget {
  final String email;
  const PasswordView({super.key, required this.email});

  @override
  State<PasswordView> createState() => _PasswordViewState();
}

class _PasswordViewState extends State<PasswordView> {
  signUp() async {
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);

    searchProvider.setLoading(true);
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: widget.email,
        password: passwordcontroller.text,
      );
      final DocumentReference documentRef = FirebaseFirestore.instance
          .collection("profile")
          .doc(credential.user!.uid);
      final Map<String, dynamic> newData = {
        'email': widget.email,
        'password': passwordcontroller.text,
        'uid': credential.user!.uid
      };
      documentRef
          .set(
            newData,
            SetOptions(merge: true),
          )
          .then((value) {})
          .whenComplete(() {
        box.write('uid', credential.user!.uid);
        box.write('islogin', true);
        context.push('/name');
        searchProvider.setLoading(false);
      }).catchError((error) {
        print("Failed to add user: $error");
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Utils.flushBarErrorMessage(
            'The password provided is too weak.'.tr, context);
      } else if (e.code == 'email-already-in-use') {
        Utils.flushBarErrorMessage(
            'The account already exists for that email.'.tr, context);
      }
      searchProvider.setLoading(false);
    } catch (e) {
      searchProvider.setLoading(false);
      Utils.flushBarErrorMessage(e.toString(), context);
    }
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController passwordcontroller = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    passwordcontroller.dispose();
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: sc.height * 0.0015,
                ),
                Text(
                  "Create a password".tr,
                  style: const TextStyle(
                      letterSpacing: 1,
                      wordSpacing: 1,
                      fontSize: 23,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: sc.height * 0.01,
                ),
                Text(
                  "create a password with at least 6 letters or numbers. It should be something that others can't guess."
                      .tr,
                  style: const TextStyle(
                    fontSize: 15.5,
                  ),
                ),
                SizedBox(
                  height: sc.height * 0.045,
                ),
                TextFormFieldWidget(
                  controler: passwordcontroller,
                  hintTxt: 'Enter Password'.tr,
                  labelTxt: 'Enter Password'.tr,
                  // keyboardtype: TextInputType.phone,
                ),
                SizedBox(
                  height: sc.height * 0.04,
                ),
                ElevatedButtonWidget(
                  isLoading: false,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      signUp();
                    }
                  },
                  title: "Next".tr,
                  color: buttonblueclr,
                  textcolor: whiteclr,
                  border: false,
                ),
                SizedBox(
                  height: sc.height * 0.41,
                ),
                InkWell(
                  onTap: () {
                    context.push('/login');
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
