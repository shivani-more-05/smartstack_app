import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool pushNotifications = true;
  bool soundOn = true;
  bool vibrate = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification Settings"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            value: pushNotifications,
            title: const Text("Enable Notifications"),
            onChanged: (v) => setState(() => pushNotifications = v),
          ),
          SwitchListTile(
            value: soundOn,
            title: const Text("Notification Sound"),
            onChanged: (v) => setState(() => soundOn = v),
          ),
          SwitchListTile(
            value: vibrate,
            title: const Text("Vibration"),
            onChanged: (v) => setState(() => vibrate = v),
          ),
        ],
      ),
    );
  }
}
