import 'package:auth_practice/views/signin.dart';
import 'package:auth_practice/widgets/widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  String _email, _password;
  TextEditingController userNameTextEditingController =
  new TextEditingController();
  TextEditingController emailTextEditingController =
  new TextEditingController();
  TextEditingController passwordTextEditingController =
  new TextEditingController();

  signMeUp() async{
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      setState(() {
        isLoading = true;
      });
      try{
        UserCredential user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignIn()));
      }catch(e){
        print(e.message);
      }

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SignUp Screen'),
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
                              return 'Name is a required field';
                            }
                          },
                          style: mediumTextStyle(),
                          cursorColor: Colors.green,
                          decoration: InputDecoration(
                              labelStyle: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green)),
                              labelText: 'NAME'),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          validator: (input){
                            if(input.isEmpty){
                              return 'Username is a required field';
                            }
                          },
                          controller: userNameTextEditingController,
                          style: mediumTextStyle(),
                          cursorColor: Colors.green,
                          decoration: InputDecoration(
                              labelStyle: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green)),
                              labelText: 'USERNAME'),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          validator: (input){
                            if(input.isEmpty){
                              return 'Please type an Email';
                            }
                          },
                          // controller: emailTextEditingController,
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
                            obscureText: true,
                            validator: (input) {
                              return input.isEmpty || input.length < 6
                                  ? "Enter atleast 6 character"
                                  : null;
                            },
                            // controller: passwordTextEditingController,
                            onSaved: (input) => _password = input,
                            style: mediumTextStyle(),
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

                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: GestureDetector(
                              onTap: () {
                                signMeUp();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                                child: Text(
                                  'REGISTER',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        SizedBox(
                          height: 25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already Registered ?',
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),
                            SizedBox(width: 5,),
                            GestureDetector(
                              onTap: (){
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignIn()));
                                },
                              child: Text(
                                'Sign In Now',
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.green,
                                    decoration: TextDecoration.underline
                                ),
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
  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty) return '*Required';
    if (!regex.hasMatch(value))
      return '*Enter a valid email';
    else
      return null;
  }
}
