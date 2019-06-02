// https://www.youtube.com/watch?v=4_2LlswlS2Q

import 'package:flutter/material.dart';
import 'widget/messaging_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final String appTitle = 'Send push notifications';
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: appTitle,
        home: MainPage(appTitle: appTitle),
      );
}

class MainPage extends StatelessWidget {
  final String appTitle;

  const MainPage({this.appTitle});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: MessagingWidget(),
      );
}
