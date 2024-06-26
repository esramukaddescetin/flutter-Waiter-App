import 'package:flutter/material.dart';
import 'package:waiter_app/screens/admin/admin_management.dart/admin_list.dart';
import 'package:waiter_app/screens/admin/member/member_list.dart';
import 'package:waiter_app/screens/admin/menu/menu_management.dart';
import 'package:waiter_app/screens/admin/register.dart';
import 'package:waiter_app/screens/admin/table_management.dart';
import 'package:waiter_app/screens/admin/waiter/waiter_list.dart';
import 'menu/menu_list.dart';

import '../../my_widgets.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white60,
        title: const Text('Admin Paneli'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.grey, Colors.amber],
                ),
              ),
              child: Text(
                'Admin Panel',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ExpansionTile(
              title: const Text('Menü Yönetimi'),
              children: [
                ListTile(
                  title: const Text('Menü Listesi'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MenuListScreen()),
                    );
                  },
                ),
                ListTile(
                  title: const Text('Yönetim Ayarları'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MenuManagementScreen()),
                    );
                  },
                ),
              ],
            ),
            ExpansionTile(
              title: const Text('Üye Yönetimi'),
              children: [
                ListTile(
                  title: const Text('Üye Listesi'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserListScreen()),
                    );
                  },
                ),
                ListTile(
                  title: const Text('Üye ekle'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                ),
              ],
            ),
            ExpansionTile(
              title: const Text('Garson Yönetimi'),
              children: [
                ListTile(
                  title: const Text('Garson Listesi'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WaiterListScreen()),
                    );
                  },
                ),
                ListTile(
                  title: const Text('Garson Ekle'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                ),
              ],
            ),
            ExpansionTile(
              title: const Text('Admin Yönetimi'),
              children: [
                ListTile(
                  title: const Text('Admin Listesi'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdminListScreen()),
                    );
                  },
                ),
                ListTile(
                  title: const Text('Admin Ekle'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                ),
              ],
            ),
            ListTile(
              title: const Text('Masa Yönetimi'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TableManagementScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: WidgetBackcolor(Colors.white60, Colors.amber),
        child: const Center(
          child: Text(
            'Yönetici Kontrol Paneli Gövdesi',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Admin Panel',
    home: AdminDashboard(),
  ));
}
