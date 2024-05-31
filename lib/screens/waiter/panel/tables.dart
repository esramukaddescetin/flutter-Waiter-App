import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:waiter_app/screens/waiter/orders/past_orders.dart';
import '../../../my_widgets.dart';

class TableDetailsPage extends StatefulWidget {
  final int tableNumber;

  TableDetailsPage({required this.tableNumber});

  @override
  _TableDetailsPageState createState() => _TableDetailsPageState();
}

class _TableDetailsPageState extends State<TableDetailsPage> {
  int selectedTableNumber = 0;
  Map<String, int> initialQuantities = {};

  // State variables to track the visibility of each list
  bool notificationsVisible = true;
  bool requestsVisible = false;
  bool ordersVisible = false;

  // Function to toggle the visibility of each list
  void toggleListVisibility(String listType) {
    setState(() {
      switch (listType) {
        case 'notifications':
          notificationsVisible = !notificationsVisible;
          break;
        case 'requests':
          requestsVisible = !requestsVisible;
          break;
        case 'orders':
          ordersVisible = !ordersVisible;
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    selectedTableNumber = widget.tableNumber;
    fetchInitialQuantities();
  }

  void fetchInitialQuantities() {
    FirebaseFirestore.instance
        .collection('orders')
        .where('tableNumber', isEqualTo: widget.tableNumber)
        .get()
        .then((querySnapshot) {
      setState(() {
        for (var doc in querySnapshot.docs) {
          var data = doc.data() as Map<String, dynamic>;
          initialQuantities[doc.id] = data['quantity'] ?? 1;
        }
      });
    });
  }

  void updateNotificationChecked(String docId, bool isChecked) {
    FirebaseFirestore.instance.collection('notifications').doc(docId).update({
      'checked': isChecked,
    }).catchError((error) {
      print("Bildirim güncellenemedi: $error");
    });
  }

  void updateRequestChecked(String docId, bool isChecked) {
    FirebaseFirestore.instance.collection('waiter_requests').doc(docId).update({
      'checked': isChecked,
    }).catchError((error) {
      print("Talep güncellenemedi: $error");
    });
  }

  void updateOrderChecked(String docId, bool isChecked) {
    FirebaseFirestore.instance.collection('orders').doc(docId).update({
      'checked': isChecked,
    }).then((_) {
      if (isChecked) {
        moveOrderToCompleted(docId);
      }
    }).catchError((error) {
      print("Sipariş güncellenemedi: $error");
    });
  }

  void moveOrderToCompleted(String docId) async {
    DocumentSnapshot orderDoc =
        await FirebaseFirestore.instance.collection('orders').doc(docId).get();
    var orderData = orderDoc.data() as Map<String, dynamic>;

    await FirebaseFirestore.instance
        .collection('completed_orders')
        .add(orderData);
    await FirebaseFirestore.instance.collection('orders').doc(docId).delete();
  }

  void clearTableData(int tableNumber) {
    FirebaseFirestore.instance
        .collection('notifications')
        .where('tableNumber', isEqualTo: tableNumber)
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.delete().catchError((error) {
          print("Bildirim silinemedi: $error");
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
          print("Sipariş silinemedi: $error");
        });
      }
    });

    FirebaseFirestore.instance
        .collection('waiter_requests')
        .where('tableNumber', isEqualTo: tableNumber)
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.delete().catchError((error) {
          print("Talep silinemedi: $error");
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
            icon: const Icon(Icons.cleaning_services),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Masa Temizleme'),
                  content: Text(
                      'Masa ${widget.tableNumber} için tüm siparişleri ve bildirimleri silmek istediğinizden emin misiniz?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('İptal'),
                    ),
                    TextButton(
                      onPressed: () {
                        clearTableData(widget.tableNumber);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text('Evet'),
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
                    'Bildirimler',
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
                          color: isChecked ? Colors.grey[300] : Colors.white,
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
                  Icon(Icons.notifications, size: 24, color: Colors.pink[700]),
                  const SizedBox(width: 8),
                  Text(
                    'Talepler',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink[700],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_drop_down_circle),
                    onPressed: () {
                      toggleListVisibility('requests');
                    },
                  ),
                ],
              ),
            ),
            Visibility(
              visible: requestsVisible,
              child: Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('waiter_requests')
                      .where('tableNumber', isEqualTo: widget.tableNumber)
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot> requestSnapshot) {
                    if (requestSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (requestSnapshot.hasError) {
                      return Center(
                          child: Text(
                              'Bir hata oluştu: ${requestSnapshot.error}'));
                    } else if (!requestSnapshot.hasData ||
                        requestSnapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('Henüz talep yok.'));
                    } else {
                      return ListView.builder(
                        itemCount: requestSnapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var request = requestSnapshot.data!.docs[index];
                          var data = request.data() as Map<String, dynamic>;
                          String title = data['title'] ?? '';
                          String requestText = data['request'] ?? '';
                          Timestamp timestamp = data['timestamp'];
                          String formattedTimestamp =
                              formatTimestamp(timestamp);
                          bool isChecked = data['checked'] ?? false;
                          return Card(
                            color: isChecked ? Colors.grey[300] : Colors.white,
                            child: ListTile(
                              title: Text(
                                title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(requestText),
                                  Text(formattedTimestamp),
                                ],
                              ),
                              trailing: Checkbox(
                                value: isChecked,
                                onChanged: (bool? value) {
                                  updateRequestChecked(
                                      request.id, value ?? false);
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
                  IconButton(
                    icon: Icon(Icons.arrow_drop_down_circle),
                    onPressed: () {
                      toggleListVisibility('orders');
                    },
                  ),
                ],
              ),
            ),
            Visibility(
              visible: ordersVisible,
              child: Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('orders')
                      .where('tableNumber', isEqualTo: widget.tableNumber)
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot> orderSnapshot) {
                    if (orderSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (orderSnapshot.hasError) {
                      return Center(
                          child:
                              Text('Bir hata oluştu: ${orderSnapshot.error}'));
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

                          bool quantityChanged =
                              initialQuantities.containsKey(order.id) &&
                                  initialQuantities[order.id] != quantity;
                          return Card(
                            color: isChecked ? Colors.grey[300] : Colors.white,
                            child: ListTile(
                              title: Text(
                                '${data['name']} - Adet: $quantity',
                                style: TextStyle(
                                  color: quantityChanged
                                      ? Colors.red
                                      : Colors.black,
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
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PastOrdersScreen(tableNumber: widget.tableNumber),
                    ),
                  );
                },
                child: const Text('Geçmiş Siparişleri Görüntüle'),
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
