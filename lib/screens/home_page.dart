import 'package:flutter/material.dart';

import '../../my_widgets.dart';

class HomePage extends StatelessWidget {
  static String routeName = '/homePage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[200],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 280, // Küçültülen kısım
                  height: 220, // Küçültülen kısım
                  decoration: BoxDecoration(
                    color: Colors.green[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/images/waiter.png',
                        width: 270, // Küçültülen kısım
                        height: 200, // Küçültülen kısım
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'PİGOME RESTORAN',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.green[800],
                    fontFamily: 'Yellowtail',
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  '"Her Yemeğin Arkasında Bir Gülümseme Var"',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white70,
                    fontFamily: 'MadimiOne',
                  ),
                  textAlign: TextAlign.center,
                ),
                Container(
                  width: 300,
                  height: 18,
                  child: const Divider(color: Colors.green),
                ),
                const CardEntry(
                  icon: Icons.mail,
                  text: 'pigome@restaurant.com',
                ),
                const SizedBox(
                  height: 6,
                ),
                const CardEntry(icon: Icons.phone, text: '0370 654 96 52'),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/waiterLogin');
                  },
                  child: const ButtonEntry(giris: 'Garson Girişi'),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/adminLogin');
                  },
                  child: const ButtonEntry(giris: 'Admin Girişi'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
