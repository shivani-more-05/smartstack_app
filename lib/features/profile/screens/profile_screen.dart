import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:smartstack_app/features/settings/account_settings_screen.dart';
import 'package:smartstack_app/features/auth/screens/about/about_app_screen.dart';
import 'package:smartstack_app/features/auth/screens/privacy/privacy_policy_screen.dart';
import 'package:smartstack_app/features/auth/screens/login_screen.dart';

const Color lavenderMist = Color(0xFFECE6F6);
const Color deepLilac = Color(0xFF8C6EC7);

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? get _user => FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final name = _user?.displayName ?? "User";
    final email = _user?.email ?? "example@gmail.com";

    return Scaffold(
      backgroundColor: lavenderMist,
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 45,
                    backgroundColor: deepLilac,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: deepLilac,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: ListView(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: const Text("Account Settings"),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AccountSettingsScreen(),
                          ),
                        );
                        setState(() {}); // refresh name/email
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.privacy_tip),
                      title: const Text("Privacy Policy"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PrivacyPolicyScreen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: const Text("About App"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AboutAppScreen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: const Text(
                        "Logout",
                        style: TextStyle(color: Colors.red),
                      ),
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        if (!mounted) return;
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                          (route) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
