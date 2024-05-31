import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditUserScreen extends StatefulWidget {
  final String userId;
  final Map<String, dynamic> userData;

  const EditUserScreen({Key? key, required this.userId, required this.userData})
      : super(key: key);

  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
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
        TextEditingController(text: widget.userData['username']);
    _emailController = TextEditingController(text: widget.userData['email']);
    _nameController = TextEditingController(text: widget.userData['name']);
    _lastNameController =
        TextEditingController(text: widget.userData['lastName']);
    _passwordController =
        TextEditingController(text: widget.userData['password']);
    _phoneController = TextEditingController(text: widget.userData['phone']);
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
        title: const Text('Kullanıcı Düzenleme'),
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
    final updatedUserData = {
      'username': _usernameController.text,
      'email': _emailController.text,
      'name': _nameController.text,
      'lastName': _lastNameController.text,
      'password': _passwordController.text,
      'phone': _phoneController.text,
    };

    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .update(updatedUserData)
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kullanıcı bilgileri güncellendi')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Güncelleme işlemi başarısız oldu: $error')),
      );
    });
  }
}
