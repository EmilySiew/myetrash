import 'package:flutter/material.dart';
import 'package:myetrash/user.dart';
 

 
class TabScreen4 extends StatefulWidget {
  final User user;
  TabScreen4({Key key, this.user});


  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<TabScreen4> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
        body: Center(
          child: Container(
            child: Text('Hello World'),
          ),
        ),
      ),
    );
  }
}