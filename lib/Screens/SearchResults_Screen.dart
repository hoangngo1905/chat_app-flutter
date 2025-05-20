import 'package:chat_app/Screens/Chat_Room_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchResultsScreen extends StatelessWidget {
  final Map<String, dynamic> userMap;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Constructor nhận tham số userMap
  SearchResultsScreen({required this.userMap});

  // Hàm tạo chat room id
  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] > user2[0].toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tạo theme với màu xanh dương chủ đạo giống ChatRoom
    final theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        primary: Colors.blue[600],
        background: Colors.blue[50],
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.blue[50],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.white,
      ),
    );

    final size = MediaQuery.of(context).size;

    return Theme(
      data: theme,
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        appBar: AppBar(
          title: Text(
            'Kết quả tìm kiếm',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height / 30),
              GestureDetector(
                onTap: () {
                  if (_auth.currentUser != null) {
                    String roomID = chatRoomId(
                      _auth.currentUser!.displayName!,
                      userMap['name'],
                    );
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ChatRoom(
                          chatRoomId: roomID,
                          userMap: userMap,
                        ),
                      ),
                    );
                  }
                },
                child: Card(
                  child: ListTile(
                    contentPadding: EdgeInsets.all(12),
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue[600],
                      child: Icon(Icons.account_box, color: Colors.white),
                    ),
                    title: Text(
                      userMap['name'],
                      style: TextStyle(
                        color: Colors.blue[900],
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      userMap['email'],
                      style: TextStyle(
                        color: Colors.blue[700],
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios, 
                      color: Colors.blue[700]
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}