import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:instagramclone/utils/utils.dart';
import 'package:instagramclone/widget/elevatedbtnwidget.dart';
import 'package:instagramclone/widget/textformfieldwidget.dart';
import 'package:provider/provider.dart';

import '../../../provider/searchprovider.dart';

class EmailView extends StatefulWidget {
  const EmailView({super.key});

  @override
  State<EmailView> createState() => _EmailViewState();
}

class _EmailViewState extends State<EmailView> {
  EmailOTP myauth = EmailOTP();
  email() async {
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);

    searchProvider.setLoading(true);

    myauth.setConfig(
        appEmail: "umar.aziz.dev@gmail.com",
        appName: "Email OTP",
        userEmail: emailcontroller.text,
        otpLength: 4,
        otpType: OTPType.digitsOnly);
    if (await myauth.sendOTP() == true) {
      Utils.toastmessage("OTP has been sent");
      myauth = myauth;
      var email = emailcontroller.text;
      context.push("/emailcode?email=$email", extra: myauth);
    } else {
      searchProvider.setLoading(false);

      Utils.flushBarErrorMessage("Oops, OTP send failed", context);
    }
    searchProvider.setLoading(false);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emailcontroller.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  TextEditingController emailcontroller = TextEditingController();
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
                  SizedBox(
                    height: sc.height * 0.001,
                  ),
                  Text(
                    "What's your email address?".tr,
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
                    "Enter the email address at which we can be contacted. No one will see this on your profile."
                        .tr,
                    style: const TextStyle(
                      fontSize: 14.5,
                    ),
                  ),
                  SizedBox(
                    height: sc.height * 0.03,
                  ),
                  TextFormFieldWidget(
                    controler: emailcontroller,
                    hintTxt: 'Email Address'.tr,
                    labelTxt: 'Email Address'.tr,
                    keyboardtype: TextInputType.emailAddress,
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
                            if (emailcontroller.text.contains("@") ||
                                emailcontroller.text.contains(".com")) {
                              email();
                            } else {
                              Utils.flushBarErrorMessage(
                                  "Please Enter Valid Email".tr, context);
                            }
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
                    height: sc.height * 0.02,
                  ),
                  ElevatedButtonWidget(
                    isLoading: false,
                    onPressed: () {
                      context.push("/signup");
                    },
                    title: "Sign up with Mobile Number".tr,
                    color: buttonbackgroundclr,
                    textcolor: blackclr,
                    border: true,
                  ),
                  SizedBox(
                    height: sc.height * 0.36,
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
      ),
    );
  }
}
