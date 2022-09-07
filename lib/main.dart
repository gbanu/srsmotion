import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const methodChannel = MethodChannel('com.gb.accelerometer/method');
  static const pressureChannel = EventChannel('com.julow.barometer/pressure');
  static const accelerometerChannel = EventChannel('com.gb.accelerometer/motion');

  String _sensorAvailable = 'Unknown';
  double _pressureReading = 0;
  double _accelerometerReading = 0;
  StreamSubscription pressureSubscription;
  StreamSubscription accelerometerSubscription;

  Future<void> _checkAvailability() async {
    try {
      var available = await methodChannel.invokeMethod('isSensorAvailable');
      setState(() {
        _sensorAvailable = available.toString();
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  _startReading() {
    accelerometerSubscription =
        accelerometerChannel.receiveBroadcastStream().listen((event) {
      setState(() {
        _accelerometerReading = event;
      });
    });
  }

  _stopReading() {
    setState(() {
      _accelerometerReading = 0;
    });
    accelerometerSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Sensor Available? : $_sensorAvailable'),
            ElevatedButton(
                onPressed: () => _checkAvailability(),
                child: Text('Check Sensor Available')),
            SizedBox(
              height: 50.0,
            ),
            if (_accelerometerReading != 0)
              Text('Sensor Reading : $_accelerometerReading'),
              ElevatedButton(
                  onPressed: () => _startReading(),
                  child: Text('Start Reading')),
            if (_accelerometerReading != 0)
              ElevatedButton(
                  onPressed: () => _stopReading(), child: Text('Stop Reading'))
          ],
        ),
      ),
    );
  }
}
