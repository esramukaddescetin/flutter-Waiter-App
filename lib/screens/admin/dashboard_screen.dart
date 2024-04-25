import 'package:flutter/material.dart';
import './menu_management.dart'; // Menu yönetimi ekranının import edilmesi

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.grey, Colors.green], // Renkler burada özelleştirildi
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
              title: Text('Menu Yönetimi'),
              onTap: () {
                Navigator.pop(context); // Drawer'ı kapat
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MenuManagementScreen()), // Menu yönetimi ekranına geçiş
                );
              },
            ),
            ListTile(
              title: Text('Garson Yönetimi'),
              onTap: () {
                // Buraya Garson Yönetimi ekranının geçiş işlemi eklenebilir
              },
            ),
            ListTile(
              title: Text('Müşteri Yönetimi'),
              onTap: () {
                // Buraya Müşteri Yönetimi ekranının geçiş işlemi eklenebilir
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey[200]!, Colors.green[200]!], // Renkler burada özelleştirildi
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Text(
            'Admin Dashboard Body',
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
