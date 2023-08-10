import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:outwork_web_app/assets/app_theme.dart';
import 'package:outwork_web_app/screens/auth/auth_widget_tree.dart';

import 'firebase_options.dart';

// ignore: depend_on_referenced_packages
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


    initializeDateFormatting('es_MX', null).then((_) => runApp(const MyApp()));

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Outwork App',
      theme: TeAppThemeData.darkTheme,
      home: const AuthWidgetTree(),
    );
  }
}
