import 'package:flutter/material.dart';
import 'package:aquasave/providers/iot_provider.dart';
import 'package:provider/provider.dart';

class SensorSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final iotProvider = Provider.of<IoTProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Pengaturan Sensor', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.blue.shade100,
      ),
      body: FutureBuilder(
        future: iotProvider.loadTools(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final sensors = iotProvider.iotDevices;

            return Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sensor Yang Terpasang',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      ...sensors
                          .map((sensor) => Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.blueGrey,
                                      child:
                                          Icon(Icons.wifi, color: Colors.white),
                                    ),
                                    SizedBox(width: 10),
                                    Text(sensor.toolName,
                                        style: TextStyle(fontSize: 16)),
                                  ],
                                ),
                              ))
                          .toList(),
                    ],
                  ),
                ),
                Spacer(),
              ],
            );
          }
        },
      ),
    );
  }
}
