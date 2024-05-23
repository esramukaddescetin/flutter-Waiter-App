import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/my_widgets.dart';
import '/phone_input_formatter.dart';
import '/services/auth_service.dart';
import '/utils/locator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Masa Yonetimi Sayfası',
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        hoverColor: Colors.deepPurpleAccent,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TableManagementScreen(),
    );
  }
}

class TableManagementScreen extends StatelessWidget {
  final _tTableNo = TextEditingController();

  Widget inputField(TextEditingController controller, icon, String text) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: text,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightGreen,
          title: const Text(
            'Masa Yönetimi',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.grey[200],
        body: Container(
          decoration: WidgetBackcolor(
            Colors.lightGreen,
            Colors.grey,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image.asset(
                        'assets/images/restaurant.png',
                        width: 200,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 20),
                    inputField(
                      _tTableNo,
                      Icons.table_bar_rounded,
                      'Masa Numarasi',
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          locator.get<AuthService>().addTable(_tTableNo.text);
                        },
                        child: Text('KAYDET',
                            style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          //primary: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          backgroundColor: Colors.lightGreen[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
