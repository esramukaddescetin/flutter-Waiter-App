import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
    getOrderFromFirebase();
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
          crossAxisCount: 2, // İki butonu yatayda yan yana göstermek için
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
          children: List.generate(20, (index) {
            // 20 masa numarası için butonlar oluşturuyoruz
            int tableNumber = index + 1; // Masa numarası 1'den başlıyor
            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('orders')
                  .where('tableNumber', isEqualTo: tableNumber)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                bool hasNotification = snapshot.hasData &&
                    snapshot.data!.docs
                        .any((doc) => !(doc['checked'] ?? false));
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
                          : Colors.green.shade200, // Yeşil tonu
                      borderRadius: BorderRadius.circular(
                          12.0), // Kare yapmak için kenar yarıçapı
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: const Offset(0, 2), // Shadow offset
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Text(
                            'Masa $tableNumber',
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        if (hasNotification)
                          const Positioned(
                            top: 8,
                            right: 8,
                            child: const Icon(
                              Icons.notification_important,
                              color: Colors.red,
                              size: 24,
                            ),
                          ),
                      ],
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


  void getOrderFromFirebase() async {
    FirebaseFirestore.instance
        .collection('orders')
        .snapshots()
        .listen((snapshot) {
      snapshot.docs.forEach((doc) {
        String orderId = doc.id;
        String itemName = doc['name'];
        int tableNumber = doc['tableNumber'];
        print(
            'Yeni bir sipariş alındı: $orderId, $itemName, Masa: $tableNumber');
      });
    });
  }
}
