import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../api/messaging.dart';
import '../model/message.dart';
import '../page/first_page.dart';
import '../page/second_page.dart';
import 'dart:io' show Platform;

class MessagingScreen extends StatefulWidget {
  @override
  _MessagingScrennState createState() => _MessagingScrennState();
}

class _MessagingScrennState extends State<MessagingScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final TextEditingController titleController =
      TextEditingController(text: 'fromApp');
  final TextEditingController bodyController =
      TextEditingController(text: 'some data');
  final List<Message> messages = [];

  @override
  void initState() {
    super.initState();

    _firebaseMessaging.onTokenRefresh.listen(sendTokenToServer);
    _firebaseMessaging.getToken();

    _firebaseMessaging.subscribeToTopic('all');

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        final data = message['data'];
        setState(() {
          messages.add(Message(
              title: data['title'], body: data['body']));
        });

        if (Platform.isAndroid) {
          // Android-specific code
        } else if (Platform.isIOS) {
          // iOS-specific code
        }

        //handleRouting(notification);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");

        final data = message['data'];
        setState(() {
          messages.add(Message(
            title: '${data['title']}',
            body: '${data['body']}',
          ));
        });

       // handleRouting(data);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        final data = message['data'];

        setState(() {
          messages.add(Message(
            title: '${data['title']}',
            body: '${data['body']}',
          ));
        });
        
        //handleRouting(data);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  void handleRouting(dynamic msg) {
    switch (msg['title']) {
      case 'first':
        Navigator.pushNamed(context, '/first');
        break;
      case 'second':
        Navigator.pushNamed(context, '/second');
        //Navigator.of(context).push(
        //    MaterialPageRoute(builder: (BuildContext context) => SecondPage()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('About'), backgroundColor: Colors.blue),

      body: ListView(
        children: [
          TextFormField(
            controller: titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          TextFormField(
            controller: bodyController,
            decoration: InputDecoration(labelText: 'Body'),
          ),
          RaisedButton(
            onPressed: sendNotification,
            child: Text('publish data msg to topic: all'),
          ),
        ]..addAll(messages.map(buildMessage).toList()),
      ),
    );
  }

  Widget buildMessage(Message message) => ListTile(
        title: Text('Title: ${message.title}'),
        subtitle: Text('Body: ${message.body}'),
      );

  Future sendNotification() async {
    print("sending data message");
    final response = await Messaging.sendToAll(
      title: titleController.text,
      body: bodyController.text,
      // fcmToken: fcmToken,
    );

    if (response.statusCode != 200) {
      print("sending data message failed");
      Scaffold.of(context).showSnackBar(SnackBar(
        content:
            Text('[${response.statusCode}] Error message: ${response.body}'),
      ));
    }
    print("sending data message DONE ");
  }

  void sendTokenToServer(String fcmToken) {
    print('Token: $fcmToken');
    // send key to your server to allow server to use
    // this token to send push notifications
  }
}
