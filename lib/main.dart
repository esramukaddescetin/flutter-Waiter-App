import 'package:flutter/material.dart';
import 'package:waiter_app/screens/waiter_panel.dart';

import 'screens/admin_login.dart';
import 'screens/dashboard_screen.dart';
import 'screens/home_page.dart';
import 'screens/waiter_login.dart';

void main() => runApp(WaiterApp());

class WaiterApp extends StatelessWidget {
  const WaiterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/homePage': (context) => HomePage(),
        '/waiterLogin': (context) => WaiterLogin(),
        '/adminLogin': (context) => AdminLogin(),
        '/tablesScreen': (context) => Tables(),
        '/dashboardScreen': (context) => DashboardScreen(),
      },
    );
  }
}
