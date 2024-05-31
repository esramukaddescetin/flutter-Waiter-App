import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:waiter_app/screens/admin/member/member_edit.dart';

class UserListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kullanıcı Listesi'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Kullanıcı bulunamadı.'));
          }
          final users = snapshot.data!.docs;
          final filteredUsers = users.where((user) {
            final userData = user.data() as Map<String,
                dynamic>?; 
            final role = userData?['roles']
                as List<dynamic>?; 
            return role != null &&
                role.contains(
                    'User'); 
          }).toList();

          return ListView.builder(
            itemCount: filteredUsers.length,
            itemBuilder: (context, index) {
              final userData =
                  filteredUsers[index].data() as Map<String, dynamic>;
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
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditUserScreen(
                              userData: userData,
                              userId: filteredUsers[index].id,
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _confirmDeleteUser(context, filteredUsers[index].id);
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

  void _confirmDeleteUser(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Kullanıcıyı Sil'),
          content:
              const Text('Bu kullanıcıyı silmek istediğinizden emin misiniz?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                _deleteUser(userId);
                Navigator.pop(context);
              },
              child: const Text('Sil'),
            ),
          ],
        );
      },
    );
  }

  void _deleteUser(String userId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
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
    title: 'User List',
    home: UserListScreen(),
  ));
}
