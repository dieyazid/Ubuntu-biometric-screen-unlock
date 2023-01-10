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
        primarySwatch: Colors.teal,
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
  String _ipAddress='';
  final _controller = TextEditingController();
  

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
    _controller.text = "";
    _controller.addListener(() {
    final text = _controller.text;
    _controller.value = _controller.value.copyWith(
        text: RegExp(r'^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$|^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$')
            .stringMatch(text) ??
        '');
  });
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
        socket.send(message, InternetAddress(_ipAddress), 8000);
      });
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 199, 230, 227),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height:20),
              Icon(
                Icons.fingerprint,
                color: _authorized == 'Authorized' ? Colors.green : Colors.red,
                size: 100.0,
              ),
              SizedBox(height:50),
              Text(
                'You are $_authorized',
                style: TextStyle(
                fontSize: 25,
                color: Colors.grey[800],
                fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height:20),
              Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(
                  width: 300,
                  child: TextField(
                    style: TextStyle(fontSize: 19.0),
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'IP Address',
                      labelText: 'IP Address',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.teal,
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.teal,
                          width: 3.0,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      // Store the IP address entered by the user
                      _ipAddress = value;
                    },
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _canCheckFingerprint ? _authenticate : null,
                child: Column(
                    children: [
                      Text('Authenticate')
                    ],
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
