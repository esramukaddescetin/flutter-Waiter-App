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
        });
      } else {
        print('Henüz bildirim yok.');
      }
    } catch (e) {
      print('Hata oluştu: $e');
    }
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
                          var data = notification.data() as Map<String, dynamic>;
                          bool isChecked = data.containsKey('checked') ? data['checked'] : false;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Card(
                              elevation: 3,
                              child: ListTile(
                                leading: Checkbox(
                                  value: isChecked,
                                  onChanged: (bool? value) {
                                    updateNotificationChecked(
                                        notification.id, value!);
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
                      Map<String, dynamic> uniqueOrders = {};
                      orderSnapshot.data!.docs.forEach((doc) {
                        String productName = doc['name'];
                        var data = doc.data() as Map<String, dynamic>;
                        if (uniqueOrders.containsKey(productName)) {
                          uniqueOrders[productName]['quantity'] += data['quantity'];
                        } else {
                          uniqueOrders[productName] = {
                            'quantity': data['quantity'],
                            'name': data['name'],
                            'id': doc.id,
                            'checked': data.containsKey('checked') ? data['checked'] : false,
                          };
                        }
                      });
                      return ListView.builder(
                        itemCount: uniqueOrders.length,
                        itemBuilder: (context, index) {
                          String productName =
                              uniqueOrders.keys.elementAt(index);
                          var order = uniqueOrders[productName];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Card(
                              elevation: 3,
                              child: ListTile(
                                leading: Checkbox(
                                  value: order['checked'],
                                  onChanged: (bool? value) {
                                    updateOrderChecked(order['id'], value!);
                                  },
                                ),
                                title: Text(order['name']),
                                subtitle: Text(
                                  'Miktar: ${order['quantity']}',
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
