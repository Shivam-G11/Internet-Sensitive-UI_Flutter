// @dart=2.9
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_ui/imageui.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Internet UI",
      theme: ThemeData(
          primarySwatch: Colors.purple,
        accentColor: Colors.deepOrange,
      ),
      home: HomePage(),
    );
  }
}


class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  StreamSubscription _streamSubscription;
  ConnectivityResult previous;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    try {
      InternetAddress.lookup('google.com').then((result){
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty){
          // internet conn avail
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => imageui()));
        }else {
          // no conn
          _showdialog();
        }
      });
    } on SocketException catch (_){
    //  no internet
      _showdialog();
    }


    Connectivity().onConnectivityChanged.listen((ConnectivityResult connresult) {
      if (connresult == ConnectivityResult.none){

      }else if (previous == ConnectivityResult.none){
        // avail internet
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => imageui()));
      }

      previous = connresult;
    });

  }



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _streamSubscription.cancel();
  }



  void _showdialog(){
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("ERROR"),
          content: Text("No Internet Detected!"),
          actions: [
            FlatButton(
                onPressed: () => SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
                child: Text("Exit"),)
          ],
        )
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Text("Checking Your Internet Connection..."),
        ),

        ],
      ),),
    );
  }
}
