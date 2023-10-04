import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:instagramclone/provider/bottombarprovider.dart';
import 'package:instagramclone/provider/searchprovider.dart';
import 'package:instagramclone/provider/themeprovider.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:instagramclone/utils/languages/language.dart';
import 'package:instagramclone/utils/routes/approute.dart';
import 'package:provider/provider.dart';

final box = GetStorage();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SearchProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeChanger(),
        ),
        ChangeNotifierProvider(
          create: (_) => BottomProvider(),
        ),
      ],
      child: Builder(
        builder: (BuildContext context) {
          final darkprovider = Provider.of<ThemeChanger>(context);
          return GetMaterialApp.router(
            locale: const Locale('en', 'US'),
            fallbackLocale: const Locale('en', 'US'),
            translations: Languages(),
            debugShowCheckedModeBanner: false,
            title: 'Instagram',
            darkTheme: ThemeData(
                brightness: Brightness.dark,
                appBarTheme: const AppBarTheme(color: blackclr)),
            theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.blue,
            ),
            themeMode: darkprovider.themeMode,
            builder: EasyLoading.init(),
            routerDelegate: AppRoute.router.routerDelegate,
            routeInformationProvider: AppRoute.router.routeInformationProvider,
            routeInformationParser: AppRoute.router.routeInformationParser,
          );
        },
      ),
    );
  }
}
