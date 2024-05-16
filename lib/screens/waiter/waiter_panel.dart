import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:waiter_app/screens/waiter/tables.dart';

void main() {
  runApp(WaiterPanel());
}

class WaiterPanel extends StatefulWidget {
  @override
  _WaiterPanelState createState() => _WaiterPanelState();
}

class _WaiterPanelState extends State<WaiterPanel> {
  // Bildirimleri göstermek için bildirim öğesi oluştur
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    // Firebase'den siparişleri almak için fonksiyonu çağırın
    getOrderFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    // Bildirim ayarlarını yapılandır ve başlat
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings('app_icon'),
            iOS: DarwinInitializationSettings());
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Text('Masalar', style: TextStyle(color: Colors.white)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          color: Colors.grey[200],
          padding: EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 2, // İki butonu yatayda yan yana göstermek için
            mainAxisSpacing: 16.0,
            crossAxisSpacing: 16.0,
            children: List.generate(20, (index) {
              // 20 masa numarası için butonlar oluşturuyoruz
              int tableNumber = index + 1; // Masa numarası 1'den başlıyor
              return GestureDetector(
                onTap: () {
                  // Masa numarasına göre bildirim göster
                  showNotification('Yeni bir talep var',
                      'Masa $tableNumber için yeni bir sipariş var');
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
                    color: Colors.green.shade200, // Yeşil tonu
                    borderRadius: BorderRadius.circular(
                        12.0), // Kare yapmak için kenar yarıçapı
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(0, 2), // Shadow offset
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Masa $tableNumber',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  // Bildirim göstermek için metot
  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'channel_description',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0, // Bildirim ID'si
      title, // Bildirim başlığı
      body, // Bildirim içeriği
      platformChannelSpecifics,
      payload: 'item x', // İsteğe bağlı payload
    );
  }

  // Firebase'den siparişleri al
  void getOrderFromFirebase() async {
    FirebaseFirestore.instance
        .collection('orders')
        .snapshots()
        .listen((snapshot) {
      snapshot.docs.forEach((doc) {
        // Veritabanından gelen sipariş bilgilerini kullan
        String orderId = doc.id;
        String itemName = doc['name'];
        int tableNumber = doc['tableNumber'];

        // Sipariş hakkında işlem yapabilirsiniz (bildirim gösterme, siparişi işleme alma vb.)
        print(
            'Yeni bir sipariş alındı: $orderId, $itemName, Masa: $tableNumber');
      });
    });
  }
}
