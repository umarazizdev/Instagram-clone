import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:instagramclone/main.dart';
import 'package:instagramclone/provider/searchprovider.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:instagramclone/utils/utils.dart';
import 'package:instagramclone/widget/bottommodalsheet.dart';
import 'package:instagramclone/widget/elevatedbtnwidget.dart';
import 'package:instagramclone/widget/textformfieldwidget.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  loginn() async {
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    try {
      searchProvider.setLoading(true);
      if (emailController.text.contains('.com')) {
        QuerySnapshot snap = await FirebaseFirestore.instance
            .collection("profile")
            .where("email", isEqualTo: emailController.text)
            .get();
        if (snap.docs.isNotEmpty) {
          final credential =
              await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: snap.docs[0]['email'],
            password: passwordController.text,
          );
          box.write("uid", snap.docs[0]['uid']);
          box.write("name", snap.docs[0]['name']);
          box.write("username", snap.docs[0]['username']);
          box.write("profilepic", snap.docs[0]['profilepic']);
          box.write("islogin", true);

          GoRouter.of(context).go('/mainview');
        } else {
          Utils.toastmessage("User not found");
        }
      } else if (emailController.text.contains('92')) {
        QuerySnapshot snap = await FirebaseFirestore.instance
            .collection("profile")
            .where("phonenumber", isEqualTo: emailController.text)
            .get();
        if (snap.docs.isNotEmpty) {
          final credential = await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: snap.docs[0]['email'],
                  password: passwordController.text);
          box.write("uid", snap.docs[0]['uid']);
          box.write("username", snap.docs[0]['username']);
          box.write("name", snap.docs[0]['name']);
          box.write("profilepic", snap.docs[0]['profilepic']);
          box.write("islogin", true);
          GoRouter.of(context).go('/mainview');
        } else {
          Utils.toastmessage("User not found");
        }
      } else {
        QuerySnapshot snap = await FirebaseFirestore.instance
            .collection("profile")
            .where("username", isEqualTo: emailController.text)
            .get();
        if (snap.docs.isNotEmpty) {
          final credential = await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: snap.docs[0]['email'],
                  password: passwordController.text);
          box.write("uid", snap.docs[0]['uid']);
          box.write("name", snap.docs[0]['name']);
          box.write("username", snap.docs[0]['username']);
          box.write("profilepic", snap.docs[0]['profilepic']);

          box.write("islogin", true);
          GoRouter.of(context).go('/mainview');
        } else {
          Utils.toastmessage("User not found");
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Utils.flushBarErrorMessage("No user found for that email.", context);
      } else if (e.code == 'wrong-password') {
        Utils.flushBarErrorMessage(
            "Wrong password provided for that user.", context);
      }
      searchProvider.setLoading(false);
    } finally {
      searchProvider.setLoading(false);
    }
  }

  facebookLogin() async {
    try {
      final result =
          await FacebookAuth.i.login(permissions: ['public_profile', 'email']);
      if (result.status == LoginStatus.success) {
        final Map<String, dynamic> userData =
            await FacebookAuth.i.getUserData();
        final DocumentReference documentRef = FirebaseFirestore.instance
            .collection("profile")
            .doc(userData['id']);
        final Map<String, dynamic> newData = {
          'name': userData['name'],
          'email': userData['email'],
          'url': userData['picture']['data']['url'],
          'id': userData['id'],
          'uid': userData['id'],
          'username': userData['name'],
        };
        documentRef.set(
          newData,
          SetOptions(merge: true),
        );
        box.write("islogin", true);
        box.write("uid", userData['id']);
        box.write("username", userData['name']);
        box.write("name", userData['name']);

        box.write("profilepic", userData['picture']['data']['url']);

        GoRouter.of(context).go('/mainview');
      }
    } catch (e) {
      Utils.flushBarErrorMessage(e.toString(), context);
      // ignore: avoid_print
      print(e.toString());
    }
  }

  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size sc = MediaQuery.of(context).size;
    return Scaffold(
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
                  height: sc.height * 0.07,
                ),
                InkWell(
                  onTap: () async {
                    showModalBottomSheet(
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(10)),
                      ),
                      context: context,
                      builder: (BuildContext context) {
                        return BottomModalSheetWidget(sc: sc);
                      },
                    );
                  },
                  child: Center(
                    child: Consumer<SearchProvider>(
                      builder: (context, searchProvider, child) {
                        return Text(
                          searchProvider.text,
                          style: TextStyle(
                            color: Colors.blueGrey.shade400,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Center(
                  child: Image.asset(
                    'assets/logo/iglogo.png',
                    height: sc.height * 0.19,
                    width: sc.width * 0.3,
                  ),
                ),
                SizedBox(
                  height: sc.height * 0.025,
                ),
                TextFormFieldWidget(
                  controler: emailController,
                  hintTxt: 'Enter Email,Username'.tr,
                  labelTxt: 'Email,Username'.tr,
                  keyboardtype: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: sc.height * 0.015,
                ),
                TextFormFieldWidget(
                  controler: passwordController,
                  hintTxt: 'Enter Password'.tr,
                  labelTxt: 'Password'.tr,
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
                          loginn();
                        }
                      },
                      title: "Login".tr,
                      color: buttonblueclr,
                      textcolor: whiteclr,
                      border: false,
                    );
                  },
                ),

                SizedBox(
                  height: sc.height * 0.02,
                ),
                Center(
                  child: Text(
                    "Forgotten Password?".tr,
                    style: const TextStyle(
                      letterSpacing: 0.4,
                      wordSpacing: 0.5,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(
                  height: sc.height * 0.03,
                ),
                ElevatedButtonWidget(
                    isLoading: false,
                    onPressed: () {
                      context.push('/email');
                    },
                    title: "Create new account".tr,
                    border: true,
                    color: buttonbackgroundclr,
                    textcolor: blackclr),
                SizedBox(
                  height: sc.height * 0.03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 0.5,
                      width: sc.width / 2.35,
                      color: greyclr,
                    ),
                    SizedBox(
                      width: sc.width * 0.01,
                    ),
                    const Text(
                      "OR",
                      style: TextStyle(fontSize: 13, color: greyclr),
                    ),
                    SizedBox(
                      width: sc.width * 0.01,
                    ),
                    Container(
                      height: 0.5,
                      width: sc.width / 2.35,
                      color: greyclr,
                    ),
                  ],
                ),
                SizedBox(
                  height: sc.height * 0.03,
                ),
                // SizedBox(
                //   height: sc.height * 0.02,
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Center(
                    child: SizedBox(
                      width: double.infinity,
                      // width: sc.width * 0.7,
                      height: sc.height * 0.075,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: fbbuttonclr),
                        onPressed: () {
                          facebookLogin();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/logo/fb-logo.png",
                              height: 25,
                            ),
                            Text(
                              "Login With FaceBook".tr,
                              style: const TextStyle(color: whiteclr),
                            ),
                          ],
                        ),
                      ),
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
