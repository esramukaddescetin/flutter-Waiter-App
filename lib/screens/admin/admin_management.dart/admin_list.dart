import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:waiter_app/screens/admin/admin_management.dart/admin_edit.dart';


class AdminListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Listesi'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Admin bulunamadı.'));
          }
          final users = snapshot.data!.docs;
          final filteredAdmins = users.where((user) {
            final userData = user.data() as Map<String, dynamic>;
            final roles = userData['roles'] as List<dynamic>;
            return roles.contains('Admin');
          }).toList();

          return ListView.builder(
            itemCount: filteredAdmins.length,
            itemBuilder: (context, index) {
              final userData =
                  filteredAdmins[index].data() as Map<String, dynamic>;
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
                            builder: (context) => AdminEditScreen(
                              adminId: filteredAdmins[index].id,
                              adminData: userData,
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _confirmDeleteAdmin(
                            context, filteredAdmins[index].id);
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

  void _confirmDeleteAdmin(BuildContext context, String adminId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Admini Sil'),
          content: Text('Bu admini silmek istediğinizden emin misiniz?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                _deleteAdmin(adminId);
                Navigator.pop(context);
              },
              child: Text('Sil'),
            ),
          ],
        );
      },
    );
  }

  void _deleteAdmin(String adminId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(adminId)
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
    title: 'Admin List',
    home: AdminListScreen(),
  ));
}
