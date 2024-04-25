import 'package:flutter/material.dart';

void main() {
  runApp(WaiterPanel());
}

class WaiterPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Text('Masalar', style: TextStyle(color: Colors.white)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          color: Colors.grey[200],
          padding: EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 2, // İki butonu yatayda yan yana göstermek için
            mainAxisSpacing: 16.0,
            crossAxisSpacing: 16.0,
            children: List.generate(20, (index) {
              // 20 masa numarası için butonlar oluşturuyoruz
              int tableNumber = index + 1; // Masa numarası 1'den başlıyor
              return Container(
                decoration: BoxDecoration(
                  color: Colors.green.shade200, // Yeşil tonu
                  borderRadius: BorderRadius.circular(
                      12.0), // Kare yapmak için kenar yarıçapı
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: Offset(0, 2), // Shadow offset
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: () {
                    print('Masa $tableNumber');
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.all(16.0),
                  ),
                  child: Text(
                    'Masa $tableNumber',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
