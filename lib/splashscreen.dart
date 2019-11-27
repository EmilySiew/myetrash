import 'package:flutter/material.dart';
//import 'loginpage.dart';
import 'package:myetrash/mainscreen.dart';
import 'package:flutter/services.dart';
import 'package:myetrash/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

String _email, _password;
String urlLogin = "http://slumberjer.com/myhelper/php/login_user.php";

void main() => runApp(SplashScreen());

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.green));
    return MaterialApp(
      theme: new ThemeData(
        primaryColor: Colors.green,
        primarySwatch: Colors.green,
        accentColor: Colors.greenAccent,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.PNG'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/myETrash_logo.PNG',
                width: 600,
                height: 450,
              ),
              SizedBox(
                height: 30,
              ),
              new ProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}

class ProgressIndicator extends StatefulWidget {
  @override
  _ProgressIndicatorState createState() => new _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<ProgressIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 5000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          if (animation.value > 0.99) {
            /*Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => LoginPage(user:user)));*/
            //print('Navigation to login page');
            loadpref(this.context);
                      }
                    });
                  });
                controller.repeat();
              }
            
              @override
              void dispose() {
                controller.stop();
                super.dispose();
              }
            
              @override
              Widget build(BuildContext context) {
                return new Center(
                    child: new Container(
                  width: 200,
                  height: 20,
                  //color: Colors.redAccent,
                  child: LinearProgressIndicator(
                    value: animation.value,
                    backgroundColor: Colors.white,
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                  ),
                ));
              }
            
              void loadpref(BuildContext ctx) async {
                print('Inside loadpref()');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  _email = (prefs.getString('email')??'');
  _password = (prefs.getString('pass')??'');
  print("Splash:Preference");
  print(_email);
  print(_password);
  if (_isEmailValid(_email??"no email")) {
      //try to login if got email;
      _onLogin(_email, _password, ctx);
          } else {
            //login as unregistered user
            User user = new User(
                name: "not register",
                email: "user@noregister",
                phone: "not register",
                radius: "15",
                credit: "0",
                rating: "0");
            Navigator.push(
                ctx, MaterialPageRoute(builder: (context) => MainScreen(user: user)));
          }
                      }
        
          bool _isEmailValid(String email) {
            return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
          }
      
        void _onLogin(String email, String password, BuildContext ctx) {
          http.post(urlLogin, body: {
    "email": _email,
    "password": _password,
  }).then((res) {
    print(res.statusCode);
    var string = res.body;
    List dres = string.split(",");
    print("SPLASH:loading");
    print(dres);
    if (dres[0] == "success") {
      User user = new User(
          name: dres[1],
          email: dres[2],
          phone: dres[3],
          radius: dres[4],
          credit: dres[5],
          rating: dres[6]);
      Navigator.push(
          ctx, MaterialPageRoute(builder: (context) => MainScreen(user: user)));
    } else {
      //allow login as unregistered user
      User user = new User(
          name: "not register",
          email: "user@noregister",
          phone: "not register",
          radius: "6370",
          credit: "0",
          rating: "0");
      Navigator.push(
          ctx, MaterialPageRoute(builder: (context) => MainScreen(user: user)));
    }
  }).catchError((err) {
    print(err);
  });
        }
}
