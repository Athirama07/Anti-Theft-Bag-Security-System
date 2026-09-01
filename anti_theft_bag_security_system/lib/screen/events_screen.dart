import 'package:flutter/material.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final events = [
      'System Armed',
      'Normal Movement Detected',
      'Suspicious Movement',
      'Zip Opened',
      'Alarm Triggered',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event History'),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: events.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: const Icon(Icons.warning_amber),
              title: Text(events[index]),
              subtitle: const Text('Today'),
            ),
          );
        },
      ),
    );
  }
}