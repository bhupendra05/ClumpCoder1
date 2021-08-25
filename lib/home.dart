import 'package:clumpcoder/main.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

var name;

class Home extends StatefulWidget {
  Home(displayname) {
    name = displayname;
  }
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  logout(context) {
    googleSignIn.signOut();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SecondScreen()));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$name'),
      ),
      body: Container(
          child: TextButton(
              onPressed: () {
                logout(context);
              },
              child: Text("Logout"))),
    );
  }
}
