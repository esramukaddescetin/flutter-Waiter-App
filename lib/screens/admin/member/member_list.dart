import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:waiter_app/screens/admin/member/member_edit.dart';

import '../../../my_widgets.dart';

class UserListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kullanıcı Listesi',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'PermanentMarker',
          ),
        ),
        backgroundColor: Color(0xFF9E9D24),
      ),
      body: Container(
        decoration: WidgetBackcolor(
          Colors.white38,
          const Color(0xFF9E9D24),
        ),
        child: StreamBuilder(
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
              final userData = user.data() as Map<String, dynamic>?;
              final role = userData?['roles'] as List<dynamic>?;
              return role != null && role.contains('User');
            }).toList();

            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: ListView.builder(
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
                              color: Color(0xFF9E9D24),
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
                                'Ad: $name',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Soyad: $lastName',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Şifre: $password',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Telefon: $phone',
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
                                icon: const Icon(
                                  Icons.edit,
                                  color: Color(0xFF9E9D24),
                                ),
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
                                icon: const Icon(
                                  Icons.delete,
                                  color: Color(0xFF9E9D24),
                                ),
                                onPressed: () {
                                  _confirmDeleteUser(
                                      context, filteredUsers[index].id);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
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
