import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../my_widgets.dart';

class TableDetailsPage extends StatefulWidget {
  final int tableNumber;

  TableDetailsPage({required this.tableNumber});

  @override
  _TableDetailsPageState createState() => _TableDetailsPageState();
}

class _TableDetailsPageState extends State<TableDetailsPage> {
  int selectedTableNumber = 0; // Seçilen masa numarası

  @override
  void initState() {
    super.initState();
  }

  void updateNotificationChecked(String docId, bool isChecked) {
    FirebaseFirestore.instance.collection('notifications').doc(docId).update({
      'checked': isChecked,
    });
  }

  void updateOrderChecked(String docId, bool isChecked) {
    FirebaseFirestore.instance.collection('orders').doc(docId).update({
      'checked': isChecked,
    });
  }

  void clearTableData(int tableNumber) {
    // Masaya ait tüm bildirimleri sil
    FirebaseFirestore.instance
        .collection('notifications')
        .where('tableNumber', isEqualTo: tableNumber)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    });

    // Masaya ait tüm siparişleri sil
    FirebaseFirestore.instance
        .collection('orders')
        .where('tableNumber', isEqualTo: tableNumber)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    });
  }

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    selectedTableNumber = widget.tableNumber;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Masa ${widget.tableNumber}',
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.pink[800],
              fontFamily: 'MadimiOne'),
        ),
        backgroundColor: const Color(0xFFEF9A9A), // App bar arka plan rengi
        actions: [
          IconButton(
            icon: Icon(Icons.cleaning_services),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Masa Temizleme'),
                  content: Text(
                      'Masa ${widget.tableNumber} için tüm siparişleri ve bildirimleri silmek istediğinizden emin misiniz?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('İptal'),
                    ),
                    TextButton(
                      onPressed: () {
                        clearTableData(widget.tableNumber);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text('Evet'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: WidgetBackcolor(
          const Color(0xFFEF9A9A),
          Colors.white,
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Icon(Icons.notifications, size: 24, color: Colors.pink[700]),
                  const SizedBox(width: 8),
                  Text(
                    'İstekler',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink[700],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('notifications')
                    .where('tableNumber', isEqualTo: widget.tableNumber)
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot> notificationSnapshot) {
                  if (notificationSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    if (notificationSnapshot.hasData &&
                        notificationSnapshot.data!.docs.isNotEmpty) {
                      return ListView.builder(
                        itemCount: notificationSnapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var notification =
                              notificationSnapshot.data!.docs[index];
                          var data =
                              notification.data() as Map<String, dynamic>;
                          bool isChecked = data.containsKey('checked')
                              ? data['checked']
                              : false;
                          String timestamp = formatTimestamp(data['timestamp']);

                          return Card(
                            child: ListTile(
                              title: Text(
                                data['message'] ?? '',
                                style: TextStyle(
                                  fontWeight: isChecked
                                      ? FontWeight.normal
                                      : FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(timestamp),
                              trailing: Checkbox(
                                value: isChecked,
                                onChanged: (bool? value) {
                                  updateNotificationChecked(
                                      notification.id, value ?? false);
                                },
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(child: Text('Henüz bildirim yok.'));
                    }
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Icon(Icons.shopping_cart, size: 24, color: Colors.pink[700]),
                  const SizedBox(width: 8),
                  Text(
                    'Siparişler',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink[700],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('orders')
                    .where('tableNumber', isEqualTo: widget.tableNumber)
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> orderSnapshot) {
                  if (orderSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    if (orderSnapshot.hasData &&
                        orderSnapshot.data!.docs.isNotEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              'Toplam Sipariş: ${orderSnapshot.data!.docs.length}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.pink[700],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: ListView.builder(
                              itemCount: orderSnapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                var order = orderSnapshot.data!.docs[index];
                                var data = order.data() as Map<String, dynamic>;
                                bool isChecked = data.containsKey('checked')
                                    ? data['checked']
                                    : false;
                                int quantity = data.containsKey('quantity')
                                    ? data['quantity']
                                    : 1;
                                String timestamp =
                                    formatTimestamp(data['timestamp']);

                                return Card(
                                  child: ListTile(
                                    title: Text(
                                      '${data['name']} - Adet: $quantity',
                                      style: TextStyle(
                                        fontWeight: isChecked
                                            ? FontWeight.normal
                                            : FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(timestamp),
                                    trailing: Checkbox(
                                      value: isChecked,
                                      onChanged: (bool? value) {
                                        updateOrderChecked(
                                            order.id, value ?? false);
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Center(child: Text('Henüz sipariş yok.'));
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  int tableNumber = 1;
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TableDetailsPage(tableNumber: tableNumber),
  ));
}
