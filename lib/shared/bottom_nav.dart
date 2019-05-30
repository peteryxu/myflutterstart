import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppBottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.graduationCap, size: 20),
            title: Text('Topics')),
        BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.addressBook, size: 20),
            title: Text('Chat')),        
        BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.userCircle, size: 20),
            title: Text('Hero')),    
        BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.bolt, size: 20),
            title: Text('AI')),
        //BottomNavigationBarItem(
        //    icon: Icon(FontAwesomeIcons.bolt, size: 20),
        //    title: Text('About')),
        
      ].toList(),
      fixedColor: Colors.deepPurple[200],
      onTap: (int idx) {
        switch (idx) {
          case 0:
            // do nuttin
            break;
          case 1:
            Navigator.pushNamed(context, '/chat');
            break;
          case 2:
            Navigator.pushNamed(context, '/hero');
            break;  
          case 3:
            Navigator.pushNamed(context, '/ai');
            break;
        }
      },
    );
  }
}