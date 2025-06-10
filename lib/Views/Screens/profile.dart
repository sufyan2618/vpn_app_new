import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vpn_app/data/services/auth_service.dart';
import 'package:vpn_app/Views/Screens/Home_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = false;
  final _authService = authService;

  @override
  Widget build(BuildContext context) {
    // Get user email from Supabase auth service
    final email = authService.getCurrentUserEmail() ?? 'No email';

    // Get username from user metadata if available
    final user = Supabase.instance.client.auth.currentUser;
    final username = user?.userMetadata?['username'] ?? 'User';

    return Scaffold(
      backgroundColor: const Color(0xFF121A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121A2E),
        elevation: 0,
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.white),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) =>const HomeScreen())),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Green indicator line
              Container(
                width: 40,
                height: 3,
                color: const Color(0xFF00BCD4),
              ).animate().fade().slideX(
                begin: -0.2,
                end: 0,
                duration: 400.ms,
                curve: Curves.easeOutQuad,
              ),

              const SizedBox(height: 20),

              // Profile card
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2C45),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: const Color(0xFF00BCD4).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    // Profile picture
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF00BCD4).withOpacity(0.1),
                      ),
                      child: const Center(
                        child: Text(
                          "😊",
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    // User info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            username,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            email,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fade().scale(
                begin: const Offset(0.95, 0.95),
                end: const Offset(1, 1),
                duration: 500.ms,
                curve: Curves.easeOutQuad,
              ),

              const SizedBox(height: 30),

              // Settings section
              const Text(
                'Settings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ).animate().fade(delay: 200.ms).slideY(
                begin: 0.2,
                end: 0,
                delay: 200.ms,
                duration: 400.ms,
              ),

              const SizedBox(height: 15),

              // Settings options
              _buildSettingsOption(
                title: 'Update username',
                icon: Icons.person_outline,
                onTap: () => _showUpdateUsernameDialog(context),
              ).animate().fade(delay: 300.ms).slideX(
                begin: 0.1,
                end: 0,
                delay: 300.ms,
                duration: 400.ms,
              ),

              _buildSettingsOption(
                title: 'Change email',
                icon: Icons.email_outlined,
                onTap: () => _showChangeEmailDialog(context),
              ).animate().fade(delay: 400.ms).slideX(
                begin: 0.1,
                end: 0,
                delay: 400.ms,
                duration: 400.ms,
              ),

              _buildSettingsOption(
                title: 'Change password',
                icon: Icons.lock_outline,
                onTap: () => _showChangePasswordDialog(context),
              ).animate().fade(delay: 500.ms).slideX(
                begin: 0.1,
                end: 0,
                delay: 500.ms,
                duration: 400.ms,
              ),

              _buildSettingsOption(
                title: 'About this app',
                icon: Icons.info_outline,
                onTap: () => _showAboutDialog(context),
              ).animate().fade(delay: 600.ms).slideX(
                begin: 0.1,
                end: 0,
                delay: 600.ms,
                duration: 400.ms,
              ),

              const SizedBox(height: 30),

              // Logout button
              Center(
                child: TextButton(
                  onPressed: _isLoading ? null : _logout,
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ).animate().fade(delay: 700.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsOption({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white70,
              size: 22,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.white54,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showUpdateUsernameDialog(BuildContext context) async {
    final TextEditingController controller = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E2C45),
        title: const Text(
          'Update Username',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Enter new username',
            hintStyle: TextStyle(color: Colors.white54),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white30),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF00BCD4)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                Navigator.pop(context);
                setState(() => _isLoading = true);
                try {
                  await authService.updateUsername(controller.text.trim());
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Username updated successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to update username: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } finally {
                  setState(() => _isLoading = false);
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00BCD4),
            ),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  Future<void> _showChangeEmailDialog(BuildContext context) async {
    final emailController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E2C45),
        title: const Text(
          'Change Email',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'New email address',
                hintStyle: TextStyle(color: Colors.white54),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white30),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF00BCD4)),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (emailController.text.isNotEmpty) {
                Navigator.pop(context);
                setState(() => _isLoading = true);
                try {
                  await authService.updateEmail(emailController.text.trim());
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Email updated successfully. Please verify your new email.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to update email: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } finally {
                  setState(() => _isLoading = false);
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00BCD4),
            ),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  Future<void> _showChangePasswordDialog(BuildContext context) async {
    final newPasswordController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E2C45),
        title: const Text(
          'Change Password',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: newPasswordController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'New password',
                hintStyle: TextStyle(color: Colors.white54),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white30),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF00BCD4)),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (newPasswordController.text.isNotEmpty) {
                Navigator.pop(context);
                setState(() => _isLoading = true);
                try {
                  await authService.updatePassword(newPasswordController.text);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password updated successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to update password: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } finally {
                  setState(() => _isLoading = false);
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00BCD4),
            ),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E2C45),
        title: const Text(
          'About This App',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFF121A2E),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.vpn_lock,
                  color: Color(0xFF00BCD4),
                  size: 40,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'SwiftShield VPN',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Version 1.0.0',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 20),
            const Text(
              'A secure and fast VPN service to protect your online privacy and security.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(color: Color(0xFF00BCD4)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    setState(() => _isLoading = true);
    try {
      await _authService.signOut();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logged out successfully'),
          backgroundColor: Colors.green,
        ));
      await Future.delayed(const Duration(seconds: 1));
      Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to log out: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() => _isLoading = false);
    }
  }
}