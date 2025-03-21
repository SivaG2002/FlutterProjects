// lib/login.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _notificationMessage;
  bool _isSuccess = false;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showNotification(String message, bool isSuccess) {
    setState(() {
      _notificationMessage = message;
      _isSuccess = isSuccess;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _notificationMessage = null;
        });
      }
    });
  }

  Future<void> _handleLogin() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      debugPrint('=-----------------------------------------------------------------------------------------------------Login successful: ${userCredential.user?.email}');
      if (userCredential.user != null) {
        _showNotification('Login successful ✓', true);
        await Future.delayed(const Duration(milliseconds: 1500));
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      }
    } catch (error) {
      _showNotification('Invalid email or password', false);
      print('Login error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFD4FC),
      body: Stack(
        children: [
          SlideTransition(
            position: _slideAnimation,
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.9,
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
                padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5EBF6),
                  borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.19),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'LOG IN',
                        style: TextStyle(
                          color: const Color(0xFF8C588C),
                          fontSize: MediaQuery.of(context).size.width * 0.07,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                      _buildInputField(
                        controller: _emailController,
                        hintText: 'Email',
                        isPassword: false,
                      ),
                      _buildRequiredAsterisk(context),
                      _buildInputField(
                        controller: _passwordController,
                        hintText: 'Password',
                        isPassword: true,
                      ),
                      _buildRequiredAsterisk(context),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Navigator.pushNamed(context, '/forgot-password'),
                          child: Text(
                            'Forgot Password',
                            style: TextStyle(
                              color: const Color(0xFF8C588C),
                              fontSize: MediaQuery.of(context).size.width * 0.035,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                      ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8C588C),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width * 0.03),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                          minimumSize: Size(MediaQuery.of(context).size.width * 0.7, 0),
                        ),
                        child: Text(
                          'LOG IN',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.045,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width * 0.05),
                        child: Divider(color: Colors.grey[300]),
                      ),
                      Text(
                        'Don\'t have an Account?',
                        style: TextStyle(
                          color: const Color(0xFF8C588C),
                          fontSize: MediaQuery.of(context).size.width * 0.035,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.width * 0.02),
                      ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, '/signup'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8C588C),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width * 0.03),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                          minimumSize: Size(MediaQuery.of(context).size.width * 0.6, 0),
                        ),
                        child: Text(
                          'SIGN UP',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.045,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_notificationMessage != null)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.05,
              left: 0,
              right: 0,
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.04,
                    vertical: MediaQuery.of(context).size.width * 0.02,
                  ),
                  decoration: BoxDecoration(
                    color: _isSuccess ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.05),
                    boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
                  ),
                  child: Text(
                    _notificationMessage!,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required bool isPassword,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: isPassword ? TextInputType.text : TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.black.withOpacity(0.19), fontWeight: FontWeight.bold),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(color: Color(0xFF8C588C)),
        ),
        contentPadding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
      ),
      style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildRequiredAsterisk(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.01),
        child: Text(
          '*',
          style: TextStyle(
            color: Colors.red,
            fontSize: MediaQuery.of(context).size.width * 0.04,
          ),
        ),
      ),
    );
  }
}