import 'package:flutter/material.dart';
import 'package:periodsapp/landing.dart'; // Import the Landing class from landing.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/skip1', // Set the initial route
      routes: {
        '/skip1': (context) => const Skip1Screen(),
        '/landing': (context) => const Landing(),
      },
    );
  }
}

class Skip1Screen extends StatelessWidget {
  const Skip1Screen({super.key});

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
            // Heart icon
            Positioned(
              top: 40,
              left: 60,
              child: Icon(
                Icons.favorite,
                color: Colors.redAccent,
                size: 30,
              ),
            ),
            // Female symbol
            Positioned(
              top: 120,
              right: 50,
              child: Icon(
                Icons.female,
                color: Colors.white.withOpacity(0.5),
                size: 40,
              ),
            ),
            // Main content
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Placeholder for the illustration (replace with your image)
                Image.asset(
                  'assets/images/skip1.png', // Ensure this path is correct
                  height: 250,
                ),
                const SizedBox(height: 20),
                // Text (justified to the left)
                Padding(
                  padding: const EdgeInsets.only(left: 20.0), // Add padding to align with dots
                  child: const Text(
                    'Understand your body & take control.',
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
                          color: Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        width: 10,
                        height: 10,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: const BoxDecoration(
                          color: Colors.black,
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
                      Navigator.pushReplacementNamed(context, '/landing');
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