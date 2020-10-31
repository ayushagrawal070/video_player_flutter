import 'package:auth_practice/views/signup.dart';
import 'package:auth_practice/views/welcome.dart';
import 'package:auth_practice/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:auth_practice/helper/helperfunctions.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isLoading = false;
  String _email,_password;
  final formKey = GlobalKey<FormState>();

  Future<void> signIn() async{
    final formState = formKey.currentState;
    if(formState.validate()){
      formState.save();
      setState(() {
        isLoading = true;
      });
      try{
      UserCredential user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password).then((val){
        if(val!= null){
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VideoApp()));
        }
      });
    } catch(e){
        print(e.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SignIn Screen'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - 50,
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              // margin: EdgeInsets.fromLTRB(50, 0, 50, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextFormField(
                          validator: (input){
                            if(input.isEmpty){
                              return 'Please type an Email';
                            }
                          },
                          onSaved: (input) => _email = input,
                          style: mediumTextStyle(),
                          cursorColor: Colors.green,
                          decoration: InputDecoration(
                              labelStyle: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green)),
                              labelText: 'EMAIL'),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          child: TextFormField(
                            validator: (input){
                              if(input.isEmpty){
                                return 'Please type an password';
                              }
                            },
                            onSaved: (input) => _password = input,
                            style: mediumTextStyle(),
                            obscureText: true,
                            cursorColor: Colors.green,
                            decoration: InputDecoration(
                                labelStyle: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.green)),
                                labelText: 'PASSWORD'),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            "Forgot Password",
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: GestureDetector(
                              onTap: () {
                                signIn();
                              },
                              child: Container(
                                // color: Colors.green,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                                child: Text(
                                  'LOGIN',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                  ),
                                ),
                            //   ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Container(
                          height: 50,
                          color: Colors.transparent,
                          child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1.0,
                                  style: BorderStyle.solid,
                                ),
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: GestureDetector(
                                onTap: () {},
                                child: Center(
                                  child: Text(
                                    'Log In with Google',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              )),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'New to Our App ?',
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUp()));
                              },
                              child: Text(
                                'Register Now',
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.green,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 60,),
                ],
              ),
            ),
          ),
        ),
    );
  }
}
