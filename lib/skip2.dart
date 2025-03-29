import 'package:flutter/material.dart';

class Skip2Screen extends StatelessWidget {
  const Skip2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFF5E1F5), // Pastel pink background
        child: Stack(
          children: [
            // Background elements (like the abstract shapes)
            Positioned(
              top: 50,
              left: 20,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: 80,
              right: 30,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // Main content
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Illustration
                Image.asset(
                  'assets/images/skip2.png', // Ensure this path is correct
                  height: 250,
                ),
                const SizedBox(height: 20),
                // Text (justified to the left)
                Padding(
                  padding: const EdgeInsets.only(left: 20.0), // Add padding to align with dots
                  child: const Text(
                    'Your personal companion for tracking your cycle',
                    textAlign: TextAlign.left, // Justify to the left
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                // Dots indicator (aligned to the left)
                Padding(
                  padding: const EdgeInsets.only(left: 20.0), // Align with text
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start, // Align to the left
                    children: [

                      Container(
                        width: 10,
                        height: 10,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: const BoxDecoration(
                          color: Colors.black, // Active dot
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        width: 10,
                        height: 10,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: const BoxDecoration(
                          color: Colors.grey, // Inactive dot
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Bottom buttons
            Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Skip button (navigates to /landing)
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/landing');
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  // Next button (arrow, navigates to /landing)
                  IconButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/skip1');
                    },
                    icon: const Icon(
                      Icons.arrow_forward,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}