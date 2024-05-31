import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MenuEditScreen extends StatefulWidget {
  final DocumentReference itemRef;
  final Map<String, dynamic> itemData;

  MenuEditScreen({required this.itemRef, required this.itemData});

  @override
  _MenuEditScreenState createState() => _MenuEditScreenState();
}

class _MenuEditScreenState extends State<MenuEditScreen> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _ingredientsController;
  late TextEditingController _imageUrlController;
  File? _imageFile;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.itemData['name']);
    _priceController = TextEditingController(text: widget.itemData['price'].toString());
    _ingredientsController = TextEditingController(text: widget.itemData['ingredients'].join(', '));
    _imageUrlController = TextEditingController(text: widget.itemData['imageUrl']);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _ingredientsController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<String?> _uploadImage(File image) async {
    try {
      final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/$fileName');
      await ref.putFile(image);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  void _saveChanges() async {
    setState(() {
      _isUploading = true;
    });

    String? imageUrl = _imageUrlController.text;
    if (_imageFile != null) {
      imageUrl = await _uploadImage(_imageFile!);
    }

    try {
      await widget.itemRef.update({
        'name': _nameController.text,
        'price': double.parse(_priceController.text),
        'ingredients': _ingredientsController.text.split(',').map((s) => s.trim()).toList(),
        'imageUrl': imageUrl,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Menü öğesi güncellendi')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Güncelleme başarısız oldu: $e')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menü Öğesi Düzenle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (_imageFile != null)
                Image.file(
                  _imageFile!,
                  height: 200,
                  fit: BoxFit.cover,
                )
              else if (_imageUrlController.text.isNotEmpty)
                Image.network(
                  _imageUrlController.text,
                  height: 200,
                  fit: BoxFit.cover,
                )
              else
                Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: const Center(child: Icon(Icons.image, size: 100)),
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Görsel Seç'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'İsim'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Fiyat'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ingredientsController,
                decoration: const InputDecoration(labelText: 'Malzemeler (virgülle ayırın)'),
              ),
              const SizedBox(height: 32),
              _isUploading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _saveChanges,
                      child: const Text('Kaydet'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
