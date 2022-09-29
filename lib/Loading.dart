import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void delayMethod() async{
    await Future.delayed(Duration(seconds: 1),(){
        Navigator.pushReplacementNamed(context, "/Home");
    });
  }

  @override
  void initState() {
    super.initState();
    delayMethod();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pinkAccent,
      body: Center(
        child: SpinKitFadingCube(
          color: Colors.white,
          size: 50.0
        ),
      )
    );
  }
}
