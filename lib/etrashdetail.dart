import 'dart:async';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myetrash/user.dart';
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:myetrash/etrash.dart';
import 'package:myetrash/mainscreen.dart';

class ETrashDetail extends StatefulWidget {
  final ETrash etrash;
  final User user;

  const ETrashDetail({Key key, this.etrash, this.user}) : super(key: key);

  @override
  _ETrashDetailState createState() => _ETrashDetailState();
}

class _ETrashDetailState extends State<ETrashDetail> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.green));
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text('ETRASH DETAILS'),
            backgroundColor: Colors.green,
          ),
          //body: SingleChildScrollView(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.PNG'),
                fit: BoxFit.cover,
              ),
            ),  
            child: Container(
              padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
              child: DetailInterface(
                etrash: widget.etrash,
                user: widget.user,
              ),
            ),
          )),
    );
  }

  Future<bool> _onBackPressAppBar() async {
    Navigator.pop(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(
            user: widget.user,
          ),
        ));
    return Future.value(false);
  }
}

class DetailInterface extends StatefulWidget {
  final ETrash etrash;
  final User user;
  DetailInterface({this.etrash, this.user});

  @override
  _DetailInterfaceState createState() => _DetailInterfaceState();
}

class _DetailInterfaceState extends State<DetailInterface> {
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _myLocation;

  @override
  void initState() {
    super.initState();
    _myLocation = CameraPosition(
      target: LatLng(
          double.parse(widget.etrash.etlat), double.parse(widget.etrash.etlon)),
      zoom: 17,
    );
    print(_myLocation.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(),
        Container(
          width: 280,
          height: 200,
          child: Image.network(
              'http://itschizo.com/emily_siew/myETrash/images/${widget.etrash.etimage}',
              fit: BoxFit.fill),
        ),
        SizedBox(
          height: 10,
        ),
        Text(widget.etrash.ettitle.toUpperCase(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            )),
        Text(widget.etrash.ettime),
        SizedBox(height: 10,),
        Container(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 5,
              ),
              Table(children: [
                TableRow(children: [
                  Text("ETrash Description",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.etrash.etdesc),
                ]),
                TableRow(children: [
                  Text("ETrash Price",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("RM" + widget.etrash.etprice),
                ]),
                TableRow(children: [
                  Text("ETrash Location",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("")
                ]),
              ]),
              SizedBox(
                height: 10,
              ),
              Container(
                
                height: 120,
                width: 340,
                child: GoogleMap(
                  // 2
                  initialCameraPosition: _myLocation,
                  // 3
                  mapType: MapType.normal,
                  // 4
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: 350,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  height: 40,
                  child: Text(
                    'ACCEPT ETRASH',
                    style: TextStyle(fontSize: 16),
                  ),
                  color: Colors.green,
                  textColor: Colors.white,
                  elevation: 5,
                  onPressed: _onAcceptET,
                ),
                //MapSample(),
              )
            ],
          ),
        ),
      ],
    );
  }

  void _onAcceptET() {
     if (widget.user.email=="user@noregister"){
      Toast.show("Please register to view accept etrash", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }else{
      _showDialog();
    }
    print("Accept ETrash");
    
  }

  void _showDialog() {
    // flutter defined function
    if (int.parse(widget.user.credit)<1){
        Toast.show("Credit not enough ", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Accept " + widget.etrash.ettitle),
          content: new Text("Are your sure?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                acceptRequest();
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<String> acceptRequest() async {
    String urlLoadJobs = "http://slumberjer.com/myhelper/php/accept_job.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Accepting ETrash");
    pr.show();
    http.post(urlLoadJobs, body: {
      "ETrashid": widget.etrash.etid,
      "email": widget.user.email,
      "credit": widget.user.credit,
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show("Success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            pr.dismiss();
            _onLogin(widget.user.email, context);
      } else {
        Toast.show("Failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            pr.dismiss();
      }
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
    return null;
  }

   void _onLogin(String email, BuildContext ctx) {
     String urlgetuser = "http://slumberjer.com/myhelper/php/get_user.php";

    http.post(urlgetuser, body: {
      "email": email,
    }).then((res) {
      print(res.statusCode);
      var string = res.body;
      List dres = string.split(",");
      print(dres);
      if (dres[0] == "success") {
        User user = new User(
            name: dres[1],
            email: dres[2],
            phone: dres[3],
            radius: dres[4],
            credit: dres[5],
            rating: dres[6]);
        Navigator.push(ctx,
            MaterialPageRoute(builder: (context) => MainScreen(user: user)));
      }
    }).catchError((err) {
      print(err);
    });
  }
}