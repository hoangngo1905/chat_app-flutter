import 'package:chat_app/Screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<User?> createAccount(String name, String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? user = userCredential.user;

    if (user != null) {
      print("Tạo tài khoản thành công");

      user.updateProfile(displayName: name);

      await _firestore.collection('users').doc(user.uid).set({
        "name": name,
        "email": email,
        "status": "Unavailable",
        "uid": _auth.currentUser!.uid,
      });
      return user;
    } else {
      print("Tạo tài khoản thất bại");
      return null;
    }
  } catch (e) {
    print("Lỗi: $e");
    return null;
  }
}

Future<User?> logIn(String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? user = userCredential.user;

    if (user != null) {
      print("Đăng nhập thành công");

      // Cập nhật trạng thái người dùng thành "Online"
      await _firestore.collection('users').doc(user.uid).update({
        "status": "Online",
      });

      return user;
    } else {
      print("Đăng nhập thất bại");
      return null;
    }
  } catch (e) {
    print("Lỗi: $e");
    return null;
  }
}

Future<void> logOut(BuildContext context) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    // Cập nhật trạng thái "Offline" trước khi đăng xuất
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        "status": "Offline",  // Đảm bảo rằng trạng thái của người dùng là "Offline"
      });
    }

    await _auth.signOut();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  } catch (e) {
    print("Lỗi khi đăng xuất: $e");
  }
}

