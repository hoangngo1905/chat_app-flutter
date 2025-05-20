import 'package:chat_app/Screens/Home_Screen.dart';
import 'package:chat_app/Services/Methods.dart';
import 'package:flutter/material.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isLoading = false;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
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
                    SizedBox(height: size.height * 0.05),
                    SizedBox(height: size.height * 0.04),
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
                    SizedBox(height: size.height * 0.03),
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
                    SizedBox(height: 8),
                    // Phụ đề
                    Center(
                      child: Text(
                        "Đăng ký để tiếp tục",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.05),
                    
                    // Trường tên
                    Text(
                      "Tên của bạn",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    SizedBox(height: 8),
                    nameField(size),
                    
                    SizedBox(height: 20),
                    
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
                    SizedBox(height: 30),                   
                    SizedBox(height: size.height * 0.04),
                    
                    // Nút đăng ký
                    registerButton(size),
                    
                    SizedBox(height: size.height * 0.03),
                    
                    // Phần đăng nhập
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Đã có tài khoản? ",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 16,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text(
                            "Đăng nhập",
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

  Widget socialSignupButton({
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
        child: Icon(
          icon,
          size: 30,
          color: color,
        ),
      ),
    );
  }

  Widget nameField(Size size) {
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
        controller: _name,
        style: TextStyle(fontSize: 16),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          border: InputBorder.none,
          hintText: "Nhập tên của bạn",
          hintStyle: TextStyle(color: Colors.grey.shade500),
          prefixIcon: Icon(
            Icons.person_outline,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }

  Widget emailField(Size size) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
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
          prefixIcon: Icon(
            Icons.email_outlined,
            color: Colors.blue,
          ),
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
      ),
      child: TextField(
        controller: _password,
        obscureText: _obscureText,
        style: TextStyle(fontSize: 16),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          border: InputBorder.none,
          hintText: "Tạo mật khẩu của bạn",
          hintStyle: TextStyle(color: Colors.grey.shade500),
          prefixIcon: Icon(
            Icons.lock_outline,
            color: Colors.blue,
          ),
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

  Widget registerButton(Size size) {
    return GestureDetector(
      onTap: () {
        if (_name.text.isNotEmpty &&
            _email.text.isNotEmpty &&
            _password.text.isNotEmpty) {
          setState(() {
            isLoading = true;
          });

          createAccount(_name.text, _email.text, _password.text).then((value) {
            setState(() {
              isLoading = false;
            });
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => HomeScreen()),
            );
            print("Tạo tài khoản thành công");
          }).catchError((error) {
            setState(() {
              isLoading = false;
            });
            // Hiển thị thông báo lỗi
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Đăng ký thất bại: ${error.toString()}"),
                backgroundColor: Colors.red,
              )
            );
          });
        } else {
          // Hiển thị thông báo lỗi
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Vui lòng điền đầy đủ thông tin"),
              backgroundColor: Colors.red,
            )
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
        ),
        alignment: Alignment.center,
        child: Text(
          "Đăng ký",
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