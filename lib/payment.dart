import 'dart:async';
import 'package:myetrash/user.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'mainscreen.dart';

class PaymentScreen extends StatefulWidget {
  final User user;
  final String orderid, val;
  PaymentScreen({this.user, this.orderid, this.val});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressAppBar,
        child: Scaffold(
            appBar: AppBar(
              title: Text('PAYMENT'),
              backgroundColor: Colors.green,
            ),
            body: Column(
              children: <Widget>[
                Expanded(
                  child: WebView(
                    initialUrl:
                        'http://itschizo.com/emily_siew/myETrash/php/payment.php?email=' +
                            widget.user.email +
                            '&mobile=' +
                            widget.user.phone +
                            '&name=' +
                            widget.user.name +
                            '&amount=' +
                            widget.val +
                            '&orderid=' +
                            widget.orderid,
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (WebViewController webViewController) {
                      _controller.complete(webViewController);
                    },
                  ),
                )
              ],
            )));
  }

  Future<bool> _onBackPressAppBar() async {
    print("onbackpress payment");
    String urlgetuser =
        "http://itschizo.com/emily_siew/myETrash/php/get_user.php";

    http.post(urlgetuser, body: {
      "email": widget.user.email,
    }).then((res) {
      print(res.statusCode);
      var string = res.body;
      List dres = string.split(",");
      print(dres);
      if (dres[0] == "success") {
        User updateuser = new User(
            name: dres[1],
            email: dres[2],
            phone: dres[3],
            radius: dres[4],
            credit: dres[5],
            rating: dres[6]);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MainScreen(user: updateuser)));
      }
    }).catchError((err) {
      print(err);
    });
    return Future.value(false);
  }
}
