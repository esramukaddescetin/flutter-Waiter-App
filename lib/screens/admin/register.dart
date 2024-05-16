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
      title: 'Kayıt Sayfası',
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        hoverColor: Colors.deepPurpleAccent,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: RegisterScreen(),
    );
  }
}

class RegisterScreen extends StatelessWidget {
  final _tName = TextEditingController();
  final _tLastName = TextEditingController();
  final _tEmail = TextEditingController();
  final _tPhone = TextEditingController();
  final _tPassword = TextEditingController();

  String _selectedRole = 'User';

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
        title: Text(
          'Üye Yönetimi',
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
                  SizedBox(height: 20),
                  inputField(
                    _tName,
                    Icons.person,
                    'Ad',
                  ),
                  SizedBox(height: 10),
                  inputField(
                    _tLastName,
                    Icons.person,
                    'Soyad',
                  ),
                  SizedBox(height: 10),
                  inputField(
                    _tEmail,
                    Icons.email,
                    'Email',
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _tPhone,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                      PhoneInputFormatter(),
                    ],
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.phone,
                      ),
                      hintText: 'Telefon Numarası',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  inputField(
                    _tPassword,
                    Icons.lock,
                    'Şifre',
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _selectedRole,
                    onChanged: (String? newValue) {
                      _selectedRole = newValue!;
                    },
                    items:
                        <String>['Admin', 'User', 'Waiter'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      hintText: 'Rol Seçin',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        locator.get<AuthService>().signUp(
                            roles: [_selectedRole],
                            name: _tName.text,
                            lastname: _tLastName.text,
                            email: _tEmail.text,
                            // phone: int.parse(_tPhone.text),
                            phone: _tPhone.text,
                            password: _tPassword.text);
                      },
                      child:
                          Text('KAYDET', style: TextStyle(color: Colors.white)),
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
      ),
    );
  }
}
