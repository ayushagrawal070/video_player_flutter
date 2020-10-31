import 'package:auth_practice/views/signin.dart';
import 'package:auth_practice/views/signup.dart';
import 'package:auth_practice/views/welcome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auth_practice/helper/helperfunctions.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool userIsLoggedIn;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }
  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value){
      setState(() {
        userIsLoggedIn = value;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return userIsLoggedIn != null ? userIsLoggedIn ? VideoApp() : SignIn() : SignIn();
  }
}
