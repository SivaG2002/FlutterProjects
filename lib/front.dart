// lib/front.dart
import 'package:flutter/material.dart';
import 'dart:async';

class Front extends StatefulWidget {
  const Front({super.key});

  @override
  State<Front> createState() => _FrontState();
}

class _FrontState extends State<Front> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _fadeOutAnimation;

  @override
  void initState() {
    super.initState();

    // Animation Controller: Total 5s (2s delay + 2s fade in + 1s fade out)
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    // Fade in from bottom (2s delay, 2s duration)
    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.8, curve: Curves.easeOut), // 2s to 4s
      ),
    );

    // Fade out (1s duration, starts at 4s)
    _fadeOutAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.8, 1.0, curve: Curves.easeOut), // 4s to 5s
      ),
    );

    // Start animation
    _controller.forward();

    // Navigate to Landing after 7s (2s wait + 5s animation)
    Timer(const Duration(seconds: 7), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/landing');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFD4FC), // #ffd4fc
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Woman Image with Animation
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeInAnimation.value * _fadeOutAnimation.value,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4, // 40vw
                    height: MediaQuery.of(context).size.height * 0.42, // 42vh
                    color: const Color(0xFFFFD4FC), // Fallback background
                    child: Image.asset(
                      'assets/images/women.png',
                      width: MediaQuery.of(context).size.width * 0.32, // 32vw
                      height: MediaQuery.of(context).size.height * 0.42, // 42vh
                      fit: BoxFit.contain,
                      color: Colors.black.withOpacity(0.7), // Brightness 70%
                      colorBlendMode: BlendMode.modulate, // Contrast approximation
                      errorBuilder: (context, error, stackTrace) {
                        return const Text(
                          'Failed to load woman image',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 4), // 0.3vw gap approximated
            // Letters Container
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeInAnimation.value * _fadeOutAnimation.value,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          _buildLetter('c', context),
                          const SizedBox(width: 6), // 0.5vw gap
                          _buildLetter('i', context),
                          const SizedBox(width: 6),
                          _buildLetter('r', context),
                          const SizedBox(width: 6),
                          _buildLetter('l', context),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLetter(String letter, BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1, // 10vh
      color: const Color(0xFFFFD4FC), // Fallback background
      child: Transform(
        transform: letter == 'l'
            ? Matrix4.rotationZ(-0.1745) // Approx -10deg in radians
            : Matrix4.identity(),
        alignment: letter == 'l' ? Alignment.bottomCenter : Alignment.center,
        child: Image.asset(
          'assets/images/$letter.png',
          width: letter == 'i' || letter == 'r'
              ? MediaQuery.of(context).size.width * 0.045 // 4.5vw
              : MediaQuery.of(context).size.width * 0.07, // 7vw
          height: letter == 'i' || letter == 'r'
              ? MediaQuery.of(context).size.width * 0.045 // 4.5vw
              : MediaQuery.of(context).size.width * 0.07, // 7vw
          fit: BoxFit.contain,
          color: Colors.black.withOpacity(0.7), // Brightness 70%
          colorBlendMode: BlendMode.modulate, // Contrast approximation
          errorBuilder: (context, error, stackTrace) {
            return Text(
              'Failed to load $letter',
              style: const TextStyle(color: Colors.red, fontSize: 12),
            );
          },
        ),
      ),
    );
  }
}