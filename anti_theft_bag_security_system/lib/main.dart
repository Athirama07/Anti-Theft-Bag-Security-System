import 'package:flutter/material.dart';

void main() {
  runApp(const SmartBagApp());
}

class SmartBagApp extends StatelessWidget {
  const SmartBagApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Anti-Theft Bag',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isArmed = false;
  bool bluetoothConnected = false;
  int battery = 86;
  String motionStatus = 'Normal';
  double sensitivity = 50;

  final List<String> events = [
    'System initialized',
    'Bluetooth disconnected',
  ];

  void connectBluetooth() {
    setState(() {
      bluetoothConnected = !bluetoothConnected;

      if (bluetoothConnected) {
        events.insert(0, 'Bluetooth connected');
      } else {
        events.insert(0, 'Bluetooth disconnected');
      }
    });
  }

  void openPinDialog() {
    showDialog(
      context: context,
      builder: (context) => PinDialog(
        title: isArmed ? 'Disarm System' : 'Arm System',
        onSuccess: () {
          setState(() {
            isArmed = !isArmed;
            events.insert(
              0,
              isArmed ? 'System armed' : 'System disarmed',
            );
          });
        },
      ),
    );
  }

  void findBag() {
    setState(() {
      events.insert(0, 'Find My Bag activated');
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Find My Bag activated'),
      ),
    );
  }

  void showEvents() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EventsScreen(events: events),
      ),
    );
  }

  void showSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SettingsScreen(
          sensitivity: sensitivity,
          onChanged: (value) {
            setState(() {
              sensitivity = value;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Smart Bag Security',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: showSettings,
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _statusCard(),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _infoCard(
                      icon: Icons.bluetooth,
                      title: 'Bluetooth',
                      value: bluetoothConnected
                          ? 'Connected'
                          : 'Disconnected',
                      iconColor: bluetoothConnected
                          ? Colors.green
                          : Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _infoCard(
                      icon: Icons.battery_5_bar,
                      title: 'Battery',
                      value: '$battery%',
                      iconColor: Colors.green,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _infoCard(
                      icon: Icons.directions_run,
                      title: 'Motion',
                      value: motionStatus,
                      iconColor: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _infoCard(
                      icon: Icons.sensors,
                      title: 'Sensitivity',
                      value: '${sensitivity.round()}%',
                      iconColor: Colors.orange,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              ElevatedButton.icon(
                onPressed: connectBluetooth,
                icon: Icon(
                  bluetoothConnected
                      ? Icons.bluetooth_disabled
                      : Icons.bluetooth,
                ),
                label: Text(
                  bluetoothConnected
                      ? 'Disconnect Bluetooth'
                      : 'Connect to Bag',
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),

              const SizedBox(height: 12),

              ElevatedButton.icon(
                onPressed: openPinDialog,
                icon: Icon(
                  isArmed ? Icons.lock_open : Icons.lock,
                ),
                label: Text(
                  isArmed ? 'DISARM SYSTEM' : 'ARM SYSTEM',
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),

              const SizedBox(height: 12),

              OutlinedButton.icon(
                onPressed: findBag,
                icon: const Icon(Icons.location_searching),
                label: const Text('FIND MY BAG'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Quick Access',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _quickButton(
                      icon: Icons.history,
                      title: 'Events',
                      onTap: showEvents,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _quickButton(
                      icon: Icons.settings,
                      title: 'Settings',
                      onTap: showSettings,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              _recentEvents(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusCard() {
    final statusColor = isArmed ? Colors.orange : Colors.green;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            isArmed ? Icons.shield : Icons.shield_outlined,
            size: 64,
            color: statusColor,
          ),
          const SizedBox(height: 10),
          Text(
            isArmed ? 'SYSTEM ARMED' : 'SYSTEM SAFE',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isArmed
                ? 'Your bag is being monitored'
                : 'Your bag is currently safe',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 30),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(title),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15),
      ),
    );
  }

  Widget _recentEvents() {
    final recent = events.take(3).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Events',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...recent.map(
            (event) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.notifications_none),
              title: Text(event),
              dense: true,
            ),
          ),
        ],
      ),
    );
  }
}

class PinDialog extends StatefulWidget {
  final String title;
  final VoidCallback onSuccess;

  const PinDialog({
    super.key,
    required this.title,
    required this.onSuccess,
  });

  @override
  State<PinDialog> createState() => _PinDialogState();
}

class _PinDialogState extends State<PinDialog> {
  final TextEditingController controller = TextEditingController();

  // Temporary test PIN.
  // Later this will be replaced by ESP32 authentication.
  final String testPin = '1234';

  String? errorMessage;

  void verifyPin() {
    if (controller.text == testPin) {
      Navigator.pop(context);
      widget.onSuccess();
    } else {
      setState(() {
        errorMessage = 'Incorrect PIN. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Enter your 4-digit security PIN'),
          const SizedBox(height: 16),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            obscureText: true,
            maxLength: 4,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: '••••',
              counterText: '',
            ),
          ),
          if (errorMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              errorMessage!,
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('CANCEL'),
        ),
        ElevatedButton(
          onPressed: verifyPin,
          child: const Text('CONFIRM'),
        ),
      ],
    );
  }
}

class EventsScreen extends StatelessWidget {
  final List<String> events;

  const EventsScreen({
    super.key,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event History'),
      ),
      body: events.isEmpty
          ? const Center(
              child: Text('No events recorded'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: events.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.event_note),
                    title: Text(events[index]),
                    subtitle: const Text('Smart Bag Security System'),
                  ),
                );
              },
            ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  final double sensitivity;
  final ValueChanged<double> onChanged;

  const SettingsScreen({
    super.key,
    required this.sensitivity,
    required this.onChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late double currentSensitivity;

  @override
  void initState() {
    super.initState();
    currentSensitivity = widget.sensitivity;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Motion Sensitivity',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${currentSensitivity.round()}%',
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          Slider(
            value: currentSensitivity,
            min: 0,
            max: 100,
            divisions: 20,
            label: '${currentSensitivity.round()}%',
            onChanged: (value) {
              setState(() {
                currentSensitivity = value;
              });

              widget.onChanged(value);
            },
          ),
          const SizedBox(height: 20),
          const ListTile(
            leading: Icon(Icons.bluetooth),
            title: Text('Bluetooth'),
            subtitle: Text('ESP32 connection settings'),
          ),
          const ListTile(
            leading: Icon(Icons.security),
            title: Text('Security PIN'),
            subtitle: Text('PIN authentication settings'),
          ),
          const ListTile(
            leading: Icon(Icons.battery_full),
            title: Text('Battery'),
            subtitle: Text('Battery monitoring'),
          ),
        ],
      ),
    );
  }
}