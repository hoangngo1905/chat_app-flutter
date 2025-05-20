import 'package:chat_app/Services/Methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AccountInfoScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    User? currentUser = _auth.currentUser;

    if (currentUser == null) {
      return Scaffold(
        backgroundColor: Colors.blue[50],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.blue[800],
          title: Text(
            'Account Info',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.account_circle, size: 80, color: Colors.blue[200]),
              SizedBox(height: 16),
              Text(
                'Please log in to view your account information.',
                style: TextStyle(fontSize: 16, color: Colors.blue[800]),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Đăng xuất', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    }

    return FutureBuilder<DocumentSnapshot>(
      future: _firestore.collection('users').doc(currentUser.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.blue[50],
            body: Center(
              child: CircularProgressIndicator(color: Colors.blue[800]),
            ),
          );
        }
        var userData = snapshot.data!.data() as Map<String, dynamic>;

        void _showEditNameDialog() {
          final _nameController = TextEditingController(
            text: userData['name'] ?? '',
          );

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: Colors.white,
                content: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Nhập tên mới',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue[100]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.blue[800]!,
                        width: 2,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Từ chối',
                      style: TextStyle(color: Colors.blue[700]),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await currentUser.updateDisplayName(
                          _nameController.text,
                        );
                        await _firestore
                            .collection('users')
                            .doc(currentUser.uid)
                            .update({'name': _nameController.text});
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Tên được cập nhật thành công'),
                            backgroundColor: Colors.green[700],
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error updating name: $e'),
                            backgroundColor: Colors.red[700],
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Lưu', style: TextStyle(color: Colors.white)),
                  ),
                ],
              );
            },
          );
        }

        void _showLogOutConfirmationDialog(BuildContext context) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: Colors.white,
                title: Text(
                  'Xác nhận đăng xuất',
                  style: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold),
                ),
                content: Text(
                  'Bạn có muốn đăng xuất?',
                  style: TextStyle(color: Colors.blue[800]),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Từ chối',
                      style: TextStyle(color: Colors.blue[700]),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () =>logOut(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Đăng xuất',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          );
        }

        return Scaffold(
          backgroundColor: Colors.blue[50],
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.blue[50],
            automaticallyImplyLeading: false,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue[100]!,
                          spreadRadius: 2,
                          blurRadius: 10,
                        )
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.blue[100],
                      child: Text(
                        (userData['name'] ?? '?').isNotEmpty
                            ? (userData['name'] ?? '?')
                                .substring(0, 1)
                                .toUpperCase()
                            : '?',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Card(
                    elevation: 4,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.blue[100]!, width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Name',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.blue[700],
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    userData['name'] ?? 'No name available',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue[900],
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue[800]),
                                onPressed: _showEditNameDialog,
                              ),
                            ],
                          ),
                          Divider(color: Colors.blue[100], height: 24),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Email',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.blue[700],
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    userData['email'] ?? 'No email available',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue[900],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () => _showLogOutConfirmationDialog(context),
                    icon: Icon(Icons.logout, color: Colors.red[700]),
                    label: Text(
                      'Đăng xuất', 
                      style: TextStyle(
                        fontSize: 16, 
                        color: Colors.red[700]
                      )
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[50],
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.red[100]!, width: 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}