import 'package:flutter/material.dart';

import '../../../my_widgets.dart';
import '../../services/auth_service.dart';
import '../../utils/locator.dart';

class WaiterLogin extends StatefulWidget {
  @override
  _StaffLoginPageState createState() => _StaffLoginPageState();
}

class _StaffLoginPageState extends State<WaiterLogin> {
  final TextEditingController _emailController = TextEditingController();
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
                    'Giriş',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
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
                      String email = _emailController.text.trim();
                      String password = _passwordController.text.trim();

                      // E-posta ve şifre boş mu kontrol edilir
                      if (email.isEmpty || password.isEmpty) {
                        // Eğer boşluk kaldırılmış e-posta ve şifre boşsa, hata mesajı gösterilir
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Lütfen e-posta ve şifreyi girin.'),
                        ));
                      } else {
                        // E-posta ve şifre boş değilse, giriş yapma işlemi başlatılır
                        locator
                            .get<AuthService>()
                            .waiterSignIn(context, email, password);
                      }
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
          const IconBack(),
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
