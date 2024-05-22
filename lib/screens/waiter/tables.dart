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

  // void getNotificationsFromFirebase() async {
  //   try {
  //     QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
  //         .instance
  //         .collection('notifications')
  //         .where('tableNumber', isEqualTo: widget.tableNumber)
  //         .orderBy('timestamp', descending: true)
  //         .get();

  //     if (snapshot.docs.isNotEmpty) {
  //       snapshot.docs.forEach((doc) {
  //         String message = doc['message'];
  //         print('Bildirim: $message');
  //       });
  //     } else {
  //       print('Henüz bildirim yok.');
  //     }
  //   } catch (e) {
  //     print('Hata oluştu: $e');
  //   }
  // }

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
                              
                          return Card(
                            child: ListTile(
                              title: Text(
                                notification['message'],
                                style: TextStyle(
                                  fontWeight: isChecked
                                      ? FontWeight.normal
                                      : FontWeight.bold,
                                ),
                              ),
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
                      return ListView.builder(
                        itemCount: orderSnapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var order = orderSnapshot.data!.docs[index];
                          var data = order.data() as Map<String, dynamic>;
                          bool isChecked = data.containsKey('checked')
                              ? data['checked']
                              : false;

                          return Card(
                            child: ListTile(
                              title: Text(
                                order['name'],
                                style: TextStyle(
                                  fontWeight: isChecked
                                      ? FontWeight.normal
                                      : FontWeight.bold,
                                ),
                              ),
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
