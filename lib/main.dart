import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waiter_app/screens/admin/register.dart';
import 'package:waiter_app/screens/user/entry_table_no.dart';
import 'package:waiter_app/screens/waiter/waiter_panel.dart';
import 'package:waiter_app/services/provider/auth_provider.dart';
import 'firebase_options.dart';
import 'utils/locator.dart';
import 'screens/admin/admin_login.dart';
import 'screens/admin/dashboard_screen.dart';
import 'screens/home_page.dart';
import 'screens/waiter/waiter_login.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupLocator();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<AuthProvider>(
        create: (context) => locator.get<AuthProvider>(),
      )
    ],
    child: const WaiterApp(),
  ));
}


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
        '/waiterPanel': (context) => WaiterPanel(),
        '/dashboardScreen': (context) => AdminDashboard(),
        '/tableNumberPage': (context) => TableNumberPage(),
        '/register': (context) => RegisterScreen(),
      },
    );
  }
}
