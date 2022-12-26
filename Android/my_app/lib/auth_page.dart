import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'dart:io';
import 'dart:convert';

// void main() {
//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fingerprint Scanner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Fingerprint Scanner'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({required this.title}) : super();

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _canCheckFingerprint = false;
  String _authorized = 'Not Authorized';

  @override
  void initState() {
    super.initState();
    _checkFingerprintAvailability();
  }

  void _checkFingerprintAvailability() async {
    bool canCheckFingerprint = false;
    try {
      canCheckFingerprint = await _localAuth.canCheckBiometrics;
    } catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      _canCheckFingerprint = canCheckFingerprint;
    });
  }

  void _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await _localAuth.authenticate(
        localizedReason: 'Scan your fingerprint to authenticate',
      );
    } catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      _authorized = authenticated ? 'Authorized' : 'Not Authorized';
    });

    if (authenticated) {
      // Send message to Python script over local WiFi
      // Replace IP_ADDRESS and PORT with the actual IP address and port of the machine running the Python script
       // Send message to Python script over local WiFi
            RawDatagramSocket.bind(InternetAddress.anyIPv4, 0)
                .then((RawDatagramSocket socket) {
              List<int> message = utf8.encode('Hello from Flutter!');
              socket.send(message, InternetAddress('192.168.1.7'), 8000);
            });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Text(
                'You are $_authorized',
                style: TextStyle(fontSize: 32),
              ),
              ElevatedButton(
                onPressed: _canCheckFingerprint ? _authenticate : null,
                child: Text('Authenticate'),
              )
            ])));
  }
}
