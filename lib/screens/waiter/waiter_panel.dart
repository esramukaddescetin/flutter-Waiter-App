import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:waiter_app/screens/waiter/tables.dart';

class WaiterPanel extends StatefulWidget {
  @override
  _WaiterPanelState createState() => _WaiterPanelState();
}

class _WaiterPanelState extends State<WaiterPanel> {
  int selectedTableNumber = 0;

  @override
  void initState() {
    super.initState();
  }

  Future<bool> checkTableStatus(int tableNumber) async {
    // Orders koleksiyonundan kontrol et
    QuerySnapshot orderSnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('tableNumber', isEqualTo: tableNumber)
        .get();
    bool hasUnseenOrders = orderSnapshot.docs.any(
        (doc) => !(doc.data() as Map<String, dynamic>)['checked'] ?? false);

    // Notifications koleksiyonundan kontrol et
    QuerySnapshot notificationSnapshot = await FirebaseFirestore.instance
        .collection('notifications')
        .where('tableNumber', isEqualTo: tableNumber)
        .get();
    bool hasUnseenNotifications = notificationSnapshot.docs.any(
        (doc) => !(doc.data() as Map<String, dynamic>)['checked'] ?? false);

    return hasUnseenOrders || hasUnseenNotifications;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text('Masalar', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.grey[200],
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
          children: List.generate(20, (index) {
            int tableNumber = index + 1;
            return FutureBuilder<bool>(
              future: checkTableStatus(tableNumber),
              builder: (context, snapshot) {
                bool hasNotification = snapshot.data ?? false;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TableDetailsPage(tableNumber: tableNumber),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: hasNotification
                          ? Colors.red.shade200
                          : Colors.green.shade200, // Kırmızı veya yeşil tonu
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: const Offset(0, 2), // Shadow offset
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'Masa $tableNumber',
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
