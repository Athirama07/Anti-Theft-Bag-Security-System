import 'package:flutter/material.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bag Location'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.location_on,
              size: 80,
            ),

            const SizedBox(height: 20),

            const Text(
              'GPS STATUS',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: const [
                    Text('Latitude'),
                    SizedBox(height: 5),
                    Text(
                      '10.000000',
                      style: TextStyle(fontSize: 20),
                    ),

                    SizedBox(height: 20),

                    Text('Longitude'),
                    SizedBox(height: 5),
                    Text(
                      '76.000000',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'GPS data will come from ESP32',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.refresh),
              label: const Text('REFRESH LOCATION'),
            ),
          ],
        ),
      ),
    );
  }
}