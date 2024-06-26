import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:waiter_app/screens/waiter/panel/tables.dart';
import 'package:waiter_app/screens/waiter/reservations/reservation_list.dart';


class WaiterPanel extends StatefulWidget {
  @override
  _WaiterPanelState createState() => _WaiterPanelState();
}

class _WaiterPanelState extends State<WaiterPanel> {
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
        actions: [
          IconButton(
            icon: const Icon(Icons.event, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReservationListPage()),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[200],
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('tables').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData) {
              return const Center(child: Text('No tables found'));
            }
            final tables = snapshot.data!.docs;

            // Masaları küçükten büyüğe sıralayalım
            tables.sort((a, b) {
              int aTableNumber =
                  (a.data() as Map<String, dynamic>)['tableNumber'] as int;
              int bTableNumber =
                  (b.data() as Map<String, dynamic>)['tableNumber'] as int;
              return aTableNumber.compareTo(bTableNumber);
            });

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
              ),
              itemCount: tables.length,
              itemBuilder: (context, index) {
                final table = tables[index];
                final tableData = table.data() as Map<String, dynamic>;
                final tableNumber = tableData['tableNumber'] as int;

                // 'orders' koleksiyonunu sorgulayıp masaya ait bildirim olup olmadığını kontrol edelim
                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('orders')
                      .where('tableNumber', isEqualTo: tableNumber)
                      .snapshots(),
                  builder: (context, orderSnapshot) {
                    if (orderSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    int orderCount = 0;
                    bool hasOrderNotification = false;
                    if (orderSnapshot.hasData) {
                      for (var order in orderSnapshot.data!.docs) {
                        final orderData = order.data() as Map<String, dynamic>;
                        final checked = orderData['checked'];
                        if (checked == null || !(checked as bool)) {
                          hasOrderNotification = true;
                          orderCount++;
                        }
                      }
                    }

                    // 'notifications' koleksiyonunu sorgulayıp masaya ait bildirim olup olmadığını kontrol edelim
                    return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('notifications')
                          .where('tableNumber', isEqualTo: tableNumber)
                          .snapshots(),
                      builder: (context, notificationSnapshot) {
                        if (notificationSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        int notificationCount = 0;
                        if (notificationSnapshot.hasData) {
                          for (var notification
                              in notificationSnapshot.data!.docs) {
                            final notificationData =
                                notification.data() as Map<String, dynamic>;
                            final checked = notificationData['checked'];
                            if (checked == null || !(checked as bool)) {
                              notificationCount++;
                            }
                          }
                        }

                        // 'waiter_requests' koleksiyonunu sorgulayıp masaya ait bildirim olup olmadığını kontrol edelim
                        return StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('waiter_requests')
                              .where('tableNumber', isEqualTo: tableNumber)
                              .snapshots(),
                          builder: (context, requestSnapshot) {
                            if (requestSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            int requestCount = 0;
                            if (requestSnapshot.hasData) {
                              for (var request in requestSnapshot.data!.docs) {
                                final requestData =
                                    request.data() as Map<String, dynamic>;
                                final checked = requestData['checked'];
                                if (checked == null || !(checked as bool)) {
                                  requestCount++;
                                }
                              }
                            }

                            // Toplam bildirim sayısını hesaplayalım
                            int totalNotificationCount =
                                orderCount + notificationCount + requestCount;

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TableDetailsPage(
                                        tableNumber: tableNumber),
                                  ),
                                );
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: totalNotificationCount > 0
                                          ? Colors.red.shade200
                                          : Colors.green.shade200,
                                      borderRadius: BorderRadius.circular(12.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
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
                                  if (totalNotificationCount > 0)
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(
                                          totalNotificationCount.toString(),
                                          style: const TextStyle(
                                            color: Colors
                                                .red, // Bildirim sayısı için uygun renk
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
