import 'package:chat_app/Screens/Home_Screen.dart';
import 'package:chat_app/Services/Methods.dart';
import 'package:chat_app/Screens/CreateAccount_Screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isLoading = false;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body:
          isLoading
              ? Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                  strokeWidth: 3,
                ),
              )
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: size.height * 0.08),
                      // Logo hoặc hình ảnh app
                      Center(
                        child: Container(
                          height: size.height * 0.15,
                          width: size.height * 0.15,
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.chat_bubble_outline,
                            size: 50,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.04),
                      // Tiêu đề
                      Center(
                        child: Text(
                          "Zép lào",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      // Phụ đề
                      Center(
                        child: Text(
                          "Đăng nhập để tiếp tục",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.06),
                      // Trường email
                      Text(
                        "Email",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      SizedBox(height: 8),
                      emailField(size),
                      SizedBox(height: 20),
                      // Trường mật khẩu
                      Text(
                        "Mật khẩu",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      SizedBox(height: 8),
                      passwordField(size),
                      SizedBox(height: size.height * 0.06),
                      loginButton(size),
                      SizedBox(height: size.height * 0.03),
                      // Phần đăng ký
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Chưa có tài khoản? ",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 16,
                            ),
                          ),
                          GestureDetector(
                            onTap:
                                () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => CreateAccount(),
                                  ),
                                ),
                            child: Text(
                              "Đăng ký ngay",
                              style: TextStyle(
                                color: Colors.blue.shade700,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget socialLoginButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300),
          color: Colors.white,
        ),
        child: Icon(icon, size: 30, color: color),
      ),
    );
  }

  Widget emailField(Size size) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: TextField(
        controller: _email,
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(fontSize: 16),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          border: InputBorder.none,
          hintText: "Nhập email của bạn",
          hintStyle: TextStyle(color: Colors.grey.shade500),
          prefixIcon: Icon(Icons.email_outlined, color: Colors.blue),
        ),
      ),
    );
  }

  Widget passwordField(Size size) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: TextField(
        controller: _password,
        obscureText: _obscureText,
        style: TextStyle(fontSize: 16),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          border: InputBorder.none,
          hintText: "Nhập mật khẩu của bạn",
          hintStyle: TextStyle(color: Colors.grey.shade500),
          prefixIcon: Icon(Icons.lock_outline, color: Colors.blue),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget loginButton(Size size) {
    return GestureDetector(
      onTap: () {
        if (_email.text.isNotEmpty && _password.text.isNotEmpty) {
          setState(() {
            isLoading = true;
          });

          logIn(_email.text, _password.text).then((user) {
            if (user != null) {
              print("Đăng nhập thành công");
              setState(() {
                isLoading = false;
              });
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => HomeScreen()),
              );
            } else {
              print("Đăng nhập thất bại");
              setState(() {
                isLoading = false;
              });
              // Hiển thị thông báo lỗi
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Email hoặc mật khẩu không chính xác"),
                  backgroundColor: Colors.red,
                ),
              );
            }
          });
        } else {
          // Hiển thị thông báo lỗi
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Vui lòng nhập đầy đủ thông tin"),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Container(
        height: 55,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.blue.shade600, Colors.blue.shade800],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          "Đăng nhập",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
