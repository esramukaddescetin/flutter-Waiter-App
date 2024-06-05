import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:waiter_app/screens/admin/menu/menu_edit.dart';

import '../../../my_widgets.dart';

class MenuListScreen extends StatefulWidget {
  @override
  _MenuListScreenState createState() => _MenuListScreenState();
}

class _MenuListScreenState extends State<MenuListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Menü Listesi',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'PermanentMarker',
          ),
        ),
        backgroundColor: Colors.blueGrey[400],
      ),
      body: Container(
        decoration: WidgetBackcolor(
          Colors.white38,
          Colors.blueGrey,
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collectionGroup('items').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('Menü bulunamadı.'));
            }

            final items = snapshot.data!.docs;
            final groupedItems = groupItemsByCategory(items);

            return ListView.builder(
              itemCount: groupedItems.length,
              itemBuilder: (context, index) {
                final category = groupedItems.keys.elementAt(index);
                final categoryItems = groupedItems[category]!;

                return ExpansionTile(
                  backgroundColor: Colors.grey[300],
                  title: Text(
                    category,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[800],
                      fontFamily: 'MadimiOne',
                    ),
                  ),
                  children: categoryItems.map((item) {
                    final itemData = item.data() as Map<String, dynamic>;

                    return ListTile(
                      leading: itemData['imageUrl'] != null
                          ? Image.network(
                              itemData['imageUrl'],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.image),
                      title: Text(
                        itemData['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                      subtitle: Text('${itemData['price']} TL'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MenuEditScreen(
                                    itemRef: item.reference,
                                    itemData: itemData,
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _confirmDelete(item.reference);
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Map<String, List<QueryDocumentSnapshot>> groupItemsByCategory(
      List<QueryDocumentSnapshot> items) {
    Map<String, List<QueryDocumentSnapshot>> groupedItems = {};
    for (var item in items) {
      final category = item.reference.parent.parent!.id;
      if (!groupedItems.containsKey(category)) {
        groupedItems[category] = [];
      }
      groupedItems[category]!.add(item);
    }
    return groupedItems;
  }

  void _confirmDelete(DocumentReference itemRef) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Silme Onayı'),
          content:
              const Text('Bu menü öğesini silmek istediğinize emin misiniz?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteMenuItem(itemRef);
              },
              child: const Text('Sil'),
            ),
          ],
        );
      },
    );
  }

  void _deleteMenuItem(DocumentReference itemRef) {
    itemRef.delete().then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Menü öğesi silindi')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Silme işlemi başarısız oldu: $error')),
      );
    });
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Menu List',
    home: MenuListScreen(),
  ));
}
