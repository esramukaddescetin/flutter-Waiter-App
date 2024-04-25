import 'package:flutter/material.dart';

class MenuManagementScreen extends StatefulWidget {
  @override
  _MenuManagementScreenState createState() => _MenuManagementScreenState();
}

class _MenuManagementScreenState extends State<MenuManagementScreen> {
  List<String> menuItems = []; // Menü öğelerini saklamak için bir liste

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Management'),
      ),
      body: ListView.builder(
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(menuItems[index]),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  // Seçili menü öğesini listeden kaldır
                  menuItems.removeAt(index);
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Yeni menü öğesi eklemek için bir dialog göster
          _showAddMenuItemDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // Yeni menü öğesi eklemek için bir dialog göster
  void _showAddMenuItemDialog(BuildContext context) {
    TextEditingController _controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Menu Item'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: 'Enter Menu Item'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Yeni menü öğesini listeye ekle ve dialogu kapat
                setState(() {
                  menuItems.add(_controller.text);
                });
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () {
                // Dialogu kapat
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
