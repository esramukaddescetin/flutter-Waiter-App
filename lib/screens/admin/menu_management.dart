import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MenuManagementScreen extends StatefulWidget {
  @override
  _MenuManagementScreenState createState() => _MenuManagementScreenState();
}

class _MenuManagementScreenState extends State<MenuManagementScreen> {
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  File? _image;

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Widget inputField(TextEditingController controller, icon, String text) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: text,
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
        title: Text('Menu Management'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                _getImage();
              },
              child: Text('Select Image'),
            ),
            SizedBox(height: 16.0),
            _image != null
                ? Image.file(
                    _image!,
                    height: 200,
                  )
                : Placeholder(
                    fallbackHeight: 200,
                  ),
            SizedBox(height: 16.0),
            inputField(_ingredientsController, Icons.food_bank,
                'Ingredients (comma separated)'),
            SizedBox(height: 16.0),
            TextField(
              controller: _ingredientsController,
              decoration:
                  InputDecoration(labelText: 'Ingredients (comma separated)'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _addMenuItem();
              },
              child: Text('Add Menu Item'),
            ),
          ],
        ),
      ),
    );
  }

  void _addMenuItem() {
    String? imageUrl;
    if (_image != null) {
      // Firebase Storage'a görüntüyü yükleme ve URL alımı
      // Bu kısmı Firebase Storage kullanımına göre güncellemelisiniz.
      // Bu örnek sadece bir URL döndürüyor.
      imageUrl = 'https://example.com/image.jpg';
    }

    List<String> ingredients = _ingredientsController.text.split(',');
    String name = _nameController.text;
    double price = double.tryParse(_priceController.text) ?? 0.0;

    if (ingredients.isNotEmpty && name.isNotEmpty && price > 0) {
      FirebaseFirestore.instance.collection('menu').add({
        'imageUrl': imageUrl,
        'ingredients': ingredients,
        'name': name,
        'price': price,
      }).then((value) {
        _showSuccessDialog();
        _clearControllers();
      }).catchError((error) {
        _showErrorDialog();
      });
    } else {
      _showValidationErrorDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Menu item added successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('An error occurred. Please try again later.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showValidationErrorDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Validation Error'),
          content: Text('Please fill all fields correctly.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _clearControllers() {
    _ingredientsController.clear();
    _nameController.clear();
    _priceController.clear();
  }
}
