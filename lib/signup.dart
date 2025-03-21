// lib/signup.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with SingleTickerProviderStateMixin {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final List<TextEditingController> _otpControllers = List.generate(6, (_) => TextEditingController());
  String? _notificationMessage;
  bool _isSuccess = false;
  String? _verificationId;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    for (var controller in _otpControllers) controller.dispose();
    super.dispose();
  }

  void _showNotification(String message, bool isSuccess) {
    setState(() {
      _notificationMessage = message;
      _isSuccess = isSuccess;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _notificationMessage = null);
    });
  }

  Future<void> _handleSignUp() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (userCredential.user != null) {
        _showNotification('Sign Up successful ✓', true);
        await Future.delayed(const Duration(milliseconds: 1500));
        if (mounted) Navigator.pushReplacementNamed(context, '/home');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        _showNotification('Email is already in use', false);
      } else {
        _showNotification('Sign Up failed: ${e.message}', false);
      }
      print('Sign Up error: $e');
    } catch (error) {
      _showNotification('Sign Up failed: $error', false);
      print('Sign Up error: $error');
    }
  }

  Future<void> _receiveOtp() async {
    String phoneNumber = _phoneController.text.trim();
    if (!phoneNumber.startsWith('+')) {
      phoneNumber = '+91$phoneNumber'; // Adjust country code as needed
    }

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
          _showNotification('Phone verified ✓', true);
        },
        verificationFailed: (FirebaseAuthException e) {
          _showNotification('Verification failed: ${e.message}', false);
          print('Verification failed: $e');
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
          });
          _showNotification('OTP sent to $phoneNumber', true);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            _verificationId = verificationId;
          });
        },
      );
    } catch (e) {
      _showNotification('Error sending OTP: $e', false);
      print('Error sending OTP: $e');
    }
  }

  Future<void> _verifyOtp() async {
    if (_verificationId == null) {
      _showNotification('Please request an OTP first', false);
      return;
    }

    String otp = _otpControllers.map((c) => c.text).join();
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      _showNotification('OTP verified ✓', true);
    } catch (e) {
      _showNotification('Invalid OTP: $e', false);
      print('OTP verification error: $e');
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/login'),
                        child: Padding(
                          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
                          child: const Text(
                            '⇐ Back to login',
                            style: TextStyle(
                              color: Color(0xFF8C588C),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'SIGN UP',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Color(0xFF8C588C),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.62,
                            child: _buildInputField(
                              controller: _phoneController,
                              hintText: 'Phone Number',
                              isPassword: false,
                              keyboardType: TextInputType.phone,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward, color: Color(0xFF8C588C)),
                            onPressed: _receiveOtp,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          const Text('*', style: TextStyle(color: Colors.red, fontSize: 16)),
                        ],
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'Check Your Phone',
                        style: TextStyle(
                          color: Color(0xFF8C588C),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(6, (index) => _buildOtpField(index)),
                      ),
                      const SizedBox(height: 15),
                      Center(
                        child: ElevatedButton(
                          onPressed: _verifyOtp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF8C588C),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                            minimumSize: const Size(100, 0),
                          ),
                          child: const Text(
                            'Verify',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      _buildInputField(
                        controller: _emailController,
                        hintText: 'Email',
                        isPassword: false,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Text('*', style: TextStyle(color: Colors.red, fontSize: 16)),
                      ),
                      const SizedBox(height: 15),
                      _buildInputField(
                        controller: _passwordController,
                        hintText: 'Password',
                        isPassword: true,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Text('*', style: TextStyle(color: Colors.red, fontSize: 16)),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: _handleSignUp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8C588C),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                            minimumSize: Size(MediaQuery.of(context).size.width * 0.6, 0),
                          ),
                          child: const Text(
                            'SIGN UP',
                            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
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
              top: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: _isSuccess ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
                  ),
                  child: Text(
                    _notificationMessage!,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
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
    TextInputType keyboardType = TextInputType.text,
  }) {
    return SizedBox(
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color.fromRGBO(140, 88, 140, 0.5),
            fontWeight: FontWeight.bold,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        ),
        style: const TextStyle(fontSize: 16, color: Color(0xFF8C588C), fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildOtpField(int index) {
    return Container(
      width: 45, // Reduced from 50 to fix overflow
      height: 45, // Reduced from 50 for consistency
      margin: const EdgeInsets.symmetric(horizontal: 4), // Reduced from 5
      child: TextField(
        controller: _otpControllers[index],
        maxLength: 1,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF8C588C), width: 2),
          ),
        ),
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}