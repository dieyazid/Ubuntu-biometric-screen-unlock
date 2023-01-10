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
  late String serverIp;

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
      try {
          // create a socket connection to the network
          RawDatagramSocket.bind(InternetAddress.anyIPv4, 0)
            .then((RawDatagramSocket socket) {
              List<int> message = utf8.encode('unlock');
              socket.broadcastEnabled = true;
              // Send message to broadcast IP
              socket.send(message, InternetAddress('255.255.255.255'), 8000);
              // wait for a response
              // socket.listen((RawSocketEvent event) {
              //   if (event == RawSocketEvent.read) {
              //     Datagram? d = socket.receive();
              //     serverIp = utf8.decode(d!.data);
              //     print('Server IP is: $serverIp');
              //   }
              // });
            });
        } catch (e) {
          print(e);
        }
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
