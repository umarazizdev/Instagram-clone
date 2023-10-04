import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/i18n/date_picker_i18n.dart';
import 'package:get/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:instagramclone/main.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:instagramclone/widget/birthdaymoda;sheet.dart';
import 'package:instagramclone/widget/elevatedbtnwidget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../provider/searchprovider.dart';

class DateofbirthView extends StatefulWidget {
  const DateofbirthView({super.key});

  @override
  State<DateofbirthView> createState() => _DateofbirthViewState();
}

class _DateofbirthViewState extends State<DateofbirthView> {
  addData() {
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);

    searchProvider.setLoading(true);

    final DocumentReference documentRef =
        FirebaseFirestore.instance.collection("profile").doc(box.read('uid'));

    final Map<String, dynamic> newData = {
      'dateofbirth':
          " ${_selectedDate!.day} ${DateFormat('MMMM').format(_selectedDate!)} ${_selectedDate!.year}",
    };
    documentRef.set(
      newData,
      SetOptions(merge: true),
    );
    searchProvider.setLoading(false);
  }

  DateTime? _selectedDate;

  Future<void> _showDatePicker() async {
    final DateTime? pickedDate = await DatePicker.showSimpleDatePicker(
      context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      dateFormat: "dd-MMMM-yyyy",
      locale: DateTimePickerLocale.en_us,
      looping: true,
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    bithcontroller.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController bithcontroller = TextEditingController();
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
                  "What's your date of birth?".tr,
                  style: const TextStyle(
                      letterSpacing: 1,
                      wordSpacing: 1,
                      fontSize: 23,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: sc.height * 0.01,
                ),
                RichText(
                  text: TextSpan(
                      text:
                          "Use your own date of birth, even if this account is for a business, pet or something else. No one will see this on."
                              .tr,
                      style: const TextStyle(
                        color: blackclr,
                        fontSize: 15.5,
                      ),
                      children: [
                        TextSpan(
                          text: "Why do I need to provide my date of birth?".tr,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              showModalBottomSheet(
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(10)),
                                ),
                                context: context,
                                builder: (BuildContext context) {
                                  return BirthdayModalSheetWidget(sc: sc);
                                },
                              );
                            },
                          style: TextStyle(
                            color: blueclr.withOpacity(0.6),
                            fontSize: 15.5,
                          ),
                        ),
                      ]),
                ),
                SizedBox(
                  height: sc.height * 0.045,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: TextFormField(
                    readOnly: true,
                    onTap: _showDatePicker,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter Date OF Birth".tr;
                      }
                      return null;
                    },
                    cursorColor: greyclr,
                    controller: TextEditingController(
                      text: _selectedDate != null
                          ? "${_selectedDate!.day} ${DateFormat('MMMM').format(_selectedDate!)} ${_selectedDate!.year}"
                          : null,
                    ),
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      filled: true,
                      fillColor: whiteclr,
                      hintText: 'Date of Birth'.tr,
                      hintStyle: const TextStyle(color: greyclr),
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: greyclr)),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: greyclr)),
                      errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: redclr)),
                      focusedErrorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: redclr)),
                    ),
                  ),
                ),
                SizedBox(
                  height: sc.height * 0.04,
                ),
                Consumer<SearchProvider>(
                  builder: (context, value, child) {
                    return ElevatedButtonWidget(
                      isLoading: false,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          addData();
                          GoRouter.of(context).go('/username');
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
                  height: sc.height * 0.38,
                ),
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
