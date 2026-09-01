import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double sensitivity = 50;
  bool alarmEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Motion Sensitivity',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          Slider(
            value: sensitivity,
            min: 0,
            max: 100,
            divisions: 10,
            label: sensitivity.round().toString(),
            onChanged: (value) {
              setState(() {
                sensitivity = value;
              });
            },
          ),

          Text(
            'Sensitivity: ${sensitivity.round()}',
          ),

          const SizedBox(height: 30),

          SwitchListTile(
            title: const Text('Alarm'),
            subtitle: const Text(
              'Enable or disable bag alarm',
            ),
            value: alarmEnabled,
            onChanged: (value) {
              setState(() {
                alarmEnabled = value;
              });
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Change PIN'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'PIN changing will be added later',
                  ),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.bluetooth),
            title: const Text('Bluetooth Device'),
            subtitle: const Text('SmartBag-ESP32'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}