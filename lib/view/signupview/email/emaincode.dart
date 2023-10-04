import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:instagramclone/utils/utils.dart';
import 'package:instagramclone/widget/elevatedbtnwidget.dart';
import 'package:instagramclone/widget/textformfieldwidget.dart';
import 'package:provider/provider.dart';
import 'package:email_otp/email_otp.dart';

import '../../../provider/searchprovider.dart';

class EmailConfirmationCode extends StatefulWidget {
  final EmailOTP myauth;
  final String email;
  const EmailConfirmationCode(
      {super.key, required this.myauth, required this.email});

  @override
  State<EmailConfirmationCode> createState() => _EmailConfirmationCodeState();
}

class _EmailConfirmationCodeState extends State<EmailConfirmationCode> {
  emailotp() async {
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);

    searchProvider.setLoading(true);
    if (await widget.myauth.verifyOTP(otp: confirmationController.text) ==
        true) {
      Utils.flushBarErrorMessage("OTP is verified", context);
      GoRouter.of(context).go('/password', extra: widget.email);
    } else {
      Utils.flushBarErrorMessage("Invalid OTP", context);
    }
    searchProvider.setLoading(false);
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController confirmationController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
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
                    "To confirm your account, enter the 6-digit code that we sent to ${widget.email}"
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
                    height: sc.height * 0.05,
                  ),
                  Consumer<SearchProvider>(
                    builder: (context, value, child) {
                      return ElevatedButtonWidget(
                        isLoading: value.loading,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            emailotp();
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
/*
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Otp extends StatelessWidget {
  const Otp({
    Key? key,
    required this.otpController,
  }) : super(key: key);
  final TextEditingController otpController;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: TextFormField(
        controller: otpController,
        keyboardType: TextInputType.number,
        style: Theme.of(context).textTheme.headline6,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly
        ],
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
          if (value.isEmpty) {
            FocusScope.of(context).previousFocus();
          }
        },
        decoration: const InputDecoration(
          hintText: ('0'),
        ),
        onSaved: (value) {},
      ),
    );
  }
}

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key, required this.myauth}) : super(key: key);
  final EmailOTP myauth;
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otp1Controller = TextEditingController();
  TextEditingController otp2Controller = TextEditingController();
  TextEditingController otp3Controller = TextEditingController();
  TextEditingController otp4Controller = TextEditingController();

  String otpController = "1234";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.info),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          const Icon(Icons.dialpad_rounded, size: 50),
          const SizedBox(
            height: 40,
          ),
          const Text(
            "Enter Mary's PIN",
            style: TextStyle(fontSize: 40),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Otp(
                otpController: otp1Controller,
              ),
              Otp(
                otpController: otp2Controller,
              ),
              Otp(
                otpController: otp3Controller,
              ),
              Otp(
                otpController: otp4Controller,
              ),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          const Text(
            "Rider can't find a pin",
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 40,
          ),
          ElevatedButton(
            onPressed: () async {
              if (await widget.myauth.verifyOTP(
                      otp: otp1Controller.text +
                          otp2Controller.text +
                          otp3Controller.text +
                          otp4Controller.text) ==
                  true) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("OTP is verified"),
                ));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Invalid OTP"),
                ));
              }
            },
            child: const Text(
              "Confirm",
              style: TextStyle(fontSize: 20),
            ),
          )
        ],
      ),
    );
  }
}
*/