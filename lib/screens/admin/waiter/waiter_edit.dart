import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WaiterEditScreen extends StatefulWidget {
  final String waiterId;
  final Map<String, dynamic> waiterData;

  const WaiterEditScreen({Key? key, required this.waiterId, required this.waiterData})
      : super(key: key);

  @override
  _WaiterEditScreenState createState() => _WaiterEditScreenState();
}

class _WaiterEditScreenState extends State<WaiterEditScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _nameController;
  late TextEditingController _lastNameController;
  late TextEditingController _passwordController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _usernameController =
        TextEditingController(text: widget.waiterData['username']);
    _emailController = TextEditingController(text: widget.waiterData['email']);
    _nameController = TextEditingController(text: widget.waiterData['name']);
    _lastNameController =
        TextEditingController(text: widget.waiterData['lastName']);
    _passwordController =
        TextEditingController(text: widget.waiterData['password']);
    _phoneController = TextEditingController(text: widget.waiterData['phone']);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _lastNameController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Garson Düzenleme'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Kullanıcı Adı'),
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'İsim'),
            ),
            TextFormField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Soyisim'),
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Şifre'),
            ),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Telefon'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _saveChanges();
              },
              child: const Text('Değişiklikleri Kaydet'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveChanges() {
    final updatedWaiterData = {
      'username': _usernameController.text,
      'email': _emailController.text,
      'name': _nameController.text,
      'lastName': _lastNameController.text,
      'password': _passwordController.text,
      'phone': _phoneController.text,
    };

    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.waiterId)
        .update(updatedWaiterData)
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Garson bilgileri güncellendi')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Güncelleme işlemi başarısız oldu: $error')),
      );
    });
  }
}
