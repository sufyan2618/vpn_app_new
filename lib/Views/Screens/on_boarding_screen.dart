import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vpn_app/data/Models/splash_ScreenContent.dart';
import 'package:vpn_app/Views/Screens/Splash_Screen.dart';

import 'package:vpn_app/Views/core/components/Simple_button.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  OnBoardingScreenState createState() => OnBoardingScreenState();
}

class OnBoardingScreenState extends State<OnBoardingScreen> {
  int currentIndex = 0;
  PageController? _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121A2E),
      body: Column(
        children: [
          // Top space
          const SizedBox(height: 50),

          // Page indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                ...List.generate(
                  contents.length,
                      (index) => Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: currentIndex == index
                            ? const Color(0xFF00BCD4)
                            : Colors.white.withOpacity(0.2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content area
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: contents.length,
              onPageChanged: (int index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (context, i) {
                return _buildPage(contents[i]);
              },
            ),
          ),

          // Bottom buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            child: Row(
              children: [
                // Skip button
                TextButton(
                  onPressed: () async {
                    var sharedPreference = await SharedPreferences.getInstance();
                    sharedPreference.setBool('newUser', true);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Splash_Screen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const Spacer(),

                // Next button
                _buildNextButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(SplashScreenContent content) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E2C45),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00BCD4).withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              margin: const EdgeInsets.symmetric(vertical: 20),
              padding: const EdgeInsets.all(30),
              child: SvgPicture.asset(
                content.image,
                fit: BoxFit.contain,
              ).animate().fade(duration: 600.ms).scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1, 1),
                duration: 600.ms,
                curve: Curves.easeOutQuad,
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Title
          Text(
            content.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ).animate().fade(delay: 200.ms).slideY(
            begin: 0.2,
            end: 0,
            delay: 200.ms,
            duration: 400.ms,
            curve: Curves.easeOutQuad,
          ),

          const SizedBox(height: 20),

          // Description
          Text(
            content.discription,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
              height: 1.5,
            ),
          ).animate().fade(delay: 400.ms).slideY(
            begin: 0.2,
            end: 0,
            delay: 400.ms,
            duration: 400.ms,
            curve: Curves.easeOutQuad,
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    return InkWell(
      onTap: () async {
        if (currentIndex == contents.length - 1) {
          var sharedPreference = await SharedPreferences.getInstance();
          sharedPreference.setBool('newUser', true);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Splash_Screen(),
            ),
          );
        } else {
          _pageController?.nextPage(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        }
      },
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF00BCD4),
              const Color(0xFF00BCD4).withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00BCD4).withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              currentIndex == contents.length - 1 ? "Get Started" : "Next",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 10),
            const Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
