import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:waiter_app/my_widgets.dart';

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
      title: 'Masa Yonetimi Sayfası',
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        hoverColor: Colors.deepPurpleAccent,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TableManagementScreen(),
    );
  }
}

class TableManagementScreen extends StatefulWidget {
  @override
  _TableManagementScreenState createState() => _TableManagementScreenState();
}

class _TableManagementScreenState extends State<TableManagementScreen> {
  final _tTableNo = TextEditingController();

  Widget inputField(TextEditingController controller, icon, String text) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number, // Sadece sayısal girişe izin ver
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

  Future<void> _addTable() async {
    await locator.get<AuthService>().addTable(_tTableNo.text);
    _tTableNo.clear(); // Formu temizle
    setState(() {}); // Ekranı güncelle
  }

  Future<void> _deleteTable(int tableNumber) async {
    await locator.get<AuthService>().deleteTable(tableNumber);
    setState(() {}); // Ekranı güncelle
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF9C27B0),
        title: const Text(
          'Masa Yönetimi',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: Container(
        decoration: WidgetBackcolor(
          Color(0xFF9C27B0),
          Colors.white38,
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
                  const SizedBox(height: 20),
                  inputField(
                    _tTableNo,
                    Icons.table_bar_rounded,
                    'Masa Numarası',
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _addTable,
                      child:
                          Text('KAYDET', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        backgroundColor: Color(0xFF9C27B0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('tables')
                        .orderBy('tableNumber', descending: false)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return const Text('Bir hata oluştu.');
                      }
                      final tables = snapshot.data!.docs;
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: tables.length,
                        itemBuilder: (context, index) {
                          final table = tables[index];
                          final tableData =
                              table.data() as Map<String, dynamic>;
                          final tableNumber = tableData['tableNumber'];
                          return ListTile(
                            title: Text('Masa $tableNumber'),
                            trailing: IconButton(
                              icon:
                                  Icon(Icons.delete, color: Color(0xFF9C27B0)),
                              onPressed: () => _deleteTable(tableNumber),
                            ),
                          );
                        },
                      );
                    },
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
