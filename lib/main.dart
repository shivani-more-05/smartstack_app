import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import 'features/home/bottom_nav.dart';
import 'features/auth/screens/login_screen.dart';

const Color lavenderMist = Color(0xFFECE6F6);
const Color deepLilac = Color(0xFF8C6EC7);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartStack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: lavenderMist,
        colorScheme: ColorScheme.fromSeed(
          seedColor: deepLilac,
          primary: deepLilac,
          secondary: deepLilac,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: deepLilac,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: deepLilac,
        ),
      ),
      home: const _AuthGate(),
    );
  }
}

/// decides LOGIN or MAIN APP based on FirebaseAuth state
class _AuthGate extends StatelessWidget {
  const _AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snap.hasData) {
          // logged in
          return const BottomNav();
        } else {
          // not logged in
          return const LoginScreen();
        }
      },
    );
  }
}
