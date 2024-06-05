import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:waiter_app/screens/admin/waiter/waiter_edit.dart';

import '../../../my_widgets.dart';

class WaiterListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Garson Listesi',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'PermanentMarker',
          ),
        ),
        backgroundColor: Color(0xFFC7732F),
      ),
      body: Container(
        decoration: WidgetBackcolor(
          const Color(0xFFC7732F),
          Colors.white38,
        ),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('Garson bulunamadı.'));
            }
            final users = snapshot.data!.docs;
            final filteredWaiters = users.where((user) {
              final userData = user.data() as Map<String, dynamic>;
              final roles = userData['roles'] as List<dynamic>;
              return roles.contains('Waiter');
            }).toList();

            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: ListView.builder(
                itemCount: filteredWaiters.length,
                itemBuilder: (context, index) {
                  final userData =
                      filteredWaiters[index].data() as Map<String, dynamic>;
                  final username = userData['username'] ?? '';
                  final email = userData['email'] ?? '';
                  final name = userData['name'] ?? '';
                  final lastName = userData['lastName'] ?? '';
                  final password = userData['password'] ?? '';
                  final phone = userData['phone'] ?? '';

                  return Column(
                    children: [
                      Container(
                        color: Colors.black12,
                        child: ListTile(
                          title: Text(
                            username,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'MadimiOne',
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Email: $email',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Name: $name',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Last Name: $lastName',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Password: $password',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Phone: $phone',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WaiterEditScreen(
                                        waiterId: filteredWaiters[index].id,
                                        waiterData: userData,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  _confirmDeleteWaiter(
                                      context, filteredWaiters[index].id);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                          height: 16.0), // Her öğeden sonra boşluk ekliyoruz
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void _confirmDeleteWaiter(BuildContext context, String waiterId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Garsonu Sil'),
          content: Text('Bu garsonu silmek istediğinizden emin misiniz?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                _deleteWaiter(waiterId);
                Navigator.pop(context);
              },
              child: Text('Sil'),
            ),
          ],
        );
      },
    );
  }

  void _deleteWaiter(String waiterId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(waiterId)
        .delete()
        .then((value) {
      // Başarıyla silindiğine dair geri bildirim gösterilebilir.
    }).catchError((error) {
      // Silme işlemi başarısız olduğunda hata mesajı gösterilebilir.
    });
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Waiter List',
    home: WaiterListScreen(),
  ));
}
