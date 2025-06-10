// ignore_for_file: camel_case_types

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:vpn_app/Views/Screens/Home_screen.dart';
import 'package:vpn_app/Handlers/location_provider.dart';

class Splash_Screen extends StatefulWidget {
  const Splash_Screen({Key? key}) : super(key: key);

  @override
  _Splash_ScreenState createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Animation setup
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();

    // Load VPN data and then navigate
    _loadDataAndNavigate();
  }

  Future<void> _loadDataAndNavigate() async {
    final locationController = Provider.of<LocationProvider>(context, listen: false);

    try {
      if (locationController.vpnList.isEmpty) {
        await locationController.getVpnData();
      }
      if (locationController.countrylist.isEmpty || locationController.flaglist.isEmpty) {
        await locationController.getCountriesData();
      }

      // Optional delay for user experience
      await Future.delayed(const Duration(seconds: 5));

      // Navigate to Home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      print("Error loading VPN data: $e");
      // You may show an error dialog or retry option here
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121A2E),
      body: Stack(
        children: [
          // Background gradient bubbles
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF00BCD4).withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -150,
            right: -150,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF00BCD4).withOpacity(0.07),
              ),
            ),
          ),

          // Splash Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo animation
                ScaleTransition(
                  scale: _animation,
                  child: Container(
                    width: 150,
                    height: 150,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2C45),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00BCD4).withOpacity(0.2),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF00BCD4).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // App title
                Text(
                  'Wrap VPN'.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ).animate().fade(duration: 800.ms, delay: 300.ms).slideY(
                  begin: 0.3,
                  end: 0,
                  duration: 800.ms,
                  delay: 300.ms,
                  curve: Curves.easeOutQuad,
                ),

                const SizedBox(height: 10),

                // Tagline
                const Text(
                  'Secure. Fast. Private.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ).animate().fade(duration: 800.ms, delay: 600.ms).slideY(
                  begin: 0.3,
                  end: 0,
                  duration: 800.ms,
                  delay: 600.ms,
                  curve: Curves.easeOutQuad,
                ),

                const SizedBox(height: 60),

                // Animated loading bar
                Container(
                  width: 200,
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2C45),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: _animation.value,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF00BCD4),
                                const Color(0xFF00BCD4).withOpacity(0.7),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Version
          const Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Text(
              'v1.0.0',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white38,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
