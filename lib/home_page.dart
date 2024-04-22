import 'package:flutter/material.dart';

import '../my_widgets.dart';

class HomePage extends StatelessWidget {
  static String routeName = '/homePage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[200],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 320, // Genişlik
                height: 260, // Yükseklik
                decoration: BoxDecoration(
                  color: Colors.green[200], // Arka plan rengi
                  borderRadius: BorderRadius.circular(10), // Köşe yarıçapı
                ),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10), // Köşe yarıçapı
                    child: Image.asset(
                      'assets/images/waiter.png',
                      width: 310, // Resmin genişliği
                      height: 240, // Resmin yüksekliği
                      fit: BoxFit.cover, // Resmin boyutlandırma şekli
                    ),
                  ),
                ),
              ),
              Text(
                'PİGOME RESTORAN',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.green[800],
                  fontFamily: 'Yellowtail',
                ),
              ),
              Center(
                child: Text(
                  '"Her Yemeğin Arkasında Bir Gülümseme Var"',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white70,
                    fontFamily: 'MadimiOne',
                  ),
                ),
              ),
              Container(
                width: 300,
                height: 18,
                child: Divider(color: Colors.green),
              ),
              CardEntry(
                icon: Icons.mail,
                text: 'pigome@restaurant.com',
              ),
              SizedBox(
                height: 6,
              ),
              CardEntry(icon: Icons.phone, text: '0370 654 96 52'),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/loginPage');
                },
                child: ButtonEntry(giris: 'Garson Girişi'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/loginPage');
                },
                child: ButtonEntry(giris: 'Admin Girişi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
