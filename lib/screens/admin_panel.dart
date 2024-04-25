import 'package:flutter/material.dart';

class AdminPanelPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Paneli'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // İlgili işlemi gerçekleştir
              },
              child: Text('Ürün Ekle'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // İlgili işlemi gerçekleştir
              },
              child: Text('Kullanıcıları Yönet'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // İlgili işlemi gerçekleştir
              },
              child: Text('Raporlar'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // İlgili işlemi gerçekleştir
              },
              child: Text('Ayarlar'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AdminPanelPage(),
  ));
}
