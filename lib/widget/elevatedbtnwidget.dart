import 'package:flutter/material.dart';
import 'package:instagramclone/utils/colors.dart';

class ElevatedButtonWidget extends StatelessWidget {
  final bool isLoading;
  final bool border;
  final VoidCallback onPressed;
  final String title;
  final Color color;
  final Color textcolor;

  const ElevatedButtonWidget({
    Key? key,
    required this.isLoading,
    required this.onPressed,
    required this.title,
    required this.border,
    required this.color,
    required this.textcolor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size sc = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          width: double.infinity,
          height: sc.height * 0.08,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color:
                  border == true ? greyclr.withOpacity(0.4) : authbackgroundclr,
              width: 1,
            ),
          ),
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      letterSpacing: 0.6,
                      wordSpacing: 0.5,
                      color: textcolor,
                      fontSize: 16.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
