import 'package:flutter/material.dart';

import '../../my_widgets.dart';

class WaiterLogin extends StatefulWidget {
  @override
  _StaffLoginPageState createState() => _StaffLoginPageState();
}

class _StaffLoginPageState extends State<WaiterLogin> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: WidgetBackcolor(
              Colors.green,
              Colors.white60,
            ),
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Garson Girişi',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Kullanıcı Adı',
                      prefixIcon: Icon(Icons.person, color: Colors.white),
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Şifre',
                      prefixIcon: Icon(Icons.lock, color: Colors.white),
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 12,
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/tablesScreen');
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        'Giriş',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconBack(),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Personel Girişi',
    home: WaiterLogin(),
  ));
}
