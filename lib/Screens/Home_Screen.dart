import 'package:chat_app/Screens/AccountInfo_Screen.dart';
import 'package:chat_app/Screens/Chat_Room_Screen.dart';
import 'package:chat_app/Screens/SearchResults_Screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  Map<String, dynamic>? userMap;
  bool isLoading = false;
  final TextEditingController _search = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> chatList = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    updateUserStatus("Online");
    loadChatList();
  }

  void loadChatList() async {
    setState(() {
      isLoading = true;
    });
    try {
      var chatDocs =
          await _firestore
              .collection('users')
              .doc(_auth.currentUser!.uid)
              .collection('chatList')
              .get();

      if (chatDocs.docs.isNotEmpty) {
        Set<String> seenUserIds = Set<String>();
        for (var doc in chatDocs.docs) {
          String chatRoomId = doc['chatRoomId'];

          var lastMessageSnapshot =
              await _firestore
                  .collection('chatroom')
                  .doc(chatRoomId)
                  .collection('chats')
                  .orderBy("time", descending: true)
                  .limit(1)
                  .get();

          String lastMessage = "No messages";

          if (lastMessageSnapshot.docs.isNotEmpty) {
            var lastMessageData = lastMessageSnapshot.docs[0].data();
            lastMessage = lastMessageData['message'];
          }

          String otherUserUid = doc['uid'];
          if (!seenUserIds.contains(otherUserUid)) {
            seenUserIds.add(otherUserUid);

            chatList.add({...doc.data(), 'lastMessage': lastMessage});
          }
        }
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Lỗi khi tải danh sách chat")));
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void updateUserStatus(String status) async {
    if (_auth.currentUser != null) {
      await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
        "status": status,
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      updateUserStatus("Online");
    } else if (state == AppLifecycleState.paused) {
      updateUserStatus("Offline");
    }
  }

  void onSearch() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    setState(() {
      isLoading = true;
    });

    try {
      var value =
          await _firestore
              .collection('users')
              .where("email", isEqualTo: _search.text)
              .get();

      if (value.docs.isNotEmpty) {
        setState(() {
          userMap = value.docs[0].data();
          isLoading = false;
        });

        if (userMap != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchResultsScreen(userMap: userMap!),
            ),
          );
        }
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Không tìm thấy người dùng")));
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Không tìm thấy người dùng")));
    }
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50], // Light blue background
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue[800], // Deep blue app bar
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.blue[100],
              child: Icon(Icons.account_circle, size: 28, color: Colors.white),
            ),
            SizedBox(width: 10),
            Text(
              _auth.currentUser?.displayName ?? "Messages",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                "Zép lào",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: _currentIndex == 0
          ? isLoading
              ? Center(child: CircularProgressIndicator(color: Colors.blue[800]))
              : Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      color: Colors.blue[800],
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue[100]!,
                              spreadRadius: 1,
                              blurRadius: 3,
                            )
                          ],
                        ),
                        child: TextField(
                          controller: _search,
                          decoration: InputDecoration(
                            hintText: "Search",
                            hintStyle: TextStyle(color: Colors.blue[300]),
                            border: InputBorder.none,
                            icon: Icon(Icons.search, color: Colors.blue[800]),
                            suffixIcon: InkWell(
                              onTap: onSearch,
                              child: Icon(
                                Icons.arrow_forward,
                                color: Colors.blue[800],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: chatList.length,
                        itemBuilder: (context, index) {
                          var user = chatList[index];
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue[100]!,
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                )
                              ],
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              onTap: () {
                                String roomID = chatList[index]['chatRoomId'];
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ChatRoom(
                                      chatRoomId: roomID,
                                      userMap: user,
                                    ),
                                  ),
                                );
                              },
                              leading: CircleAvatar(
                                radius: 24,
                                backgroundColor: Colors.blue[100],
                                child: Text(
                                  user['name'].substring(0, 1).toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.blue[800],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              title: Padding(
                                padding: EdgeInsets.only(bottom: 4),
                                child: Text(
                                  user['name'],
                                  style: TextStyle(
                                    color: Colors.blue[900],
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              subtitle: Text(
                                user['lastMessage'] ?? "Tap to start chatting",
                                style: TextStyle(
                                  color: Colors.blue[700],
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )
          : AccountInfoScreen(),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 8,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue[900],
        unselectedItemColor: Colors.blue[500],
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
