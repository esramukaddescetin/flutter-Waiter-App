import 'package:flutter/material.dart';
import 'package:waiter_app/screens/admin/register.dart';
import 'package:waiter_app/screens/admin/table_management.dart';

import '../../my_widgets.dart';
import './menu_management.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white60,
        title: Text('Admin Paneli'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
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
            ListTile(
              title: Text('Menü Yönetimi'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MenuManagementScreen()),
                );
              },
            ),
            ListTile(
              title: Text('Üye Yönetimi'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
            ),
            ListTile(
              title: Text('Garson Yönetimi'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Müşteri Yönetimi'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Masa Yönetimi'),
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
        child: Center(
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
