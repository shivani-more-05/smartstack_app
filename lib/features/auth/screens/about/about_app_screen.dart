import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About App"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "SmartStack App",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8C6EC7),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "SmartStack helps you save copied content instantly — "
              "categorized as Links, Emails, Quotes, Notes, Phone Numbers, Code Snippets or Others.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              "Version: 1.0.0",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
