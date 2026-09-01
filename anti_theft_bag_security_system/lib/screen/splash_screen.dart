import 'dart:async';
import 'package:flutter/material.dart';
import 'pin_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const PinScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_outline,
              size: 90,
              color: Theme.of(context).colorScheme.primary,
            ),

            const SizedBox(height: 20),

            const Text(
              'SMART BAG',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Text(
              'SECURITY SYSTEM',
              style: TextStyle(
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 30),

            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}