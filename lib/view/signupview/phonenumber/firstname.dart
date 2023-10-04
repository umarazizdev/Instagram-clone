import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:instagramclone/widget/elevatedbtnwidget.dart';
import 'package:instagramclone/widget/textformfieldwidget.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';
import '../../../provider/searchprovider.dart';

class FirstNameView extends StatefulWidget {
  const FirstNameView({super.key});

  @override
  State<FirstNameView> createState() => _FirstNameViewState();
}

class _FirstNameViewState extends State<FirstNameView> {
  addData() {
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);

    searchProvider.setLoading(true);

    final DocumentReference documentRef =
        FirebaseFirestore.instance.collection("profile").doc(box.read('uid'));

    final Map<String, dynamic> newData = {
      'name': namecontroller.text,
      'bio': '',
    };
    box.write(
      'name',
      namecontroller.text,
    );
    documentRef.set(
      newData,
      SetOptions(merge: true),
    );
    searchProvider.setLoading(false);
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController namecontroller = TextEditingController();
  @override
  void dispose() {
    namecontroller.dispose();
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
      body: Padding(
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
                "What's your name?".tr,
                style: const TextStyle(
                    letterSpacing: 1,
                    wordSpacing: 1,
                    fontSize: 23,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: sc.height * 0.045,
              ),
              TextFormFieldWidget(
                controler: namecontroller,
                hintTxt: 'First Name'.tr,
                labelTxt: 'First Name'.tr,
                keyboardtype: TextInputType.name,
              ),
              SizedBox(
                height: sc.height * 0.04,
              ),
              Consumer<SearchProvider>(
                builder: (context, value, child) {
                  return ElevatedButtonWidget(
                    isLoading: value.loading,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        addData();
                        context.push('/birth');
                      }
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
    );
  }
}
