import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../my_widgets.dart';

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
      final firebase_storage.Reference ref = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('images/$fileName');
      await ref.putFile(_image!);

      final String imageUrl = await ref.getDownloadURL();
      print('Image uploaded. URL: $imageUrl');

      _addMenuItem(imageUrl);
    } catch (e) {
      print('Error uploading image: $e');
    }
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
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          'Menü Yönetimi',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        decoration: WidgetBackcolor(
          Colors.blueAccent,
          Colors.white,
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _getImage();
                    },
                    child: const Text(
                      'Fotoğraf seç',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 15,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      backgroundColor: Colors.blue[200],
                      minimumSize: const Size(double.infinity, 35),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  _image != null
                      ? Image.file(
                          _image!,
                          height: 200,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.blueGrey[100],
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.blue[200]!, // Gradient renkleri
                                Colors.purple[200]!,
                              ],
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.image,
                              size: 80,
                              color: Colors.white,
                            ),
                          ),
                        ),
                  const SizedBox(height: 20.0),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                    items: <String>[
                      'Çorba',
                      'Ana yemek',
                      'Ara Sıcak',
                      'Tatlı',
                      'Atıştırmalıklar'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.category_outlined),
                      labelText: 'Kategori',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  inputField(_ingredientsController, Icons.set_meal,
                      'Malzemeler (virgülle ayırın)'),
                  const SizedBox(height: 20.0),
                  inputField(_nameController,
                      Icons.emoji_food_beverage_outlined, 'İsim'),
                  const SizedBox(height: 20.0),
                  inputField(
                      _priceController, Icons.price_change_outlined, 'Fiyat'),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      _uploadImage();
                    },
                    child: const Text(
                      'Menüye Ekle',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 15,
                      //primary: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      backgroundColor: Colors.blueAccent[100],
                      minimumSize: const Size(double.infinity, 50),
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

  void _addMenuItem(String imageUrl) {
    List<String> ingredients = _ingredientsController.text.split(',');
    String name = _nameController.text;
    double price = double.tryParse(_priceController.text) ?? 0.0;

    if (_selectedCategory != null &&
        ingredients.isNotEmpty &&
        name.isNotEmpty &&
        price > 0) {
      FirebaseFirestore.instance
          .collection('menu')
          .doc(_selectedCategory)
          .collection('items')
          .add({
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
          title: const Text('Başarılı'),
          content: const Text('Menü öğesi başarıyla eklendi.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('TAMAM'),
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
          title: const Text('Hata'),
          content: const Text('Bir hata oluştu. Lütfen daha sonra tekrar deneyiniz.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('TAMAM'),
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
          title: const Text('Doğrulama Hatası'),
          content: const Text('Lütfen tüm alanları doğru şekilde doldurunuz.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('TAMAM'),
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
