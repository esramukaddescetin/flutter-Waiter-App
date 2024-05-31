import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MenuListScreen extends StatefulWidget {
  @override
  _MenuListScreenState createState() => _MenuListScreenState();
}

class _MenuListScreenState extends State<MenuListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menü Listesi'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collectionGroup('items').snapshots(),
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
                title: Text(category),
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
                    title: Text(itemData['name']),
                    subtitle: Text('${itemData['price']} TL'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // Düzenleme işlemleri
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _deleteMenuItem(item.reference);
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

  void _deleteMenuItem(DocumentReference itemRef) {
    itemRef
        .delete()
        .then((value) {
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
