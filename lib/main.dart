import 'package:flutter/material.dart';

import 'home_page.dart';
import 'login_page.dart';

void main() => runApp(WaiterApp());

class WaiterApp extends StatelessWidget {
  const WaiterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/homePage': (context) => HomePage(),
        '/loginPage': (context) => LoginPage(),
      },
    );
  }
}
