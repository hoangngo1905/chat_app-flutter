import 'package:chat_app/Screens/Home_Screen.dart';
import 'package:chat_app/Screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatelessWidget {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    if (_auth.currentUser !=null){
      return HomeScreen();
    }else{
      return LoginScreen();
    }
  
  }
}