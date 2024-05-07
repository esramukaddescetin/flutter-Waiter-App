import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MenuManagementScreen extends StatefulWidget {
  @override
  _MenuManagementScreenState createState() => _MenuManagementScreenState();
}

class _MenuManagementScreenState extends State<MenuManagementScreen> {
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  File? _image;
  String? _selectedCategory;

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

  Future<void> _uploadImage() async {
    if (_image == null) {
      print('No image selected.');
      return;
    }

    try {
      final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref().child('images/$fileName');
      await ref.putFile(_image!);

      final String imageUrl = await ref.getDownloadURL();
      print('Image uploaded. URL: $imageUrl');

      _addMenuItem(imageUrl);
    } catch (e) {
      print('Error uploading image: $e');
    }
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
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              onChanged: (String? value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
              items: <String>['Anayemek', 'Corba', 'Tatli', 'Salata'] // Örnek kategoriler
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Category',
              ),
            ),
            TextField(
              controller: _ingredientsController,
              decoration: InputDecoration(labelText: 'Ingredients (comma separated)'),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _uploadImage();
              },
              child: Text('Add Menu Item'),
            ),
          ],
        ),
      ),
    );
  }

  void _addMenuItem(String imageUrl) {
    List<String> ingredients = _ingredientsController.text.split(',');
    String name = _nameController.text;
    double price = double.tryParse(_priceController.text) ?? 0.0;

    if (_selectedCategory != null && ingredients.isNotEmpty && name.isNotEmpty && price > 0) {
      FirebaseFirestore.instance.collection('menu').doc(_selectedCategory).collection('items').add({
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
    setState(() {
      _image = null;
      _selectedCategory = null;
    });
  }
}
