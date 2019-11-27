import 'package:flutter/material.dart';
import 'package:myetrash/tab_screen2.dart';
import 'package:myetrash/tab_screen3.dart';
import 'package:myetrash/tab_screen4.dart';
import 'package:myetrash/user.dart';
import 'tab_screen.dart';

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key key, this.user}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  List<Widget> tabs;

  int currentTabIndex = 0;

  @override
  void initState(){
    super.initState();
  
        print(widget.user.name);
    tabs = [
      TabScreen(user: widget.user),
      TabScreen2(user: widget.user),
      TabScreen3(user: widget.user),
      TabScreen4(user: widget.user),
    ];
  }

  String $pagetitle = "MyETrash";

  onTapped(int index){
    setState((){
      currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(   
      body: tabs[currentTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTapped,
        currentIndex: currentTabIndex,
        type: BottomNavigationBarType.fixed,

        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Colors.green),
            title: Text("ETrash"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list, color: Colors.green),
            title: Text("Posted ETrash"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event, color: Colors.green),
            title: Text("My ETrash"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.green),
            title: Text("Profile"),
          )
        ],
      ),
    );
  }
}
