import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  final Map<String, dynamic> userMap;
  final String chatRoomId;

  const ChatRoom({Key? key, required this.chatRoomId, required this.userMap})
    : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ScrollController _scrollController = ScrollController();

  void onSendMessage() async {
    if (_messageController.text.isNotEmpty) {
      Map<String, dynamic> message = {
        "sendby": _auth.currentUser?.displayName,
        "message": _messageController.text,
        "time": FieldValue.serverTimestamp(),
      };

      _messageController.clear();
      await _firestore
          .collection('chatroom')
          .doc(widget.chatRoomId)
          .collection('chats')
          .add(message);

      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('chatList')
          .add({
            'chatRoomId': widget.chatRoomId,
            'name': widget.userMap['name'],
            'uid': widget.userMap['uid'],
          });

      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tạo theme với màu xanh dương chủ đạo
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
    );

    return Theme(
      data: theme,
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: StreamBuilder<DocumentSnapshot>(
            stream:
                _firestore
                    .collection('users')
                    .doc(widget.userMap['uid'])
                    .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(color: Colors.white);
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Text("User not found");
              }

              var userStatus =
                  snapshot.data?.get('status') ?? 'Status not available';
              var userName = snapshot.data?.get('name') ?? 'Name not available';

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    userStatus == 'Online' ? 'Online' : 'Offline',
                    style: TextStyle(
                      color:
                          userStatus == 'Online'
                              ? Colors.green[200]
                              : Colors.white54,
                      fontSize: 14,
                    ),
                  ),
                ],
              );
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.call, color: Colors.white),
              onPressed: () {
                // Xử lý cuộc gọi
              },
            ),
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onPressed: () {
                // Hiển thị menu thêm
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    _firestore
                        .collection('chatroom')
                        .doc(widget.chatRoomId)
                        .collection('chats')
                        .orderBy("time", descending: false)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        "Chưa có tin nhắn",
                        style: TextStyle(color: Colors.blue[800]),
                      ),
                    );
                  }

                  var messages = snapshot.data!.docs;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom();
                  });

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> message =
                          messages[index].data() as Map<String, dynamic>;

                      var time = message['time'];
                      String timeString = "Vừa xong";

                      if (time != null && time is Timestamp) {
                        var dateTime = time.toDate();
                        timeString =
                            "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
                      }

                      return _buildMessageWidget(message, timeString, theme);
                    },
                  );
                },
              ),
            ),
            // Message Input Section
            _buildMessageInputSection(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInputSection(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            offset: const Offset(0, -2),
            blurRadius: 4,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: "Nhập tin nhắn...",
                  filled: true,
                  fillColor: Colors.blue[50],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Colors.blue[600],
              child: IconButton(
                icon: Icon(Icons.send, color: Colors.white),
                onPressed: onSendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageWidget(
    Map<String, dynamic> message,
    String time,
    ThemeData theme,
  ) {
    bool isSentByCurrentUser =
        message['sendby'] == _auth.currentUser?.displayName;

    return Align(
      alignment:
          isSentByCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors:
                isSentByCurrentUser
                    ? [Colors.blue[600]!, Colors.blue[500]!]
                    : [Colors.blue[100]!, Colors.blue[50]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.1),
              offset: const Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message['message'],
              style: TextStyle(
                color: isSentByCurrentUser ? Colors.white : Colors.blue[900],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              time,
              style: TextStyle(
                color: isSentByCurrentUser ? Colors.white70 : Colors.blue[700],
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
