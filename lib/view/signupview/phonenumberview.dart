import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:instagramclone/utils/utils.dart';
import 'package:instagramclone/widget/elevatedbtnwidget.dart';
import 'package:instagramclone/widget/textformfieldwidget.dart';
import 'package:provider/provider.dart';

import '../../provider/searchprovider.dart';

class PhoneNumberView extends StatefulWidget {
  const PhoneNumberView({super.key});

  @override
  State<PhoneNumberView> createState() => _PhoneNumberViewState();
}

class _PhoneNumberViewState extends State<PhoneNumberView> {
  // final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // verifyphonenumber() async {
  //   auth.verifyPhoneNumber(
  //     phoneNumber: mobileNumberController.text.toString(),
  //     verificationCompleted: (_) {},
  //     verificationFailed: (e) {
  //       Utils.flushBarErrorMessage(e.toString(), context);
  //     },
  //     codeSent: (String verificationId, int? token) {
  //       var verification = verificationId;
  //       context.push("/phonecode", extra: verification);
  //     },
  //     codeAutoRetrievalTimeout: (e) {
  //       Utils.flushBarErrorMessage(e.toString(), context);
  //     },
  //   );
  // }
  String verificationId = '';
  void registerWithPhoneNumber(String phoneNumber) async {
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    try {
      searchProvider.setLoading(true);
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          searchProvider.setLoading(false);
          Utils.toastmessage('Verification failed: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            this.verificationId = verificationId;
          });
          Utils.toastmessage('Verification code sent'.tr);
          var verification = verificationId;
          var phone = mobileNumberController.text;
          context.push("/phonecode?phone=$phone", extra: verification);
          // String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
          // final DocumentReference documentRef =
          //     FirebaseFirestore.instance.collection("profile").doc(uid);
          // final Map<String, dynamic> newData = {
          //   'phonenumber': mobileNumberController.text,
          //   'uid': uid
          // };
          // documentRef.set(
          //   newData,
          //   SetOptions(merge: true),
          // );
          // box.write('uid', uid);
          // print("uid is: $uid");
          searchProvider.setLoading(false);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            this.verificationId = verificationId;
          });
          searchProvider.setLoading(false);
        },
      );

      searchProvider.setLoading(false);
    } catch (e) {
      searchProvider.setLoading(false);
    }
  }

  // void registerWithPhoneNumber(String phoneNumber) async {
  //   final searchProvider = Provider.of<SearchProvider>(context, listen: false);
  //   searchProvider.setLoading(true);

  //   await _auth.verifyPhoneNumber(
  //     phoneNumber: phoneNumber,
  //     verificationCompleted: (PhoneAuthCredential credential) async {
  //       await _auth.signInWithCredential(credential);
  //       Utils.toastmessage('Verification automatically completed');
  //     },
  //     verificationFailed: (FirebaseAuthException e) {
  //       Utils.toastmessage('Verification failed: ${e.message}');
  //   searchProvider.setLoading(false);

  //     },
  //     codeSent: (String verificationId, int? resendToken) {
  //       setState(() {
  //         this.verificationId = verificationId;
  //       });
  //       Utils.toastmessage('Verification code sent');
  //       var verification = verificationId;
  //       context.push("/phonecode", extra: verification);
  //   searchProvider.setLoading(false);

  //     },
  //     codeAutoRetrievalTimeout: (String verificationId) {
  //       setState(() {
  //         this.verificationId = verificationId;
  //       });
  //       Utils.toastmessage('Code auto retrieval timeout');
  //   searchProvider.setLoading(false);

  //     }
  //   );
  // }

  final _formKey = GlobalKey<FormState>();
  TextEditingController mobileNumberController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    mobileNumberController.dispose();
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: sc.height * 0.001,
                ),
                Text(
                  "What's your mobile \nnumber?".tr,
                  style: const TextStyle(
                      letterSpacing: 1,
                      wordSpacing: 1,
                      fontSize: 23,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: sc.height * 0.018,
                ),
                Text(
                  "Enter the mobile number on which you can be contacted. No one will see this on your profile."
                      .tr,
                  style: const TextStyle(
                    fontSize: 14.5,
                  ),
                ),
                SizedBox(
                  height: sc.height * 0.03,
                ),
                TextFormFieldWidget(
                  controler: mobileNumberController,
                  hintTxt: 'Mobile Number'.tr,
                  labelTxt: 'Mobile Number'.tr,
                  // sc: sc,
                  keyboardtype: TextInputType.phone,
                ),
                SizedBox(
                  height: sc.height * 0.015,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(
                    "You may receive an SMS notification from us for security and login purposes."
                        .tr,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                SizedBox(
                  height: sc.height * 0.06,
                ),
                Consumer<SearchProvider>(
                  builder: (context, value, child) {
                    return ElevatedButtonWidget(
                      isLoading: value.loading,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // verifyphonenumber();
                          registerWithPhoneNumber(mobileNumberController.text);
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
                  height: sc.height * 0.025,
                ),
                Consumer<SearchProvider>(
                  builder: (context, value, child) {
                    return ElevatedButtonWidget(
                      isLoading: value.loading,
                      onPressed: () {
                        context.push("/email");
                      },
                      title: "Sign up with email address".tr,
                      color: buttonbackgroundclr,
                      textcolor: blackclr,
                      border: true,
                    );
                  },
                ),
                SizedBox(
                  height: sc.height * 0.23,
                ),
                InkWell(
                  onTap: () {
                    context.push("/login");
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
