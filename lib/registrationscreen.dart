/*import 'package:flutter/material.dart';
//import 'package:flutter/semantics.dart';
import 'package:myetrash/loginpage.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert'; //base64 encode
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';

String pathAsset = 'assets/images/profile.PNG'; //////////
String urlUpload = "http://itschizo.com/emily_siew/myETrash/php/Register.php";
File _image;

final TextEditingController _namecontroller = TextEditingController();
final TextEditingController _emcontroller = TextEditingController();
final TextEditingController _pscontroller = TextEditingController();
final TextEditingController _phcontroller = TextEditingController();
String _name, _email, _pass, _phone;

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterUserState createState() => _RegisterUserState();
  const RegisterScreen({Key key, File image}) : super(key: key);
}

class _RegisterUserState extends State<RegisterScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('New User Registration'),
          backgroundColor: Colors.green[300],
        ),
        body: new Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/background.PNG'),
                fit: BoxFit.cover),
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
            child: RegisterWidget(),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressAppBar() async {
    _image = null;
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ));
    return Future.value(false);
  }
}

class RegisterWidget extends StatefulWidget {
  @override
  RegisterWidgetState createState() => RegisterWidgetState();
}

class RegisterWidgetState extends State<RegisterWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
            onTap: _choose,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: _image == null
                        ? AssetImage(pathAsset)
                        : FileImage(_image),
                    fit: BoxFit.fill,
                  )),
            )),
        Text('Click on image above to take profile picture'),
        SizedBox(height: 10.0),
        TextField(
            controller: _emcontroller,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              filled: true,
              labelText: 'Email',
              icon: Icon(Icons.email),
            )),
        SizedBox(height: 8.0),
        TextField(
            controller: _namecontroller,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              filled: true,
              labelText: 'Name',
              icon: Icon(Icons.person),
            )),
        SizedBox(height: 8.0),
        TextField(
          controller: _pscontroller,
          decoration: InputDecoration(
            filled: true,
            labelText: 'Password',
            icon: Icon(Icons.lock),
          ),
          obscureText: true,
        ),
        SizedBox(height: 8.0),
        TextField(
            controller: _phcontroller,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              filled: true,
              labelText: 'Phone',
              icon: Icon(Icons.phone),
            )),
        SizedBox(
          height: 10,
        ),
        MaterialButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          minWidth: 300,
          height: 50,
          child: Text('Register'),
          color: Colors.green,
          textColor: Colors.white,
          elevation: 15,
          onPressed: _onRegister,
        ),
        SizedBox(
          height: 10,
        ),
        GestureDetector(
            onTap: _onBackPress,
            child: Text('Already Register', style: TextStyle(fontSize: 16, color: Colors.blue))),
      ],
    );
  }

  void _choose() async {
    _image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {});
  }

  void _onRegister() {
    print('onRegister Button from RegisterUser()');
    print(_image.toString());
    uploadData();
  }

  void _onBackPress() {
    _image = null;
    print('onBackpress from Register');
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
  }

  void uploadData() {
    _name = _namecontroller.text;
    _email = _emcontroller.text;
    _pass = _pscontroller.text; 
    _phone = _phcontroller.text;

    if ((_isEmailValid(_email)) &&
        (_pass.length > 5) &&
        (_image != null) &&
        (_phone.length > 5)) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Registration in progress, please check your email for verification");
      pr.show();

      String base64Image = base64Encode(_image.readAsBytesSync());
      http.post(urlUpload, body: {
        "encoded_string": base64Image,
        "name": _name,
        "email": _email,
        "password": _pass,
        "phone": _phone,
      }).then((res) {
        print(res.statusCode);
        Toast.show(res.body, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _image = null;
        _namecontroller.text = '';
        _emcontroller.text = '';
        _phcontroller.text = '';
        _pscontroller.text = '';
        pr.dismiss();
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
      }).catchError((err) {
        print(err);
      });
    } else {
      Toast.show("Check your registeration information", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  _isEmailValid(String email) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }
}*/
