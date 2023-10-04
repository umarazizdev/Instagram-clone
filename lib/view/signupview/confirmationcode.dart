import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:instagramclone/utils/utils.dart';
import 'package:instagramclone/widget/elevatedbtnwidget.dart';
import 'package:instagramclone/widget/textformfieldwidget.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../provider/searchprovider.dart';

class PhoneConfirmationCode extends StatefulWidget {
  final String verification, phone;
  const PhoneConfirmationCode(
      {super.key, required this.verification, required this.phone});

  @override
  State<PhoneConfirmationCode> createState() => _PhoneConfirmationCodeState();
}

class _PhoneConfirmationCodeState extends State<PhoneConfirmationCode> {
  Future<void> signInWithPhoneNumber() async {
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);

    searchProvider.setLoading(true);
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verification,
        smsCode: confirmationController.text,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        String token = (await user.getIdToken()) ?? "";

        // ignore: unnecessary_null_comparison
        if (token != null) {
          // ignore: avoid_print
          print("Verification id is :$widget.verification");
          final DocumentReference documentRef =
              FirebaseFirestore.instance.collection("profile").doc(token);
          final Map<String, dynamic> newData = {
            'phonenumber': widget.phone,
            'uid': token
          };
          documentRef
              .set(
                newData,
                SetOptions(merge: true),
              )
              .then((value) {})
              .whenComplete(() {
            box.write('uid', token);
            box.write('islogin', true);
            context.push('/name');
            searchProvider.setLoading(false);
          }).catchError((error) {
            searchProvider.setLoading(false);
          });
        } else {}
      } else {
        Utils.toastmessage('User registration failed');
      }
    } catch (e) {
      searchProvider.setLoading(false);

      Utils.toastmessage('Error occurred during registration: $e');
    }

    // ignore: avoid_returning_null_for_void
    return null;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  TextEditingController confirmationController = TextEditingController();

  @override
  void dispose() {
    confirmationController.dispose();
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Enter the confirmation\ncode".tr,
                    style: const TextStyle(
                        letterSpacing: 1,
                        wordSpacing: 1,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: sc.height * 0.018,
                  ),
                  Text(
                    "To confirm your account, enter the 6-digit code that we sent to ${widget.phone}"
                        .tr,
                    style: const TextStyle(
                      fontSize: 14.5,
                    ),
                  ),
                  SizedBox(
                    height: sc.height * 0.03,
                  ),
                  TextFormFieldWidget(
                    controler: confirmationController,
                    hintTxt: 'Confirmation Code'.tr,
                    labelTxt: 'Confirmation Code'.tr,
                    keyboardtype: TextInputType.phone,
                  ),
                  SizedBox(
                    height: sc.height * 0.035,
                  ),
                  Consumer<SearchProvider>(
                    builder: (context, value, child) {
                      return ElevatedButtonWidget(
                        isLoading: value.loading,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            signInWithPhoneNumber();
                          }
                        },
                        title: "Next".tr,
                        color: buttonblueclr,
                        textcolor: whiteclr,
                        border: false,
                      );
                    },
                  ),
                  SizedBox(
                    height: sc.height * 0.03,
                  ),
                  ElevatedButtonWidget(
                    isLoading: false,
                    onPressed: () {},
                    title: "I Didn't Receive the Code".tr,
                    color: buttonbackgroundclr,
                    textcolor: blackclr,
                    border: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
