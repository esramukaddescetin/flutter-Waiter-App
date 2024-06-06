import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../my_widgets.dart';

class ReservationListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rezervasyonlar',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'PermanentMarker',
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Color(0xFFE0D100),
      ),
      body: Container(
        decoration: WidgetBackcolor(
          Colors.white38,
          const Color(0xFFE0D100),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('reservations').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData) {
              return const Center(child: Text('No reservations found'));
            }
            final reservations = snapshot.data!.docs;

            reservations.sort((a, b) {
              final aData = a.data() as Map<String, dynamic>;
              final bData = b.data() as Map<String, dynamic>;
              DateTime? aDateTime = aData['dateTime']?.toDate();
              DateTime? bDateTime = bData['dateTime']?.toDate();

              if (aDateTime == null && bDateTime == null) return 0;
              if (aDateTime == null) return 1; // Null değerleri sona koy
              if (bDateTime == null) return -1; // Null değerleri sona koy

              return aDateTime.compareTo(bDateTime);
            });

            return ListView.builder(
              itemCount: reservations.length,
              itemBuilder: (context, index) {
                final reservation = reservations[index];
                final reservationData =
                    reservation.data() as Map<String, dynamic>;
                final dateTime =
                    (reservationData['dateTime'] as Timestamp?)?.toDate();
                final formattedDate = dateTime != null
                    ? DateFormat('dd/MM/yyyy HH:mm').format(dateTime.toLocal())
                    : 'Tarih belirtilmemiş';
                final table = reservationData['table'];
                final phone = reservationData['phone'];
                final name = reservationData['name'];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text('Masa $table - $formattedDate'),
                    subtitle: Text('İsim: $name\nTelefon: $phone'),
                    trailing: Icon(Icons.restaurant_menu),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
