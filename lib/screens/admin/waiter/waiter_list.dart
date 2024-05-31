import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:waiter_app/screens/admin/waiter/waiter_edit.dart';

class WaiterListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Garson Listesi'),
      ),
      body: StreamBuilder(
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

          return ListView.builder(
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
              return ListTile(
                title: Text(username),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Email: $email'),
                    Text('Name: $name'),
                    Text('Last Name: $lastName'),
                    Text('Password: $password'),
                    Text('Phone: $phone'),
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
                                    waiterData: userData)));
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
              );
            },
          );
        },
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
