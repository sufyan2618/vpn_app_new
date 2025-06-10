import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:vpn_app/data/services/auth_service.dart';
import 'package:vpn_app/Views/Screens/IP_details_screen.dart';
import 'package:vpn_app/Views/Screens/Location_screen.dart';
import 'package:vpn_app/Views/Screens/profile.dart';
import 'package:vpn_app/Views/Screens/register.dart';


class SideNavigationBar extends StatefulWidget {
  const SideNavigationBar({Key? key}) : super(key: key);

  @override
  _SideNavigationBarState createState() => _SideNavigationBarState();
}

class _SideNavigationBarState extends State<SideNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF121A2E),
      child: ListView(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        children: <Widget>[
          // Header with logo and app name
          Container(
            padding: const EdgeInsets.only(top: 50, bottom: 20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2C45),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(0),
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00BCD4).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover, // Fill the entire space, may stretch the image
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'Wrap VPN'.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ).animate().fade().slideY(begin: 0.2, end: 0, curve: Curves.easeOut),
                const SizedBox(height: 5),
                const Text(
                  'Secure VPN Service',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),
          authService.getCurrentUserEmail() != null ?
          _buildMenuItem(
            icon: CupertinoIcons.info_circle,
            title: 'Profile Page',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
            },
          ):
          _buildMenuItem(
            icon: Icons.login_rounded,
            title: 'Login',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()));
            },
          ),
          // Main menu items
          _buildMenuSection(
            title: 'VPN Services',
            items: [
              // IP Details Screen
              _buildMenuItem(
                icon: CupertinoIcons.info_circle,
                title: 'IP Details',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const IPDetailsScreen()));
                },
              ),

              // Server Location Screen
              _buildMenuItem(
                icon: CupertinoIcons.globe,
                title: 'Server List',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LocationScreen(serverList: [], countries: [], flags: []),
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(color: Colors.white24, thickness: 1),
          ),
          const SizedBox(height: 10),

          // Communication section
          _buildMenuSection(
            title: 'Communicate',
            items: [
              // Share App
              _buildMenuItem(
                icon: Icons.share_rounded,
                title: 'Share App',
                onTap: () async {
                  final String appLink = 'https://play.google.com/store/apps/details?id=com.example.vpn_app';
                  final String message = 'Check out Wrap VPN for secure and private browsing:';
                  await Share.share('$message\n$appLink', subject: 'WRAP VPN');
                },
              ),

              // Rate App
              _buildMenuItem(
                icon: CupertinoIcons.star_fill,
                title: 'Rate Us',
                onTap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) => _buildRatingDialog(),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(color: Colors.white24, thickness: 1),
          ),
          const SizedBox(height: 20),

          // App version
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'App Version 1.0.0',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMenuSection({required String title, required List<Widget> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        ),
        ...items,
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2C45),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: const Color(0xFF00BCD4),
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.white54,
        size: 16,
      ),
    );
  }

  RatingDialog _buildRatingDialog() {
    return RatingDialog(
      starColor: const Color(0xFF00BCD4),
      initialRating: 5.0,
      starSize: 35,
      title: const Text(
        'Rate Wrap VPN',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
      ),
      message: const Text(
        'Your feedback helps us improve. Tap the stars to rate your experience and share any additional thoughts.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          color: Colors.blueAccent,
        ),
      ),
      image: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFF00BCD4).withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          CupertinoIcons.star_fill,
          size: 50,
          color: Color(0xFF00BCD4),
        ),
      ),
      submitButtonText: 'Submit',
      commentHint: 'Tell us your experience...',
      submitButtonTextStyle: const TextStyle(
        color: Color(0xFF00BCD4),
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      onSubmitted: (response) {
        StoreRedirect.redirect(
          androidAppId: 'com.example.vpn_app',
          iOSAppId: 'com.example.vpn_app',
        );
      },
    );
  }
}
