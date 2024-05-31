import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:waiter_app/screens/admin/dashboard_screen.dart';
import 'package:waiter_app/screens/waiter/panel/waiter_panel.dart';

class AuthService {
  final _firestore = FirebaseFirestore.instance;
  final waiterCollection = FirebaseFirestore.instance.collection('waiters');
  final firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String lastname,
    required String phone,
    required List<String> roles, // Kullanıcı rolleri
  }) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore
          .collection('user_roles')
          .doc(userCredential.user!.uid)
          .set({
        'roles': roles,
      });

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'lastname': lastname,
        'email': email,
        'phone': phone,
        'password': password,
        'roles': roles
      });
    } catch (e) {
      print('Failed to sign up: $e');
    }
  }

  Future<void> waiterSignIn(
      BuildContext context, String email, String password) async {
    try {
      final UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      String userId = userCredential.user!.uid;
      print('User ID: $userId');
      DocumentSnapshot snapshot = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();
      dynamic rolesData = snapshot.get('roles');

      if (rolesData is List<dynamic> && rolesData.contains('Waiter')) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => WaiterPanel()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('You are not authorized to access this app.'),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to sign in: $e'),
      ));
    }
  }

  Future<void> addTable(String tableNumber) async {
    try {
      int tableNo = int.parse(tableNumber); // tableNumber'ı sayıya dönüştür
      await _db.collection('tables').doc('table_$tableNo').set({
        'tableNumber': tableNo, // Sayısal olarak kaydet
      });
      print('Masa $tableNumber eklendi.');
    } catch (e) {
      print('Hata oluştu: $e');
    }
  }

  Future<void> deleteTable(int tableNumber) async {
    try {
      await _db.collection('tables').doc('table_$tableNumber').delete();
      print('Masa $tableNumber silindi.');
    } catch (e) {
      print('Hata oluştu: $e');
    }
  }
  Future<void> adminSignIn(
      BuildContext context, String email, String password) async {
    try {
      final UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      String userId = userCredential.user!.uid;
      print('User ID: $userId');

      DocumentSnapshot snapshot = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();
      dynamic rolesData = snapshot.get('roles');

      if (rolesData is List<dynamic> && rolesData.contains('Admin')) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminDashboard()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('You are not authorized to access this app.'),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to sign in: $e'),
      ));
    }
  }
}
