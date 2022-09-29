// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String msg = "3 taps to login";
  String info_ = "Reset Password";
  int tapCounter = 0;
  int gap = 0;
  String currentTimeIAmTapping = "";
  List<int> rythmSecondsDifferenceList = [];
  var rythmTimeList = [];
  String myStoredRythm = "";
  bool havIReg = true;
  var different, date1, date2;
  //SharedPreferences prefs;
  //BuildContext scaffoldContext;
  void showToast(String msgParam) {
    Fluttertoast.showToast(
        msg: msgParam,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future checkIfExisitingUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.remove("time1Flutter");
    //prefs.remove("time2Flutter");
    if (prefs.get('time1Flutter') == null) {
      havIReg = false;
      setState(() => msg = "Create rhythm with 3 taps");
      info_ = "Guide";
    }
  }

  void confirmAndSaveRythm() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('time1Flutter', rythmSecondsDifferenceList.elementAt(0));
    prefs.setInt('time2Flutter', rythmSecondsDifferenceList.elementAt(1));
    Navigator.pushReplacementNamed(context, "/");
  }

  void authenticationError() async {
    // Check if the device can vibrate
    vibrateNow();
    createSnackBar("Error", 2, Colors.red);
    resetRhythm();
  }

  static Future<void> vibrateNow() async {
    await SystemChannels.platform.invokeMethod<void>('HapticFeedback.vibrate');
  }

  void resetRhythm() {
    rythmTimeList.clear();
    rythmSecondsDifferenceList.clear();
    tapCounter = 0;
  }

  void getCurrentTime(int x) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
    currentTimeIAmTapping = formatter.format(now);
    rythmTimeList.add(currentTimeIAmTapping);
    if (x > 0) {
      date1 = DateTime.parse(rythmTimeList[x - 1]);
      date2 = DateTime.parse(currentTimeIAmTapping);
      different = date2.difference(date1);
      rythmSecondsDifferenceList.add(different.inSeconds);
      print(rythmSecondsDifferenceList);
      showToast((rythmSecondsDifferenceList.elementAt(x - 1)).toString());
      if (x == 2) {
        if (havIReg) {
          gap =
              prefs.getInt("time1Flutter")! - rythmSecondsDifferenceList.first;
          if (gap >= 0 && gap <= 1) {
            gap =
                prefs.getInt("time2Flutter")! - rythmSecondsDifferenceList.last;
            if (gap >= 0 && gap <= 1) {
              createSnackBar("Correct", 3, Colors.greenAccent);
              resetRhythm(); //remove this coz authentication is complete
            } else
              authenticationError();
          } else
            authenticationError();
        } else
          _showDialog();
      }
    }
    //print(new DateFormat("H:m:s").format(now));
  }

  @override
  void initState() {
    super.initState();
    checkIfExisitingUser();
  }

  void createSnackBar(String message, int duration, Color colorParam) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: colorParam,
      duration: Duration(seconds: duration),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pinkAccent,
          title: Text("Rhythm App"),
          centerTitle: true,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          actions: <Widget>[
            PopupMenuButton<int>(
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 0,
                  child: Text("$info_"),
                ),
              ],
              onSelected: (value) {
                if (value == 0) {
                  if (info_.trim() != "Guide") {
                    confirmResetPassword(
                        "Are you sure you want to reset your password? ");
                  } else {
                    showAppInfo(
                        "Register by tapping on the screen 3 times and take note of the seconds between each tap\nYou will be required to tap " +
                            " 3 times during login with the same tap time difference");
                  }
                }
              },
              offset: const Offset(0, 100),
            )
          ],
        ),
        body: Builder(builder: (BuildContext context) {
          //scaffoldContext = context;
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Center(child: Text(msg)),
                const Divider(height: 10.0),
                Material(
                  color: Colors.grey[100],
                  child: InkWell(
                    onTap: () => saveTapsClick(), // handle your onTap here
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height / 1.23,
                    ),
                  ),
                ),
              ],
            ),
          );
        }));
  }

  void confirmResetPassword(String text_ln) async {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Confirm"),
          content: SingleChildScrollView(child: new Text(text_ln)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
                child: Text(
                  "No",
                  style: TextStyle(
                    color: Colors.red[500],
                    fontStyle: FontStyle.italic,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            TextButton(
              child: Text("Yes"),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.clear();
                Navigator.pushReplacementNamed(context, "/");
              },
            ),
          ],
        );
      },
    );
  }

  void showAppInfo(String appInfo) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("How to"),
          content: SingleChildScrollView(child: new Text(appInfo)),
          actions: <Widget>[
            TextButton(
              child: Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

// user defined function
  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Confirm"),
          content: new Text("Are you sure?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
                child: Text(
                  "No",
                  style: TextStyle(
                    color: Colors.red[500],
                    fontStyle: FontStyle.italic,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  resetRhythm();
                }),
            TextButton(
              child: Text("Yes"),
              onPressed: () {
                confirmAndSaveRythm();
              },
            ),
          ],
        );
      },
    );
  }

  void saveTapsClick() {
    getCurrentTime(tapCounter++);
  }
}
