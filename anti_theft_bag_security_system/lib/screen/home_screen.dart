import 'package:flutter/material.dart';
import 'events_screen.dart';
import 'location_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isArmed = false;
  bool bluetoothConnected = false;
  bool alarmActive = false;

  int batteryLevel = 82;
  int theftScore = 10;

  String motionStatus = 'Normal';
  String gpsStatus = 'Available';

  void toggleArm() {
    setState(() {
      isArmed = !isArmed;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isArmed ? 'Security system armed' : 'Security system disarmed',
        ),
      ),
    );
  }

  void findBag() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Find My Bag command will be sent to ESP32'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Bag'),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Security status
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      'SECURITY STATUS',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Icon(
                      isArmed
                          ? Icons.lock
                          : Icons.lock_open,
                      size: 55,
                    ),

                    const SizedBox(height: 8),

                    Text(
                      isArmed ? 'ARMED' : 'SAFE',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: isArmed ? Colors.orange : Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Bluetooth
            _buildStatusCard(
              icon: Icons.bluetooth,
              title: 'Bluetooth',
              value: bluetoothConnected
                  ? 'Connected'
                  : 'Not Connected',
            ),

            // Battery
            _buildStatusCard(
              icon: Icons.battery_full,
              title: 'Battery',
              value: '$batteryLevel%',
            ),

            // Motion
            _buildStatusCard(
              icon: Icons.directions_run,
              title: 'Motion',
              value: motionStatus,
            ),

            // GPS
            _buildStatusCard(
              icon: Icons.location_on,
              title: 'GPS',
              value: gpsStatus,
            ),

            // Theft score
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    const Text(
                      'THEFT RISK SCORE',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      '$theftScore / 100',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    LinearProgressIndicator(
                      value: theftScore / 100,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Arm button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: toggleArm,
                icon: Icon(
                  isArmed
                      ? Icons.lock_open
                      : Icons.lock,
                ),
                label: Text(
                  isArmed ? 'DISARM SYSTEM' : 'ARM SYSTEM',
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Find bag
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: findBag,
                icon: const Icon(Icons.volume_up),
                label: const Text('FIND MY BAG'),
              ),
            ),

            const SizedBox(height: 20),

            // Navigation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _navigationButton(
                  Icons.history,
                  'Events',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EventsScreen(),
                      ),
                    );
                  },
                ),

                _navigationButton(
                  Icons.location_on,
                  'Location',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LocationScreen(),
                      ),
                    );
                  },
                ),

                _navigationButton(
                  Icons.settings,
                  'Settings',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SettingsScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _navigationButton(
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    return Column(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon),
        ),
        Text(label),
      ],
    );
  }
}