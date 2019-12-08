import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:myetrash/registrationscreen.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:myetrash/mainscreen.dart';
import 'package:myetrash/forgotpw.dart';
import 'user.dart';

String urlLogin = "http://itschizo.com/emily_siew/myETrash/php/login_admin.php";

bool _isChecked = true;
final TextEditingController _emcontroller = TextEditingController();
String _email = "";
final TextEditingController _pscontroller = TextEditingController();
String _pass = "";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    _loadpref();
    print('Init: $_email');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      body: new Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/background.PNG'),
              fit: BoxFit.cover),
        ),
        padding: EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/myETrash_logo.PNG',
              scale: 2.5,
            ),
            TextField(
                controller: _emcontroller,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.lightGreenAccent[50],
                    labelText: 'Email',
                    icon: Icon(Icons.email))),
            SizedBox(height: 10.0),
            TextField(
              controller: _pscontroller,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.lightGreenAccent[50],
                  labelText: 'Password',
                  icon: Icon(Icons.lock)),
              obscureText: true,
            ),
            Row(
              children: <Widget>[
                Checkbox(
                  value: _isChecked,
                  onChanged: (bool value) {
                    _onChange(value);
                  },
                ),
                Text('Remember Me', style: TextStyle(fontSize: 16))
              ],
            ),
            SizedBox(
              height: 10,
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              minWidth: 300,
              height: 50,
              child: Text('Login'),
              color: Colors.green[300],
              textColor: Colors.white,
              elevation: 20,
              onPressed: _onLogin,
            ),
            SizedBox(
              height: 100,
            ),
            Row(
              children: <Widget>[
                GestureDetector(
                    onTap: _onRegister,
                    child: Text('Register New Account',
                        style: TextStyle(fontSize: 16, color: Colors.blue)
                        ),
                        ),
                Spacer(),
                GestureDetector(
                    onTap: _onForgot,
                    child:
                        Text('Forgot Password', 
                        style: TextStyle(fontSize: 16,color: Colors.blue),
                        ),
                        ),
              ],
            )
            
          ],
        ),
      ),
    );
  }

  void _onLogin() {
    _email = _emcontroller.text;
    _pass = _pscontroller.text;
    print(_email);
    print(_pass);
    if (_checkEmail(_email) && _pass.length > 5) {
      ProgressDialog pr = new ProgressDialog(context, 
        type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Login in");
      pr.show();
      http.post(urlLogin, body: {
        "email": _email,
        "password": _pass,
      }).then((res){
        print(res.statusCode);
        var string = res.body;
        List dres = string.split(",");
        print(dres);
        Toast.show(dres[0], context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        if (dres[0] == "success") {
          pr.dismiss();
          print("Radius:");
          print(dres);
          User user = new User(name: dres[1],email:dres[2],phone:dres[3],radius:dres[4],credit:dres[5],rating:dres[6]);
          Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen(user: user)));
        }else{
          pr.dismiss();
        }
      }).catchError((err) {
        pr.dismiss();
        print(err);
      });
    } else {
      Toast.show("Invalid email or password", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _onChange(bool value) {
    setState(() {
      _isChecked = value;
      print('Check value $value');
      savePref(value);
    });
  }

  bool _checkEmail(String _email) {
    bool emailValid =
        RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_email);
    return emailValid;
  }

  void _onRegister() {
    print('onRegister');
    Navigator.push(
      context, MaterialPageRoute(builder: (context)=>RegisterScreen())
    );
  }

  void _onForgot() {
    print('Forgot');
    Navigator.push(
      context, MaterialPageRoute(builder: (context)=>ForgotpwScreen())
    );
  }

  void savePref(bool value) async {
    print('Inside loadpref()');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _email = _emcontroller.text;
    _pass = _pscontroller.text;
    if (value) {
      if (_checkEmail(_email) && (_pass.length > 5)) {
        await prefs.setString('email', _email);
        await prefs.setString('pass', _pass);
        print('Pref Stored');
        Toast.show("Preferences have been saved", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      } else {
        print('No email');
        setState(() {
          _isChecked = false;
        });
        Toast.show("Check your credentials", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
      //store value in pref
    } else {
      //remove value from pref
      await prefs.setString('email', '');
      await prefs.setString('pass', '');
      setState(() {
        _emcontroller.text = '';
        _pscontroller.text = '';
        _isChecked = false;
      });
      Toast.show('Preferences have been removed', context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  void _loadpref() async {
    print('Inside loadpref');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _email = (prefs.getString('email'));
    _pass = (prefs.getString('pass'));
    print(_email);
    print(_pass);
    if (_email.length > 1) {
      _emcontroller.text = _email;
      _pscontroller.text = _pass;
      setState(() {
        _isChecked = true;
      });
    } else {
      print('No pref');
      setState(() {
        _isChecked = false;
      });
    }
  }

}
