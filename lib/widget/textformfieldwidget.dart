import 'package:flutter/material.dart';
import 'package:instagramclone/utils/colors.dart';

class TextFormFieldWidget extends StatefulWidget {
  const TextFormFieldWidget({
    Key? key,
    required this.controler,
    required this.labelTxt,
    required this.hintTxt,
    this.keyboardtype = TextInputType.text,
  }) : super(key: key);

  final TextInputType keyboardtype;
  final String labelTxt, hintTxt;
  final TextEditingController controler;
  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: TextFormField(
        keyboardType: widget.keyboardtype,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return widget.hintTxt.toString();
          }
          return null;
        },
        cursorColor: greyclr,
        controller: widget.controler,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          filled: true,
          fillColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.black38
              : whiteclr,
          // contentPadding: const EdgeInsets.all(1),
          hintText: widget.hintTxt,
          hintStyle: const TextStyle(color: greyclr),
          labelText: widget.labelTxt,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          labelStyle: const TextStyle(color: greyclr),
          enabledBorder:
              const OutlineInputBorder(borderSide: BorderSide(color: greyclr)),
          focusedBorder:
              const OutlineInputBorder(borderSide: BorderSide(color: greyclr)),
          errorBorder:
              const OutlineInputBorder(borderSide: BorderSide(color: redclr)),
          focusedErrorBorder:
              const OutlineInputBorder(borderSide: BorderSide(color: redclr)),
        ),
      ),
    );
  }
}
