import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'drawer.dart';

class PushNotification extends StatefulWidget {
  @override
  _PushNotificationState createState() => _PushNotificationState();
}

class _PushNotificationState extends State<PushNotification> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String _message = '';

  _registerOnFirebase() {
    _firebaseMessaging.subscribeToTopic('all');
    _firebaseMessaging.getToken().then((token) => print(token));
  }

  @override
  void initState() {
    _registerOnFirebase();
    getMessage();
    super.initState();
  }

  void getMessage() {
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print('received message');
          setState(() => _message = message["notification"]["body"]);
        }, onResume: (Map<String, dynamic> message) async {

      setState(() => _message = message["notification"]["body"]);
    }, onLaunch: (Map<String, dynamic> message) async {

      setState(() => _message = message["notification"]["body"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notificações', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.yellow),),
      ),

      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            DrawerHead()
          ],
        ),
      ),

      body: Container(
          child: Center(
            child: _message == '' ? Text(
              "Notificação: Nenhuma notificação no momento",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 18),
            ) : Text(
              "Notificação: $_message",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 18),
            ),
          )),
    );
  }
}
