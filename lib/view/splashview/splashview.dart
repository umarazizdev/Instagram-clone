import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:instagramclone/main.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:instagramclone/utils/utils.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 3),
      (() {
        if (box.read('islogin') == true) {
          GoRouter.of(context).go('/mainview');
        } else {
          GoRouter.of(context).go('/login');
        }
      }),
    );
    Size sc = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: bsplashclr,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Center(
              child: Image.asset(
                'assets/logo/iglogo.png',
                height: sc.height * 0.25,
                width: sc.width * 0.35,
              ),
            ),
            const Spacer(),
            Text(
              "from",
              style: TextStyle(color: Colors.blue[100]!.withOpacity(0.5)),
            ),
            Image.asset(
              "assets/logo/metalogo.png",
              height: sc.height * 0.055,
            ),
            20.ph,
          ],
        ),
      ),
    );
  }
}
