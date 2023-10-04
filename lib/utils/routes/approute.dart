import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:instagramclone/utils/themechanger.dart';
import 'package:instagramclone/view/adddataview.dart/adddataview.dart';
import 'package:instagramclone/view/loginview/loginview.dart';
import 'package:instagramclone/view/profileview/editprofileview.dart';
import 'package:instagramclone/view/profileview/postdetail.dart';
import 'package:instagramclone/view/profileview/profileview.dart';
import 'package:instagramclone/view/savedview/saveddetail.dart';
import 'package:instagramclone/view/savedview/savedview.dart';
import 'package:instagramclone/view/searchview.dart/searchview.dart';
import 'package:instagramclone/view/signupview/confirmationcode.dart';
import 'package:instagramclone/view/signupview/email/emailview.dart';
import 'package:instagramclone/view/mainview/mainview.dart';
import 'package:instagramclone/view/signupview/phonenumber/datebirth.dart';
import 'package:instagramclone/view/signupview/phonenumber/firstname.dart';
import 'package:instagramclone/view/signupview/phonenumber/password.dart';
import 'package:instagramclone/view/signupview/phonenumber/username.dart';
import 'package:instagramclone/view/signupview/profilepic.dart';
import 'package:instagramclone/view/splashview/splashview.dart';
import 'package:instagramclone/view/welcomeview/welcomeview.dart';
import 'package:instagramclone/widget/followwidget/followerswidget.dart';

import '../../view/homeview/homeview.dart';
import '../../view/homeview/usersdetailview.dart/userdetailview.dart';
import '../../view/signupview/email/emaincode.dart';
import '../../view/signupview/phonenumberview.dart';
import '../../widget/followwidget/followingwidget.dart';
import 'errorwidget.dart' as e;

class AppRoute {
  static final GoRouter router = GoRouter(
      routes: [
        GoRoute(
          path: "/",
          builder: (BuildContext context, GoRouterState state) =>
              const SplashView(),
        ),
        GoRoute(
          path: "/profileview",
          builder: (BuildContext context, GoRouterState state) => ProfileView(
            uname: state.extra as String,
          ),
        ),
        GoRoute(
          path: "/editprofileview",
          builder: (BuildContext context, GoRouterState state) =>
              const EditProfileView(),
        ),
        GoRoute(
          path: "/postdetailview",
          builder: (BuildContext context, GoRouterState state) =>
              PostDetailView(
            usname: state.extra as String,
          ),
        ),
        GoRoute(
          path: "/adddataview",
          builder: (BuildContext context, GoRouterState state) =>
              const AddDataView(),
        ),
        GoRoute(
          path: "/usersdetailview",
          builder: (BuildContext context, GoRouterState state) =>
              UsersDetailView(documentId: state.extra.toString()),
        ),
        GoRoute(
          path: "/searchview",
          builder: (BuildContext context, GoRouterState state) =>
              const SearchView(),
        ),
        GoRoute(
          path: "/mainview",
          builder: (BuildContext context, GoRouterState state) =>
              const BottomNavigationBarExample(),
        ),
        GoRoute(
          path: "/home",
          builder: (BuildContext context, GoRouterState state) =>
              const HomeView(),
        ),
        GoRoute(
          path: "/signup",
          builder: (BuildContext context, GoRouterState state) =>
              const PhoneNumberView(),
        ),
        GoRoute(
          path: "/savedview",
          builder: (BuildContext context, GoRouterState state) =>
              const SavedView(),
        ),
        GoRoute(
          path: "/saveddetail",
          builder: (BuildContext context, GoRouterState state) =>
              const SavedDetailView(),
        ),
        GoRoute(
          path: "/emailcode",
          builder: (BuildContext context, GoRouterState state) {
            final queryParams = state.queryParams;
            final email = queryParams['email'];
            return EmailConfirmationCode(
              myauth: state.extra as EmailOTP,
              email: email.toString(),
            );
          },
        ),
        GoRoute(
          path: "/email",
          builder: (BuildContext context, GoRouterState state) =>
              const EmailView(),
        ),
        GoRoute(
          path: "/login",
          builder: (BuildContext context, GoRouterState state) =>
              const LoginView(),
        ),
        GoRoute(
          path: "/name",
          builder: (BuildContext context, GoRouterState state) =>
              const FirstNameView(),
        ),
        GoRoute(
          path: "/username",
          builder: (BuildContext context, GoRouterState state) =>
              const UserNameView(),
        ),
        GoRoute(
          path: "/birth",
          builder: (BuildContext context, GoRouterState state) =>
              const DateofbirthView(),
        ),
        GoRoute(
            path: "/password",
            builder: (BuildContext context, GoRouterState state) {
              return PasswordView(
                email: state.extra.toString(),
              );
            }),
        GoRoute(
            path: "/phonecode",
            builder: (BuildContext context, GoRouterState state) {
              final queryParams = state.queryParams;
              final phone = queryParams['phone'];

              return PhoneConfirmationCode(
                verification: state.extra.toString(),
                phone: phone.toString(),
              );
            }),
        GoRoute(
          path: "/welcome",
          builder: (BuildContext context, GoRouterState state) =>
              const WelcomeView(),
        ),
        GoRoute(
          path: "/profilepic",
          builder: (BuildContext context, GoRouterState state) =>
              const ProfilePicView(),
        ),
        GoRoute(
          path: "/darktheme",
          builder: (BuildContext context, GoRouterState state) =>
              const DarkTheme(),
        ),
        GoRoute(
            path: "/followerswidget",
            builder: (BuildContext context, GoRouterState state) {
              return FollowersWidget(
                dat: state.extra.toString(),
              );
            }),
        GoRoute(
          path: "/followingwidget",
          builder: (BuildContext context, GoRouterState state) =>
              FollowingWidget(
            dat: state.extra.toString(),
          ),
        ),
      ],
      errorBuilder: (context, state) {
        return e.ErrorWidget(error: state.error.toString());
      });
}
