import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waiter_app/screens/admin/admin_management.dart/admin_edit.dart';
import 'package:waiter_app/screens/admin/admin_management.dart/admin_list.dart';
import 'package:waiter_app/screens/admin/member/member_edit.dart';
import 'package:waiter_app/screens/admin/member/member_list.dart';
import 'package:waiter_app/screens/admin/menu/menu_list.dart';
import 'package:waiter_app/screens/admin/menu/menu_management.dart';
import 'package:waiter_app/screens/admin/register.dart';
import 'package:waiter_app/screens/admin/table_management.dart';
import 'package:waiter_app/screens/admin/waiter/waiter_edit.dart';
import 'package:waiter_app/screens/admin/waiter/waiter_list.dart';
import 'package:waiter_app/screens/waiter/panel/waiter_panel.dart';
import 'package:waiter_app/services/provider/auth_provider.dart';


import 'firebase_options.dart';
import 'screens/admin/admin_login.dart';
import 'screens/admin/dashboard_screen.dart';
import 'screens/home_page.dart';
import 'screens/waiter/waiter_login.dart';
import 'utils/locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupLocator();
  // initializeNotifications();
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
        '/register': (context) => RegisterScreen(),
        '/menuManagementScreen': (context) => MenuManagementScreen(),
        '/tableManagementScreen': (context) => TableManagementScreen(),
        '/menuListScreen': (context) => MenuListScreen(),
        '/memberListScreen': (context) => UserListScreen(),
        '/editUserScreen': (context) => EditUserScreen(userData: {}, userId: '',),
        '/waiterListScreen': (context) => WaiterListScreen(),
        '/editWaiterScreen': (context) => WaiterEditScreen(waiterData: {}, waiterId: '',),
        '/adminListScreen': (context) => AdminListScreen(),
        '/editAdminScreen': (context) => AdminEditScreen(adminData: {}, adminId: '',),
      },
    );
  }
}
