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
  Map<String, bool> notificationChecked = {};
  Map<String, bool> orderChecked = {};

  @override
  void initState() {
    super.initState();
    getNotificationsFromFirebase();
  }

  void getNotificationsFromFirebase() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('notifications')
          .where('tableNumber', isEqualTo: widget.tableNumber)
          .orderBy('timestamp', descending: true)
          .get();

      if (snapshot.docs.isNotEmpty) {
        snapshot.docs.forEach((doc) {
          String message = doc['message'];
          print('Bildirim: $message');
          setState(() {
            notificationChecked[doc.id] = false;
          });
        });
      } else {
        print('Henüz bildirim yok.');
      }
    } catch (e) {
      print('Hata oluştu: $e');
    }
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
        backgroundColor: Color(0xFFEF9A9A), // App bar arka plan rengi
      ),
      body: Container(
        decoration: WidgetBackcolor(
          Color(0xFFEF9A9A),
          Colors.white,
        ),
        //  color: Colors.grey[200], // Arka plan rengi
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Icon(Icons.notifications, size: 24, color: Colors.pink[700]),
                  SizedBox(width: 8),
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
            SizedBox(height: 8),
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
                    return Center(child: CircularProgressIndicator());
                  } else {
                    if (notificationSnapshot.hasData &&
                        notificationSnapshot.data!.docs.isNotEmpty) {
                      return ListView.builder(
                        itemCount: notificationSnapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var notification =
                              notificationSnapshot.data!.docs[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Card(
                              elevation: 3,
                              child: ListTile(
                                leading: Checkbox(
                                  value: notificationChecked[notification.id] ??
                                      false,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      notificationChecked[notification.id] =
                                          value!;
                                    });
                                  },
                                ),
                                title: Text(notification['message']),
                                subtitle: Text(
                                  'İstek',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: Text(
                          'Henüz bildirim yok.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }
                  }
                },
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Icon(Icons.shopping_cart, size: 24, color: Colors.pink[700]),
                  SizedBox(width: 8),
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
            SizedBox(height: 8),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('orders')
                    .where('tableNumber', isEqualTo: widget.tableNumber)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> orderSnapshot) {
                  if (orderSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    if (orderSnapshot.hasData &&
                        orderSnapshot.data!.docs.isNotEmpty) {
                      return ListView.builder(
                        itemCount: orderSnapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var order = orderSnapshot.data!.docs[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Card(
                              elevation: 3,
                              child: ListTile(
                                leading: Checkbox(
                                  value: orderChecked[order.id] ?? false,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      orderChecked[order.id] = value!;
                                    });
                                  },
                                ),
                                title: Text(order['name']),
                                subtitle: Text(
                                  'Sipariş ID: ${order.id}',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: Text(
                          'Bu masa için henüz sipariş yok.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
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
