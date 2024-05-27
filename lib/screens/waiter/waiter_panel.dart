import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:waiter_app/screens/waiter/tables.dart';

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
                  int.parse((a.data() as Map<String, dynamic>)['tableNumber']);
              int bTableNumber =
                  int.parse((b.data() as Map<String, dynamic>)['tableNumber']);
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
                final tableNumber = tableData['tableNumber'];

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
                    bool hasNotification = false;
                    if (orderSnapshot.hasData) {
                      for (var order in orderSnapshot.data!.docs) {
                        if (!(order.data()
                            as Map<String, dynamic>)['checked']) {
                          hasNotification = true;
                          break;
                        }
                      }
                    }

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
