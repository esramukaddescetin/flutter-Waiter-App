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
  int selectedTableNumber = 0;

  @override
  void initState() {
    super.initState();
    selectedTableNumber = widget.tableNumber;
  }

  void updateNotificationChecked(String docId, bool isChecked) {
    FirebaseFirestore.instance.collection('notifications').doc(docId).update({
      'checked': isChecked,
    }).catchError((error) {
      print("Failed to update notification: $error");
    });
  }

  void updateOrderChecked(String docId, bool isChecked) {
    FirebaseFirestore.instance.collection('orders').doc(docId).update({
      'checked': isChecked,
    }).catchError((error) {
      print("Failed to update order: $error");
    });
  }

  void clearTableData(int tableNumber) {
    FirebaseFirestore.instance
        .collection('notifications')
        .where('tableNumber', isEqualTo: tableNumber)
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.delete().catchError((error) {
          print("Failed to delete notification: $error");
        });
      }
    });

    FirebaseFirestore.instance
        .collection('orders')
        .where('tableNumber', isEqualTo: tableNumber)
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.delete().catchError((error) {
          print("Failed to delete order: $error");
        });
      }
    });
  }

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: const Color(0xFFEF9A9A),
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
                  } else if (notificationSnapshot.hasError) {
                    return Center(
                        child: Text(
                            'Bir hata oluştu: ${notificationSnapshot.error}'));
                  } else if (!notificationSnapshot.hasData ||
                      notificationSnapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('Henüz bildirim yok.'));
                  } else {
                    return ListView.builder(
                      itemCount: notificationSnapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var notification =
                            notificationSnapshot.data!.docs[index];
                        var data = notification.data() as Map<String, dynamic>;
                        bool isChecked = data['checked'] ?? false;
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
                  } else if (orderSnapshot.hasError) {
                    return Center(
                        child: Text('Bir hata oluştu: ${orderSnapshot.error}'));
                  } else if (!orderSnapshot.hasData ||
                      orderSnapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('Henüz sipariş yok.'));
                  } else {
                    return ListView.builder(
                      itemCount: orderSnapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var order = orderSnapshot.data!.docs[index];
                        var data = order.data() as Map<String, dynamic>;
                        bool isChecked = data['checked'] ?? false;
                        int quantity = data['quantity'] ?? 1;
                        String timestamp = formatTimestamp(data['timestamp']);

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
                                updateOrderChecked(order.id, value ?? false);
                              },
                            ),
                          ),
                        );
                      },
                    );
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
