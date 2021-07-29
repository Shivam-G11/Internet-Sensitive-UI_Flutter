// @dart=2.9
import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class imageui extends StatefulWidget {
  const imageui({Key key}) : super(key: key);

  @override
  _imageuiState createState() => _imageuiState();
}

class _imageuiState extends State<imageui> {



  StreamSubscription connectivitySubscription;
  ConnectivityResult _previousResult;
  bool dialogshown = false;





  List<String> code = [
    'https://images.pexels.com/photos/169573/pexels-photo-169573.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
    'https://images.pexels.com/photos/270348/pexels-photo-270348.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
    'https://images.pexels.com/photos/943096/pexels-photo-943096.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
  ];

  List<String> nature = [
    'https://images.pexels.com/photos/358457/pexels-photo-358457.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    'https://images.pexels.com/photos/235615/pexels-photo-235615.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    'https://images.pexels.com/photos/414144/pexels-photo-414144.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260',
  ];

  List<String> computer = [
    'https://images.pexels.com/photos/2115217/pexels-photo-2115217.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
    'https://images.pexels.com/photos/204611/pexels-photo-204611.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
    'https://images.pexels.com/photos/2800552/pexels-photo-2800552.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940 ',
  ];

  List<String> toshow = [
    'https://images.pexels.com/photos/169573/pexels-photo-169573.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
    'https://images.pexels.com/photos/270348/pexels-photo-270348.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
    'https://images.pexels.com/photos/943096/pexels-photo-943096.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
  ];



  Future<bool> checkinternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return Future.value(true);
      }
    } on SocketException catch (_) {
      return Future.value(false);
    }
  }





  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    connectivitySubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult connresult) {
      if(connresult == ConnectivityResult.none){
        // no connection
        dialogshown = true;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Text(
              "Error",
            ),
            content: Text(
              "No Data Connection Available.",
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
                },
                child: Text("Exit."),
              ),
            ],
          ),
        );
      }else if (_previousResult == ConnectivityResult.none){
        // connection avialable
        checkinternet().then((result) {
          if (result == true) {
            if (dialogshown == true) {
              dialogshown = false;
              Navigator.pop(context);
            }
          }
        });
      }
      _previousResult = connresult;
    });
  }



@override
void dispose() {
    // TODO: implement dispose
    super.dispose();
    connectivitySubscription.cancel();

  }





  void createlist(String kword){
    if (kword == "code"){
      toshow = [];
      setState(() {
        for (var srcs in code){
          toshow.add(srcs);
        }
      });
    }else if (kword == "nature"){
      toshow = [];
      setState(() {
        for(var srcs in nature){
          toshow.add(srcs);
        }
      });
    }else if (kword == "computer"){
      toshow = [];
      setState(() {
        for(var srcs in computer){
          toshow.add(srcs);
        }
      });
    }
  }


  Widget card (String src){
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.network(src),
      ],),
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Image Viewer",
          style: TextStyle(
              fontSize: 25, color: Colors.red,),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: SingleChildScrollView(scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              Expanded(
                child: FlatButton(
                    onPressed: () => createlist("code"),
                    child: Text("Code",
                    style: TextStyle(
                        fontSize: 18, color: Colors.red,),
                    )),
              ),
                Expanded(
                  child: FlatButton(
                      onPressed: ()=> createlist("nature"),
                      child: Text("Nature",
                        style: TextStyle(
                          fontSize: 18, color: Colors.red,),
                      )),
                ),
                Expanded(
                  child: FlatButton(
                      onPressed: ()=> createlist("computer"),
                      child: Text("Computer",
                        style: TextStyle(
                          fontSize: 18, color: Colors.red,),
                      )),
                ),
            ],),

            Column(children: [
              card(toshow[0]),
              card(toshow[1]),
              card(toshow[2]),
            ],)
          ],
        ),
      ),
    );
  }
}
